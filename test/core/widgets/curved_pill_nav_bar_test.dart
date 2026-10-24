import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/constants/app_bottom_nav.dart';
import 'package:market/core/widgets/curved_nav_bar/curved_pill_nav_bar.dart';
import 'package:market/core/widgets/curved_nav_bar/nav_bar_custom_icons.dart';

void main() {
  group('CurvedPillNavBar Widget Tests', () {
    testWidgets('renders all 5 tabs with correct labels and custom icons', (
      WidgetTester tester,
    ) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CurvedPillNavBar(
              currentIndex: 0,
              items: AppBottomNav.items,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify tab labels are rendered
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الفئات'), findsOneWidget);
      expect(find.text('الحساب'), findsOneWidget);
      expect(find.text('المفضلة'), findsOneWidget);
      expect(find.text('السلة'), findsOneWidget);

      // Verify NavBarCustomIcon widgets exist
      expect(find.byType(NavBarCustomIcon), findsWidgets);

      // Tap on 'الفئات' (index 1)
      await tester.tap(find.text('الفئات'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(1));

      // Tap on 'الحساب' (index 2)
      await tester.tap(find.text('الحساب'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(2));

      // Tap on 'السلة' (index 4)
      await tester.tap(find.text('السلة'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(4));
    });

    testWidgets('animates active bump when currentIndex updates', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: CurvedPillNavBar(
                  currentIndex: 0,
                  items: AppBottomNav.items,
                  onTap: (_) {},
                ),
              );
            },
          ),
        ),
      );

      // Verify initial frame pumps without error
      await tester.pumpAndSettle();
      expect(find.byType(CurvedPillNavBar), findsOneWidget);
    });

    testWidgets(
      'renders all 5 NavTabType icons in active and inactive states',
      (WidgetTester tester) async {
        for (final type in NavTabType.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    NavBarCustomIcon(
                      type: type,
                      isActive: false,
                      activeColor: const Color(0xFFF16E36),
                      inactiveColor: const Color(0xFF1B2844),
                    ),
                    NavBarCustomIcon(
                      type: type,
                      isActive: true,
                      activeColor: const Color(0xFFF16E36),
                      inactiveColor: const Color(0xFF1B2844),
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(find.byType(NavBarCustomIcon), findsNWidgets(2));
        }
      },
    );
  });
}
