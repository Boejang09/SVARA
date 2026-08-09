import 'package:flutter/material.dart';

class MobileWrapper extends StatelessWidget {
  final Widget child;

  const MobileWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430, maxHeight: 900),
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FBF7),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BFA5).withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: Size(
                    MediaQuery.of(context).size.width > 430
                        ? 430
                        : MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height > 900
                        ? 900
                        : MediaQuery.of(context).size.height,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return child;
  }
}
