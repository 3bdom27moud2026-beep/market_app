import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(UserModel userModel);
  String? getAuthToken();
  UserModel? getCachedUser();
  bool isLoggedIn();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveAuthData(UserModel userModel) async {
    await CacheHelper.saveAuthToken(userModel.token);
    await CacheHelper.saveUserData(userModel.toJsonString());
  }

  @override
  String? getAuthToken() {
    return CacheHelper.authToken;
  }

  @override
  UserModel? getCachedUser() {
    final jsonStr = CacheHelper.userData;
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return UserModel.fromJsonString(jsonStr);
    } catch (_) {
      return null;
    }
  }

  @override
  bool isLoggedIn() {
    return CacheHelper.isLoggedIn;
  }

  @override
  Future<void> clearAuthData() async {
    await CacheHelper.clear();
  }
}
