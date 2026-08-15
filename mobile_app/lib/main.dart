import 'package:flutter/material.dart';

import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/splash/splash_screen.dart';
import 'package:svara_app/services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.loadSession();

  runApp(
    SvaraApp(
      initialRoute: ApiService.accessToken != null
          ? AppRoutes.main
          : AppRoutes.onboarding,
    ),
  );
}

class SvaraApp extends StatelessWidget {
  static const _splashRoute = '/splash';

  final String initialRoute;

  /// Mode khusus untuk widget test.
  ///
  /// false = aplikasi normal, video splash aktif.
  /// true  = widget test, video splash tidak dijalankan.
  final bool testMode;

  const SvaraApp({
    super.key,
    required this.initialRoute,
    this.testMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVARA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: _splashRoute,
      onGenerateInitialRoutes: (_) => [
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: _splashRoute),
          builder: (_) =>
              SplashScreen(nextRoute: initialRoute, enableVideo: !testMode),
        ),
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
