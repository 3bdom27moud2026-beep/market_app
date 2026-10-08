import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'package:market/features/home/presentation/widgets/flash_sale_section.dart';
import 'package:market/features/home/presentation/widgets/flash_sale_timer.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  const testProduct = FlashSaleProductEntity(
    id: '1',
    title: 'وجبة برجر دبل تشيز',
    store: 'برجر كينج',
    price: 99.0,
    oldPrice: 200.0,
    image: 'https://example.com/burger.png',
    discount: '51%',
    rating: 4.7,
    remaining: 12,
  );

  group('FlashSaleTimer Widget Tests', () {
    testWidgets('displays hours, minutes, seconds and label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlashSaleTimer(
              duration: Duration(hours: 1, minutes: 45, seconds: 22),
            ),
          ),
        ),
      );

      expect(find.text('ينتهي خلال'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
      expect(find.text('45'), findsOneWidget);
      expect(find.text('22'), findsOneWidget);
      expect(find.text('س'), findsOneWidget);
      expect(find.text('د'), findsOneWidget);
      expect(find.text('ث'), findsOneWidget);
    });
  });

  group('FlashSaleSection Widget Tests', () {
    testWidgets('renders section title, subtitle, timer, and view all button', (
      tester,
    ) async {
      bool viewAllTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          SingleChildScrollView(
            child: FlashSaleSection(
              products: const [testProduct],
              timerDuration: const Duration(hours: 2),
              onViewAllTap: () => viewAllTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('فلاش سيل'), findsOneWidget);
      expect(find.text('عروض محدودة بكميات قليلة'), findsOneWidget);
      expect(find.text('عرض كل عروض الفلاش'), findsOneWidget);

      await tester.tap(find.text('عرض كل عروض الفلاش'));
      await tester.pump();
      expect(viewAllTapped, isTrue);
    });

    testWidgets('renders empty state when products list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          const FlashSaleSection(
            products: [],
            timerDuration: Duration(hours: 1),
          ),
        ),
      );

      expect(find.text('لا توجد عروض حالياً'), findsOneWidget);
    });
  });
}
