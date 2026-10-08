import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'package:market/features/profile/domain/usecases/upload_avatar_usecase.dart';

class MockProfileRepositoryForAvatar implements ProfileRepository {
  Either<String, ProfileDataEntity>? uploadAvatarResult;

  @override
  Future<Either<String, ProfileDataEntity>> uploadAvatar(File file) async {
    return uploadAvatarResult!;
  }

  @override
  Future<Either<String, String>> changePassword(
    ChangePasswordRequestModel request,
  ) {
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
  late MockProfileRepositoryForAvatar mockRepository;
  late UploadAvatarUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepositoryForAvatar();
    useCase = UploadAvatarUseCase(repository: mockRepository);
  });

  const tProfile = ProfileDataEntity(
    profile: ProfileEntity(
      id: 1,
      fullName: 'User',
      email: 'user@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
    ),
    statistics: StatisticsEntity(
      ordersCount: 0,
      favoritesCount: 0,
      subscriptionDaysRemaining: 0,
    ),
    savings: SavingsEntity(totalSavings: 0.0, currency: 'ج.م'),
  );

  test('should return ProfileDataEntity when avatar upload succeeds', () async {
    mockRepository.uploadAvatarResult = const Right(tProfile);

    final result = await useCase(File('dummy/path/avatar.jpg'));

    expect(result, const Right(tProfile));
  });

  test('should return error string when avatar upload fails', () async {
    mockRepository.uploadAvatarResult = const Left('فشل في رفع الصورة الشخصية');

    final result = await useCase(File('dummy/path/avatar.jpg'));

    expect(result, const Left('فشل في رفع الصورة الشخصية'));
  });
}
