import 'dart:async';
import 'dart:io';

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

/// Service untuk merekam audio menggunakan package `record`.
/// Menyediakan stream amplitude real-time untuk animasi waveform.
class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _currentFilePath;
  Timer? _amplitudeTimer;

  // Stream controller untuk amplitude real-time
  final StreamController<double> _amplitudeController =
      StreamController<double>.broadcast();

  /// Stream amplitude (0.0 - 1.0) untuk animasi waveform
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  /// Apakah sedang merekam
  bool get isRecording => _isRecording;

  /// Path file terakhir yang direkam
  String? get lastFilePath => _currentFilePath;

  /// Mulai merekam audio.
  /// Return true jika berhasil, false jika gagal (misal: permission denied).
  Future<bool> startRecording() async {
    try {
      // Cek permission
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        return false;
      }

      // Generate file path unik
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentFilePath = '${dir.path}/svara_recording_$timestamp.wav';

      // Konfigurasi recording - WAV untuk kualitas ML terbaik
      const config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        numChannels: 1, // Mono untuk analisis suara
        bitRate: 128000,
      );

      await _recorder.start(config, path: _currentFilePath!);
      _isRecording = true;

      // Mulai polling amplitude setiap 100ms
      _amplitudeTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => _updateAmplitude(),
      );

      return true;
    } catch (e) {
      _isRecording = false;
      return false;
    }
  }

  /// Stop merekam dan return path file audio.
  Future<String?> stopRecording() async {
    try {
      _amplitudeTimer?.cancel();
      _amplitudeTimer = null;

      if (_isRecording) {
        final path = await _recorder.stop();
        _isRecording = false;

        // Gunakan path dari recorder jika tersedia
        final filePath = path ?? _currentFilePath;

        // Verifikasi file ada
        if (filePath != null && await File(filePath).exists()) {
          _currentFilePath = filePath;
          return filePath;
        }
      }

      return null;
    } catch (e) {
      _isRecording = false;
      return null;
    }
  }

  /// Update amplitude dari microphone
  Future<void> _updateAmplitude() async {
    try {
      final amplitude = await _recorder.getAmplitude();
      // amplitude.current dalam dBFS (negatif, -160 = diam, 0 = max)
      // Normalisasi ke 0.0 - 1.0
      final dBFS = amplitude.current;
      double normalized;
      if (dBFS <= -60.0 || dBFS == double.negativeInfinity) {
        normalized = 0.0; // Diam
      } else if (dBFS >= 0.0) {
        normalized = 1.0; // Max
      } else {
        // Map -60..0 ke 0.0..1.0
        normalized = (dBFS + 60.0) / 60.0;
      }

      if (!_amplitudeController.isClosed) {
        _amplitudeController.add(normalized.clamp(0.0, 1.0));
      }
    } catch (_) {
      // Ignore errors saat getting amplitude
    }
  }

  /// Cleanup resources
  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    await _amplitudeController.close();
    await _recorder.dispose();
  }
}
