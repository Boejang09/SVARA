import os

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from sqlalchemy import text

from database import get_db, init_db

app = FastAPI(title="SVARA API", version="1.0.0")

# ── CORS (agar Flutter bisa akses) ────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Buat folder uploads jika belum ada ────────
os.makedirs("uploads/audio", exist_ok=True)

# ── Serve static files (audio uploads) ────────
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# ── Routers ───────────────────────────────────
from routers.record import router as record_router  # noqa: E402

app.include_router(record_router)


# ── Startup: auto-create semua tabel ──────────
@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/")
def read_root(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {
            "message": "Welcome to SVARA API",
            "database_status": "Connected to PostgreSQL Successfully!",
        }
    except Exception as e:
        return {
            "message": "Welcome to SVARA API",
            "database_status": "Failed to connect to PostgreSQL",
            "error": str(e),
        }

