import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/data/datasource/local/profile_local_datasource.dart';
import 'package:market/features/profile/data/datasource/remote/profile_remote_datasource.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/profile_model.dart';
import 'package:market/features/profile/data/repository/profile_repository_impl.dart';

class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  ProfileDataModel? uploadAvatarResult;
  ProfileDataModel? getProfileResult;
  Object? uploadAvatarError;

  @override
  Future<ProfileDataModel> uploadAvatar(File file) async {
    if (uploadAvatarError != null) throw uploadAvatarError!;
    return uploadAvatarResult!;
  }

  @override
  Future<ProfileDataModel> getProfileData() async {
    return getProfileResult!;
  }

  @override
  Future<ProfileDataModel> editProfile(EditProfileRequestModel request) async {
    return uploadAvatarResult!;
  }

  @override
  Future<String> changePassword(ChangePasswordRequestModel request) async {
    return 'Success';
  }
}

class MockProfileLocalDataSource implements ProfileLocalDataSource {
  ProfileDataModel? cachedData;

  @override
  Future<void> cacheProfileData(ProfileDataModel data) async {
    cachedData = data;
  }

  @override
  ProfileDataModel? getCachedProfileData() {
    return cachedData;
  }

  @override
  Future<void> clearCache() async {
    cachedData = null;
  }
}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemote;
  late MockProfileLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockProfileRemoteDataSource();
    mockLocal = MockProfileLocalDataSource();
    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('ProfileRepositoryImpl Avatar Upload & Caching', () {
    test(
      'uploadAvatar delegates to remote and updates local cache with new avatar',
      () async {
        const returnedModel = ProfileDataModel(
          profile: ProfileModel(
            id: 1,
            fullName: 'Updated Name',
            email: 'test@example.com',
            avatarUrl:
                'https://shopguide.medguide.software/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
          ),
          statistics: StatisticsModel(
            ordersCount: 1,
            favoritesCount: 1,
            subscriptionDaysRemaining: 5,
          ),
          savings: SavingsModel(totalSavings: 50.0),
        );
        mockRemote.uploadAvatarResult = returnedModel;

        final dummyFile = File('test_path.jpg');
        final result = await repository.uploadAvatar(dummyFile);

        expect(result, isA<Right>());
        result.fold((_) => fail('Should succeed'), (entity) {
          expect(
            entity.profile.avatarUrl,
            'https://shopguide.medguide.software/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
          );
        });
        expect(mockLocal.cachedData, equals(returnedModel));
      },
    );
  });
}
