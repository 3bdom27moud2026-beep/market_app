// ignore_for_file: prefer_initializing_formals
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/data/models/profile_model.dart';

/// Remote data source for profile operations.
abstract class ProfileRemoteDataSource {
  /// Fetches profile data from the API.
  Future<ProfileDataModel> getProfileData();

  /// Edits user profile data via POST /v1/profile/edit.
  Future<ProfileDataModel> editProfile(EditProfileRequestModel request);

  /// Changes user password via POST /v1/profile/change-password.
  Future<String> changePassword(ChangePasswordRequestModel request);

  /// Uploads user avatar via POST /v1/profile/avatar with FormData.
  Future<ProfileDataModel> uploadAvatar(File file);
}

/// Implementation of [ProfileRemoteDataSource] using Dio.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<ProfileDataModel> getProfileData() async {
    try {
      final response = await _apiClient.get('/v1/profile');
      final data = response.data as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] response: $data');
      }
      var profileData = ProfileDataModel.fromJson(data);

      try {
        final results = await Future.wait([
          _apiClient
              .get('/v1/favorites')
              .catchError(
                (_) => Response(requestOptions: RequestOptions(path: '')),
              ),
          _apiClient
              .get(EndPoints.orders)
              .catchError(
                (_) => Response(requestOptions: RequestOptions(path: '')),
              ),
        ]);

        int? liveFavCount;
        final favData = results[0].data;
        if (favData is Map<String, dynamic>) {
          if (favData['products'] is List) {
            liveFavCount = (favData['products'] as List).length;
          } else if (favData['favorites'] is List) {
            liveFavCount = (favData['favorites'] as List).length;
          } else if (favData['data'] is List) {
            liveFavCount = (favData['data'] as List).length;
          }
        } else if (favData is List) {
          liveFavCount = favData.length;
        }

        int? liveOrdersCount;
        final ordersData = results[1].data;
        if (ordersData is Map<String, dynamic>) {
          if (ordersData['orders'] is List) {
            liveOrdersCount = (ordersData['orders'] as List).length;
          } else if (ordersData['data'] is List) {
            liveOrdersCount = (ordersData['data'] as List).length;
          }
        } else if (ordersData is List) {
          liveOrdersCount = ordersData.length;
        }

        final effectiveFav = liveFavCount != null
            ? (liveFavCount > 0 || profileData.statistics.favoritesCount == 0
                  ? liveFavCount
                  : profileData.statistics.favoritesCount)
            : profileData.statistics.favoritesCount;

        final effectiveOrders = liveOrdersCount != null
            ? (liveOrdersCount > 0 || profileData.statistics.ordersCount == 0
                  ? liveOrdersCount
                  : profileData.statistics.ordersCount)
            : profileData.statistics.ordersCount;

        profileData = profileData.copyWith(
          statistics: profileData.statistics.copyWith(
            favoritesCount: effectiveFav,
            ordersCount: effectiveOrders,
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            '[ProfileRemoteDataSource] Live count sync error (non-fatal): $e',
          );
        }
      }

      return profileData;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] ERROR: $e\n$stack');
      }
      rethrow;
    }
  }

  @override
  Future<ProfileDataModel> editProfile(EditProfileRequestModel request) async {
    try {
      final response = await _apiClient.post(
        EndPoints.editProfile,
        data: request.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] edit response: $data');
      }
      return ProfileDataModel.fromJson(data);
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] EDIT ERROR: $e\n$stack');
      }
      rethrow;
    }
  }

  @override
  Future<String> changePassword(ChangePasswordRequestModel request) async {
    try {
      final response = await _apiClient.post(
        EndPoints.changePassword,
        data: request.toJson(),
      );
      final data = response.data;
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] change password response: $data');
      }
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 'تم تغيير كلمة المرور بنجاح';
      }
      return 'تم تغيير كلمة المرور بنجاح';
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] CHANGE PASSWORD DIO ERROR: $e');
      }
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData['message'] != null) {
          throw Exception(responseData['message'].toString());
        }
        if (responseData['errors'] is Map<String, dynamic>) {
          final errorsMap = responseData['errors'] as Map<String, dynamic>;
          if (errorsMap.isNotEmpty) {
            final firstVal = errorsMap.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              throw Exception(firstVal[0].toString());
            } else if (firstVal is String) {
              throw Exception(firstVal);
            }
          }
        }
        if (responseData['error'] != null) {
          throw Exception(responseData['error'].toString());
        }
      }
      throw Exception('فشل في تغيير كلمة المرور');
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint(
          '[ProfileRemoteDataSource] CHANGE PASSWORD ERROR: $e\n$stack',
        );
      }
      rethrow;
    }
  }

  @override
  Future<ProfileDataModel> uploadAvatar(File file) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.post(
        EndPoints.uploadAvatar,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] upload avatar response: $data');
      }

      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      return ProfileDataModel.fromJson(payload);
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ProfileRemoteDataSource] UPLOAD AVATAR ERROR: $e\n$stack');
      }
      rethrow;
    }
  }
}
