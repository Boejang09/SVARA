import os

from dotenv import load_dotenv
from sqlalchemy import create_engine, inspect, text
from sqlalchemy.orm import sessionmaker, declarative_base

# Load environment variables dari file .env
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:admin@localhost:5432/svara_db")

engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    """Dependency untuk mendapatkan database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """Buat semua tabel di database berdasarkan models."""
    # Import models agar Base.metadata tahu semua tabel
    import models  # noqa: F401

    print("[DB] Membuat tabel database...")
    Base.metadata.create_all(bind=engine)
    _ensure_runtime_columns()
    print("[DB] Semua tabel berhasil dibuat!")


def _ensure_runtime_columns():
    """Tambahkan kolom baru untuk database lama yang sudah pernah dibuat."""
    inspector = inspect(engine)
    if "skrinings" not in inspector.get_table_names():
        return

    existing = {column["name"] for column in inspector.get_columns("skrinings")}
    required_columns = {
        "confidence": "DOUBLE PRECISION",
        "heart_status": "VARCHAR(120)",
        "bpm_estimate": "INTEGER",
        "recommendation": "TEXT",
        "model_name": "VARCHAR(120)",
        "model_version": "VARCHAR(80)",
        "inference_ms": "INTEGER",
        "raw_output": "TEXT",
    }

    with engine.begin() as conn:
        for column_name, column_type in required_columns.items():
            if column_name not in existing:
                conn.execute(
                    text(f"ALTER TABLE skrinings ADD COLUMN {column_name} {column_type}")
                )
