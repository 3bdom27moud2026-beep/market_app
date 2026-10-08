import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'package:market/features/profile/domain/usecases/change_password_usecase.dart';

class MockProfileRepository implements ProfileRepository {
  Either<String, String>? changePasswordResult;

  @override
  Future<Either<String, String>> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    return changePasswordResult!;
  }

  @override
  Future<Either<String, ProfileDataEntity>> uploadAvatar(File file) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, ProfileDataEntity>> getProfileData() {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, ProfileDataEntity>> editProfile(
    EditProfileRequestModel request,
  ) {
    throw UnimplementedError();
  }
}

void main() {
  late MockProfileRepository mockRepository;
  late ChangePasswordUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = ChangePasswordUseCase(repository: mockRepository);
  });

  const tRequest = ChangePasswordRequestModel(
    currentPassword: 'old123456',
    newPassword: 'new123456',
    newPasswordConfirmation: 'new123456',
  );

  test(
    'should return success message when password change is successful',
    () async {
      mockRepository.changePasswordResult = const Right(
        'تم تغيير كلمة المرور بنجاح',
      );

      final result = await useCase(tRequest);

      expect(result, const Right('تم تغيير كلمة المرور بنجاح'));
    },
  );

  test('should return error string when password change fails', () async {
    mockRepository.changePasswordResult = const Left(
      'كلمة المرور الحالية غير صحيحة',
    );

    final result = await useCase(tRequest);

    expect(result, const Left('كلمة المرور الحالية غير صحيحة'));
  });
}
