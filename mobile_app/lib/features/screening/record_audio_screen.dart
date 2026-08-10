import 'dart:async';
import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/services/audio_recorder_service.dart';
import 'package:svara_app/services/api_service.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class RecordAudioScreen extends StatefulWidget {
  const RecordAudioScreen({super.key});

  @override
  State<RecordAudioScreen> createState() => _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int _secondsElapsed = 0;

  // Real audio recording
  final AudioRecorderService _recorderService = AudioRecorderService();
  StreamSubscription<double>? _amplitudeSub;
  final List<double> _waveformHeights = List.generate(30, (_) => 4.0);
  bool _isRecording = false;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startRecording();
  }

  Future<void> _startRecording() async {
    final success = await _recorderService.startRecording();

    if (!mounted) return;

    if (success) {
      setState(() {
        _isRecording = true;
        _errorMessage = null;
      });

      // Timer untuk hitungan waktu
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _secondsElapsed++);
      });

      // Listen amplitude real-time untuk waveform
      _amplitudeSub = _recorderService.amplitudeStream.listen((amplitude) {
        if (mounted) {
          setState(() {
            // Geser semua bar ke kiri, tambah bar baru di kanan
            for (var i = 0; i < _waveformHeights.length - 1; i++) {
              _waveformHeights[i] = _waveformHeights[i + 1];
            }
            // Tinggi bar: min 4px (diam), max 48px (suara keras)
            _waveformHeights[_waveformHeights.length - 1] =
                4.0 + (amplitude * 44.0);
          });
        }
      });
    } else {
      setState(() {
        _errorMessage = 'Tidak bisa merekam. Pastikan izin mikrofon diberikan.';
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    _amplitudeSub?.cancel();
    _recorderService.dispose();
    super.dispose();
  }

  Future<void> _finishRecording() async {
    if (_isUploading) return;

    setState(() => _isUploading = true);

    // Stop recording
    final filePath = await _recorderService.stopRecording();
    _timer?.cancel();
    _amplitudeSub?.cancel();

    if (filePath != null) {
      // Upload ke backend
      final result = await ApiService.uploadAudio(
        filePath: filePath,
        nama: 'Rekaman Skrining',
      );

      if (mounted) {
        if (result != null) {
          // Upload berhasil -> lanjut ke AI loading
          AppRouter.toAiAnalysis(context, filePath);
        } else {
          // Upload gagal tapi file tersimpan lokal -> tetap lanjut
          // (nanti bisa retry upload)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Audio tersimpan lokal. Upload ke server gagal, akan dicoba lagi nanti.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          AppRouter.toAiAnalysis(context, filePath);
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'Gagal menyimpan rekaman.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerText =
        '${(_secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(_secondsElapsed % 60).toString().padLeft(2, '0')}';

    return MobileWrapper(
      child: Scaffold(
        backgroundColor: AppTheme.bgMint,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () async {
              // Stop recording sebelum kembali
              await _recorderService.stopRecording();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
          title: const SvaraWordmark(markSize: 32, fontSize: 20),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  _isRecording
                      ? 'Sedang merekam suara...'
                      : 'Memulai rekaman...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tempelkan mikrofon HP di dada kiri\ndan pastikan lingkungan tenang',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLightTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timerText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + (_pulseController.value * 0.12);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryTeal.withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.primaryDarkTeal,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mic_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'REC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                // ── Waveform: mengikuti suara real-time ──
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_waveformHeights.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                        width: 3.5,
                        height: _waveformHeights[index],
                        decoration: BoxDecoration(
                          color: AppTheme.primaryTeal.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: (_isRecording && !_isUploading)
                        ? _finishRecording
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: _isUploading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Menyimpan...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Selesai Rekaman',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          await _recorderService.stopRecording();
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
