import io
import hmac
import math
import os
from pathlib import Path

import librosa
import numpy as np
import torch
import torch.nn as nn
import torchvision
from flask import Flask, jsonify, request


# ============================================================================
# PATH
# ============================================================================

BASE_DIR = Path(__file__).resolve().parent

MODEL_PATH = (
    BASE_DIR.parent
    / "checkpoints_combine_dataset_artifact"
    / "best.pth"
)

KEY_PATH = BASE_DIR / "key"


# ============================================================================
# AUDIO CONFIGURATION
# ============================================================================

TARGET_SR = 4000

SEGMENT_SEC = 5.0

SEGMENT_SAMPLES = int(
    SEGMENT_SEC * TARGET_SR,
)


# ============================================================================
# MEL-SPECTROGRAM CONFIGURATION
# ============================================================================

N_MELS = 128
N_FFT = 1024
HOP_LENGTH = 256


# ============================================================================
# MODEL CONFIGURATION
# ============================================================================

DEVICE = torch.device("cpu")

CLASS_NAMES = [
    "AP",
    "Artifact",
    "Benign",
    "CAD",
    "MR",
    "MS",
    "MVP",
    "Normal",
    "PC",
]

NUM_CLASSES = len(CLASS_NAMES)

ARTIFACT_CLASS = "Artifact"


# ============================================================================
# APPLICATION
# ============================================================================

app = Flask(__name__)


# ============================================================================
# MODEL
# ============================================================================

def build_resnet18(
    num_classes: int,
    in_channels: int = 1,
) -> nn.Module:
    model = torchvision.models.resnet18(
        weights=None,
    )

    old_conv = model.conv1

    new_conv = nn.Conv2d(
        in_channels,
        old_conv.out_channels,
        kernel_size=old_conv.kernel_size,
        stride=old_conv.stride,
        padding=old_conv.padding,
        bias=False,
    )

    model.conv1 = new_conv

    model.fc = nn.Linear(
        model.fc.in_features,
        num_classes,
    )

    return model


def load_inference_model(
    path: Path,
) -> tuple[nn.Module, list[str]]:
    if not path.exists():
        raise FileNotFoundError(
            f"Model checkpoint tidak ditemukan: {path}"
        )

    checkpoint = torch.load(
        path,
        map_location=DEVICE,
    )

    class_names = checkpoint.get(
        "class_names",
        CLASS_NAMES,
    )

    if list(class_names) != CLASS_NAMES:
        raise ValueError(
            "Class mapping checkpoint tidak sesuai "
            "dengan konfigurasi API."
        )

    model = build_resnet18(
        num_classes=len(class_names),
        in_channels=1,
    )

    model.load_state_dict(
        checkpoint["model_state_dict"],
    )

    model.to(DEVICE)
    model.eval()

    return model, list(class_names)


inference_model, target_labels = load_inference_model(
    MODEL_PATH,
)


# ============================================================================
# AUTHENTICATION
# ============================================================================

def load_api_key() -> str:
    environment_key = os.getenv(
        "ML_API_KEY",
    )

    if environment_key:
        return environment_key.strip()

    if KEY_PATH.exists():
        return KEY_PATH.read_text(
            encoding="utf-8",
        ).strip()

    return ""


def is_authorized() -> bool:
    expected_key = load_api_key()

    if not expected_key:
        return False

    authorization = request.headers.get(
        "Authorization",
        "",
    ).strip()

    return hmac.compare_digest(
        authorization,
        expected_key,
    )


# ============================================================================
# SEGMENTATION
# ============================================================================

def get_segment_starts(
    total_samples: int,
    segment_samples: int,
) -> list[int]:
    if total_samples <= segment_samples:
        return [0]

    number_of_segments = math.ceil(
        total_samples / segment_samples,
    )

    if number_of_segments <= 1:
        return [0]

    if total_samples % segment_samples == 0:
        return [
            index * segment_samples
            for index in range(number_of_segments)
        ]

    step = (
        total_samples - segment_samples
    ) / (number_of_segments - 1)

    starts = [
        int(round(index * step))
        for index in range(number_of_segments)
    ]

    starts[-1] = (
        total_samples - segment_samples
    )

    return starts


def extract_segments(
    waveform: np.ndarray,
) -> list[np.ndarray]:
    total_samples = len(waveform)

    starts = get_segment_starts(
        total_samples,
        SEGMENT_SAMPLES,
    )

    segments = []

    for start in starts:
        segment = waveform[
            start : start + SEGMENT_SAMPLES
        ]

        if len(segment) < SEGMENT_SAMPLES:
            segment = np.pad(
                segment,
                (
                    0,
                    SEGMENT_SAMPLES - len(segment),
                ),
                mode="constant",
            )

        segments.append(
            segment.astype(np.float32),
        )

    return segments


# ============================================================================
# MEL-SPECTROGRAM
# ============================================================================

def waveform_to_melspectrogram(
    waveform: np.ndarray,
) -> np.ndarray:
    mel = librosa.feature.melspectrogram(
        y=waveform,
        sr=TARGET_SR,
        n_fft=N_FFT,
        hop_length=HOP_LENGTH,
        n_mels=N_MELS,
    )

    mel_db = librosa.power_to_db(
        mel,
        ref=np.max,
    )

    mean = mel_db.mean()
    std = mel_db.std()

    mel_normalized = (
        mel_db - mean
    ) / (
        std + 1e-6
    )

    return mel_normalized.astype(
        np.float32,
    )


