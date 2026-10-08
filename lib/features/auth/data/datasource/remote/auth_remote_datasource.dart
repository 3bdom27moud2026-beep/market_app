import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register(RegisterRequestModel request);
  Future<UserModel> login(LoginRequestModel request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiClient.post(
        EndPoints.register,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        final payload = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;

        return UserModel.fromJson(payload);
      } else {
        throw Exception('فشل إنشاء الحساب: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.post(
        EndPoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        final payload = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;

        return UserModel.fromJson(payload);
      } else {
        throw Exception('فشل تسجيل الدخول: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(EndPoints.logout);
    } catch (e) {
      rethrow;
    }
  }
}
