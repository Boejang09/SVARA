# SVARA

**SVARA (Smart Voice for Cardiac Risk Assessment)** adalah aplikasi mobile untuk skrining awal suara jantung yang mengintegrasikan Flutter, FastAPI, PostgreSQL, dan Machine Learning berbasis PyTorch.

> **Disclaimer:** SVARA adalah alat bantu skrining awal. Hasil sistem bukan diagnosis medis definitif dan tidak menggantikan pemeriksaan atau keputusan tenaga kesehatan profesional.


## Daftar Isi

- Tentang SVARA
- Tujuan
- Fitur
- Arsitektur
- Teknologi
- Struktur Repository
- Alur Sistem
- Machine Learning
- Instalasi dan Konfigurasi
- Menjalankan ML API
- Menjalankan Backend
- Menjalankan Flutter
- Build APK
- Pengujian
- Endpoint API
- Penanganan Rekaman Tidak Jelas
- Troubleshooting
- Keamanan
- Status MVP
- Keterbatasan
- Deployment Demo/GEMASTIK
- Git Workflow
- Checklist Demo

---

## Tentang SVARA

SVARA menerima rekaman suara jantung, menyimpannya melalui backend, mengirimkannya ke layanan Machine Learning, menyimpan hasil screening, lalu menampilkan hasil dan riwayat pada aplikasi mobile.

```text
Flutter
   |
   | HTTP/REST
   v
FastAPI Backend
   |    |  \--> PostgreSQL
   |
   v
ML Inference API (Flask)
   |
   v
ResNet18 + best.pth
```

## Tujuan

1. Menyediakan aplikasi mobile untuk skrining awal.
2. Mengelola rekaman suara jantung secara terstruktur.
3. Mengintegrasikan Machine Learning dengan aplikasi mobile.
4. Menyimpan hasil screening dan riwayat.
5. Menghindari hasil yang menyesatkan ketika kualitas rekaman tidak memadai.

## Fitur

### Mobile
- Register dan login.
- JWT authentication.
- Profil pengguna.
- Rekam/upload audio.
- Screening suara jantung.
- Status dan hasil analisis.
- Penanganan `Artifact` sebagai `Rekaman tidak jelas`.
- Riwayat screening.
- Pemutaran audio.
- Notifikasi.
- Berita/informasi kesehatan.

### Backend
- REST API FastAPI.
- Authentication dan authorization.
- Manajemen pengguna.
- Upload audio.
- Screening dan history.
- Integrasi ML.
- Penyimpanan hasil ML.
- Notifikasi.
- Static serving audio.
- Health check.
- OpenAPI/Swagger.

### Machine Learning
- Resampling dan segmentasi audio.
- Mel-Spectrogram.
- ResNet18 multi-class classification.
- Majority voting pada level audio.
- Confidence prediction.
- Penanganan `Artifact`.

---

# Arsitektur

```text
┌──────────────────────────┐
│      Flutter Mobile      │
│ Login / Upload / Result  │
│ History / Profile        │
└────────────┬─────────────┘
             │ HTTP/REST
             v
┌──────────────────────────┐
│      FastAPI Backend     │
│ Auth / Records / Screen  │
│ History / Notifications  │
│ ML Adapter               │
└───────┬───────────┬──────┘
        │           │
        │           v
        │    ┌───────────────┐
        │    │  Flask ML API │
        │    └───────┬───────┘
        │            v
        │    ┌───────────────┐
        │    │ ResNet18      │
        │    │ best.pth      │
        │    └───────────────┘
        v
┌──────────────────────────┐
│       PostgreSQL         │
│ users / records          │
│ skrinings / histories    │
│ ml_prediction_jobs       │
│ notifications            │
└──────────────────────────┘
```

# Teknologi

| Komponen | Teknologi |
|---|---|
| Mobile | Flutter / Dart |
| Backend | Python / FastAPI |
| ORM | SQLAlchemy |
| Validation | Pydantic |
| Database | PostgreSQL |
| Authentication | JWT |
| ML API | Flask |
| Deep Learning | PyTorch |
| Model | ResNet18 |
| Audio | Librosa |
| Numerical | NumPy |
| Evaluation | Scikit-learn |
| Version Control | Git / GitHub |

# Struktur Repository

