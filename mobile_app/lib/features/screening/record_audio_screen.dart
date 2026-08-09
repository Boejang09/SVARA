import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
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
  Timer? _waveformTimer;
  int _secondsElapsed = 0;
  final Random _random = Random();
  final List<double> _waveformHeights = List.generate(30, (_) => 20.0);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });

    _waveformTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (mounted) {
        setState(() {
          for (var i = 0; i < _waveformHeights.length; i++) {
            _waveformHeights[i] = 10.0 + _random.nextDouble() * 40.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    _waveformTimer?.cancel();
    super.dispose();
  }

  void _finishRecording() {
    AppRouter.toAiAnalysis(context);
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const SvaraWordmark(markSize: 32, fontSize: 20),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Simulasi rekam audio...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Audio asli belum diproses karena API AI belum tersedia',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
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
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(_waveformHeights.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
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
                    onPressed: _finishRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: const Text(
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
                  onPressed: () => Navigator.of(context).pop(),
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
