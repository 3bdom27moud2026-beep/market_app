/// Centralized route path constants.
/// Do NOT hardcode route paths in widgets; use this class instead.
abstract final class AppRoutes {
  /// Splash screen route.
  static const String splash = '/';

  /// Home screen route.
  static const String home = '/home';

  /// Login screen route.
  static const String login = '/login';

  /// Product details screen route (with parameter).
  static const String productDetails = '/product-details/:productId';

  /// Categories screen route.
  static const String categories = '/categories';

  /// Discount Card screen route.
  static const String discountCard = '/discount-card';

  /// Profile screen route.
  static const String profile = '/profile';

  /// Cart / Basket screen route.
  static const String basket = '/basket';

  /// Checkout screen route.
  static const String checkout = '/checkout';

  /// Payment screen route.
  static const String payment = '/payment';

  /// Order Success screen route.
  static const String orderSuccess = '/order-success';

  /// Favorites screen route.
  static const String favorites = '/favorites';

  /// Card Details screen route.
  static const String cardDetails = '/card-details';

  /// Merchant Details screen route (with parameter).
  static const String merchantDetails = '/merchant-details/:merchantId';

  /// Category Products screen route (with categoryId and categoryName parameters).
  static const String categoryProducts = '/category-products/:categoryId';

  /// Search screen route.
  static const String search = '/search';

  /// Edit Profile screen route.
  static const String editProfile = '/edit-profile';

  /// Change Password screen route.
  static const String changePassword = '/change-password';

  /// Orders History & Tracking screen route.
  static const String orders = '/orders';

  /// Order Details screen route.
  static const String orderDetails = '/order-details';

  /// Flash Sale screen route.
  static const String flashSale = '/flash-sale';

  /// All Merchants / Partners screen route.
  static const String merchants = '/merchants';

  /// All Products catalog screen route.
  static const String allProducts = '/all-products';

  /// Notifications screen route.
  static const String notifications = '/notifications';

  /// Named routes for GoRouter.
  static const String splashNamed = 'splash';
  static const String homeNamed = 'home';
  static const String loginNamed = 'login';
  static const String productDetailsNamed = 'product-details';
  static const String categoriesNamed = 'categories';
  static const String discountCardNamed = 'discount-card';
  static const String profileNamed = 'profile';
  static const String favoritesNamed = 'favorites';
  static const String cardDetailsNamed = 'card-details';
  static const String basketNamed = 'basket';
  static const String checkoutNamed = 'checkout';
  static const String paymentNamed = 'payment';
  static const String orderSuccessNamed = 'order-success';
  static const String merchantDetailsNamed = 'merchant-details';
  static const String categoryProductsNamed = 'category-products';
  static const String searchNamed = 'search';
  static const String editProfileNamed = 'edit-profile';
  static const String changePasswordNamed = 'change-password';
  static const String ordersNamed = 'orders';
  static const String orderDetailsNamed = 'order-details';
  static const String flashSaleNamed = 'flash-sale';
  static const String merchantsNamed = 'merchants';
  static const String allProductsNamed = 'all-products';
  static const String notificationsNamed = 'notifications';
}
