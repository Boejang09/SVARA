"""
Router untuk fitur rekaman suara (Record).
Upload, list, detail, dan hapus rekaman audio.
"""
import os
import uuid
import wave

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from auth_utils import get_current_user
from database import get_db
from models import History, Record, Skrining, User
from schemas import UploadAudioResponse

router = APIRouter(prefix="/api/records", tags=["Records"])

UPLOAD_DIR = "uploads/audio"
ALLOWED_EXTENSIONS = {".wav"}
ALLOWED_CONTENT_TYPES = {
    "audio/wav",
    "audio/x-wav",
    "audio/wave",
    "application/octet-stream",
}


def _get_wav_metadata(file_path: str) -> dict:
    """Ambil metadata dari file WAV (duration, sample_rate)."""
    try:
        with wave.open(file_path, "rb") as wf:
            frames = wf.getnframes()
            rate = wf.getframerate()
            duration = frames / float(rate) if rate > 0 else 0.0
            return {
                "duration_seconds": round(duration, 2),
                "sample_rate": rate,
            }
    except Exception:
        return {"duration_seconds": None, "sample_rate": None}


def _get_audio_metadata(file_path: str, file_format: str) -> dict:
    """Ambil metadata audio berdasarkan format."""
    if file_format == "wav":
        return _get_wav_metadata(file_path)

    # Untuk format lain (m4a, mp3, dll), coba pydub jika tersedia
    try:
        from pydub import AudioSegment

        audio = AudioSegment.from_file(file_path)
        return {
            "duration_seconds": round(len(audio) / 1000.0, 2),
            "sample_rate": audio.frame_rate,
        }
    except Exception:
        return {"duration_seconds": None, "sample_rate": None}


# ──────────────────────────────────────────────
# POST /api/records/upload  —  Upload file audio
# ──────────────────────────────────────────────
def _validate_wav_file(file: UploadFile):
    ext = os.path.splitext(file.filename or "")[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Format audio tidak valid. Gunakan file WAV.",
        )

    if file.content_type and file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Tipe konten audio tidak valid. Gunakan file WAV.",
        )


def _assert_phase2_wav(metadata: dict):
    if metadata["sample_rate"] is not None and metadata["sample_rate"] != 44100:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Sample rate audio harus 44.1 kHz.",
        )


@router.post(
    "/upload",
    response_model=UploadAudioResponse,
    status_code=status.HTTP_201_CREATED,
)
async def upload_audio(
    file: UploadFile = File(...),
    nama: str = Form(default="Rekaman Suara"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    _validate_wav_file(file)

    # Generate unique filename
    ext = ".wav"
    file_format = "wav"
    unique_name = f"{uuid.uuid4().hex}{ext}"
    file_path = os.path.join(UPLOAD_DIR, unique_name)

    # Simpan file
    content = await file.read()
    file_size = len(content)
    if file_size == 0:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="File audio kosong.",
        )

    os.makedirs(UPLOAD_DIR, exist_ok=True)
    with open(file_path, "wb") as f:
        f.write(content)

    # Ambil metadata audio
    metadata = _get_audio_metadata(file_path, file_format)
    _assert_phase2_wav(metadata)

    # Simpan ke database
    record = Record(
        nama=nama,
        id_user=current_user.id_user,
        file_path=file_path,
        file_format=file_format,
        duration_seconds=metadata["duration_seconds"],
        file_size_bytes=file_size,
        sample_rate=metadata["sample_rate"],
    )
    db.add(record)
    db.flush()

    skrining = Skrining(
        id_user=current_user.id_user,
        id_record=record.id_suara,
        status="uploaded",
    )
    db.add(skrining)
    db.flush()

    db.add(
        History(
            id_user=current_user.id_user,
            id_skr=skrining.id_skr,
            id_record=record.id_suara,
        )
    )
    db.commit()
    db.refresh(record)
    db.refresh(skrining)

    return UploadAudioResponse(
        message="Audio berhasil diunggah",
        screening_id=skrining.id_skr,
        record_id=record.id_suara,
        status=skrining.status,
    )


# ──────────────────────────────────────────────
# GET /api/records/  —  List semua rekaman
# ──────────────────────────────────────────────
@router.get("/")
def list_records(db: Session = Depends(get_db)):
    records = db.query(Record).order_by(Record.created_at.desc()).all()
    return {
        "total": len(records),
        "data": [
            {
                "id_suara": r.id_suara,
                "nama": r.nama,
                "file_format": r.file_format,
                "duration_seconds": r.duration_seconds,
                "file_size_bytes": r.file_size_bytes,
                "created_at": r.created_at.isoformat() if r.created_at else None,
            }
            for r in records
        ],
    }


# ──────────────────────────────────────────────
# GET /api/records/{id}  —  Detail rekaman
# ──────────────────────────────────────────────
@router.get("/{record_id}")
def get_record(record_id: str, db: Session = Depends(get_db)):
    record = db.query(Record).filter(Record.id_suara == record_id).first()
    if not record:
        raise HTTPException(status_code=404, detail="Rekaman tidak ditemukan")
    return {
        "data": {
            "id_suara": record.id_suara,
            "nama": record.nama,
            "id_user": record.id_user,
            "file_path": record.file_path,
            "file_format": record.file_format,
            "duration_seconds": record.duration_seconds,
            "file_size_bytes": record.file_size_bytes,
            "sample_rate": record.sample_rate,
            "created_at": record.created_at.isoformat() if record.created_at else None,
        },
    }


# ──────────────────────────────────────────────
# DELETE /api/records/{id}  —  Hapus rekaman
# ──────────────────────────────────────────────
@router.delete("/{record_id}")
def delete_record(record_id: str, db: Session = Depends(get_db)):
    record = db.query(Record).filter(Record.id_suara == record_id).first()
    if not record:
        raise HTTPException(status_code=404, detail="Rekaman tidak ditemukan")

    # Hapus file fisik
    if record.file_path and os.path.exists(record.file_path):
        os.remove(record.file_path)

    # Hapus dari database
    db.delete(record)
    db.commit()
    return {"message": "Rekaman berhasil dihapus", "id_suara": record_id}
