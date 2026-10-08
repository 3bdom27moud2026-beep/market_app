class EndPoints {
  static const String baseUrl = 'https://shopguide.medguide.software/api';
  static const String register = '/v1/auth/register';
  static const String login = '/v1/auth/login';
  static const String logout = '/v1/auth/logout';
  static const String home = '/v1/home';
  static const String location = '/v1/locations';
  static const String categories = '/v1/categories';
  static const String merchants = '/v1/merchants';
  static const String products = '/v1/products';
  static const String bestSellingProducts = '/v1/products?sort_by=best_selling';
  static const String userCart = '/v1/cart';
  static const String cartClear = '/v1/cart-clear';
  static const String orders = '/v1/orders';
  static const String cardSubscribe = '/v1/card/subscribe';
  static const String search = '/v1/search';
  static const String editProfile = '/v1/profile/edit';
  static const String changePassword = '/v1/profile/change-password';
  static const String uploadAvatar = '/v1/profile/avatar';
  static const String flashSaleProducts = '/v1/products?is_flash_sale=true';
  static const String cardStatus = '/v1/card/status';
  static const String requestCard = '/v1/card/request';
  static const String fcmToken = '/v1/notifications/fcm-token';
  static const String notifications = '/v1/notifications';
  static const String notificationsReadAll = '/v1/notifications/read-all';
  static const String favorites = '/v1/favorites';
  static const String favoritesToggle = '/v1/favorites/toggle';
  static const String calculateShipping = '/v1/cart/calculate-shipping';
  static String notificationRead(dynamic id) => '/v1/notifications/$id/read';
  static String notificationDelete(dynamic id) => '/v1/notifications/$id';
  static String productReviews(dynamic id) => '/v1/products/$id/reviews';
  static String merchantReviews(dynamic id) => '/v1/merchants/$id/reviews';
  static String merchantTrackContact(dynamic id) =>
      '/v1/merchants/$id/track-contact';
}
