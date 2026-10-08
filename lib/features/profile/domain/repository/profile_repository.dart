import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import '../entities/profile_entity.dart';

/// Repository interface for profile data operations.
abstract class ProfileRepository {
  /// Fetches the user's profile data including profile info, statistics, and savings.
  Future<Either<String, ProfileDataEntity>> getProfileData();

  /// Edits user profile info.
  Future<Either<String, ProfileDataEntity>> editProfile(
    EditProfileRequestModel request,
  );

  /// Changes the user password.
  Future<Either<String, String>> changePassword(
    ChangePasswordRequestModel request,
  );

  /// Uploads user avatar.
  Future<Either<String, ProfileDataEntity>> uploadAvatar(File file);
}
