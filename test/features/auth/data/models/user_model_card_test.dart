import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel Card Parsing & Persistence Verification', () {
    test(
      'Test A: User with no card ("card": null) results in user.card == null',
      () {
        final jsonInput = {
          "user": {
            "id": 13,
            "name": "Regular Customer",
            "email": "regular@example.com",
            "phone": "01000000000",
            "card": null,
          },
        };

        final user = UserModel.fromJson(jsonInput, token: 'fake_token');

        expect(user.id, '13');
        expect(user.name, 'Regular Customer');
        expect(user.card, isNull);

        // Persistence round-trip verification
        final cachedJsonString = user.toJsonString();
        final restoredUser = UserModel.fromJsonString(cachedJsonString);

        expect(restoredUser.card, isNull);
      },
    );

    test(
      'Test B: User with a card results in user.card != null and cardNo matching',
      () {
        final jsonInput = {
          "user": {
            "id": 14,
            "name": "Card Customer",
            "email": "card@example.com",
            "phone": "01111111111",
            "card": {
              "id": 12,
              "user_id": 14,
              "card_no": "SG-2026-9479",
              "type": "annual",
              "status": "active",
              "total_savings": 0,
              "activated_at": "2026-08-14T16:06:46.000000Z",
              "expires_at": "2027-08-14T16:06:46.000000Z",
            },
          },
        };

        final user = UserModel.fromJson(jsonInput, token: 'fake_token');

        expect(user.id, '14');
        expect(user.name, 'Card Customer');
        expect(user.card, isNotNull);
        expect(user.card!.id, 12);
        expect(user.card!.userId, 14);
        expect(user.card!.cardNo, "SG-2026-9479");
        expect(user.card!.type, "annual");
        expect(user.card!.status, "active");
        expect(user.card!.isActive, isTrue);

        // Persistence round-trip verification
        final cachedJsonString = user.toJsonString();
        final restoredUser = UserModel.fromJsonString(cachedJsonString);

        expect(restoredUser.card, isNotNull);
        expect(restoredUser.card!.cardNo, "SG-2026-9479");
        expect(restoredUser.card!.id, 12);
        expect(restoredUser.card!.type, "annual");
        expect(restoredUser.card!.status, "active");
      },
    );
  });
}
