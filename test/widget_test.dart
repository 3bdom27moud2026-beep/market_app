import 'package:flutter_test/flutter_test.dart';

import 'package:market/main.dart';

void main() {
  testWidgets('Splash screen displays title and subtitle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MarketApp());

    // Verify that the splash page is displayed.
    expect(find.text('Shop Guide'), findsOneWidget);
    expect(find.text('دليل التسوق والخدمات'), findsOneWidget);
  });
}
