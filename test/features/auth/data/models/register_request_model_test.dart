import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';

void main() {
  group('RegisterRequestModel', () {
    test('toJson produces exact expected json payload', () {
      const model = RegisterRequestModel(
        name: 'محمود أحمد',
        email: 'mahmoud@example.com',
        phone: '01099887766',
        password: '123456',
        areaId: 1,
        requestCard: false,
      );

      final json = model.toJson();

      expect(json, {
        'name': 'محمود أحمد',
        'email': 'mahmoud@example.com',
        'phone': '01099887766',
        'password': '123456',
        'password_confirmation': '123456',
        'area_id': 1,
        'request_card': false,
      });
    });

    test('toJson handles optional email with fallback and referralCode', () {
      const model = RegisterRequestModel(
        name: 'أحمد علي',
        phone: '01011223344',
        password: 'password123',
        areaId: 2,
        referralCode: 'REF9988',
      );

      final json = model.toJson();

      expect(json, {
        'name': 'أحمد علي',
        'email': '01011223344@customer.app',
        'phone': '01011223344',
        'password': 'password123',
        'password_confirmation': 'password123',
        'area_id': 2,
        'request_card': false,
        'referral_code': 'REF9988',
      });
    });
  });
}
