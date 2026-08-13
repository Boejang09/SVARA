import 'package:flutter/material.dart';

import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/features/dashboard/dashboard_screen.dart';
import 'package:svara_app/features/history/history_screen.dart';
import 'package:svara_app/features/news/news_screen.dart';
import 'package:svara_app/features/profile/profile_screen.dart';
import 'package:svara_app/widgets/bottom_nav_bar.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  late final PageController _pageController;

  late int _currentIndex;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages.addAll([
      // Page 0 → Beranda
      DashboardScreen(
        onStartScreening: () => _onTabSelected(2),
      ),

      // Page 1 → Riwayat
      const HistoryScreen(),

      // Page 2 → Berita
      const NewsScreen(),

      // Page 3 → Profil
      const ProfileScreen(),
    ]);

    final int initialPage = _navIndexToPage(
      widget.initialIndex,
    );

    _currentIndex = widget.initialIndex == 2
        ? 0
        : widget.initialIndex;

    _pageController = PageController(
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // BOTTOM NAVIGATION INDEX → PAGEVIEW INDEX
  // ============================================================

  int _navIndexToPage(int index) {
    switch (index) {
      // Beranda
      case 0:
        return 0;

      // Riwayat
      case 1:
        return 1;

      // Pindai
      // Tidak mempunyai halaman di PageView.
      case 2:
        return 0;

      // Berita
      case 3:
        return 2;

      // Profil
      case 4:
        return 3;

      default:
        return 0;
    }
  }

  // ============================================================
  // PAGEVIEW INDEX → BOTTOM NAVIGATION INDEX
  // ============================================================

  int _pageToNavIndex(int page) {
    switch (page) {
      // Beranda
      case 0:
        return 0;

      // Riwayat
      case 1:
        return 1;

      // Berita
      case 2:
        return 3;

      // Profil
      case 3:
        return 4;

      default:
        return 0;
    }
  }

  // ============================================================
  // BOTTOM NAVIGATION TAP
  // ============================================================

  void _onTabSelected(int index) {
    // ==========================================================
    // PINDAI
    // ==========================================================
    //
    // Pindai bukan bagian dari PageView.
    //
    // Tombol mic harus ditekan untuk membuka
    // proses screening.
    //
    // Karena itu Pindai tidak ikut animasi slide.
    // ==========================================================

    if (index == 2) {
      AppRouter.startScreening(context);
      return;
    }

    // ==========================================================
    // TAB AKTIF
    // ==========================================================
    //
    // Tidak perlu menjalankan animasi jika user
    // menekan tab yang sedang aktif.
    // ==========================================================

    if (index == _currentIndex) {
      return;
    }

    final int targetPage = _navIndexToPage(index);

    setState(() {
      _currentIndex = index;
    });

    // ==========================================================
    // SLIDE ANIMATION
    // ==========================================================

    _pageController.animateToPage(
      targetPage,
      duration: const Duration(
        milliseconds: 280,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  // ============================================================
  // PAGE CHANGED
  // ============================================================

  void _onPageChanged(int page) {
    final int navIndex = _pageToNavIndex(page);

    if (_currentIndex == navIndex) {
      return;
    }

    setState(() {
      _currentIndex = navIndex;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        body: PageView(
          controller: _pageController,

          // ====================================================
          // SWIPE
          // ====================================================
          //
          // Beranda ↔ Riwayat ↔ Berita ↔ Profil
          //
          // Pindai tidak ikut PageView.
          // Pindai hanya dibuka ketika tombol mic ditekan.
          // ====================================================

          physics: const PageScrollPhysics(),

          pageSnapping: true,

          onPageChanged: _onPageChanged,

          children: _pages,
        ),

        // ======================================================
        // BOTTOM NAVIGATION
        // ======================================================

        bottomNavigationBar: SvaraBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}