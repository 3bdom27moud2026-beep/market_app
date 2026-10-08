import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';

void main() {
  group('ChangePasswordRequestModel', () {
    const tModel = ChangePasswordRequestModel(
      currentPassword: 'oldPassword123',
      newPassword: 'newPassword123',
      newPasswordConfirmation: 'newPassword123',
    );

    test('toJson returns correct map', () {
      final json = tModel.toJson();

      expect(json, {
        'current_password': 'oldPassword123',
        'new_password': 'newPassword123',
        'new_password_confirmation': 'newPassword123',
      });
    });

    test('supports value equality', () {
      const model2 = ChangePasswordRequestModel(
        currentPassword: 'oldPassword123',
        newPassword: 'newPassword123',
        newPasswordConfirmation: 'newPassword123',
      );

      expect(tModel, equals(model2));
    });
  });
}
