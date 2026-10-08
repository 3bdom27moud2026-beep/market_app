import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/cart/data/models/order_model.dart';

void main() {
  group('OrderModel & Real POST /v1/orders Response Parsing', () {
    const realResponseJson = {
      'status': true,
      'message': 'تم تسجيل الطلب بنجاح',
      'orders': [
        {
          'order_no': 'ORD-5534',
          'user_id': 13,
          'merchant_id': 4,
          'total_price': 1299,
          'savings': 901,
          'payment_method': 'cash',
          'status': 'pending',
          'updated_at': '2026-08-17T19:06:32.000000Z',
          'created_at': '2026-08-17T19:06:32.000000Z',
          'id': 8,
          'items': [
            {
              'id': 8,
              'order_id': 8,
              'product_id': 4,
              'qty': 1,
              'price': 1299,
              'savings': 901,
              'created_at': '2026-08-17T19:06:32.000000Z',
              'updated_at': '2026-08-17T19:06:32.000000Z',
              'product': {
                'id': 4,
                'merchant_id': 4,
                'name': 'حذاء رياضي مريح للجري',
                'brand': 'Nike',
                'description':
                    'حذاء رياضي مريح للجري جودة ممتازة وسعر مميز حصرياً لحاملي كارت شوب جايد.',
                'price': 1299,
                'old_price': 2200,
                'image':
                    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400',
                'thumbnails': [
                  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400',
                  'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=600',
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=600',
                ],
                'specs': {
                  'النوع': 'رياضي للجري',
                  'الخامة': 'أنسجة شبكية مريحة',
                  'المنشأ': 'فيتنام',
                },
                'rating': 4.6,
                'review_count': 45,
                'stock': 19,
                'is_flash_sale': true,
                'is_active': true,
                'created_at': '2026-07-19T15:49:52.000000Z',
                'updated_at': '2026-08-17T19:06:32.000000Z',
              },
            },
          ],
        },
      ],
    };

    test(
      'OrderModel.fromApiResponse parses full real backend payload accurately without type cast error',
      () {
        expect(
          () => OrderModel.fromApiResponse(realResponseJson),
          returnsNormally,
        );

        final order = OrderModel.fromApiResponse(realResponseJson);

        // Root / Order level fields
        expect(order.id, 8);
        expect(order.orderNo, 'ORD-5534');
        expect(order.orderId, 'ORD-5534');
        expect(order.userId, 13);
        expect(order.merchantId, 4);
        expect(order.totalPrice, 1299.0);
        expect(order.savings, 901.0);
        expect(order.paymentMethodType, 'cash');
        expect(order.status, 'pending');
        expect(order.createdAt, DateTime.parse('2026-08-17T19:06:32.000000Z'));
        expect(order.updatedAt, DateTime.parse('2026-08-17T19:06:32.000000Z'));

        // Computed Summary
        expect(order.summary.total, 1299.0);
        expect(order.summary.discountAmount, 901.0);
        expect(order.summary.subtotal, 2200.0);

        // Items Array
        expect(order.items.length, 1);
        final item = order.items.first;
        expect(item.id, 8);
        expect(item.qty, 1);
        expect(item.lineTotal, 1299.0);
        expect(item.lineSavings, 901.0);

        // Nested Product
        final product = item.product;
        expect(product.id, '4');
        expect(product.name, 'حذاء رياضي مريح للجري');
        expect(product.brand, 'Nike');
        expect(product.store, 'Nike');
        expect(product.price, 1299.0);
        expect(product.oldPrice, 2200.0);
        expect(product.rating, 4.6);
        expect(product.reviewCount, 45);
        expect(product.stock, 19);
        expect(product.isFlashSale, true);
        expect(product.images.length, 3);
        expect(product.specifications.length, 3);
        expect(product.specifications[0].title, 'النوع');
        expect(product.specifications[0].value, 'رياضي للجري');
        expect(product.specifications[1].title, 'الخامة');
        expect(product.specifications[1].value, 'أنسجة شبكية مريحة');
        expect(product.specifications[2].title, 'المنشأ');
        expect(product.specifications[2].value, 'فيتنام');
      },
    );

    test(
      'OrderModel.fromJson handles direct single order map without error',
      () {
        final singleOrderMap =
            (realResponseJson['orders'] as List).first as Map<String, dynamic>;
        final order = OrderModel.fromJson(singleOrderMap);

        expect(order.id, 8);
        expect(order.orderNo, 'ORD-5534');
        expect(order.status, 'pending');
        expect(order.totalPrice, 1299.0);
        expect(order.items.length, 1);
      },
    );

    test('OrderModel.fromJson handles empty/malformed map gracefully', () {
      final order = OrderModel.fromJson(const {});

      expect(order.id, 0);
      expect(order.orderNo, '');
      expect(order.status, 'pending');
      expect(order.totalPrice, 0.0);
      expect(order.savings, 0.0);
      expect(order.items, isEmpty);
    });
  });
}
