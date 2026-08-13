import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await simulateLoading();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
                      'Berita Jantung',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Informasi terbaru dan edukasi seputar kesehatan jantung.',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const _FeaturedNewsCard(),

                    const SizedBox(height: 20),

                    const Text(
                      'Berita Terbaru',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const _NewsCard(
                      icon: Icons.favorite_rounded,
                      category: 'Kesehatan Jantung',
                      title: 'Kenali tanda-tanda kesehatan jantung',
                      description:
                          'Mengetahui kondisi tubuh dan menjaga kesehatan jantung sejak dini merupakan bagian penting dari pola hidup sehat.',
                    ),

                    const SizedBox(height: 12),

                    const _NewsCard(
                      icon: Icons.directions_run_rounded,
                      category: 'Gaya Hidup',
                      title: 'Aktivitas fisik untuk menjaga kesehatan jantung',
                      description:
                          'Aktivitas fisik secara teratur dapat menjadi bagian dari kebiasaan hidup yang mendukung kesehatan jantung.',
                    ),

                    const SizedBox(height: 12),

                    const _NewsCard(
                      icon: Icons.restaurant_rounded,
                      category: 'Nutrisi',
                      title: 'Pola makan yang mendukung kesehatan jantung',
                      description:
                          'Pilih makanan bergizi seimbang dan perhatikan pola makan sebagai bagian dari menjaga kesehatan jantung.',
                    ),

                    const SizedBox(height: 12),

                    const _NewsCard(
                      icon: Icons.monitor_heart_rounded,
                      category: 'Pemeriksaan',
                      title: 'Mengapa pemeriksaan jantung penting?',
                      description:
                          'Pemeriksaan kesehatan secara berkala dapat membantu memahami kondisi tubuh dan mendukung pemantauan kesehatan.',
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _FeaturedNewsCard extends StatelessWidget {
  const _FeaturedNewsCard();

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
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkTeal.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Berita Utama',
              style: TextStyle(
                color: AppTheme.primaryDarkTeal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Jaga kesehatan jantung mulai dari kebiasaan sehari-hari',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Kenali berbagai kebiasaan sederhana yang dapat membantu menjaga kesehatan jantung dalam kehidupan sehari-hari.',
            style: TextStyle(
              color: AppTheme.primaryDarkTeal,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 17,
                color: AppTheme.primaryDarkTeal,
              ),
              const SizedBox(width: 6),
              Text(
                'Baca 3 menit',
                style: TextStyle(
                  color: AppTheme.primaryDarkTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final IconData icon;
  final String category;
  final String title;
  final String description;

  const _NewsCard({
    required this.icon,
    required this.category,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primaryLightTeal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryDarkTeal,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: AppTheme.primaryDarkTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Baca selengkapnya',
                      style: TextStyle(
                        color: AppTheme.primaryDarkTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.primaryDarkTeal,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}