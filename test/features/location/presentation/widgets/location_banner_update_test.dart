import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/home/presentation/widgets/location_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  group('LocationBanner & CacheHelper Location Tests', () {
    test(
      'CacheHelper saves and retrieves selectedLocationName accurately',
      () async {
        expect(CacheHelper.selectedLocationName, isNull);

        await CacheHelper.setSelectedLocationName('القاهرة، المعادي');
        expect(CacheHelper.selectedLocationName, equals('القاهرة، المعادي'));

        await CacheHelper.setSelectedLocationName(null);
        expect(CacheHelper.selectedLocationName, isNull);
      },
    );

    testWidgets('LocationBanner displays provided location name', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LocationBanner(selectedLocation: 'الجيزة، الدقي'),
          ),
        ),
      );

      expect(find.text('الجيزة، الدقي'), findsOneWidget);
    });

    testWidgets(
      'LocationBanner displays fallback text when selectedLocation is null',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: LocationBanner(selectedLocation: null)),
          ),
        );

        expect(find.text('حدد موقعك لتصفية العروض'), findsOneWidget);
      },
    );

    testWidgets('Tapping LocationBanner executes onTap callback', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationBanner(
              selectedLocation: 'القاهرة، المعادي',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LocationBanner));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
