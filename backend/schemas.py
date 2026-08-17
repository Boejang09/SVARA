from datetime import datetime, timezone
from typing import Any, Optional

from pydantic import BaseModel, Field, field_serializer


class SvaraBaseModel(BaseModel):
    @field_serializer(
        "*",
        when_used="json",
        check_fields=False,
    )
    def serialize_datetime(self, value):
        if not isinstance(
            value,
            datetime,
        ):
            return value

        if value.tzinfo is None:
            value = value.replace(
                tzinfo=timezone.utc
            )

        return (
            value
            .astimezone(timezone.utc)
            .isoformat()
            .replace("+00:00", "Z")
        )


class RegisterRequest(SvaraBaseModel):
    username: str = Field(
        ...,
        min_length=3,
        max_length=50,
        description="Username unik untuk login",
    )
    nama: str = Field(
        ...,
        min_length=1,
        max_length=255,
        description="Nama lengkap pengguna",
    )
    password: str = Field(
        ...,
        min_length=6,
        description="Kata sandi minimal 6 karakter",
    )
    email: Optional[str] = Field(
        None,
        description="Email (opsional)",
    )
    phone: Optional[str] = Field(
        None,
        description="Nomor telepon (opsional)",
    )


class LoginRequest(SvaraBaseModel):
    username: str = Field(
        ...,
        description="Username",
    )
    password: str = Field(
        ...,
        description="Password",
    )


class UserResponse(SvaraBaseModel):
    id_user: str
    username: str
    nama: str
    email: Optional[str] = None
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class TokenResponse(SvaraBaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class PredictResponse(SvaraBaseModel):
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


class PredictRequest(SvaraBaseModel):
    id_record: str = Field(
        ...,
        description="ID rekaman audio yang akan dianalisis",
    )


class ScreeningResponse(SvaraBaseModel):
    id_skr: str
    id_user: Optional[str] = None
    id_record: Optional[str] = None
    status: Optional[str] = None
    result_type: Optional[str] = None
    nama_penyakit: Optional[str] = None
    risk_analysis: Optional[float] = None
    confidence: Optional[float] = None
    heart_status: Optional[str] = None
    bpm_estimate: Optional[int] = None
    recommendation: Optional[str] = None
    model_name: Optional[str] = None
    model_version: Optional[str] = None
    inference_ms: Optional[int] = None
    raw_output: Optional[dict[str, Any]] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class HistoryResponse(SvaraBaseModel):
    id_history: str
    id_user: Optional[str] = None
    id_skr: str
    id_record: Optional[str] = None
    tanggal: Optional[datetime] = None
    created_at: Optional[datetime] = None
    audio_url: Optional[str] = None
    screening: Optional[ScreeningResponse] = None

    class Config:
        from_attributes = True


class NotificationResponse(SvaraBaseModel):
    id_notification: str
    id_user: Optional[str] = None
    id_skr: Optional[str] = None
    title: str
    message: str
    type: str
    is_read: bool
    created_at: Optional[datetime] = None
    read_at: Optional[datetime] = None


class NotificationCreateRequest(SvaraBaseModel):
    id_user: Optional[str] = None
    id_skr: Optional[str] = None
    title: str = Field(
        ...,
        min_length=1,
        max_length=160,
    )
    message: str = Field(
        ...,
        min_length=1,
    )
    type: str = Field(
        default="info",
        max_length=40,
    )


class UploadAudioResponse(SvaraBaseModel):
    message: str
    screening_id: str
    record_id: str
    status: str


class AnalyzeScreeningResponse(SvaraBaseModel):
    message: str
    data: ScreeningResponse