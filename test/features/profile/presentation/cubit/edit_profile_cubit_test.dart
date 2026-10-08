import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'package:market/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/edit_profile_state.dart';

class MockProfileRepositoryForEdit implements ProfileRepository {
  Either<String, ProfileDataEntity>? editProfileResult;
  Either<String, ProfileDataEntity>? uploadAvatarResult;

  @override
  Future<Either<String, ProfileDataEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    return editProfileResult!;
  }

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
}

void main() {
  late MockProfileRepositoryForEdit mockRepo;
  late EditProfileCubit cubit;

  const tProfile = ProfileDataEntity(
    profile: ProfileEntity(
      id: 1,
      fullName: 'Updated Name',
      email: 'updated@example.com',
      phoneNumber: '01012345678',
      avatarUrl: 'https://example.com/new_avatar.jpg',
    ),
    statistics: StatisticsEntity(
      ordersCount: 5,
      favoritesCount: 3,
      subscriptionDaysRemaining: 20,
    ),
    savings: SavingsEntity(totalSavings: 150.0, currency: 'ج.م'),
  );

  setUp(() {
    mockRepo = MockProfileRepositoryForEdit();
    cubit = EditProfileCubit(repository: mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is EditProfileState()', () {
    expect(cubit.state, const EditProfileState());
  });

  test(
    'uploadAvatar emits isUploadingAvatar true then updatedProfile on success',
    () async {
      mockRepo.uploadAvatarResult = const Right(tProfile);

      expectLater(
        cubit.stream,
        emitsInOrder([
          const EditProfileState(isUploadingAvatar: true),
          const EditProfileState(
            isUploadingAvatar: false,
            updatedProfile: tProfile,
            avatarSuccessMessage: 'تم تحديث الصورة الشخصية بنجاح',
          ),
        ]),
      );

      final result = await cubit.uploadAvatar(File('avatar.png'));
      expect(result, true);
    },
  );

  test(
    'uploadAvatar emits isUploadingAvatar true then avatarErrorMessage on failure',
    () async {
      mockRepo.uploadAvatarResult = const Left('فشل في رفع الصورة');

      expectLater(
        cubit.stream,
        emitsInOrder([
          const EditProfileState(isUploadingAvatar: true),
          const EditProfileState(
            isUploadingAvatar: false,
            avatarErrorMessage: 'فشل في رفع الصورة',
          ),
        ]),
      );

      final result = await cubit.uploadAvatar(File('avatar.png'));
      expect(result, false);
    },
  );

  test('submitEditProfile emits submitting then success on success', () async {
    mockRepo.editProfileResult = const Right(tProfile);

    expectLater(
      cubit.stream,
      emitsInOrder([
        const EditProfileState(status: EditProfileStatus.submitting),
        const EditProfileState(
          status: EditProfileStatus.success,
          updatedProfile: tProfile,
        ),
      ]),
    );

    final result = await cubit.submitEditProfile(
      name: 'Updated Name',
      email: 'updated@example.com',
      phone: '01012345678',
      areaId: 1,
    );
    expect(result, true);
  });
}
