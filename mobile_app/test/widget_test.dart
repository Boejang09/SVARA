import 'package:flutter_test/flutter_test.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/main.dart';

void main() {
  testWidgets('SVARA app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const SvaraApp(
        initialRoute: AppRoutes.onboarding,
        testMode: true,
      ),
    );

    // Pastikan aplikasi berhasil dibuat.
    expect(find.byType(SvaraApp), findsOneWidget);

    // Beri waktu untuk fallback splash test.
    await tester.pump(
      const Duration(milliseconds: 500),
    );

    await tester.pump();
  });
}