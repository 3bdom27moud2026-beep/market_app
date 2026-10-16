import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/home/domain/entities/best_seller_entity.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'package:market/features/home/domain/entities/newest_product_entity.dart';
import 'package:market/features/home/presentation/cubit/home_state.dart';
import 'package:market/features/home/presentation/widgets/best_seller_section.dart';
import 'package:market/features/home/presentation/widgets/flash_sale_section.dart';
import 'package:market/features/home/presentation/widgets/newest_products_section.dart';

void main() {
  group('FlashSaleSection.sortProducts', () {
    const p1 = FlashSaleProductEntity(
      id: '1',
      title: 'Item 1',
      store: 'Store',
      image: '',
      price: 100.0,
      oldPrice: 150.0,
      rating: 4.0,
      remaining: 5,
      discount: '33%',
    );
    const p2 = FlashSaleProductEntity(
      id: '2',
      title: 'Item 2',
      store: 'Store',
      image: '',
      price: 50.0,
      oldPrice: 100.0,
      rating: 4.8,
      remaining: 2,
      discount: '50%',
    );
    const p3 = FlashSaleProductEntity(
      id: '3',
      title: 'Item 3',
      store: 'Store',
      image: '',
      price: 200.0,
      oldPrice: 220.0,
      rating: 3.5,
      remaining: 10,
      discount: '10%',
    );

    final list = [p1, p2, p3];

    test('preserves order for NewestFilter.newest', () {
      final result = FlashSaleSection.sortProducts(list, NewestFilter.newest);
      expect(result.map((p) => p.id).toList(), ['1', '2', '3']);
    });

    test('sorts by highest discount descending', () {
      final result = FlashSaleSection.sortProducts(
        list,
        NewestFilter.highestDiscount,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by lowest price ascending', () {
      final result = FlashSaleSection.sortProducts(
        list,
        NewestFilter.lowestPrice,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by highest rating descending', () {
      final result = FlashSaleSection.sortProducts(
        list,
        NewestFilter.highestRating,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });
  });

  group('BestSellerSection.sortProducts', () {
    const b1 = BestSellerEntity(
      id: '1',
      title: 'Best 1',
      image: '',
      price: 150.0,
      oldPrice: 200.0,
      rating: 4.2,
      discount: '25%',
    );
    const b2 = BestSellerEntity(
      id: '2',
      title: 'Best 2',
      image: '',
      price: 80.0,
      oldPrice: 160.0,
      rating: 4.9,
      discount: '50%',
    );
    const b3 = BestSellerEntity(
      id: '3',
      title: 'Best 3',
      image: '',
      price: 300.0,
      oldPrice: 330.0,
      rating: 3.8,
      discount: '10%',
    );

    final list = [b1, b2, b3];

    test('preserves order for NewestFilter.newest', () {
      final result = BestSellerSection.sortProducts(list, NewestFilter.newest);
      expect(result.map((p) => p.id).toList(), ['1', '2', '3']);
    });

    test('sorts by highest discount descending', () {
      final result = BestSellerSection.sortProducts(
        list,
        NewestFilter.highestDiscount,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by lowest price ascending', () {
      final result = BestSellerSection.sortProducts(
        list,
        NewestFilter.lowestPrice,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by highest rating descending', () {
      final result = BestSellerSection.sortProducts(
        list,
        NewestFilter.highestRating,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });
  });

  group('NewestProductsSection.sortProducts', () {
    const n1 = NewestProductEntity(
      id: '1',
      title: 'Newest 1',
      store: 'Store',
      image: '',
      price: 120.0,
      oldPrice: 150.0,
      rating: 4.1,
      discount: '20%',
    );
    const n2 = NewestProductEntity(
      id: '2',
      title: 'Newest 2',
      store: 'Store',
      image: '',
      price: 60.0,
      oldPrice: 120.0,
      rating: 5.0,
      discount: '50%',
    );
    const n3 = NewestProductEntity(
      id: '3',
      title: 'Newest 3',
      store: 'Store',
      image: '',
      price: 250.0,
      oldPrice: 275.0,
      rating: 3.9,
      discount: '9%',
    );

    final list = [n1, n2, n3];

    test('preserves order for NewestFilter.newest', () {
      final result = NewestProductsSection.sortProducts(
        list,
        NewestFilter.newest,
      );
      expect(result.map((p) => p.id).toList(), ['1', '2', '3']);
    });

    test('sorts by highest discount descending', () {
      final result = NewestProductsSection.sortProducts(
        list,
        NewestFilter.highestDiscount,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by lowest price ascending', () {
      final result = NewestProductsSection.sortProducts(
        list,
        NewestFilter.lowestPrice,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });

    test('sorts by highest rating descending', () {
      final result = NewestProductsSection.sortProducts(
        list,
        NewestFilter.highestRating,
      );
      expect(result.map((p) => p.id).toList(), ['2', '1', '3']);
    });
  });
}
