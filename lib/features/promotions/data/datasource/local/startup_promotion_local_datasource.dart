// ignore_for_file: prefer_initializing_formals
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for startup promotion cache.
class StartupPromotionLocalDataSource {
  final SharedPreferences _prefs;

  const StartupPromotionLocalDataSource({required SharedPreferences prefs})
    : _prefs = prefs;

  static const String _promotionShownKey = 'startup_promotion_shown';

  /// Checks if the promotion has been shown in this session.
  bool isPromotionShown() {
    return _prefs.getBool(_promotionShownKey) ?? false;
  }

  /// Marks the promotion as shown for this session.
  Future<void> setPromotionShown() async {
    await _prefs.setBool(_promotionShownKey, true);
  }

  /// Clears the promotion shown flag (for testing or reset).
  Future<void> clearPromotionShown() async {
    await _prefs.remove(_promotionShownKey);
  }
}
