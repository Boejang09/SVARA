import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import requests
from dotenv import load_dotenv

load_dotenv(
    Path(__file__).resolve().with_name(".env")
)

DEFAULT_ML_TIMEOUT_SECONDS = 45


class MLInferenceError(Exception):
    pass


@dataclass(frozen=True)
class MLResult:
    filename: str | None
    prediction: str
    result_type: str
    confidence: float | None
    segment_details: list[str]
    segment_confidences: list[float]
    status: str
    message: str | None
    raw_response: dict[str, Any]


def _ml_api_url() -> str:
    url = os.getenv("ML_API_URL", "").strip()

    if not url:
        raise MLInferenceError(
            "ML_API_URL belum dikonfigurasi."
        )

    return url


def run_prediction(
    file_path: str,
    file_format: str = "wav",
) -> MLResult:
    if not os.path.exists(file_path):
        raise MLInferenceError(
            "File audio tidak ditemukan."
        )

    try:
        timeout = int(
            os.getenv(
                "ML_API_TIMEOUT_SECONDS",
                str(DEFAULT_ML_TIMEOUT_SECONDS),
            )
        )
    except ValueError as exc:
        raise MLInferenceError(
            "ML_API_TIMEOUT_SECONDS tidak valid."
        ) from exc

    filename = os.path.basename(file_path)

    content_type = (
        "audio/wav"
        if file_format.lower() == "wav"
        else "application/octet-stream"
    )

    headers = {}

    ml_api_key = os.getenv(
        "ML_API_KEY",
        "",
    ).strip()

    if ml_api_key:
        headers["Authorization"] = ml_api_key

    try:
        with open(
            file_path,
            "rb",
        ) as audio_file:
            response = requests.post(
                _ml_api_url(),
                headers=headers,
                files={
                    "audio": (
                        filename,
                        audio_file,
                        content_type,
                    )
                },
                timeout=timeout,
            )

    except requests.Timeout as exc:
        raise MLInferenceError(
            "Koneksi ke layanan ML terlalu lama."
        ) from exc

    except requests.RequestException as exc:
        raise MLInferenceError(
            "Layanan ML belum dapat dihubungi."
        ) from exc

    if response.status_code >= 400:
        try:
            error_data = response.json()
            error_message = error_data.get(
                "message",
                f"Layanan ML mengembalikan status {response.status_code}.",
            )
        except ValueError:
            error_message = (
                f"Layanan ML mengembalikan status "
                f"{response.status_code}."
            )

        raise MLInferenceError(
            error_message
        )

    try:
        data = response.json()

    except ValueError as exc:
        raise MLInferenceError(
            "Response ML bukan JSON yang valid."
        ) from exc

    prediction = data.get("prediction")

    if not isinstance(
        prediction,
        str,
    ) or not prediction.strip():
        raise MLInferenceError(
            "Response ML tidak memiliki field prediction."
        )

    status = data.get("status")

    if not isinstance(
        status,
        str,
    ) or not status.strip():
        raise MLInferenceError(
            "Response ML tidak memiliki status yang valid."
        )

    if status.strip().lower() != "success":
        raise MLInferenceError(
            "Layanan ML belum berhasil menganalisis audio."
        )

    result_type = data.get(
        "result_type",
        "classification",
    )

    if result_type not in {
        "classification",
        "retry",
    }:
        raise MLInferenceError(
            "Response ML memiliki result_type yang tidak valid."
        )

    confidence = data.get("confidence")

    if confidence is not None:
        try:
            confidence = float(confidence)
        except (TypeError, ValueError) as exc:
            raise MLInferenceError(
                "Confidence dari ML tidak valid."
            ) from exc

    segment_details = data.get(
        "segment_predictions",
        data.get("segment_details", []),
    )

    if not isinstance(
        segment_details,
        list,
    ) or not all(
        isinstance(item, str)
        for item in segment_details
    ):
        raise MLInferenceError(
            "Response ML memiliki segment predictions yang tidak valid."
        )

    segment_confidences = data.get(
        "segment_confidences",
        [],
    )

    if not isinstance(
        segment_confidences,
        list,
    ):
        raise MLInferenceError(
            "Response ML memiliki segment confidences yang tidak valid."
        )

    parsed_segment_confidences = []

    for item in segment_confidences:
        try:
            parsed_segment_confidences.append(
                float(item)
            )
        except (TypeError, ValueError) as exc:
            raise MLInferenceError(
                "Segment confidence dari ML tidak valid."
            ) from exc

    message = data.get("message")

    if message is not None and not isinstance(
        message,
        str,
    ):
        message = str(message)

    return MLResult(
        filename=(
            data.get("filename")
            if isinstance(
                data.get("filename"),
                str,
            )
            else filename
        ),
        prediction=prediction.strip(),
        result_type=result_type,
        confidence=confidence,
        segment_details=segment_details,
        segment_confidences=parsed_segment_confidences,
        status=status.strip(),
        message=message,
        raw_response=data,
    )
