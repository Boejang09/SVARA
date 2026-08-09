import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await simulateLoading();
    if (mounted) setState(() => _isLoading = false);
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
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const AdviceSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saran Hari Ini',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    const Text(
                      'Rekomendasi kesehatan berdasarkan aktivitas dan hasil skrining contoh.',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _AdviceHeroCard(),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.22,
                      children: const [
                        _FocusCard(
                          icon: Icons.directions_run_rounded,
                          title: 'Aktivitas',
                          subtitle: '3 saran aktif',
                        ),
                        _FocusCard(
                          icon: Icons.restaurant_rounded,
                          title: 'Nutrisi',
                          subtitle: 'Catat sarapan',
                        ),
                        _FocusCard(
                          icon: Icons.air_rounded,
                          title: 'Pernapasan',
                          subtitle: 'Latihan 2 menit',
                        ),
                        _FocusCard(
                          icon: Icons.bedtime_rounded,
                          title: 'Istirahat',
                          subtitle: 'Target 7j 45m',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const _AdviceListTile(
                      icon: Icons.water_drop_outlined,
                      title: 'Optimasi Hidrasi',
                      subtitle:
                          'Tambah asupan air sebelum skrining berikutnya.',
                    ),
                    const SizedBox(height: 10),
                    const _AdviceListTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Pemantauan Rutin',
                      subtitle: 'Jadwalkan skrining ulang dalam 7 hari.',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AdviceHeroCard extends StatelessWidget {
  const _AdviceHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Perawatan Jantung',
              style: TextStyle(
                color: AppTheme.primaryDarkTeal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tambah Aktivitas Kardio',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan 15 menit aktivitas ringan hari ini untuk membantu pemulihan detak jantung.',
            style: TextStyle(
              color: AppTheme.primaryDarkTeal,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FocusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
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
          _AdviceIcon(icon: icon),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AdviceListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AdviceListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _AdviceIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
        ],
      ),
    );
  }
}

class _AdviceIcon extends StatelessWidget {
  final IconData icon;

  const _AdviceIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.primaryLightTeal,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppTheme.primaryDarkTeal, size: 22),
    );
  }
}
