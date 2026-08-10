"""
Pydantic schemas untuk request/response validation SVARA API.
"""
from datetime import datetime
from typing import Any, Optional

from pydantic import BaseModel, Field


# ──────────────────────────────────────────────
# Auth Schemas
# ──────────────────────────────────────────────
class RegisterRequest(BaseModel):
    username: str = Field(..., min_length=3, max_length=50, description="Username unik untuk login")
    nama: str = Field(..., min_length=1, max_length=255, description="Nama lengkap pengguna")
    password: str = Field(..., min_length=6, description="Kata sandi minimal 6 karakter")
    email: Optional[str] = Field(None, description="Email (opsional)")
    phone: Optional[str] = Field(None, description="Nomor telepon (opsional)")


class LoginRequest(BaseModel):
    username: str = Field(..., description="Username")
    password: str = Field(..., description="Kata sandi")


class UserResponse(BaseModel):
    id_user: str
    username: str
    nama: str
    email: Optional[str] = None
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


# ──────────────────────────────────────────────
# Predict Schemas
# ──────────────────────────────────────────────
class PredictResponse(BaseModel):
    id_skr: str
    id_record: Optional[str] = None
    nama_penyakit: str
    risk_analysis: float
    confidence: float
    heart_status: str
    bpm_estimate: int
    recommendation: str
    model_name: Optional[str] = None
    model_version: Optional[str] = None
    inference_ms: Optional[int] = None
    raw_output: Optional[dict[str, Any]] = None
    created_at: Optional[datetime] = None


class PredictRequest(BaseModel):
    id_record: str = Field(..., description="ID rekaman audio yang akan dianalisis")


# ──────────────────────────────────────────────
# Screening Schemas
# ──────────────────────────────────────────────
class ScreeningResponse(BaseModel):
    id_skr: str
    id_user: Optional[str] = None
    id_record: Optional[str] = None
    nama_penyakit: Optional[str] = None
    risk_analysis: Optional[float] = None
    confidence: Optional[float] = None
    heart_status: Optional[str] = None
    bpm_estimate: Optional[int] = None
    recommendation: Optional[str] = None
    model_name: Optional[str] = None
    model_version: Optional[str] = None
    inference_ms: Optional[int] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class HistoryResponse(BaseModel):
    id_history: str
    id_user: Optional[str] = None
    id_skr: str
    id_record: Optional[str] = None
    tanggal: Optional[datetime] = None
    created_at: Optional[datetime] = None
    # Include screening data when joined
    screening: Optional[ScreeningResponse] = None

    class Config:
        from_attributes = True


class NotificationResponse(BaseModel):
    id_notification: str
    id_user: Optional[str] = None
    id_skr: Optional[str] = None
    title: str
    message: str
    type: str
    is_read: bool
    created_at: Optional[datetime] = None
    read_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class NotificationCreateRequest(BaseModel):
    id_user: Optional[str] = None
    id_skr: Optional[str] = None
    title: str = Field(..., min_length=1, max_length=160)
    message: str = Field(..., min_length=1)
    type: str = Field(default="info", max_length=40)
