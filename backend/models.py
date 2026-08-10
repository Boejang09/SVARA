"""
SQLAlchemy models untuk SVARA database.
Schema berdasarkan whiteboard + kolom tambahan untuk kesiapan ML.
"""
import uuid
from datetime import datetime

from sqlalchemy import (
    Column,
    String,
    Integer,
    Float,
    DateTime,
    ForeignKey,
    Text,
    Boolean,
)
from sqlalchemy.orm import relationship

from database import Base


def _gen_uuid() -> str:
    return str(uuid.uuid4())


# ──────────────────────────────────────────────
# User  (Auth via username + password)
# ──────────────────────────────────────────────
class User(Base):
    __tablename__ = "users"

    id_user = Column(String, primary_key=True, default=_gen_uuid)
    username = Column(String(50), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    nama = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=True, index=True)
    phone = Column(String(20), nullable=True)
    avatar_url = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    records = relationship("Record", back_populates="user", cascade="all, delete-orphan")
    skrinings = relationship("Skrining", back_populates="user", cascade="all, delete-orphan")
    histories = relationship("History", back_populates="user", cascade="all, delete-orphan")
    notifications = relationship("Notification", back_populates="user", cascade="all, delete-orphan")
    ml_jobs = relationship("MLPredictionJob", back_populates="user", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<User {self.username} ({self.nama})>"


# ──────────────────────────────────────────────
# Record  (Rekaman suara)
# ──────────────────────────────────────────────
class Record(Base):
    __tablename__ = "records"

    id_suara = Column(String, primary_key=True, default=_gen_uuid)
    id_user = Column(String, ForeignKey("users.id_user"), nullable=True)
    nama = Column(String(255), nullable=False)
    file_path = Column(Text, nullable=False)
    file_format = Column(String(10), nullable=False, default="wav")  # wav, m4a, etc.
    duration_seconds = Column(Float, nullable=True)
    file_size_bytes = Column(Integer, nullable=True)
    sample_rate = Column(Integer, nullable=True)  # e.g. 44100, 16000
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="records")
    skrinings = relationship("Skrining", back_populates="record", cascade="all, delete-orphan")
    ml_jobs = relationship("MLPredictionJob", back_populates="record", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Record {self.nama} ({self.file_format})>"


# ──────────────────────────────────────────────
# Skrining  (Hasil screening / analisis)
# ──────────────────────────────────────────────
class Skrining(Base):
    __tablename__ = "skrinings"

    id_skr = Column(String, primary_key=True, default=_gen_uuid)
    id_user = Column(String, ForeignKey("users.id_user"), nullable=True)
    id_record = Column(String, ForeignKey("records.id_suara"), nullable=True)
    nama_penyakit = Column(String(255), nullable=True)
    risk_analysis = Column(Float, nullable=True)  # 0.0 - 100.0
    confidence = Column(Float, nullable=True)
    heart_status = Column(String(120), nullable=True)
    bpm_estimate = Column(Integer, nullable=True)
    recommendation = Column(Text, nullable=True)
    model_name = Column(String(120), nullable=True)
    model_version = Column(String(80), nullable=True)
    inference_ms = Column(Integer, nullable=True)
    raw_output = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="skrinings")
    record = relationship("Record", back_populates="skrinings")
    histories = relationship("History", back_populates="skrining", cascade="all, delete-orphan")
    notifications = relationship("Notification", back_populates="skrining", cascade="all, delete-orphan")
    ml_jobs = relationship("MLPredictionJob", back_populates="skrining", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Skrining {self.nama_penyakit} risk={self.risk_analysis}>"


# ──────────────────────────────────────────────
# History  (Riwayat screening)
# ──────────────────────────────────────────────
class History(Base):
    __tablename__ = "histories"

    id_history = Column(String, primary_key=True, default=_gen_uuid)
    id_user = Column(String, ForeignKey("users.id_user"), nullable=True)
    id_skr = Column(String, ForeignKey("skrinings.id_skr"), nullable=False)
    id_record = Column(String, ForeignKey("records.id_suara"), nullable=True)
    tanggal = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="histories")
    skrining = relationship("Skrining", back_populates="histories")

    def __repr__(self):
        return f"<History {self.id_history} skr={self.id_skr}>"


class MLPredictionJob(Base):
    __tablename__ = "ml_prediction_jobs"

    id_job = Column(String, primary_key=True, default=_gen_uuid)
    id_user = Column(String, ForeignKey("users.id_user"), nullable=True)
    id_record = Column(String, ForeignKey("records.id_suara"), nullable=False)
    id_skr = Column(String, ForeignKey("skrinings.id_skr"), nullable=True)
    status = Column(String(40), nullable=False, default="completed")
    provider = Column(String(80), nullable=False, default="dummy")
    model_name = Column(String(120), nullable=True)
    model_version = Column(String(80), nullable=True)
    error_message = Column(Text, nullable=True)
    started_at = Column(DateTime, default=datetime.utcnow)
    finished_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="ml_jobs")
    record = relationship("Record", back_populates="ml_jobs")
    skrining = relationship("Skrining", back_populates="ml_jobs")


class Notification(Base):
    __tablename__ = "notifications"

    id_notification = Column(String, primary_key=True, default=_gen_uuid)
    id_user = Column(String, ForeignKey("users.id_user"), nullable=True)
    id_skr = Column(String, ForeignKey("skrinings.id_skr"), nullable=True)
    title = Column(String(160), nullable=False)
    message = Column(Text, nullable=False)
    type = Column(String(40), nullable=False, default="info")
    is_read = Column(Boolean, nullable=False, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    read_at = Column(DateTime, nullable=True)

    user = relationship("User", back_populates="notifications")
    skrining = relationship("Skrining", back_populates="notifications")
