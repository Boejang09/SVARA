import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/screening/record_audio_screen.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class BeforeRecordingScreen extends StatelessWidget {
  const BeforeRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primaryDarkTeal),
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
                'Before Recording',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Follow these steps to ensure a high-quality\nclinical screening.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),

              // Visual Placement Container
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
                        title: 'Front Placement',
                        icon: Icons.accessibility_new_rounded,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPlacementCard(
                        title: 'Back Placement',
                        icon: Icons.person_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Checklist Tiles
              _buildStepTile(
                icon: Icons.chair_rounded,
                title: 'Sit comfortably',
                desc: 'Keep your back straight and relaxed.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.volume_off_rounded,
                title: 'Stay in quiet',
                desc: 'Minimize background noise and talking.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.pan_tool_rounded,
                title: 'Hold steadily',
                desc: 'Avoid moving the phone during recording.',
              ),
              const SizedBox(height: 10),
              _buildStepTile(
                icon: Icons.accessibility_rounded,
                title: 'Follow body',
                desc: 'Place phone exactly as shown above.',
              ),
              const SizedBox(height: 24),

              // Start Recording Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RecordAudioScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                  label: const Text(
                    'Start Recording',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'By starting, you agree to the clinical data\ncollection guidelines.',
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
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
