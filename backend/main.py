from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import get_db

app = FastAPI(title="SVARA API", version="1.0.0")

@app.get("/")
def read_root(db: Session = Depends(get_db)):
    try:
        # Coba jalankan query sederhana ke PostgreSQL
        db.execute(text("SELECT 1"))
        return {"message": "Welcome to SVARA API", "database_status": "Connected to PostgreSQL Successfully!"}
    except Exception as e:
        return {"message": "Welcome to SVARA API", "database_status": "Failed to connect to PostgreSQL", "error": str(e)}
