import 'package:flutter_test/flutter_test.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/main.dart';

void main() {
  testWidgets('SVARA app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const SvaraApp(
        initialRoute: AppRoutes.onboarding,
      ),
    );

    // Pastikan aplikasi berhasil dibuat.
    expect(find.byType(SvaraApp), findsOneWidget);

    // Biarkan splash menyelesaikan timer 1,8 detik.
    await tester.pump(
      const Duration(milliseconds: 1800),
    );

    // Jalankan satu frame setelah navigasi.
    await tester.pump();
  });
}