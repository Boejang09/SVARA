import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';
import 'package:svara_app/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onStartScreening;

  const DashboardScreen({
    super.key,
    required this.onStartScreening,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _latestScreening;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final list = await ApiService.getScreenings();

      if (mounted) {
        setState(() {
          if (list != null && list.isNotEmpty) {
            final first = list.first;

            _latestScreening =
                first is Map<String, dynamic> ? first : null;
          } else {
            _latestScreening = null;
          }

          _hasError = list == null;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _latestScreening = null;
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,

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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: _isLoading
          ? const DashboardSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================
                  // WELCOME CARD
                  // =========================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal,
                      borderRadius: BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryTeal.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          '${_getGreeting()}, '
                          '${ApiService.currentUser?['nama'] ?? 'Tamu'}',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Lakukan pemeriksaan jantung cepat\n'
                          'selama 30 detik.',

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton.icon(
                          onPressed: widget.onStartScreening,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                AppTheme.primaryDarkTeal,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),

                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            size: 20,
                          ),

                          label: const Text(
                            'Mulai Sekarang',

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================================================
                  // RINGKASAN KESEHATAN
                  // =========================================================

                  _DashboardLatestContent(
                    data: _latestScreening,
                    hasError: _hasError,
                    onRetry: _loadData,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ===========================================================================
// DASHBOARD LATEST CONTENT
// ===========================================================================

class _DashboardLatestContent extends StatelessWidget {
  final Map<String, dynamic>? data;
  final bool hasError;
  final VoidCallback onRetry;

  const _DashboardLatestContent({
    this.data,
    required this.hasError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // =======================================================================
    // BELUM ADA DATA
    // =======================================================================

    if (data == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          children: [
            Icon(
              hasError
                  ? Icons.wifi_off_rounded
                  : Icons.health_and_safety_outlined,

              color: AppTheme.primaryTeal,
              size: 34,
            ),

            const SizedBox(height: 12),

            Text(
              hasError
                  ? 'Data belum dapat dimuat. Silakan coba lagi.'
                  : 'Belum ada hasil skrining.',

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              hasError
                  ? 'Beranda tetap tersedia meski koneksi API belum siap.'
                  : 'Mulai pemeriksaan untuk melihat ringkasan '
                      'kesehatan Anda.',

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: AppTheme.textMuted,
                height: 1.35,
              ),
            ),

            if (hasError) ...[
              const SizedBox(height: 14),

              OutlinedButton.icon(
                onPressed: onRetry,

                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),

                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      );
    }

    // =======================================================================
    // DATA SKRINING TERBARU
    // =======================================================================

    final status =
        (data!['heart_status'] as String?)?.trim();

    final displayStatus =
        status == null || status.isEmpty
            ? 'Belum tersedia'
            : status;

    final hasScreeningResult = status != null && status.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ===================================================================
        // TITLE
        // ===================================================================

        _sectionTitle('Ringkasan Kesehatan'),

        const SizedBox(height: 12),

        // ===================================================================
        // SUMMARY CARDS
        // ===================================================================

        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.favorite_border_rounded,
                title: 'Status Jantung',
                value: displayStatus,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _SummaryCard(
                icon: Icons.air_rounded,
                title: 'Kondisi',
                value: hasScreeningResult
                    ? 'Sudah dianalisis'
                    : 'Belum tersedia',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========================================================================
  // SECTION TITLE
  // ========================================================================

  static Widget _sectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        color: AppTheme.textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ===========================================================================
// SUMMARY CARD
// ===========================================================================

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _IconBadge(
            icon: icon,
          ),

          const SizedBox(height: 12),

          Text(
            title,

            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,

            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// ICON BADGE
// ===========================================================================

class _IconBadge extends StatelessWidget {
  final IconData icon;

  const _IconBadge({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,

      decoration: BoxDecoration(
        color: AppTheme.primaryLightTeal,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Icon(
        icon,
        color: AppTheme.primaryDarkTeal,
        size: 22,
      ),
    );
  }
}