```text
svara_app/
├── mobile_app/
├── backend/
│   ├── main.py
│   ├── database.py
│   ├── models.py
│   ├── schemas.py
│   ├── auth_utils.py
│   ├── ml_inference.py
│   ├── requirements.txt
│   ├── .env.example
│   ├── routers/
│   │   ├── auth.py
│   │   ├── record.py
│   │   └── screening.py
│   └── uploads/
│       └── audio/
├── ml/
│   ├── heart_sound_api/
│   │   ├── app.py
│   │   └── key
│   ├── checkpoints_combine_dataset_artifact/
│   │   └── best.pth
│   └── heart_sound_diagnosis_classification_drive_combine_dataset_artifact.ipynb
└── README.md
```

Virtual environment (`venv`, `.venv`) dan credential lokal tidak perlu di-commit.

# Alur Sistem

```text
Login
  ↓
Rekam / Upload Audio
  ↓
POST /api/records/upload
  ↓
Screening dibuat
  ↓
POST /api/screenings/{id}/analyze
  ↓
FastAPI → ML API /predict
  ↓
Audio → 5 detik → Mel-Spectrogram → ResNet18
  ↓
Prediction
  ↓
FastAPI menyimpan hasil
  ↓
Flutter menampilkan hasil
  ↓
History
```

# Machine Learning

Pipeline training pada notebook:

1. Download dataset.
2. Analisis struktur dataset.
3. Menyusun metadata.
4. Menggabungkan dataset dan kelas yang diperlukan.
5. Split train/test per audio dengan stratifikasi.
6. Segmentasi 5 detik.
7. Mel-Spectrogram.
8. ResNet18 multi-class.
9. Class-weighted loss.
10. Augmentasi audio untuk training.
11. Checkpoint `last.pth` dan `best.pth`.
12. Evaluasi Accuracy, Precision, Recall, F1, dan confusion matrix.
13. Evaluasi level audio menggunakan majority voting.

Dataset yang digunakan pada notebook mencakup:

- `bjoernjostein/physionet-challenge-2016`
- `asirisirithunga/yaseen21khan-public-heart-sounds`
- `zkyfauzi/heartbeat-sound` untuk kelas `Artifact`

Konfigurasi inference:

```text
Target sample rate : 4000 Hz
Segment duration   : 5 detik
Mel bins            : 128
FFT                 : 1024
Hop length          : 256
```

Preprocessing:

```text
Audio
 ↓
Resampling
 ↓
5-second segmentation
 ↓
Mel-Spectrogram
 ↓
Power-to-dB
 ↓
Mean/std normalization
 ↓
ResNet18
```

Checkpoint yang digunakan:

```text
Architecture : ResNet18
Classes      : 9
Device       : CPU
Epoch        : 13
Test Macro F1: 0.7984753779290641
Checkpoint   : best.pth
```

Nilai tersebut adalah hasil evaluasi checkpoint dan bukan validasi klinis.

# Kelas Model

```text
AP
Artifact
Benign
CAD
MR
MS
MVP
Normal
PC
```

`Artifact` tidak diperlakukan sebagai diagnosis. Jika hasilnya `Artifact`, layanan mengembalikan kondisi `retry`.

# Persyaratan Sistem

Siapkan:

- Python yang kompatibel dengan dependency proyek.
- Flutter SDK.
- Dart SDK melalui Flutter.
- PostgreSQL.
- Android SDK jika memakai Android.
- Git.

Periksa:

```powershell
python --version
flutter --version
dart --version
git --version
flutter devices
```

# Persiapan Repository

```powershell
git clone <URL_REPOSITORY_SVARA>
cd svara_app
```

# Konfigurasi PostgreSQL

Pastikan PostgreSQL aktif dan database tersedia.

Format:

```env
DATABASE_URL=postgresql://USERNAME:PASSWORD@HOST:PORT/DATABASE
```

Contoh:

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/svara
```

Gunakan credential sesuai environment lokal.

Backend menggunakan SQLAlchemy. Saat startup, tabel yang didefinisikan pada model dibuat jika belum tersedia.

# Konfigurasi Backend

```powershell
cd backend
python -m venv venv
.env\Scripts\Activate.ps1
pip install -r requirements.txt
```

Buat `backend/.env`:

```env
DATABASE_URL=postgresql://USERNAME:PASSWORD@HOST:PORT/DATABASE

