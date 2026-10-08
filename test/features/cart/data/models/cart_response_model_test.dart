import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/cart/data/models/cart_response_model.dart';
import 'package:market/features/cart/data/models/cart_item_model.dart';

void main() {
  group('CartResponseModel & CartItemModel', () {
    const mockJson = {
      "status": true,
      "is_member": true,
      "cart": [
        {
          "id": 16,
          "qty": 2,
          "line_total": 130,
          "line_savings": 110,
          "product": {
            "id": 5,
            "merchant_id": 6,
            "name": "مشروب لاتيه مثلج مكرمل",
            "brand": "ستاربكس",
            "description":
                "مشروب لاتيه مثلج مع الحليب جودة ممتازة وسعر مميز حصرياً لحاملي كارت شوب جايد.",
            "price": 65,
            "old_price": 120,
            "image":
                "https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400",
            "thumbnails": [
              "https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400",
              "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=600",
              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=600",
            ],
            "specs": {
              "الحجم": "غراندي",
              "النوع": "مثلج مع الحليب",
              "النكهة": "كلاسيك",
            },
            "rating": 4.9,
            "review_count": 200,
            "stock": 30,
            "is_flash_sale": true,
            "is_active": true,
            "created_at": "2026-07-19T15:49:52.000000Z",
            "updated_at": "2026-07-19T15:49:52.000000Z",
            "merchant": {
              "id": 6,
              "category_id": 2,
              "area_id": 5,
              "name": "ستاربكس شوب جايد",
              "description":
                  "ستاربكس شوب جايد شريك معتمد لـ شوب جايد لتوفير أفضل العروض والخصومات لحاملي الكارت.",
              "image":
                  "https://images.unsplash.com/photo-1554118811-1e0d58224a0c?q=80&w=400",
              "phone": "01000000000",
              "whatsapp": "01012345678",
              "email": "merchant6@shopguide.com",
              "address": "مصر، الفرع الرئيسي للتاجر",
              "lat": 30.0444,
              "lng": 31.2357,
              "discount": "15%",
              "type": "retail",
              "rating": 4.8,
              "review_count": 120,
              "order_count": 250,
              "supports_installment": false,
              "is_wholesale": false,
              "status": "active",
              "distance": "0.5 كم",
              "created_at": "2026-07-19T15:49:52.000000Z",
              "updated_at": "2026-07-24T16:14:03.000000Z",
            },
            "is_member": true,
            "display_price": 65,
            "original_price": 120,
            "member_price": 65,
            "has_discount": true,
            "savings_amount": 55,
          },
        },
      ],
      "cart_total": 130,
      "cart_savings": 110,
      "cart_count": 1,
    };

    test(
      'should parse complete confirmed CartResponseModel JSON accurately',
      () {
        final model = CartResponseModel.fromJson(mockJson);

        expect(model.status, true);
        expect(model.isMember, true);
        expect(model.cartTotal, 130);
        expect(model.cartSavings, 110);
        expect(model.cartCount, 1);
        expect(model.cart.length, 1);

        final item = model.cart.first;
        expect(item.id, 16);
        expect(item.qty, 2);
        expect(item.lineTotal, 130);
        expect(item.lineSavings, 110);

        expect(item.product.id, '5');
        expect(item.product.name, 'مشروب لاتيه مثلج مكرمل');
        expect(item.product.brand, 'ستاربكس');
        expect(item.product.isMember, true);
        expect(item.product.displayPrice, 65);
        expect(item.product.originalPrice, 120);
        expect(item.product.memberPrice, 65);
        expect(item.product.hasDiscount, true);
        expect(item.product.savingsAmount, 55);
        expect(item.product.images.length, 3);
        expect(item.product.specifications.length, 3);
      },
    );

    test('should handle empty cart response safely', () {
      final emptyJson = {
        "status": true,
        "is_member": false,
        "cart": [],
        "cart_total": 0,
        "cart_savings": 0,
        "cart_count": 0,
      };

      final model = CartResponseModel.fromJson(emptyJson);

      expect(model.status, true);
      expect(model.isMember, false);
      expect(model.cartTotal, 0);
      expect(model.cartSavings, 0);
      expect(model.cartCount, 0);
      expect(model.cart.isEmpty, true);
    });

    test('should parse defensive types and fallbacks in CartItemModel', () {
      final itemJson = {
        "id": "22",
        "qty": "3",
        "line_total": "210",
        "line_savings": "50",
        "product": {"id": 99, "name": "Fallback Item", "price": 70},
      };

      final item = CartItemModel.fromJson(itemJson);

      expect(item.id, 22);
      expect(item.qty, 3);
      expect(item.lineTotal, 210.0);
      expect(item.lineSavings, 50.0);
      expect(item.product.name, 'Fallback Item');
    });
  });
}
