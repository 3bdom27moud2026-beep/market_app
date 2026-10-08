import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../models/change_password_request_model.dart';
import '../models/edit_profile_request_model.dart';
import '../datasource/remote/profile_remote_datasource.dart';

import '../datasource/local/profile_local_datasource.dart';

/// Implementation of [ProfileRepository].
///
/// Tries to fetch from remote first. On failure, falls back to local cache.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, ProfileDataEntity>> getProfileData() async {
    try {
      final model = await remoteDataSource.getProfileData();
      // Cache the result
      await localDataSource.cacheProfileData(model);
      return Right(model.toEntity());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[ProfileRepository] Remote failed: $e — trying local cache',
        );
      }
      // Try local cache
      final cached = localDataSource.getCachedProfileData();
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<String, ProfileDataEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    try {
      final model = await remoteDataSource.editProfile(request);
      await localDataSource.cacheProfileData(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<String, String>> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    try {
      final message = await remoteDataSource.changePassword(request);
      return Right(message);
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<String, ProfileDataEntity>> uploadAvatar(File file) async {
    try {
      final model = await remoteDataSource.uploadAvatar(file);
      await localDataSource.cacheProfileData(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  String _mapError(dynamic error) {
    return AppErrorHandler.getMessage(
      error,
      defaultMessage: 'حدث خطأ في الملف الشخصي. يرجى المحاولة لاحقاً.',
    );
  }
}
