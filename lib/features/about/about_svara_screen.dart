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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inovasi Kesehatan\nJantung',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kami mendefinisikan ulang cara dunia mendengarkan\nkesehatan, satu detak jantung dalam satu waktu.',
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
                title: 'Misi Kami',
                desc:
                    'Menyediakan skrining kesehatan jantung yang mudah diakses dan non-invasif ke seluruh penjuru dunia menggunakan kekuatan suara dan kecerdasan buatan. Kami bertujuan memberdayakan individu dengan wawasan dini tentang kesehatan jantung mereka, sehingga memungkinkan intervensi medis yang proaktif.',
              ),
              const SizedBox(height: 16),

              // Card: Our Vision
              _buildInfoCard(
                icon: Icons.remove_red_eye_outlined,
                title: 'Visi Kami',
                desc:
                    'Dunia di mana kondisi jantung terdeteksi jauh sebelum gejala menjadi serius. SVARA membayangkan masa depan di mana smartphone Anda berfungsi sebagai pendamping klinis yang canggih, menjembatani kesenjangan antara kehidupan sehari-hari dan perawatan medis profesional.',
              ),
              const SizedBox(height: 28),

              // How SVARA Works Section
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppTheme.primaryTeal,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Cara Kerja SVARA',
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
                stepTitle: 'REKAM',
                desc:
                    'Aplikasi merekam suara jantung Anda menggunakan algoritma pemrosesan audio berstandar klinis yang dioptimalkan untuk smartphone.',
                icon: Icons.mic_none_rounded,
              ),
              const SizedBox(height: 12),
              _buildStepCard(
                stepNum: '02',
                stepTitle: 'ANALISIS',
                desc:
                    'Model deep-learning kami menguraikan sinyal audio, mengidentifikasi pola yang terkait dengan berbagai biomarker jantung.',
                icon: Icons.graphic_eq_rounded,
              ),
              const SizedBox(height: 12),
              _buildStepCard(
                stepNum: '03',
                stepTitle: 'NILAI',
                desc:
                    'AI memberikan skor risiko dan wawasan yang dapat ditindaklanjuti secara langsung, membantu Anda memutuskan kapan harus mencari saran medis profesional.',
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
                      'Didukung oleh Ilmu Pengetahuan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Teknologi kami didukung oleh penelitian klinis bertahun-tahun dan divalidasi terhadap data medis standar emas.',
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
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber.shade800,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pernyataan Penting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SVARA hanya memberikan penilaian risiko awal dan tidak menggantikan diagnosis medis profesional. Informasi yang diberikan oleh aplikasi ini hanya untuk tujuan informasi dan tidak dimaksudkan sebagai pengganti saran dari dokter atau tenaga kesehatan profesional Anda. Selalu konsultasikan kepada tenaga kesehatan yang berkualifikasi mengenai kondisi medis Anda.',
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
