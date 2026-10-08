// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/home_data_model.dart';

/// Local data source for the home screen.
///
/// Caches the home data in SharedPreferences for offline access.
class HomeLocalDataSource {
  static const String _cacheKey = 'home_data_cache';

  final SharedPreferences _prefs;

  HomeLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  /// Saves home data to local cache.
  Future<void> cacheHomeData(HomeDataModel data) async {
    final jsonString = jsonEncode(data.toJson());
    await _prefs.setString(_cacheKey, jsonString);
  }

  /// Loads cached home data. Returns null if no cache exists.
  HomeDataModel? getCachedHomeData() {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return HomeDataModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Clears the cache.
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