# ============================================================================
# PREDICTION
# ============================================================================

def predict_segment(
    segment: np.ndarray,
) -> tuple[int, float]:
    mel = waveform_to_melspectrogram(
        segment,
    )

    tensor = (
        torch.from_numpy(mel)
        .unsqueeze(0)
        .unsqueeze(0)
        .to(DEVICE)
    )

    with torch.no_grad():
        logits = inference_model(
            tensor,
        )

        probabilities = torch.softmax(
            logits,
            dim=1,
        )

        prediction = int(
            probabilities.argmax(
                dim=1,
            ).item()
        )

        confidence = float(
            probabilities[0, prediction].item()
        )

    return prediction, confidence


def classify_audio(
    waveform: np.ndarray,
) -> dict:
    segments = extract_segments(
        waveform,
    )

    segment_predictions = []
    segment_confidences = []

    for segment in segments:
        prediction, confidence = predict_segment(
            segment,
        )

        segment_predictions.append(
            prediction,
        )

        segment_confidences.append(
            confidence,
        )

    final_index = max(
        set(segment_predictions),
        key=segment_predictions.count,
    )

    final_label = target_labels[
        final_index
    ]

    final_label_confidences = [
        confidence
        for prediction, confidence in zip(
            segment_predictions,
            segment_confidences,
        )
        if prediction == final_index
    ]

    final_confidence = (
        float(
            np.mean(
                final_label_confidences,
            )
        )
        if final_label_confidences
        else 0.0
    )

    return {
        "prediction": final_label,
        "confidence": round(
            final_confidence,
            4,
        ),
        "segment_predictions": [
            target_labels[prediction]
            for prediction in segment_predictions
        ],
        "segment_confidences": [
            round(confidence, 4)
            for confidence in segment_confidences
        ],
        "segment_count": len(segments),
    }


# ============================================================================
# PREDICT ENDPOINT
# ============================================================================

@app.route(
    "/predict",
    methods=["POST"],
)
def predict():
    if not is_authorized():
        return jsonify({
            "status": "unauthorized",
            "code": 401,
            "message": "Unauthorized.",
        }), 401

    if "audio" not in request.files:
        return jsonify({
            "status": "failed",
            "code": 400,
            "message": "No audio file provided.",
        }), 400

    audio_file = request.files["audio"]

    if not audio_file.filename:
        return jsonify({
            "status": "failed",
            "code": 400,
            "message": "Audio filename is empty.",
        }), 400

    try:
        audio_bytes = audio_file.read()

        if not audio_bytes:
            return jsonify({
                "status": "failed",
                "code": 400,
                "message": "Audio file is empty.",
            }), 400

        waveform, _ = librosa.load(
            io.BytesIO(audio_bytes),
            sr=TARGET_SR,
            mono=True,
        )

        if len(waveform) == 0:
            return jsonify({
                "status": "failed",
                "code": 400,
                "message": "Audio contains no usable samples.",
            }), 400

        result = classify_audio(
            waveform,
        )

        prediction = result["prediction"]

        # ====================================================================
        # ARTIFACT
        # ====================================================================

        if prediction == ARTIFACT_CLASS:
            return jsonify({
                "status": "success",
                "code": 200,
                "filename": audio_file.filename,
                "prediction": ARTIFACT_CLASS,
                "result_type": "retry",
                "message": (
                    "Rekaman suara jantung belum cukup jelas "
                    "untuk dianalisis. Silakan lakukan "
                    "perekaman ulang."
                ),
                "confidence": result["confidence"],
                "segment_predictions": (
                    result["segment_predictions"]
                ),
                "segment_confidences": (
                    result["segment_confidences"]
                ),
                "segment_count": result["segment_count"],
            }), 200

        # ====================================================================
        # CLASSIFICATION RESULT
        # ====================================================================

        return jsonify({
            "status": "success",
            "code": 200,
            "filename": audio_file.filename,
            "prediction": prediction,
            "result_type": "classification",
            "message": (
                "Audio berhasil dianalisis."
            ),
            "confidence": result["confidence"],
            "segment_predictions": (
                result["segment_predictions"]
            ),
            "segment_confidences": (
                result["segment_confidences"]
            ),
            "segment_count": result["segment_count"],
        }), 200

    except Exception as exc:
        app.logger.exception(
            "Prediction failed",
        )

        return jsonify({
            "status": "failed",
            "code": 500,
            "message": "Audio gagal dianalisis.",
            "error": str(exc),
        }), 500


# ============================================================================
# HEALTH CHECK
# ============================================================================

@app.route(
    "/health",
    methods=["GET"],
)
def health():
    return jsonify({
        "status": "ok",
        "model": "ResNet18",
        "classes": target_labels,
        "num_classes": len(target_labels),
        "device": str(DEVICE),
    })


# ============================================================================
# ROOT
# ============================================================================

@app.route(
    "/",
    methods=["GET"],
)
def index():
    return jsonify({
        "service": "SVARA Heart Sound ML API",
        "status": "running",
        "endpoint": "/predict",
        "health": "/health",
    })


# ============================================================================
# RUN
# ============================================================================

if __name__ == "__main__":
    port = int(
        os.getenv(
            "ML_PORT",
            "5000",
        )
    )

    app.run(
        host="0.0.0.0",
        port=port,
        debug=False,
    )
