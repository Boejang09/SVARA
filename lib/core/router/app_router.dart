import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/features/about/about_svara_screen.dart';
import 'package:svara_app/features/auth/login_screen.dart';
import 'package:svara_app/features/auth/register_screen.dart';
import 'package:svara_app/features/dashboard/main_navigation_screen.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/features/onboarding/onboarding_screen.dart';
import 'package:svara_app/features/screening/ai_loading_screen.dart';
import 'package:svara_app/features/screening/before_recording_screen.dart';
import 'package:svara_app/features/screening/record_audio_screen.dart';
import 'package:svara_app/features/screening/screening_result_screen.dart';

/// Central navigation for the SVARA MVP user flow:
/// Login -> Record Audio -> AI -> Risk Score -> History
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.onboarding => _page(const OnboardingScreen(), settings),
      AppRoutes.login => _page(const LoginScreen(), settings),
      AppRoutes.register => _page(const RegisterScreen(), settings),
      AppRoutes.main => _page(
        MainNavigationScreen(
          initialIndex: _readMainTabIndex(settings.arguments),
        ),
        settings,
      ),
      AppRoutes.beforeRecording => _page(
        const BeforeRecordingScreen(),
        settings,
      ),
      AppRoutes.recordAudio => _page(const RecordAudioScreen(), settings),
      AppRoutes.aiLoading => _page(const AILoadingScreen(), settings),
      AppRoutes.screeningResult => _page(
        const ScreeningResultScreen(),
        settings,
      ),
      AppRoutes.notifications => _page(const NotificationsScreen(), settings),
      AppRoutes.about => _page(const AboutSvaraScreen(), settings),
      _ => _page(const OnboardingScreen(), settings),
    };
  }

  static int _readMainTabIndex(Object? arguments) {
    if (arguments is int) return arguments.clamp(0, 4);
    if (arguments is Map && arguments['tab'] is int) {
      return (arguments['tab'] as int).clamp(0, 4);
    }
    return 0;
  }

  static MaterialPageRoute<T> _page<T>(Widget child, RouteSettings settings) {
    return MaterialPageRoute<T>(settings: settings, builder: (_) => child);
  }

  // --- Auth ---

  static void toLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  static void toRegister(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  static void toMain(BuildContext context, {int tab = 0}) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false, arguments: tab);
  }

  // --- MVP Screening flow ---

  static void startScreening(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.beforeRecording);
  }

  static void toRecordAudio(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.recordAudio);
  }

  static void toAiAnalysis(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.aiLoading);
  }

  static void toScreeningResult(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.screeningResult);
  }

  static void finishScreeningToHome(BuildContext context) {
    toMain(context, tab: 0);
  }

  static void finishScreeningToHistory(BuildContext context) {
    toMain(context, tab: 1);
  }

  static void popToMain(BuildContext context) {
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == AppRoutes.main);
  }
}
