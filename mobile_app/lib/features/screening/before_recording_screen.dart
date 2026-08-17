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
        title: const SvaraWordmark(
          markSize: 32,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
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
                'Ikuti panduan berikut agar proses perekaman '
                'berjalan dengan baik.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Panduan Rekaman',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 12),

              _buildStepTile(
                icon: Icons.chair_rounded,
                title: 'Duduk dengan nyaman',
                desc:
                    'Duduk dalam posisi yang nyaman dan tetap rileks '
                    'selama proses perekaman.',
              ),

              const SizedBox(height: 10),

              _buildStepTile(
                icon: Icons.volume_off_rounded,
                title: 'Cari tempat yang tenang',
                desc:
                    'Pilih lingkungan dengan suara latar seminimal '
                    'mungkin agar rekaman lebih jelas.',
              ),

              const SizedBox(height: 10),

              _buildStepTile(
                icon: Icons.phone_android_rounded,
                title: 'Pegang ponsel dengan stabil',
                desc:
                    'Jaga perangkat tetap stabil dan hindari '
                    'gerakan berlebihan selama merekam.',
              ),

              const SizedBox(height: 10),

              _buildStepTile(
                icon: Icons.mic_none_rounded,
                title: 'Ikuti instruksi perekaman',
                desc:
                    'Saat perekaman dimulai, ikuti instruksi yang '
                    'ditampilkan pada layar.',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppRouter.toRecordAudio(context);
                  },
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Mulai Rekaman',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Pastikan Anda berada di lingkungan yang tenang '
                  'sebelum memulai.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                    height: 1.4,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryLightTeal,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryTeal,
              size: 23,
            ),
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

                const SizedBox(height: 4),

                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    height: 1.35,
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