JWT_SECRET_KEY=GANTI_DENGAN_SECRET_YANG_AMAN
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

ML_API_URL=http://127.0.0.1:5000/predict
ML_API_TIMEOUT_SECONDS=45
ML_API_KEY=GANTI_DENGAN_KEY_ML
```

Jangan commit nilai rahasia sebenarnya.

# Konfigurasi ML API

```powershell
cd ml\heart_sound_api
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Environment ML membutuhkan komponen seperti:

```text
Flask
PyTorch
Torchvision
Librosa
NumPy
Scikit-learn
Pyngrok
```

Pastikan checkpoint tersedia:

```text
ml/checkpoints_combine_dataset_artifact/best.pth
```

Layanan ML memvalidasi header `Authorization` menggunakan key lokal. Key tersebut adalah credential dan tidak boleh dipublikasikan.

# Menjalankan ML API

Terminal 1:

```powershell
cd ml\heart_sound_api
.\.venv\Scripts\Activate.ps1
python app.py
```

ML API:

```text
http://127.0.0.1:5000
```

Health check:

```powershell
curl.exe http://127.0.0.1:5000/health
```

Expected:

```json
{
  "classes": ["AP", "Artifact", "Benign", "CAD", "MR", "MS", "MVP", "Normal", "PC"],
  "device": "cpu",
  "model": "ResNet18",
  "num_classes": 9,
  "status": "ok"
}
```

# Menjalankan Backend

Terminal 2:

```powershell
cd backend
.env\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8000
```

Backend:

```text
http://127.0.0.1:8000
```

Health check:

```powershell
curl.exe http://127.0.0.1:8000/health
```

Expected:

```json
{
  "status": "ok",
  "database": "connected"
}
```

Swagger:

```text
http://127.0.0.1:8000/docs
```

# Menjalankan Flutter

Terminal 3:

```powershell
cd mobile_app
flutter pub get
flutter devices
```

Emulator/device yang dapat mengakses localhost:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Android fisik melalui jaringan lokal:

```powershell
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Contoh:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.0.103:8000
```

Gunakan IP aktual laptop, bukan contoh di atas.

# Android: USB dan Wi-Fi

## USB

Aktifkan Developer Options dan USB Debugging.

```powershell
flutter devices
flutter run -d <DEVICE_ID> --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Jika `adb` tidak dikenali, pastikan Android SDK Platform Tools tersedia pada PATH. Flutter tetap dapat mendeteksi device jika konfigurasi Android SDK benar.

## Wi-Fi

Laptop dan HP harus berada pada jaringan yang dapat saling mengakses.

Cari IP:

```powershell
ipconfig
```

Kemudian gunakan IPv4 laptop:

```powershell
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Pastikan firewall tidak memblokir port `8000`.

# Build APK

Untuk testing dengan backend lokal:

```powershell
cd mobile_app
flutter build apk --release --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Contoh:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=http://192.168.0.103:8000
```

Output:

```text
mobile_app/build/app/outputs/flutter-apk/app-release.apk
```

APK dengan alamat `192.168.x.x` masih bergantung pada laptop sebagai server. Jika IP berubah, endpoint perlu dikonfigurasi ulang atau APK dibuild kembali.

# Pengujian End-to-End

Urutan:

```text
1. PostgreSQL aktif
2. ML API aktif
3. Backend aktif
4. Health check ML = OK
5. Health check Backend = OK
6. Flutter aktif
7. Login
8. Rekam/upload audio
9. Screening dibuat
10. Analisis dijalankan
11. ML menerima /predict
12. Backend menyimpan hasil
13. Flutter menampilkan hasil
14. Riwayat diperiksa
15. Audio dapat diputar
```

Backend seharusnya menunjukkan:

```text
POST /api/auth/login
POST /api/records/upload
POST /api/screenings/{screening_id}/analyze
```

ML seharusnya menunjukkan:

```text
POST /predict
```

# Health Check

ML:

```powershell
curl.exe http://127.0.0.1:5000/health
```

Backend:

```powershell
curl.exe http://127.0.0.1:8000/health
```

Kedua endpoint harus berhasil sebelum pengujian end-to-end.

# Endpoint API

## Auth

