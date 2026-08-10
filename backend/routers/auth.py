"""
Router untuk autentikasi: Register, Login, dan Get Profile.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from auth_utils import (
    create_access_token,
    get_current_user,
    hash_password,
    verify_password,
)
from database import get_db
from models import User
from schemas import LoginRequest, RegisterRequest, TokenResponse, UserResponse

router = APIRouter(prefix="/api/auth", tags=["Auth"])


# ──────────────────────────────────────────────
# POST /api/auth/register  —  Daftar akun baru
# ──────────────────────────────────────────────
@router.post("/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def register(body: RegisterRequest, db: Session = Depends(get_db)):
    # Cek username sudah dipakai
    existing_user = db.query(User).filter(User.username == body.username).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Username '{body.username}' sudah digunakan",
        )

    # Cek email jika diberikan
    if body.email:
        existing_email = db.query(User).filter(User.email == body.email).first()
        if existing_email:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"Email '{body.email}' sudah terdaftar",
            )

    # Buat user baru
    user = User(
        username=body.username,
        password_hash=hash_password(body.password),
        nama=body.nama,
        email=body.email,
        phone=body.phone,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    # Buat token
    access_token = create_access_token(data={"sub": user.id_user})

    return TokenResponse(
        access_token=access_token,
        user=UserResponse(
            id_user=user.id_user,
            username=user.username,
            nama=user.nama,
            email=user.email,
            phone=user.phone,
            avatar_url=user.avatar_url,
            created_at=user.created_at,
        ),
    )


# ──────────────────────────────────────────────
# POST /api/auth/login  —  Login dengan username
# ──────────────────────────────────────────────
@router.post("/login", response_model=TokenResponse)
def login(body: LoginRequest, db: Session = Depends(get_db)):
    # Cari user berdasarkan username
    user = db.query(User).filter(User.username == body.username).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username atau password salah",
        )

    # Verifikasi password
    if not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username atau password salah",
        )

    # Buat token
    access_token = create_access_token(data={"sub": user.id_user})

    return TokenResponse(
        access_token=access_token,
        user=UserResponse(
            id_user=user.id_user,
            username=user.username,
            nama=user.nama,
            email=user.email,
            phone=user.phone,
            avatar_url=user.avatar_url,
            created_at=user.created_at,
        ),
    )


# ──────────────────────────────────────────────
# GET /api/auth/me  —  Get current user profile
# ──────────────────────────────────────────────
@router.get("/me", response_model=UserResponse)
def get_profile(current_user: User = Depends(get_current_user)):
    return UserResponse(
        id_user=current_user.id_user,
        username=current_user.username,
        nama=current_user.nama,
        email=current_user.email,
        phone=current_user.phone,
        avatar_url=current_user.avatar_url,
        created_at=current_user.created_at,
    )
