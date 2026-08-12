"""Adapter API ML eksternal untuk analisis rekaman SVARA."""
import os
from dataclasses import dataclass
from typing import Any

import requests
from dotenv import load_dotenv

load_dotenv()

DEFAULT_ML_TIMEOUT_SECONDS = 45


class MLInferenceError(Exception):
    """Error terkontrol saat komunikasi atau validasi response ML gagal."""


@dataclass(frozen=True)
class MLResult:
    filename: str | None
    prediction: str
    segment_details: list[str]
    status: str
    raw_response: dict[str, Any]


def _ml_api_url() -> str:
    url = os.getenv("ML_API_URL", "").strip()
    if not url:
        raise MLInferenceError("ML_API_URL belum dikonfigurasi.")
    return url


def run_prediction(file_path: str, file_format: str = "wav") -> MLResult:
    """Kirim audio ke API ML dan validasi response inti."""
    if not os.path.exists(file_path):
        raise MLInferenceError("File audio tidak ditemukan.")

    timeout = int(os.getenv("ML_API_TIMEOUT_SECONDS", str(DEFAULT_ML_TIMEOUT_SECONDS)))
    filename = os.path.basename(file_path)
    content_type = "audio/wav" if file_format.lower() == "wav" else "application/octet-stream"

    try:
        with open(file_path, "rb") as audio_file:
            response = requests.post(
                _ml_api_url(),
                files={"audio": (filename, audio_file, content_type)},
                timeout=timeout,
            )
    except requests.Timeout as exc:
        raise MLInferenceError("Koneksi ke layanan ML terlalu lama.") from exc
    except requests.RequestException as exc:
        raise MLInferenceError("Layanan ML belum dapat dihubungi.") from exc

    if response.status_code >= 400:
        raise MLInferenceError(f"Layanan ML mengembalikan status {response.status_code}.")

    try:
        data = response.json()
    except ValueError as exc:
        raise MLInferenceError("Response ML bukan JSON yang valid.") from exc

    prediction = data.get("prediction")
    if not isinstance(prediction, str) or not prediction.strip():
        raise MLInferenceError("Response ML tidak memiliki field prediction.")

    segment_details = data.get("segment_details")
    if not isinstance(segment_details, list) or not all(
        isinstance(item, str) for item in segment_details
    ):
        raise MLInferenceError("Response ML tidak memiliki segment_details yang valid.")

    status = data.get("status")
    if not isinstance(status, str) or not status.strip():
        raise MLInferenceError("Response ML tidak memiliki status yang valid.")
    if status.strip().lower() != "success":
        raise MLInferenceError("Layanan ML belum berhasil menganalisis audio.")

    return MLResult(
        filename=data.get("filename") if isinstance(data.get("filename"), str) else filename,
        prediction=prediction.strip(),
        segment_details=segment_details,
        status=status.strip(),
        raw_response=data,
    )
