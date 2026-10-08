import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/data/models/card_request_response_model.dart';

void main() {
  group('CardRequestModel Serialization Verification', () {
    test('toJson serializes correctly with required and default fields', () {
      const model = CardRequestModel(
        deliveryAddress: 'المنصورة - شارع المشاية',
        phone: '01012345678',
        paymentMethod: 'cash',
      );

      final json = model.toJson();

      expect(json, {
        'delivery_address': 'المنصورة - شارع المشاية',
        'phone': '01012345678',
        'payment_method': 'cash',
      });
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'delivery_address': 'القاهرة - المعادي',
        'phone': '01198765432',
        'payment_method': 'cash',
      };

      final model = CardRequestModel.fromJson(json);

      expect(model.deliveryAddress, 'القاهرة - المعادي');
      expect(model.phone, '01198765432');
      expect(model.paymentMethod, 'cash');
    });
  });

  group('CardRequestResponseModel Verification', () {
    test('parses successful response with status=true', () {
      final json = {'status': true, 'message': 'تم تقديم طلب الكارت بنجاح'};

      final model = CardRequestResponseModel.fromJson(json);

      expect(model.status, isTrue);
      expect(model.message, 'تم تقديم طلب الكارت بنجاح');
      expect(model.card, isNull);
    });

    test('parses business rejection response with status=false and card', () {
      final json = {
        'status': false,
        'message': 'لديك بالفعل كارت توفير ساري حتى 2028-08-14',
        'card': {
          'id': 12,
          'user_id': 14,
          'card_no': 'SG-2026-9479',
          'type': 'annual',
          'status': 'active',
          'total_savings': 0,
          'activated_at': '2026-08-14T16:06:46.000000Z',
          'expires_at': '2028-08-14T16:06:46.000000Z',
          'created_at': '2026-08-14T16:06:46.000000Z',
          'updated_at': '2026-08-15T13:36:08.000000Z',
        },
      };

      final model = CardRequestResponseModel.fromJson(json);

      expect(model.status, isFalse);
      expect(model.message, 'لديك بالفعل كارت توفير ساري حتى 2028-08-14');
      expect(model.card, isNotNull);
      expect(model.card!.id, 12);
      expect(model.card!.cardNo, 'SG-2026-9479');
      expect(model.card!.status, 'active');
      expect(model.card!.isActive, isTrue);
    });
  });
}
