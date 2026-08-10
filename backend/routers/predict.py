"""Router prediksi ML.

Endpoint dan penyimpanan sudah final untuk integrasi aplikasi.
Saat model ML asli sudah ada, cukup ganti run_prediction() di ml_inference.py.
"""
import json
import time
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from auth_utils import get_optional_user
from database import get_db
from ml_inference import run_prediction
from models import History, MLPredictionJob, Notification, Record, Skrining, User
from schemas import PredictRequest, PredictResponse

router = APIRouter(prefix="/api/predict", tags=["Predict (ML)"])


@router.post("/", response_model=PredictResponse)
def predict(
    body: PredictRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_optional_user),
):
    record = db.query(Record).filter(Record.id_suara == body.id_record).first()
    if not record:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rekaman dengan ID '{body.id_record}' tidak ditemukan",
        )

    started = time.perf_counter()
    prediction = run_prediction(record.file_path, record.file_format)
    inference_ms = int((time.perf_counter() - started) * 1000)
    model_name = "svara-dummy-heart-sound"
    model_version = "0.1.0"
    user_id = current_user.id_user if current_user else record.id_user

    skrining = Skrining(
        id_user=user_id,
        id_record=record.id_suara,
        nama_penyakit=prediction["nama_penyakit"],
        risk_analysis=prediction["risk_analysis"],
        confidence=prediction["confidence"],
        heart_status=prediction["heart_status"],
        bpm_estimate=prediction["bpm_estimate"],
        recommendation=prediction["recommendation"],
        model_name=model_name,
        model_version=model_version,
        inference_ms=inference_ms,
        raw_output=json.dumps(prediction),
    )
    db.add(skrining)
    db.flush()

    db.add(History(id_user=user_id, id_skr=skrining.id_skr, id_record=record.id_suara))
    db.add(
        MLPredictionJob(
            id_user=user_id,
            id_record=record.id_suara,
            id_skr=skrining.id_skr,
            status="completed",
            provider="dummy",
            model_name=model_name,
            model_version=model_version,
            finished_at=datetime.utcnow(),
        )
    )
    db.add(
        Notification(
            id_user=user_id,
            id_skr=skrining.id_skr,
            title="Hasil skrining tersedia",
            message=f"Hasil skrining {prediction['heart_status']} sudah selesai diproses.",
            type="screening_result",
        )
    )
    db.commit()
    db.refresh(skrining)

    return PredictResponse(
        id_skr=skrining.id_skr,
        id_record=record.id_suara,
        nama_penyakit=prediction["nama_penyakit"],
        risk_analysis=prediction["risk_analysis"],
        confidence=prediction["confidence"],
        heart_status=prediction["heart_status"],
        bpm_estimate=prediction["bpm_estimate"],
        recommendation=prediction["recommendation"],
        model_name=model_name,
        model_version=model_version,
        inference_ms=inference_ms,
        raw_output=prediction,
        created_at=skrining.created_at,
    )
