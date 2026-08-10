"""Router untuk skrining, riwayat, notifikasi, dan data dummy."""
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from database import get_db
from models import History, Notification, Record, Skrining, User
from schemas import (
    HistoryResponse,
    NotificationCreateRequest,
    NotificationResponse,
    ScreeningResponse,
)

router = APIRouter(tags=["Screening, History, Notifications"])


def _screening_response(skrining: Skrining) -> ScreeningResponse:
    return ScreeningResponse(
        id_skr=skrining.id_skr,
        id_user=skrining.id_user,
        id_record=skrining.id_record,
        nama_penyakit=skrining.nama_penyakit,
        risk_analysis=skrining.risk_analysis,
        confidence=skrining.confidence,
        heart_status=skrining.heart_status,
        bpm_estimate=skrining.bpm_estimate,
        recommendation=skrining.recommendation,
        model_name=skrining.model_name,
        model_version=skrining.model_version,
        inference_ms=skrining.inference_ms,
        created_at=skrining.created_at,
    )


@router.get("/api/screenings/", response_model=dict)
def list_screenings(
    id_user: Optional[str] = Query(None, description="Filter by user ID"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(Skrining).order_by(Skrining.created_at.desc())
    if id_user:
        query = query.filter(Skrining.id_user == id_user)

    total = query.count()
    screenings = query.offset(offset).limit(limit).all()
    return {
        "total": total,
        "limit": limit,
        "offset": offset,
        "data": [_screening_response(item) for item in screenings],
    }


@router.get("/api/screenings/{screening_id}", response_model=dict)
def get_screening(screening_id: str, db: Session = Depends(get_db)):
    skrining = db.query(Skrining).filter(Skrining.id_skr == screening_id).first()
    if not skrining:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Skrining tidak ditemukan",
        )
    return {"data": _screening_response(skrining)}


@router.delete("/api/screenings/{screening_id}")
def delete_screening(screening_id: str, db: Session = Depends(get_db)):
    skrining = db.query(Skrining).filter(Skrining.id_skr == screening_id).first()
    if not skrining:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Skrining tidak ditemukan",
        )

    db.delete(skrining)
    db.commit()
    return {"message": "Skrining berhasil dihapus", "id_skr": screening_id}


@router.get("/api/history/", response_model=dict)
def list_history(
    id_user: Optional[str] = Query(None, description="Filter by user ID"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(History).order_by(History.created_at.desc())
    if id_user:
        query = query.filter(History.id_user == id_user)

    total = query.count()
    histories = query.offset(offset).limit(limit).all()
    return {
        "total": total,
        "limit": limit,
        "offset": offset,
        "data": [
            HistoryResponse(
                id_history=item.id_history,
                id_user=item.id_user,
                id_skr=item.id_skr,
                id_record=item.id_record,
                tanggal=item.tanggal,
                created_at=item.created_at,
                screening=_screening_response(item.skrining) if item.skrining else None,
            )
            for item in histories
        ],
    }


@router.get("/api/history/{history_id}", response_model=dict)
def get_history(history_id: str, db: Session = Depends(get_db)):
    history = db.query(History).filter(History.id_history == history_id).first()
    if not history:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Riwayat tidak ditemukan",
        )

    return {
        "data": HistoryResponse(
            id_history=history.id_history,
            id_user=history.id_user,
            id_skr=history.id_skr,
            id_record=history.id_record,
            tanggal=history.tanggal,
            created_at=history.created_at,
            screening=_screening_response(history.skrining) if history.skrining else None,
        )
    }


@router.get("/api/notifications/", response_model=dict)
def list_notifications(
    id_user: Optional[str] = Query(None, description="Filter by user ID"),
    unread_only: bool = Query(False),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(Notification).order_by(Notification.created_at.desc())
    if id_user:
        query = query.filter(Notification.id_user == id_user)
    if unread_only:
        query = query.filter(Notification.is_read.is_(False))

    total = query.count()
    notifications = query.offset(offset).limit(limit).all()
    return {
        "total": total,
        "limit": limit,
        "offset": offset,
        "data": [NotificationResponse.model_validate(item) for item in notifications],
    }


@router.post("/api/notifications/", response_model=dict, status_code=status.HTTP_201_CREATED)
def create_notification(body: NotificationCreateRequest, db: Session = Depends(get_db)):
    notification = Notification(
        id_user=body.id_user,
        id_skr=body.id_skr,
        title=body.title,
        message=body.message,
        type=body.type,
    )
    db.add(notification)
    db.commit()
    db.refresh(notification)
    return {
        "message": "Notifikasi berhasil dibuat",
        "data": NotificationResponse.model_validate(notification),
    }


@router.patch("/api/notifications/{notification_id}/read", response_model=dict)
def mark_notification_read(notification_id: str, db: Session = Depends(get_db)):
    notification = db.query(Notification).filter(
        Notification.id_notification == notification_id
    ).first()
    if not notification:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Notifikasi tidak ditemukan",
        )

    notification.is_read = True
    notification.read_at = datetime.utcnow()
    db.commit()
    db.refresh(notification)
    return {
        "message": "Notifikasi sudah dibaca",
        "data": NotificationResponse.model_validate(notification),
    }


@router.post("/api/dev/seed", response_model=dict)
def seed_dummy_data(db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == "tamu").first()
    if not user:
        user = User(
            username="tamu",
            password_hash="$2b$12$CwTycUXWue0Thq9StjUM0uJ8.KSVwqdqkd1YAAxRbUJPZBPWmjNyC",
            nama="Pengguna Tamu",
            email="tamu@svara.local",
            phone="+62 812 0000 0000",
        )
        db.add(user)
        db.flush()

    record = Record(
        id_user=user.id_user,
        nama="Contoh Rekaman Jantung",
        file_path="uploads/audio/dummy-heart.wav",
        file_format="wav",
        duration_seconds=12.4,
        file_size_bytes=248000,
        sample_rate=16000,
    )
    db.add(record)
    db.flush()

    skrining = Skrining(
        id_user=user.id_user,
        id_record=record.id_suara,
        nama_penyakit="Normal",
        risk_analysis=92.0,
        confidence=0.94,
        heart_status="Normal",
        bpm_estimate=72,
        recommendation="Lanjutkan pemantauan rutin dan jaga pola hidup sehat.",
        model_name="svara-dummy-heart-sound",
        model_version="0.1.0",
        inference_ms=18,
    )
    db.add(skrining)
    db.flush()

    db.add(History(id_user=user.id_user, id_skr=skrining.id_skr, id_record=record.id_suara))
    db.add(Notification(
        id_user=user.id_user,
        id_skr=skrining.id_skr,
        title="Data contoh siap",
        message="Data dummy skrining berhasil dibuat untuk pengujian aplikasi.",
        type="dev_seed",
    ))
    db.commit()

    return {
        "message": "Data dummy berhasil dibuat",
        "user_id": user.id_user,
        "record_id": record.id_suara,
        "screening_id": skrining.id_skr,
    }
