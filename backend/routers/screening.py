"""Router untuk skrining, riwayat, dan notifikasi."""
import json
import os
import time
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from database import get_db
from auth_utils import get_current_user
from ml_inference import MLInferenceError, run_prediction
from models import History, MLPredictionJob, Notification, Record, Skrining, User
from schemas import (
    AnalyzeScreeningResponse,
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
        status=skrining.status,
        nama_penyakit=skrining.nama_penyakit,
        risk_analysis=skrining.risk_analysis,
        confidence=skrining.confidence,
        heart_status=skrining.heart_status,
        bpm_estimate=skrining.bpm_estimate,
        recommendation=skrining.recommendation,
        model_name=skrining.model_name,
        model_version=skrining.model_version,
        inference_ms=skrining.inference_ms,
        raw_output=json.loads(skrining.raw_output) if skrining.raw_output else None,
        created_at=skrining.created_at,
    )


def _audio_url(record: Record | None) -> str | None:
    if not record or not record.file_path:
        return None
    return f"/uploads/audio/{os.path.basename(record.file_path)}"


@router.get("/api/screenings/", response_model=dict)
def list_screenings(
    id_user: Optional[str] = Query(None, description="Filter by user ID"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(Skrining).order_by(Skrining.created_at.desc())
    query = query.filter(Skrining.id_user == (id_user or current_user.id_user))

    total = query.count()
    screenings = query.offset(offset).limit(limit).all()
    return {
        "total": total,
        "limit": limit,
        "offset": offset,
        "data": [_screening_response(item) for item in screenings],
    }


@router.get("/api/screenings/{screening_id}", response_model=dict)
def get_screening(
    screening_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    skrining = db.query(Skrining).filter(Skrining.id_skr == screening_id).first()
    if not skrining or skrining.id_user != current_user.id_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Skrining tidak ditemukan",
        )
    return {"data": _screening_response(skrining)}


@router.post(
    "/api/screenings/{screening_id}/analyze",
    response_model=AnalyzeScreeningResponse,
)
def analyze_screening(
    screening_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    skrining = db.query(Skrining).filter(Skrining.id_skr == screening_id).first()
    if not skrining or skrining.id_user != current_user.id_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Skrining tidak ditemukan",
        )

    record = db.query(Record).filter(Record.id_suara == skrining.id_record).first()
    if not record or not os.path.exists(record.file_path):
        skrining.status = "failed"
        skrining.recommendation = "File audio tidak ditemukan."
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="File audio tidak ditemukan.",
        )

    skrining.status = "processing"
    job = MLPredictionJob(
        id_user=current_user.id_user,
        id_record=record.id_suara,
        id_skr=skrining.id_skr,
        status="processing",
        provider="external_ml_api",
        model_name="external-heart-sound-api",
    )
    db.add(job)
    db.commit()

    started = time.perf_counter()
    try:
        result = run_prediction(record.file_path, record.file_format)
    except MLInferenceError as exc:
        skrining.status = "failed"
        skrining.recommendation = str(exc)
        job.status = "failed"
        job.error_message = str(exc)
        job.finished_at = datetime.utcnow()
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Gagal menganalisis rekaman. Silakan coba lagi.",
        ) from exc

    inference_ms = int((time.perf_counter() - started) * 1000)
    raw_output = {
        **result.raw_response,
        "filename": result.filename,
        "prediction": result.prediction,
        "segment_details": result.segment_details,
        "status": result.status,
    }

    skrining.status = "completed"
    skrining.nama_penyakit = result.prediction
    skrining.heart_status = result.prediction
    skrining.recommendation = "Hasil berasal dari model ML eksternal."
    skrining.model_name = "external-heart-sound-api"
    skrining.model_version = None
    skrining.inference_ms = inference_ms
    skrining.raw_output = json.dumps(raw_output)
    job.status = "completed"
    job.finished_at = datetime.utcnow()
    db.add(
        Notification(
            id_user=current_user.id_user,
            id_skr=skrining.id_skr,
            title="Analisis selesai",
            message=f"Hasil analisis rekaman: {result.prediction}.",
            type="screening_result",
        )
    )
    db.commit()
    db.refresh(skrining)

    return AnalyzeScreeningResponse(
        message="Analisis selesai",
        data=_screening_response(skrining),
    )


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
    current_user: User = Depends(get_current_user),
):
    query = db.query(History).order_by(History.created_at.desc())
    query = query.filter(History.id_user == (id_user or current_user.id_user))

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
                audio_url=_audio_url(
                    db.query(Record).filter(Record.id_suara == item.id_record).first()
                ),
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
            audio_url=_audio_url(
                db.query(Record).filter(Record.id_suara == history.id_record).first()
            ),
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
