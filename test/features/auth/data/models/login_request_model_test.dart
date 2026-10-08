import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';

void main() {
  group('LoginRequestModel', () {
    test('toJson formats email payload correctly', () {
      const model = LoginRequestModel(
        identifier: 'mahmoud@example.com',
        password: '123456',
      );

      final json = model.toJson();

      expect(json, {
        'login': 'mahmoud@example.com',
        'email': 'mahmoud@example.com',
        'password': '123456',
      });
    });

    test('toJson formats phone payload correctly', () {
      const model = LoginRequestModel(
        identifier: '01099887766',
        password: '123456',
      );

      final json = model.toJson();

      expect(json, {
        'login': '01099887766',
        'phone': '01099887766',
        'password': '123456',
      });
    });
  });
}
