import 'package:flutter/material.dart';

class SvaraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SvaraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 96,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(0, Icons.home_rounded, 'Beranda'),
                    ),
                    Expanded(
                      child: _buildNavItem(1, Icons.history_rounded, 'Riwayat'),
                    ),
                    const SizedBox(width: 86),
                    Expanded(
                      child: _buildNavItem(3, Icons.stars_rounded, 'Saran'),
                    ),
                    Expanded(
                      child: _buildNavItem(4, Icons.person_rounded, 'Profil'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: -18, child: _buildCenterScanButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? const Color(0xFF007F73)
        : const Color(0xFF64748B);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScanButton() {
    final isSelected = currentIndex == 2;

    return Semantics(
      button: true,
      label: 'Scan',
      child: GestureDetector(
        onTap: () => onTap(2),
        child: SizedBox(
          width: 88,
          height: 96,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF007F73)
                      : const Color(0xFF00BFA5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.32),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Pindai',
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFF005F56),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
