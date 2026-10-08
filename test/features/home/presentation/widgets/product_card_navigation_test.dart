import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/home/domain/entities/best_seller_entity.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'package:market/features/home/domain/entities/newest_product_entity.dart';
import 'package:market/features/home/domain/entities/offer_banner_entity.dart';
import 'package:market/features/home/presentation/widgets/best_seller_card.dart';
import 'package:market/features/home/presentation/widgets/flash_sale_product_card.dart';
import 'package:market/features/home/presentation/widgets/newest_product_card.dart';
import 'package:market/features/home/presentation/widgets/offer_slider.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('Product Cards & Banner Navigation Tapping Tests', () {
    const tBestSeller = BestSellerEntity(
      id: 'prod_1',
      title: 'Test Best Seller',
      image: 'https://example.com/image.jpg',
      price: 100,
      oldPrice: 120,
      discount: '20%',
      rating: 4.5,
      reviewCount: 10,
      brand: 'Brand',
      merchantName: 'Store',
    );

    const tFlashSale = FlashSaleProductEntity(
      id: 'prod_2',
      title: 'Test Flash Sale',
      image: 'https://example.com/image.jpg',
      price: 80,
      oldPrice: 100,
      discount: '20%',
      rating: 4.8,
      remaining: 5,
      store: 'Store',
    );

    const tNewest = NewestProductEntity(
      id: 'prod_3',
      title: 'Test Newest Product',
      image: 'https://example.com/image.jpg',
      price: 150,
      oldPrice: 200,
      discount: '25%',
      rating: 4.9,
      store: 'Store',
      isFavorite: false,
    );

    const tOffer = OfferBannerEntity(
      id: 'banner_1',
      title: 'Special Banner',
      subtitle: 'Big Sale',
      image: 'https://example.com/banner.jpg',
      discount: '30%',
      buttonText: 'تسوق الآن',
    );

    testWidgets('Tapping anywhere on BestSellerCard triggers onDetailsTap', (
      tester,
    ) async {
      bool detailsTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          BestSellerCard(
            product: tBestSeller,
            onDetailsTap: () => detailsTapped = true,
          ),
        ),
      );

      // Tap product title
      await tester.tap(find.text('Test Best Seller'));
      await tester.pump();

      expect(detailsTapped, isTrue);
    });

    testWidgets(
      'Tapping anywhere on FlashSaleProductCard triggers onDetailsTap',
      (tester) async {
        bool detailsTapped = false;

        await tester.pumpWidget(
          _buildTestApp(
            FlashSaleProductCard(
              product: tFlashSale,
              onDetailsTap: () => detailsTapped = true,
            ),
          ),
        );

        // Tap product title
        await tester.tap(find.text('Test Flash Sale'));
        await tester.pump();

        expect(detailsTapped, isTrue);
      },
    );

    testWidgets('Tapping anywhere on NewestProductCard triggers onDetailsTap', (
      tester,
    ) async {
      bool detailsTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          NewestProductCard(
            product: tNewest,
            onDetailsTap: () => detailsTapped = true,
          ),
        ),
      );

      // Tap product title
      await tester.tap(find.text('Test Newest Product'));
      await tester.pump();

      expect(detailsTapped, isTrue);
    });

    testWidgets('Tapping OfferSlider banner triggers onOfferTap', (
      tester,
    ) async {
      OfferBannerEntity? tappedOffer;

      await tester.pumpWidget(
        _buildTestApp(
          OfferSlider(
            offers: const [tOffer],
            currentIndex: 0,
            onPageChanged: (_) {},
            onOfferTap: (offer) => tappedOffer = offer,
          ),
        ),
      );

      await tester.tap(find.text('Special Banner'));
      await tester.pump();

      expect(tappedOffer, equals(tOffer));
    });
  });
}
