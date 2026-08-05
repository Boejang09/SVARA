import 'package:flutter/material.dart';
import 'package:svara_app/features/advice/advice_screen.dart';
import 'package:svara_app/features/dashboard/dashboard_screen.dart';
import 'package:svara_app/features/history/history_screen.dart';
import 'package:svara_app/features/profile/profile_screen.dart';
import 'package:svara_app/features/screening/before_recording_screen.dart';
import 'package:svara_app/widgets/bottom_nav_bar.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeforeRecordingScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(onStartScreening: () => _onTabSelected(2)),
      const HistoryScreen(),
      const SizedBox.shrink(),
      const AdviceScreen(),
      const ProfileScreen(),
    ];

    return MobileWrapper(
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex == 2 ? 0 : _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: SvaraBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}
