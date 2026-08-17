# Heart Sound Diagnosis Classification System

Sistem klasifikasi otomatis untuk diagnosis kondisi jantung berdasarkan analisis sinyal suara jantung menggunakan Deep Learning dan Machine Learning.

## Deskripsi Proyek

Proyek ini menggunakan Convolutional Neural Networks (CNN) untuk mengklasifikasikan rekaman suara jantung menjadi. Sistem menganalisis fitur mel-spectrogram dari audio jantung dan menggunakan model yang telah dilatih untuk memberikan diagnosis otomatis.

## Persyaratan

### Sistem
- Python 3.8+
- CUDA (opsional, untuk GPU acceleration)
- 2GB+ RAM untuk inference

### Dependencies
Lihat `heart_sound_api/requirements.txt`:
- Flask 3.0.3
- PyTorch (dengan torchvision)
- NumPy 2.1.3
- librosa 0.10.2.post1
- soundfile 0.12.1
- pandas
- scikit-learn
- matplotlib
- kagglehub

## Struktur Direktori

```
.
├── README.md                                              # Dokumentasi proyek ini
├── heart_sound_diagnosis_classification_..._aug.ipynb    # Jupyter notebook untuk training
├── heart_sound_api/                                       # Aplikasi Flask API
│   ├── app.py                                            # Main Flask application
│   ├── requirements.txt                                   # Python dependencies
│   ├── vercel.json                                        # Konfigurasi deployment Vercel
│   └── tmp_uploads/                                       # Direktori temporary untuk upload file
└── checkpoints_combine_dataset_aug/                       # Model checkpoints
    ├── best.pth                                           # Model terbaik (training)
    └── last.pth                                           # Model terakhir (training)
```

## Instalasi dan Setup

### 1. Clone atau Download Repository
```bash
cd "d:\__PROJEK_KODING_APAPUN__\FINAL"
```

### 2. Buat Virtual Environment (Opsional tapi Direkomendasikan)
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r heart_sound_api/requirements.txt
```

### 4. Download Dataset (untuk training)
Dataset akan otomatis diunduh melalui kagglehub saat menjalankan notebook:
- PhysioNet Challenge 2016
- Yaseen21Khan Public Heart Sounds Dataset

## Cara Menggunakan

### A. Inference menggunakan API Flask

#### 1. Jalankan Flask Server
```bash
cd heart_sound_api
python app.py
```

Server akan berjalan di `http://localhost:5000` atau dengan ngrok tunnel jika dikonfigurasi.

#### 2. Endpoint API

**POST** `/predict`
- **Input**: (form-data audio) File audio WAV
- **Output**: JSON dengan prediksi

```bash
curl -X POST -F "file=@heart_sound.wav" http://localhost:5000/predict
```

**Response Example:**
```json
{
    "filename": "artifact__201106040933.wav",
    "prediction": "Normal",
    "segment_details": [
        "Normal",
        "Normal"
    ],
    "status": "success"
}
```

### B. Training Model (menggunakan Jupyter Notebook)

1. Buka `heart_sound_diagnosis_classification_drive_combine_dataset_aug.ipynb`
2. Jalankan cell secara berurutan:
   - Data loading dan preprocessing
   - Mel-spectrogram extraction
   - Model architecture definition
   - Training loop dengan validation
   - Model evaluation dan testing

**Catatan**: Proses training memerlukan waktu beberapa jam tergantung GPU availability.

## Spesifikasi Model

### Audio Processing Parameters
- **Target Sample Rate**: 4000 Hz
- **Segment Duration**: 5.0 seconds
- **Segment Samples**: 20000 samples
- **Mel-Spectrogram**:
  - N_MELS: 128
  - N_FFT: 1024
  - HOP_LENGTH: 256

### Model Output
- **Classes**: 
    0: AP
    1: Benign
    2: CAD
    3: MR
    4: MS
    5: MVP
    6: Normal
    7: PC
- **Output Format**: Probability distribution untuk setiap kelas

## Dataset Information

### Dataset yang Digunakan
1. **PhysioNet Challenge 2016**
   - Dataset komprehensif rekaman suara jantung
   - Referensi label dalam REFERENCE.csv
   - Anotasi diagnosis dalam Online_Appendix_training_set.csv

2. **Yaseen21Khan Public Heart Sounds Dataset**
   - Dataset tambahan untuk augmentasi data
   - Meningkatkan robustness model

### Data Augmentation
- Segmentasi audio menjadi chunks 5 detik
- Augmentasi untuk meningkatkan data training

## Evaluasi Model

### Metrik Evaluasi
- **Accuracy**: Persentase prediksi yang benar
- **Precision**: Ketepatan prediksi positif
- **Recall**: Coverage dari kasus positif
- **F1-Score**: Harmonic mean dari precision dan recall
- **Confusion Matrix**: Visualisasi prediksi vs actual
- **Classification Report**: Laporan detail per kelas

### Hasil Evaluasi
Lihat notebook untuk hasil training terbaru termasuk:
- Training history (loss, accuracy)
- Validation metrics
- Test set performance
- Confusion matrix visualization

## Troubleshooting

### Issue: Model tidak ditemukan
```
FileNotFoundError: [Errno 2] No such file or directory: 'checkpoints_combine_dataset_aug/best.pth'
```
**Solusi**: Pastikan file checkpoint ada atau download dari training atau cloud storage.

### Issue: Audio file format tidak support
**Solusi**: Konversi audio ke WAV format 16-bit, 4000 Hz atau gunakan librosa untuk konversi otomatis.

### Issue: Out of Memory
**Solusi**: 
- Kurangi batch size
- Gunakan shorter audio segments
- Pastikan tidak ada proses lain yang menggunakan banyak memory

### Issue: CUDA not available
**Solusi**: Model akan otomatis jatuh ke CPU. Untuk GPU support, install CUDA-compatible PyTorch version.

## Konfigurasi

### Audio Configuration (`app.py`)
```python
TARGET_SR = 4000           # Sample rate
SEGMENT_SEC = 5.0          # Durasi segment
N_MELS = 128               # Jumlah mel bins
N_FFT = 1024               # FFT window size
HOP_LENGTH = 256           # Hop length
```

## Deployment

### Local Deployment
Jalankan Flask server dan akses melalui `localhost:5000` atau public URL dengan ngrok.

## References

- **Librosa Documentation**: https://librosa.org/
- **PyTorch Documentation**: https://pytorch.org/docs/
- **PhysioNet Challenge 2016**: https://physionet.org/
- **Kaggle Datasets**: https://www.kaggle.com/

## Lisensi

Proyek ini menggunakan dataset publik dari PhysioNet dan Kaggle. Harap patuhi lisensi masing-masing dataset.

## Penulis

Dokumentasi dibuat untuk proyek Heart Sound Diagnosis Classification System.

## Support

Untuk pertanyaan atau issue:
1. Periksa section Troubleshooting
2. Review Jupyter notebook untuk contoh penggunaan
3. Periksa logs dari Flask API

---

**Last Updated**: Agustus 2024  
**Status**: Production Ready for Inference
