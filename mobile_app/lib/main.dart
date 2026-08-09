import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/core/theme/app_theme.dart';

void main() {
  runApp(const SvaraApp());
}

class SvaraApp extends StatelessWidget {
  const SvaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVARA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
