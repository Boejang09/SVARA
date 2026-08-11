import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/development_notice.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class ScreeningResultScreen extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  const ScreeningResultScreen({super.key, this.resultData});

  @override
  State<ScreeningResultScreen> createState() => _ScreeningResultScreenState();
}

class _ScreeningResultScreenState extends State<ScreeningResultScreen> {
  bool _saved = false;

  void _saveResult() {
    if (_saved) return;
    _saved = true;
  }

  void _saveAndGoHome() {
    _saveResult();
    AppRouter.finishScreeningToHome(context);
  }

  void _saveAndGoHistory() {
    _saveResult();
    AppRouter.finishScreeningToHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.resultData;
    final bool hasData = data != null;
    final String uploadStatus = _readText(data?['status']);
    final String uploadStatusLabel = _statusLabel(uploadStatus);
    final String screeningId = _readText(data?['screening_id']);
    final rawSkor = hasData ? data['risk_analysis'] : null;
    final int? skor = rawSkor is num
        ? rawSkor.toInt().clamp(0, 100).toInt()
        : null;
    final String status = _readText(data?['heart_status']);
    final rawBpm = hasData ? data['bpm_estimate'] : null;
    final int? bpm = rawBpm is num ? rawBpm.toInt() : null;
    final String rekomendasi = _readText(data?['recommendation']);
    final rawConfidence = hasData ? data['confidence'] : null;
    final double confidence = rawConfidence is num
        ? rawConfidence.toDouble().clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(markSize: 32, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () => showDevelopmentSnack(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: skor == null ? 0 : skor / 100,
                      strokeWidth: 14,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryTeal,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skor == null ? '-' : '$skor',
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Audio Diterima',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Rekaman audio berhasil disimpan di server. Hasil analisis medis akan tersedia pada fase berikutnya.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLightTeal,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.settings_suggest_rounded,
                            color: AppTheme.primaryTeal,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Rekaman',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            Text(
                              'Menunggu Analisis',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        uploadStatusLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                icon: Icons.favorite_rounded,
                iconColor: Colors.redAccent,
                title: 'Analisis Jantung',
                val: status,
                subText: bpm == null ? 'Belum tersedia.' : 'Estimasi $bpm BPM',
                progress: confidence,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rekomendasi Kesehatan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 18,
                          color: AppTheme.primaryTeal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildRecommendationItem(
                      title: 'Status Upload',
                      desc: screeningId == 'Belum tersedia.'
                          ? rekomendasi
                          : 'ID skrining: $screeningId. Rekaman siap diproses pada fase analisis berikutnya.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveAndGoHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: const Text(
                    'Simpan Sementara',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => AppRouter.finishScreeningToHome(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.home_rounded,
                        color: AppTheme.textDark,
                        size: 18,
                      ),
                      label: const Text(
                        'Beranda',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saveAndGoHistory,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.history_rounded,
                        color: AppTheme.textDark,
                        size: 18,
                      ),
                      label: const Text(
                        'Riwayat',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _readText(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return 'Belum tersedia.';
  }

  String _statusLabel(String status) {
    return switch (status.toLowerCase()) {
      'uploaded' => 'Diunggah',
      'processing' => 'Sedang diproses',
      'completed' => 'Selesai',
      'failed' => 'Gagal',
      _ => 'Diunggah',
    };
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String val,
    required String subText,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                val,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                subText,
                style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.primaryTeal,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
