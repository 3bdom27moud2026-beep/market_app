import 'dart:convert';
import 'package:market/core/utils/cache_helper.dart';
import '../../models/profile_model.dart';

/// Local data source for profile operations (caching).
abstract class ProfileLocalDataSource {
  /// Caches profile data.
  Future<void> cacheProfileData(ProfileDataModel data);

  /// Retrieves cached profile data.
  ProfileDataModel? getCachedProfileData();

  /// Clears cached profile data.
  Future<void> clearCache();
}

/// Implementation of [ProfileLocalDataSource] using SharedPreferences.
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _cachedProfileKey = 'cached_profile_data';

  @override
  Future<void> cacheProfileData(ProfileDataModel data) async {
    try {
      final jsonStr = jsonEncode(data.toJson());
      await CacheHelper.prefs.setString(_cachedProfileKey, jsonStr);
    } catch (_) {
      // Ignore cache write failure
    }
  }

  @override
  ProfileDataModel? getCachedProfileData() {
    try {
      final jsonStr = CacheHelper.prefs.getString(_cachedProfileKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ProfileDataModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await CacheHelper.prefs.remove(_cachedProfileKey);
    } catch (_) {
      // Ignore cache clear failure
    }
  }
}
