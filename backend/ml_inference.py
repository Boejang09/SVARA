"""Adapter inference ML untuk SVARA.

Saat model asli sudah tersedia, cukup ganti isi run_prediction().
Kontrak response dict di file ini dipakai router, database, history, dan notifikasi.
"""
import requests

def run_prediction(file_path: str, file_format: str) -> dict:
    """
    Jalankan inference audio jantung dengan memanggil API deep learning eksternal.
    """
    url = "https://visiting-mustard-cleat.ngrok-free.dev/predict"
    
    try:
        with open(file_path, "rb") as f:
            files = {"audio": (file_path.split("/")[-1] if "/" in file_path else file_path.split("\\")[-1], f, f"audio/{file_format}")}
            response = requests.post(url, files=files)
            response.raise_for_status()
            data = response.json()
            
            prediction_label = data.get("prediction", "Unknown")
            
            # Map API response to backend requirements
            result = {
                "nama_penyakit": prediction_label,
                "risk_analysis": 10.0 if prediction_label == "Normal" else 85.0,
                "confidence": 0.95,
                "heart_status": prediction_label,
                "bpm_estimate": 80,
                "recommendation": f"Status: {prediction_label}."
            }
            
            if prediction_label != "Normal":
                result["recommendation"] += " Disarankan konsultasi ke dokter."
            else:
                result["recommendation"] += " Kondisi jantung Anda normal."
                
            return result
    except Exception as e:
        print(f"Error calling ML API: {e}")
        # Fallback in case of error
        return {
            "nama_penyakit": "Error",
            "risk_analysis": 0.0,
            "confidence": 0.0,
            "heart_status": "Gagal Menganalisa",
            "bpm_estimate": 0,
            "recommendation": "Terjadi kesalahan saat menghubungi server AI."
        }