```text
POST /api/auth/register
POST /api/auth/login
GET  /api/auth/me
```

## Records

```text
POST /api/records/upload
```

## Screening

```text
GET    /api/screenings/
GET    /api/screenings/{screening_id}
POST   /api/screenings/{screening_id}/analyze
DELETE /api/screenings/{screening_id}
```

## History

```text
GET /api/history/
GET /api/history/{history_id}
```

## Notifications

```text
GET   /api/notifications/
POST  /api/notifications/
PATCH /api/notifications/{notification_id}/read
```

Dokumentasi interaktif tersedia pada:

```text
http://127.0.0.1:8000/docs
```

# Penanganan Rekaman Tidak Jelas

Contoh response ML:

```json
{
  "prediction": "Artifact",
  "result_type": "retry",
  "status": "success",
  "segment_details": ["Artifact", "Artifact"]
}
```

FastAPI menyimpan:

```text
status        = retry
nama_penyakit = None
heart_status  = Rekaman tidak jelas
```

Flutter kemudian memberi tahu pengguna bahwa rekaman belum cukup jelas dan meminta perekaman ulang.

Artinya:

```text
Artifact ≠ diagnosis
Artifact → retry → Rekaman tidak jelas
```

# Troubleshooting

## `ModuleNotFoundError`

Aktifkan environment yang benar:

```powershell
.env\Scripts\Activate.ps1
```

atau untuk ML:

```powershell
.\.venv\Scripts\Activate.ps1
```

Kemudian install dependency.

## Database disconnected

Periksa:

```env
DATABASE_URL=...
```

Pastikan PostgreSQL aktif dan credential benar.

## Login `422`

Body login harus mengikuti schema:

```json
{
  "username": "username",
  "password": "password"
}
```

## Token tidak valid

Periksa JWT secret, algorithm, expiration, dan token yang dikirim Flutter. Restart backend setelah mengubah `.env`.

## Analisis `502 Bad Gateway`

Periksa:

```text
FastAPI :8000
ML API  :5000
ML_API_URL
ML_API_KEY
ML_API_TIMEOUT_SECONDS
```

Pastikan ML menerima:

```text
POST /predict
```

## ML `401 Unauthorized`

Pastikan `ML_API_KEY` pada backend sama dengan key lokal yang digunakan ML API. Jangan tampilkan key sebenarnya.

## HP tidak dapat mengakses backend

Pastikan FastAPI menggunakan:

```powershell
uvicorn main:app --host 0.0.0.0 --port 8000
```

Periksa IP dengan:

```powershell
ipconfig
```

Pastikan firewall dan jaringan mengizinkan akses port `8000`.

## Hasil `Artifact`

Jika:

```text
status = success
prediction = Artifact
result_type = retry
```

API berhasil melakukan inference. Model menganggap rekaman sebagai artifact sehingga SVARA meminta perekaman ulang.

Gunakan rekaman dengan suara jantung lebih jelas dan noise lingkungan lebih rendah.

# Keamanan

Jangan commit:

```text
.env
key
database password
JWT secret
ML API key
credential files
```

Gunakan `.env.example` tanpa nilai rahasia.

JWT secret harus acak dan kuat.

ML API key hanya digunakan untuk autentikasi komunikasi FastAPI → ML API.

# Status MVP

```text
MVP — Functional
```

Komponen terintegrasi:

```text
[✓] Flutter
[✓] Register
[✓] Login
[✓] JWT authentication
[✓] PostgreSQL
[✓] Audio upload
[✓] Screening
[✓] ML inference API
[✓] ResNet18
[✓] Mel-Spectrogram
[✓] 5-second segmentation
[✓] Majority voting
[✓] Confidence
[✓] Artifact / retry handling
[✓] Result persistence
[✓] History
[✓] Audio playback
[✓] Notifications
[✓] Backend health check
[✓] ML health check
[✓] Android testing
```

# Keterbatasan MVP

MVP saat ini masih dapat dijalankan menggunakan arsitektur lokal:

```text
Flutter
  ↓
Laptop / Local Network
  ↓
FastAPI
  ↓
ML API
  ↓
best.pth
```

Endpoint seperti:

```text
http://192.168.x.x:8000
```

bersifat environment-specific.

