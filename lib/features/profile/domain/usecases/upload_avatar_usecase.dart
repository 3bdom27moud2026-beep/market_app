// ignore_for_file: prefer_initializing_formals
import 'dart:io';

import 'package:dartz/dartz.dart';
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

/// Use case for uploading user avatar.
class UploadAvatarUseCase {
  final ProfileRepository _repository;

  UploadAvatarUseCase({required ProfileRepository repository})
    : _repository = repository;

  /// Executes the avatar upload request.
  Future<Either<String, ProfileDataEntity>> call(File file) async {
    return await _repository.uploadAvatar(file);
  }
}
