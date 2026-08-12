import 'dart:async';
import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/services/api_service.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class AILoadingScreen extends StatefulWidget {
  final Map<String, dynamic>? uploadData;

  const AILoadingScreen({super.key, this.uploadData});

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen> {
  int _progressPercent = 0;
  Timer? _progressTimer;
  bool _isAnalyzing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    final screeningId = widget.uploadData?['screening_id'] as String?;
    if (screeningId == null || screeningId.isEmpty) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Data skrining belum tersedia.';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _progressPercent = 0;
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          if (_progressPercent < 92) _progressPercent += 1;
        });
      }
    });

    final result = await ApiService.analyzeScreening(screeningId);
    _progressTimer?.cancel();
    if (!mounted) return;

    if (result.isSuccess) {
      setState(() => _progressPercent = 100);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        AppRouter.toScreeningResult(context, result.data);
      });
    } else {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = result.message ?? 'Analisis rekaman gagal.';
      });
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(markSize: 32, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppTheme.textDark),
            onPressed: () => AppRouter.finishScreeningToHome(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryTeal.withValues(alpha: 0.08),
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryTeal.withValues(alpha: 0.18),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLightTeal,
                      border: Border.all(color: AppTheme.primaryTeal, width: 3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.psychology_rounded,
                        size: 54,
                        color: AppTheme.primaryDarkTeal,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: _buildBadge(Icons.cloud_upload_outlined, 'Upload'),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    child: _buildBadge(Icons.monitor_heart_rounded, 'Analisis'),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                _errorMessage == null
                    ? 'Menganalisis\nrekaman audio...'
                    : 'Analisis\ngagal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ??
                    'Rekaman audio sedang dianalisis oleh layanan ML melalui backend SVARA.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),
              const Spacer(),
              _buildInfoTile(
                icon: Icons.check_circle_outline_rounded,
                title: 'Audio Tersimpan',
                desc: 'Rekaman sudah diterima oleh backend SVARA.',
                color: AppTheme.primaryTeal,
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.security_rounded,
                title: _errorMessage == null
                    ? 'Sedang Dianalisis'
                    : 'Analisis Belum Selesai',
                desc: _errorMessage == null
                    ? 'Backend SVARA sedang menunggu response dari layanan ML.'
                    : 'Tidak ada hasil palsu yang ditampilkan.',
                color: Colors.indigo,
              ),
              const SizedBox(height: 24),
              if (_errorMessage == null)
                Text(
                  '$_progressPercent%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkTeal,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _startAnalysis,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryTeal),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
