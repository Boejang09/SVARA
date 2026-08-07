import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class BeforeRecordingScreen extends StatelessWidget {
  const BeforeRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sebelum Merekam',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ikuti langkah-langkah berikut untuk\nmemastikan hasil rekaman berkualitas tinggi.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPlacementCard(
                        title: 'Posisi Depan',
                        icon: Icons.accessibility_new_rounded,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPlacementCard(
                        title: 'Posisi Belakang',
                        icon: Icons.person_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildStepTile(
                icon: Icons.chair_rounded,
                title: 'Duduk dengan nyaman',
                desc: 'Jaga punggung tetap tegak dan rileks.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.volume_off_rounded,
                title: 'Cari tempat yang tenang',
                desc: 'Minimalkan kebisingan dan pembicaraan.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.pan_tool_rounded,
                title: 'Pegang dengan stabil',
                desc: 'Hindari menggerakkan ponsel saat merekam.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.accessibility_rounded,
                title: 'Ikuti posisi tubuh',
                desc: 'Letakkan ponsel tepat seperti gambar di atas.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => AppRouter.toRecordAudio(context),
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Mulai Rekaman',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Dengan memulai, Anda menyetujui panduan\npengumpulan data klinis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlacementCard({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: AppTheme.primaryTeal),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDarkTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile({
    required IconData icon,
    required String title,
    required String desc,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLightTeal,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.primaryTeal, size: 22),
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
                    fontSize: 13,
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
}
