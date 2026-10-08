import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/discount_card_data_model.dart';
import 'package:market/features/profile/data/models/profile_model.dart';

void main() {
  group('Zero-Trust UserCardModel JSON Parsing Tests (GET /v1/card/status)', () {
    test(
      'Case A: status=true + card=null parses card as null and isSubscribed as false',
      () {
        final json = {"status": true, "card": null};

        final dataModel = DiscountCardDataModel.fromJson(json);

        expect(dataModel.card, isNull);
        expect(dataModel.isSubscribed, isFalse);
      },
    );

    test('Case B: status=true + active card parses all fields accurately', () {
      final json = {
        "status": true,
        "card": {
          "id": 12,
          "user_id": 14,
          "card_no": "SG-2026-9479",
          "type": "annual",
          "status": "active",
          "total_savings": 0,
          "activated_at": "2026-08-14T16:06:46.000000Z",
          "expires_at": "2027-08-14T16:06:46.000000Z",
          "created_at": "2026-08-14T16:06:46.000000Z",
          "updated_at": "2026-08-14T16:06:46.000000Z",
        },
      };

      final cardJson = json['card'] as Map<String, dynamic>;
      final model = UserCardModel.fromJson(cardJson);

      expect(model.id, 12);
      expect(model.userId, 14);
      expect(model.cardNo, "SG-2026-9479");
      expect(model.type, "annual");
      expect(model.status, "active");
      expect(model.totalSavings, 0.0);
      expect(model.activatedAt, "2026-08-14T16:06:46.000000Z");
      expect(model.expiresAt, "2027-08-14T16:06:46.000000Z");
      expect(model.createdAt, "2026-08-14T16:06:46.000000Z");
      expect(model.updatedAt, "2026-08-14T16:06:46.000000Z");
      expect(model.isActive, isTrue);
    });

    test(
      'Case C: malformed/null optional timestamps are handled defensively without throwing',
      () {
        final cardJson = {
          "id": 15,
          "user_id": 20,
          "card_no": "SG-2026-0000",
          "type": "annual",
          "status": "active",
          "total_savings": 25.5,
          "activated_at": null,
          "expires_at": "not-a-valid-date",
          "created_at": null,
          "updated_at": null,
        };

        final model = UserCardModel.fromJson(cardJson);

        expect(model.id, 15);
        expect(model.userId, 20);
        expect(model.cardNo, "SG-2026-0000");
        expect(model.activatedAt, isNull);
        expect(model.expiresAt, "not-a-valid-date");
        expect(
          model.daysRemaining,
          0,
        ); // Gracefully returns 0 for malformed date
        expect(model.createdAt, isNull);
        expect(model.updatedAt, isNull);
        expect(model.isActive, isTrue);
      },
    );

    test(
      'Case D: expired card status produces isActive == false and daysRemaining == 0',
      () {
        final cardJson = {
          "id": 12,
          "user_id": 14,
          "card_no": "SG-2025-1234",
          "type": "annual",
          "status": "expired",
          "total_savings": 100.0,
          "activated_at": "2025-01-01T00:00:00.000000Z",
          "expires_at": "2026-01-01T00:00:00.000000Z",
        };

        final model = UserCardModel.fromJson(cardJson);

        expect(model.id, 12);
        expect(model.status, "expired");
        expect(model.isActive, isFalse);
        expect(model.daysRemaining, 0);
      },
    );
  });
}
