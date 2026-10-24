import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/theme/app_theme.dart';
import 'package:market/core/widgets/custom_bottom_nav_bar.dart';

Widget _buildTestWidget({required String currentRoute}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: CustomBottomNavBar(
            currentRoute: currentRoute,
          ),
        ),
      );
    },
  );
}

void main() {
  group('CustomBottomNavBar Widget Tests', () {
    testWidgets('renders CurvedNavigationBar with 5 items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestWidget(currentRoute: AppRoutes.home));
      await tester.pumpAndSettle();

      expect(find.byType(CurvedNavigationBar), findsOneWidget);
      final CurvedNavigationBar navBar = tester.widget(
        find.byType(CurvedNavigationBar),
      );
      expect(navBar.items.length, equals(5));
      expect(navBar.index, equals(0));
    });

    testWidgets('activates profile tab when on profile route', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(currentRoute: AppRoutes.profile),
      );
      await tester.pumpAndSettle();

      final CurvedNavigationBar navBar = tester.widget(
        find.byType(CurvedNavigationBar),
      );
      expect(navBar.index, equals(2));
    });

    testWidgets('activates favorites tab when on favorites route', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(currentRoute: AppRoutes.favorites),
      );
      await tester.pumpAndSettle();

      final CurvedNavigationBar navBar = tester.widget(
        find.byType(CurvedNavigationBar),
      );
      expect(navBar.index, equals(3));
    });

    testWidgets('activates categories tab when on categories route', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(currentRoute: AppRoutes.categories),
      );
      await tester.pumpAndSettle();

      final CurvedNavigationBar navBar = tester.widget(
        find.byType(CurvedNavigationBar),
      );
      expect(navBar.index, equals(1));
    });
  });
}
