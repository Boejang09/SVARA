import os

from dotenv import load_dotenv
from sqlalchemy import create_engine
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
    print("[DB] Semua tabel berhasil dibuat!")