Untuk deployment production, backend dan ML sebaiknya ditempatkan pada server dengan alamat yang konsisten, HTTPS, secret management, monitoring, dan production-grade server.

Performa model juga belum boleh dianggap sebagai validasi klinis.

# Deployment Demo / GEMASTIK

Untuk demonstrasi lokal pada satu laptop:

### Terminal 1 — ML

```powershell
cd ml\heart_sound_api
.\.venv\Scripts\Activate.ps1
python app.py
```

### Terminal 2 — Backend

```powershell
cd backend
.env\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Terminal 3 — Flutter

```powershell
cd mobile_app
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Arsitektur:

```text
HP Android
    |
    | Wi-Fi / Local Network
    v
Laptop
    |
    +-- FastAPI :8000
    |      |
    |      +-- PostgreSQL
    |
    +-- ML Flask :5000
           |
           +-- best.pth
```

Untuk HP lain, USB tidak diperlukan jika HP dapat mengakses laptop melalui jaringan.

Untuk panitia yang menjalankan repository pada laptop berbeda, konfigurasi lokal harus dibuat ulang:

```text
Clone repository
  ↓
Install dependencies
  ↓
Setup PostgreSQL
  ↓
Configure backend .env
  ↓
Configure ML key
  ↓
Run ML API
  ↓
Run FastAPI
  ↓
Configure Flutter API endpoint
  ↓
Run/build Flutter
  ↓
Test end-to-end
```

IP laptop pengembang tidak boleh menjadi asumsi permanen dalam repository.

# Git Workflow

Gunakan Conventional Commits:

```text
type(scope): description
```

Contoh:

```text
feat(auth): tambah autentikasi pengguna
feat(screening): tambah proses analisis rekaman
feat(history): tambah riwayat screening
fix(screening): perbaiki tampilan analisis rekaman tidak jelas
fix(auth): perbaiki validasi token
refactor(backend): rapikan integrasi layanan ML
docs(readme): perbarui dokumentasi proyek
```

Sebelum commit:

```powershell
git status
```

Commit:

```powershell
git add .
git commit -m "fix(screening): perbaiki tampilan analisis rekaman tidak jelas"
git push origin main
```

Verifikasi:

```powershell
git status
git log -1 --oneline
```

# Checklist Demo

```text
[ ] PostgreSQL aktif
[ ] DATABASE_URL benar
[ ] Backend environment aktif
[ ] ML environment aktif
[ ] best.pth tersedia
[ ] ML API aktif
[ ] ML /health = OK
[ ] FastAPI aktif
[ ] FastAPI /health = database connected
[ ] ML_API_URL benar
[ ] ML_API_KEY benar
[ ] JWT configuration benar
[ ] Flutter API_BASE_URL benar
[ ] Android device siap
[ ] Login berhasil
[ ] Upload audio berhasil
[ ] Screening berhasil dibuat
[ ] Analisis berhasil
[ ] ML menerima /predict
[ ] Hasil tersimpan
[ ] Hasil tampil di Flutter
[ ] Artifact ditampilkan sebagai Rekaman tidak jelas
[ ] Riwayat tampil
[ ] Audio dapat diputar
```

# Ringkasan Menjalankan

Setelah seluruh konfigurasi selesai, cukup jalankan tiga terminal.

**ML:**

```powershell
cd ml\heart_sound_api
.\.venv\Scripts\Activate.ps1
python app.py
```

**Backend:**

```powershell
cd backend
.env\Scripts\Activate.ps1
uvicorn main:app --host 0.0.0.0 --port 8000
```

**Flutter:**

```powershell
cd mobile_app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8000
```

Alur penggunaan:

```text
Login
 ↓
Rekam / Upload
 ↓
Audio tersimpan
 ↓
Analisis
 ↓
Machine Learning
 ↓
Hasil Screening
 ↓
Riwayat
```

# Disclaimer Medis

SVARA adalah teknologi bantu skrining awal.

Hasil Machine Learning tidak boleh digunakan sebagai satu-satunya dasar untuk menentukan diagnosis, pengobatan, menghentikan pengobatan, atau mengambil keputusan medis darurat.

Jika pengguna mengalami gejala yang mengkhawatirkan, pemeriksaan oleh tenaga kesehatan tetap diperlukan.

---

**SVARA — Smart Voice Analysis for Recognition & Assessment**
