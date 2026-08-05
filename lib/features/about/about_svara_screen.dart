import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class AboutSvaraScreen extends StatelessWidget {
  const AboutSvaraScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pioneering Respiratory\nWellness',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We are redefining how the world listens to\nhealth, one breath at a time.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),

              // Card: Our Mission
              _buildInfoCard(
                icon: Icons.rocket_launch_outlined,
                title: 'Our Mission',
                desc: 'To provide accessible, non-invasive respiratory screening to every corner of the globe using the power of sound and artificial intelligence. We aim to empower individuals with early insights into their lung health, enabling proactive medical intervention.',
              ),
              const SizedBox(height: 16),

              // Card: Our Vision
              _buildInfoCard(
                icon: Icons.remove_red_eye_outlined,
                title: 'Our Vision',
                desc: 'A world where respiratory conditions are caught long before symptoms become severe. SVARA envisions a future where your smartphone serves as a sophisticated clinical companion, bridging the gap between everyday life and professional medical care.',
              ),
              const SizedBox(height: 28),

              // How SVARA Works Section
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.primaryTeal, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'How SVARA Works',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildStepCard(
                stepNum: '01',
                stepTitle: 'CAPTURE',
                desc: 'The app records your cough or breathing pattern using clinical-grade audio processing algorithms optimized for smartphones.',
                icon: Icons.mic_none_rounded,
              ),
              const SizedBox(height: 12),
              _buildStepCard(
                stepNum: '02',
                stepTitle: 'ANALYZE',
                desc: 'Our deep-learning models decompose the audio signal, identifying patterns associated with various respiratory biomarkers.',
                icon: Icons.graphic_eq_rounded,
              ),
              const SizedBox(height: 12),
              _buildStepCard(
                stepNum: '03',
                stepTitle: 'ASSESS',
                desc: 'The AI provides an immediate risk score and actionable insights, helping you decide when to seek professional medical advice.',
                icon: Icons.assessment_outlined,
              ),
              const SizedBox(height: 28),

              // Banner: Driven by Science
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkTeal,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Driven by Science',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our technology is backed by years of clinical research and validated against gold-standard medical data.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Mandatory Disclaimer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mandatory Disclaimer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SVARA provides early risk assessment only and does not replace professional medical diagnosis. The information provided by this application is for informational purposes only and is not intended as a substitute for advice from your physician or other healthcare professionals. Always seek the advice of a qualified healthcare provider with any questions you may have regarding a medical condition.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryLightTeal,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.primaryTeal, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDarkTeal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNum,
    required String stepTitle,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bgMint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryTeal, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$stepNum. $stepTitle',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkTeal,
                    letterSpacing: 0.8,
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
