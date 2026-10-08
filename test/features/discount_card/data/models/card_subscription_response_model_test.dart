import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/card_subscription_response_model.dart';

void main() {
  group(
    'CardSubscriptionResponseModel Verification (POST /v1/card/subscribe)',
    () {
      test(
        'parses confirmed backend successful response for annual renewal',
        () {
          final json = {
            "status": true,
            "message":
                "تم تفعيل/تجديد كارت الاشتراك السنوي بنجاح (لمدة سنة كاملة)",
            "card": {
              "id": 12,
              "user_id": 14,
              "card_no": "SG-2026-9479",
              "type": "annual",
              "status": "active",
              "total_savings": 0,
              "activated_at": "2026-08-14T16:06:46.000000Z",
              "expires_at": "2028-08-14T16:06:46.000000Z",
              "created_at": "2026-08-14T16:06:46.000000Z",
              "updated_at": "2026-08-15T13:36:08.000000Z",
            },
          };

          final model = CardSubscriptionResponseModel.fromJson(json);

          expect(model.status, isTrue);
          expect(
            model.message,
            'تم تفعيل/تجديد كارت الاشتراك السنوي بنجاح (لمدة سنة كاملة)',
          );
          expect(model.card, isNotNull);
          expect(model.card!.id, 12);
          expect(model.card!.userId, 14);
          expect(model.card!.cardNo, 'SG-2026-9479');
          expect(model.card!.type, 'annual');
          expect(model.card!.status, 'active');
          expect(model.card!.isActive, isTrue);
          expect(model.card!.expiresAt, '2028-08-14T16:06:46.000000Z');
        },
      );

      test('toJson produces valid structure matching response model', () {
        final json = {
          "status": true,
          "message": "تم التفعيل",
          "card": {
            "id": 12,
            "user_id": 14,
            "card_no": "SG-2026-9479",
            "type": "annual",
            "status": "active",
            "total_savings": 0,
            "activated_at": "2026-08-14T16:06:46.000000Z",
            "expires_at": "2028-08-14T16:06:46.000000Z",
            "created_at": "2026-08-14T16:06:46.000000Z",
            "updated_at": "2026-08-15T13:36:08.000000Z",
          },
        };

        final model = CardSubscriptionResponseModel.fromJson(json);
        final serialized = model.toJson();

        expect(serialized['status'], isTrue);
        expect(serialized['message'], 'تم التفعيل');
        expect(serialized['card']['card_no'], 'SG-2026-9479');
      });

      test(
        'parses business rejection response with status=false and message',
        () {
          final json = {
            "status": false,
            "message": "لا يمكن تجديد الكارت حالياً",
            "card": null,
          };

          final model = CardSubscriptionResponseModel.fromJson(json);

          expect(model.status, isFalse);
          expect(model.message, "لا يمكن تجديد الكارت حالياً");
          expect(model.card, isNull);
        },
      );
    },
  );
}
