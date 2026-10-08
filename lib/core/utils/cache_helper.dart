import 'package:shared_preferences/shared_preferences.dart';

/// Cache keys for the application.
abstract final class CacheKeys {
  static const String isLoggedIn = 'is_logged_in';
  static const String authToken = 'auth_token';
  static const String userData = 'user_data';
  static const String selectedGovernorateId = 'selected_governorate_id';
  static const String selectedCenterId = 'selected_center_id';
  static const String selectedAreaId = 'selected_area_id';
  static const String selectedLocationName = 'selected_location_name';
  static const String selectedCategoryId = 'selected_category_id';
  static const String appThemeMode = 'app_theme_mode';
  static const String fcmToken = 'fcm_token';
  static const String reviewedEndpoints = 'reviewed_endpoints';
}

/// Helper class for managing local storage using SharedPreferences.
abstract final class CacheHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// The underlying SharedPreferences instance.
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError(
        'CacheHelper not initialized. Call CacheHelper.init() first.',
      );
    }
    return _prefs!;
  }

  /// Check if user is logged in.
  static bool get isLoggedIn {
    final token = authToken;
    if (token != null && token.isNotEmpty) return true;
    return _prefs?.getBool(CacheKeys.isLoggedIn) ?? false;
  }

  /// Set user login status.
  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(CacheKeys.isLoggedIn, value);
  }

  /// Get authentication token.
  static String? get authToken {
    return _prefs?.getString(CacheKeys.authToken);
  }

  /// Save authentication token.
  /// Always marks the user as logged-in; only persists the token string when
  /// it is non-empty (some registration endpoints do not return a token).
  static Future<void> saveAuthToken(String token) async {
    if (token.isNotEmpty) {
      await _prefs?.setString(CacheKeys.authToken, token);
    }
    await setLoggedIn(true);
  }

  /// Get cached user data JSON.
  static String? get userData {
    return _prefs?.getString(CacheKeys.userData);
  }

  /// Save cached user data JSON.
  static Future<void> saveUserData(String jsonString) async {
    await _prefs?.setString(CacheKeys.userData, jsonString);
  }

  /// Get selected governorate ID.
  static int? get selectedGovernorateId {
    return _prefs?.getInt(CacheKeys.selectedGovernorateId);
  }

  /// Set selected governorate ID.
  static Future<void> setSelectedGovernorateId(int? value) async {
    await _prefs?.setInt(CacheKeys.selectedGovernorateId, value ?? -1);
  }

  /// Get selected center ID.
  static int? get selectedCenterId {
    return _prefs?.getInt(CacheKeys.selectedCenterId);
  }

  /// Set selected center ID.
  static Future<void> setSelectedCenterId(int? value) async {
    await _prefs?.setInt(CacheKeys.selectedCenterId, value ?? -1);
  }

  /// Get selected area ID.
  static int? get selectedAreaId {
    return _prefs?.getInt(CacheKeys.selectedAreaId);
  }

  /// Set selected area ID.
  static Future<void> setSelectedAreaId(int? value) async {
    await _prefs?.setInt(CacheKeys.selectedAreaId, value ?? -1);
  }

  /// Get selected location display name.
  static String? get selectedLocationName {
    return _prefs?.getString(CacheKeys.selectedLocationName);
  }

  /// Set selected location display name.
  static Future<void> setSelectedLocationName(String? value) async {
    if (value == null) {
      await _prefs?.remove(CacheKeys.selectedLocationName);
    } else {
      await _prefs?.setString(CacheKeys.selectedLocationName, value);
    }
  }

  /// Get selected category ID.
  static String? get selectedCategoryId {
    return _prefs?.getString(CacheKeys.selectedCategoryId);
  }

  /// Set selected category ID.
  static Future<void> setSelectedCategoryId(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs?.remove(CacheKeys.selectedCategoryId);
    } else {
      await _prefs?.setString(CacheKeys.selectedCategoryId, value);
    }
  }

  /// Get app theme mode ('light', 'dark', or 'system').
  static String? get themeMode {
    return _prefs?.getString(CacheKeys.appThemeMode);
  }

  /// Set app theme mode.
  static Future<void> setThemeMode(String value) async {
    await _prefs?.setString(CacheKeys.appThemeMode, value);
  }

  /// Get cached FCM device token.
  static String? get fcmToken {
    return _prefs?.getString(CacheKeys.fcmToken);
  }

  /// Save cached FCM device token.
  static Future<void> saveFcmToken(String token) async {
    if (token.isNotEmpty) {
      await _prefs?.setString(CacheKeys.fcmToken, token);
    }
  }

  /// Get list of reviewed endpoint keys.
  static List<String> get reviewedEndpoints {
    return _prefs?.getStringList(CacheKeys.reviewedEndpoints) ?? [];
  }

  /// Check if an endpoint has already been reviewed.
  static bool hasReviewedEndpoint(String endpoint) {
    final norm = _normalizeEndpoint(endpoint);
    return reviewedEndpoints.contains(norm);
  }

  /// Mark an endpoint as reviewed.
  static Future<void> markEndpointAsReviewed(String endpoint) async {
    final norm = _normalizeEndpoint(endpoint);
    final list = List<String>.from(reviewedEndpoints);
    if (!list.contains(norm)) {
      list.add(norm);
      await _prefs?.setStringList(CacheKeys.reviewedEndpoints, list);
    }
  }

  static String _normalizeEndpoint(String endpoint) {
    return endpoint.trim().toLowerCase().replaceAll(RegExp(r'/+$'), '');
  }

  /// Get list of product IDs currently in cart.
  static List<String> get cachedCartProductIds {
    return _prefs?.getStringList('cart_product_ids') ?? [];
  }

  /// Check if a product ID is in the cached cart.
  static bool isProductInCart(dynamic productId) {
    if (productId == null) return false;
    final idStr = productId.toString();
    return cachedCartProductIds.contains(idStr);
  }

  /// Add a product ID to the cached cart.
  static Future<void> addCartProductId(dynamic productId) async {
    if (productId == null) return;
    final idStr = productId.toString();
    final list = List<String>.from(cachedCartProductIds);
    if (!list.contains(idStr)) {
      list.add(idStr);
      await _prefs?.setStringList('cart_product_ids', list);
    }
  }

  /// Remove a product ID from the cached cart.
  static Future<void> removeCartProductId(dynamic productId) async {
    if (productId == null) return;
    final idStr = productId.toString();
    final list = List<String>.from(cachedCartProductIds);
    if (list.remove(idStr)) {
      await _prefs?.setStringList('cart_product_ids', list);
    }
  }

  /// Set the authoritative list of product IDs currently in the cart.
  static Future<void> setCartProductIds(List<dynamic> productIds) async {
    final list = productIds.map((e) => e.toString()).toSet().toList();
    await _prefs?.setStringList('cart_product_ids', list);
  }

  /// Clear all cached data (for logout).
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
