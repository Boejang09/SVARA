import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/development_notice.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class ScreeningResultScreen extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  const ScreeningResultScreen({
    super.key,
    this.resultData,
  });

  @override
  State<ScreeningResultScreen> createState() =>
      _ScreeningResultScreenState();
}

class _ScreeningResultScreenState
    extends State<ScreeningResultScreen> {
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

    // ================================================================
    // STATUS
    // ================================================================

    final String uploadStatus = _readText(
      data?['status'],
    );

    final String uploadStatusLabel = _statusLabel(
      uploadStatus,
    );

    // ================================================================
    // SCREENING ID
    // ================================================================

    final String screeningId = _readText(
      data?['screening_id'] ?? data?['id_skr'],
    );

    // ================================================================
    // PREDICTION DARI MODEL ML
    // ================================================================

    final String prediction = _readText(
      data?['heart_status'] ?? data?['nama_penyakit'],
    );

    // ================================================================
    // BPM
    // ================================================================

    final rawBpm = hasData
        ? data['bpm_estimate']
        : null;

    final int? bpm = rawBpm is num
        ? rawBpm.toInt()
        : null;

    // ================================================================
    // REKOMENDASI
    // ================================================================

    final String rekomendasi = _readText(
      data?['recommendation'],
    );

    // ================================================================
    // CONFIDENCE MODEL
    // ================================================================

    final rawConfidence = hasData
        ? data['confidence']
        : null;

    final double confidence = rawConfidence is num
        ? rawConfidence.toDouble().clamp(0.0, 1.0)
        : 0.0;

    // ================================================================
    // DETAIL SEGMENT
    // ================================================================

    final segments = _segmentDetails(
      data?['raw_output'],
    );

    // ================================================================
    // STATUS ANALISIS
    // ================================================================

    final bool isCompleted =
        uploadStatus == 'completed';

    final bool isFailed =
        uploadStatus == 'failed';

    return Scaffold(
      backgroundColor: AppTheme.bgMint,

      // ==============================================================
      // APP BAR
      // ==============================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const SvaraWordmark(
          markSize: 32,
          fontSize: 20,
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {
              showDevelopmentSnack(context);
            },
          ),
        ],
      ),

      // ==============================================================
      // BODY
      // ==============================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              // ========================================================
              // HASIL UTAMA
              // ========================================================

              _buildResultIndicator(
                prediction: prediction,
                isCompleted: isCompleted,
                isFailed: isFailed,
              ),

              const SizedBox(height: 20),

              // ========================================================
              // JUDUL HASIL
              // ========================================================

              Text(
                isCompleted
                    ? 'Analisis Selesai'
                    : (isFailed
                        ? 'Analisis Gagal'
                        : 'Menunggu Analisis'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                isCompleted
                    ? 'Berikut hasil analisis rekaman '
                      'dari model ML eksternal.'
                    : (isFailed
                        ? 'Gagal menganalisis rekaman. '
                          'Silakan coba lagi dari riwayat '
                          'atau buat rekaman baru.'
                        : 'Rekaman audio berhasil disimpan. '
                          'Hasil analisis belum tersedia.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 24),

              // ========================================================
              // STATUS ANALISIS
              // ========================================================

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLightTeal,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.settings_suggest_rounded,
                            color: AppTheme.primaryTeal,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCompleted
                                  ? 'Hasil Analisis'
                                  : 'Status Rekaman',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),

                            Text(
                              isCompleted
                                  ? 'Model ML'
                                  : 'Menunggu Analisis',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppTheme.primaryDarkTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isFailed
                            ? Colors.redAccent
                            : AppTheme.primaryTeal,
                        borderRadius:
                            BorderRadius.circular(14),
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

              // ========================================================
              // ANALISIS JANTUNG
              // ========================================================

              _buildMetricCard(
                icon: Icons.favorite_rounded,
                iconColor: Colors.redAccent,
                title: 'Analisis Jantung',
                val: prediction,
                subText: bpm == null
                    ? 'Belum tersedia.'
                    : 'Estimasi $bpm BPM',
                progress: confidence,
              ),

              const SizedBox(height: 20),

              // ========================================================
              // REKOMENDASI
              // ========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rekomendasi Kesehatan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                AppTheme.textDark,
                          ),
                        ),
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 18,
                          color:
                              AppTheme.primaryTeal,
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _buildRecommendationItem(
                      title: isCompleted
                          ? 'Hasil Model'
                          : 'Status Skrining',
                      desc: isCompleted
                          ? 'Hasil analisis: $prediction.'
                          : (screeningId ==
                                  'Belum tersedia.'
                              ? rekomendasi
                              : 'ID skrining: '
                                '$screeningId. '
                                '$rekomendasi'),
                    ),

                    if (segments.isNotEmpty) ...[
                      const SizedBox(height: 12),

                      _buildRecommendationItem(
                        title: 'Detail Segmen',
                        desc: segments.join(', '),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ========================================================
              // SIMPAN SEMENTARA
              // ========================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveAndGoHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.primaryDarkTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(27),
                    ),
                  ),
                  child: const Text(
                    'Simpan Sementara',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ========================================================
              // HOME + HISTORY
              // ========================================================

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppRouter
                            .finishScreeningToHome(
                          context,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Colors.grey.shade200,
                        side: BorderSide.none,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
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
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saveAndGoHistory,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Colors.grey.shade200,
                        side: BorderSide.none,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
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
                          fontWeight:
                              FontWeight.bold,
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

  // =========================================================================
  // HASIL UTAMA
  // =========================================================================

  Widget _buildResultIndicator({
    required String prediction,
    required bool isCompleted,
    required bool isFailed,
  }) {
    final Color indicatorColor = isFailed
        ? Colors.redAccent
        : AppTheme.primaryTeal;

    final IconData indicatorIcon = isFailed
        ? Icons.error_outline_rounded
        : isCompleted
            ? Icons.favorite_rounded
            : Icons.hourglass_empty_rounded;

    final String displayText = isFailed
        ? 'Gagal'
        : isCompleted
            ? prediction
            : 'Menunggu';

    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ==============================================================
          // LINGKARAN
          // ==============================================================

          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: indicatorColor.withValues(
                  alpha: 0.22,
                ),
                width: 10,
              ),
              boxShadow: [
                BoxShadow(
                  color: indicatorColor.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // ==============================================================
          // ICON + STATUS
          // ==============================================================

          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: indicatorColor.withValues(
                      alpha: 0.10,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    indicatorIcon,
                    color: indicatorColor,
                    size: 27,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  displayText,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: indicatorColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // READ TEXT
  // =========================================================================

  String _readText(Object? value) {
    if (value is String &&
        value.trim().isNotEmpty) {
      return value.trim();
    }

    return 'Belum tersedia.';
  }

  // =========================================================================
  // STATUS LABEL
  // =========================================================================

  String _statusLabel(String status) {
    return switch (status.toLowerCase()) {
      'uploaded' => 'Diunggah',
      'processing' => 'Sedang diproses',
      'completed' => 'Selesai',
      'failed' => 'Gagal',
      _ => 'Diunggah',
    };
  }

  // =========================================================================
  // SEGMENT DETAILS
  // =========================================================================

  List<String> _segmentDetails(
    Object? rawOutput,
  ) {
    if (rawOutput is Map) {
      final segments =
          rawOutput['segment_details'];

      if (segments is List) {
        return segments
            .whereType<String>()
            .where(
              (item) =>
                  item.trim().isNotEmpty,
            )
            .toList();
      }
    }

    return const [];
  }

  // =========================================================================
  // METRIC CARD
  // =========================================================================

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
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  val,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppTheme.textDark,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                subText,
                style: const TextStyle(
                  fontSize: 13,
                  color:
                      AppTheme.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(4),
            child:
                LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor:
                  Colors.grey.shade100,
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                AppTheme.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // RECOMMENDATION ITEM
  // =========================================================================

  Widget _buildRecommendationItem({
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.primaryTeal,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 14,
                    color:
                        AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color:
                        AppTheme.textMuted,
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