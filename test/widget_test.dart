import 'package:flutter_test/flutter_test.dart';
import 'package:svara_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SvaraApp());
    expect(find.byType(SvaraApp), findsOneWidget);
  });
}
