import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;

  const SplashScreen({
    super.key,
    required this.nextRoute,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _splashTimer;

  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoController.forward();

    _startSplash();
  }

  void _startSplash() {
    _splashTimer = Timer(
      const Duration(milliseconds: 1800),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(
          widget.nextRoute,
        );
      },
    );
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _logoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              final logoSize = (screenWidth * 0.30).clamp(
                90.0,
                150.0,
              );

              final lottieWidth = (screenWidth * 0.28).clamp(
                80.0,
                120.0,
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ==========================================
                  // LOGO SVARA
                  // ==========================================
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _logoController,
                      curve: Curves.easeIn,
                    ),
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.75,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: _logoController,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/svara_logo_exact.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==========================================
                  // LOTTIE LOADING
                  // ==========================================
                  SizedBox(
                    width: lottieWidth,
                    height: 35,
                    child: Lottie.asset(
                      'assets/lottie/svara_splash.json',
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // NAMA APLIKASI
                  // ==========================================
                  const Text(
                    'SVARA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: Color(0xFF00695C),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ==========================================
                  // STATUS
                  // ==========================================
                  const Text(
                    'Memuat aplikasi...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}