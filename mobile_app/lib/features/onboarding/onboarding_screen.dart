import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      title: 'Deteksi Dini\nKesehatan Jantung',
      subtitle: 'Pantau kesehatan jantung Anda\nhanya menggunakan smartphone.',
      imagePath: 'assets/images/onboarding_heart_detection.png',
    ),
    OnboardingItem(
      title: 'Rekam Suara\nJantung Anda',
      subtitle:
          'Tempelkan smartphone di posisi tubuh\nyang disarankan dan rekam\nsuara jantung Anda.',
      imagePath: 'assets/images/onboarding_record_heart.png',
    ),
    OnboardingItem(
      title: 'Penilaian Risiko AI',
      subtitle:
          'Dapatkan penilaian risiko jantung\nberbasis AI dan rekomendasi\nkesehatan yang dipersonalisasi.',
      imagePath: 'assets/images/onboarding_risk_assessment.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    AppRouter.toLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        backgroundColor: AppTheme.bgMint,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SvaraWordmark(markSize: 32, fontSize: 20),
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: const Text(
                        'Lewati',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 0,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildIllustration(context, item),
                                const SizedBox(height: 12),
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.subtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textMuted,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primaryDarkTeal
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _items.length - 1
                                  ? 'Mulai Sekarang'
                                  : 'Selanjutnya',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the illustration area for each onboarding slide.
  /// If the item has an imagePath, it renders the image directly (no card/box).
  /// If the item has an icon, it renders the original card-based layout.
  Widget _buildIllustration(BuildContext context, OnboardingItem item) {
    if (item.imagePath != null) {
      // Image-based slide: show image directly, centered and responsive
      final availableWidth = MediaQuery.sizeOf(context).width - 48;

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: availableWidth,
          maxHeight: availableWidth * 1.1,
        ),
        child: Image.asset(
          item.imagePath!,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    // Icon-based slide (slide 3): keep original card layout
    final availableWidth = MediaQuery.sizeOf(context).width - 48;
    final cardHeight = availableWidth * 0.9 < 320.0
        ? availableWidth * 0.9
        : 320.0;

    return SizedBox(
      width: double.infinity,
      height: cardHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.bgMint,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: AppTheme.primaryLightTeal,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryTeal.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
              child: Icon(item.icon, color: AppTheme.primaryTeal, size: 58),
            ),
            if (item.badgeText != null)
              Positioned(
                bottom: 28,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    item.badgeText!,
                    style: const TextStyle(
                      color: AppTheme.primaryDarkTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? badgeText;
  final String? imagePath;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    this.icon,
    this.badgeText,
    this.imagePath,
  });
}
