import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/widgets/main_shell.dart';
import 'package:market/features/login/presentation/pages/login_page.dart';
import 'package:market/features/home/dependency_injection.dart';
import 'package:market/features/home/presentation/screens/home_screen.dart';
import 'package:market/features/home/presentation/cubit/home_cubit.dart';
import 'package:market/features/products/dependency_injection.dart';
import 'package:market/features/profile/dependency_injection.dart';
import 'package:market/features/profile/presentation/pages/profile_screen.dart';
import 'package:market/features/profile/presentation/pages/card_details_screen.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/products/presentation/screens/product_details_screen.dart';
import 'package:market/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:market/features/categories/dependency_injection.dart';
import 'package:market/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:market/features/categories/presentation/screens/categories_screen.dart';
import 'package:market/features/discount_card/dependency_injection.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/pages/discount_card_screen.dart';
import 'package:market/features/cart/dependency_injection.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/pages/basket_screen.dart';
import 'package:market/features/cart/presentation/pages/checkout_screen.dart';
import 'package:market/features/cart/presentation/pages/payment_screen.dart';
import 'package:market/features/cart/presentation/pages/order_success_screen.dart';
import 'package:market/features/cart/domain/entities/order_entity.dart';
import 'package:market/features/favorites/dependency_injection.dart';
import 'package:market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:market/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:market/features/promotions/dependency_injection.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';
import 'package:market/features/orders/orders_di.dart';
import 'package:market/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:market/features/orders/presentation/pages/orders_screen.dart';
import 'package:market/features/orders/presentation/pages/order_details_screen.dart';
import 'package:market/features/splash/presentation/screens/splash_screen.dart';
import 'package:market/features/merchants/dependency_injection.dart';
import 'package:market/features/merchants/presentation/cubit/merchant_details_cubit.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_cubit.dart';
import 'package:market/features/merchants/presentation/screens/merchant_details_screen.dart';
import 'package:market/features/merchants/presentation/screens/merchants_screen.dart';
import 'package:market/features/products/presentation/cubit/all_products_cubit.dart';
import 'package:market/features/products/presentation/cubit/all_products_state.dart';
import 'package:market/features/products/presentation/cubit/category_products_cubit.dart';
import 'app_routes.dart';
import 'package:market/features/products/presentation/screens/all_products_screen.dart';
import 'package:market/features/products/presentation/screens/category_products_screen.dart';
import 'package:market/features/search/dependency_injection.dart';
import 'package:market/features/search/presentation/cubit/search_cubit.dart';
import 'package:market/features/search/presentation/pages/search_screen.dart';
import 'package:market/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:market/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:market/features/profile/presentation/pages/change_password_screen.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/flash_sale/dependency_injection.dart';
import 'package:market/features/flash_sale/presentation/cubit/flash_sale_cubit.dart';
import 'package:market/features/flash_sale/presentation/screens/flash_sale_screen.dart';
import 'package:market/features/notifications/presentation/pages/notifications_screen.dart';

/// GoRouter configuration for the application.

///
/// All navigation must go through GoRouter.
/// Do NOT use Navigator.push(), Navigator.pushReplacement(), or Navigator.of(context).
abstract final class AppRouter {
  /// The root navigator key for GoRouter.
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final GlobalKey<NavigatorState> shellNavigatorCategories =
      GlobalKey<NavigatorState>(debugLabel: 'shellCategories');
  static final GlobalKey<NavigatorState> shellNavigatorFavorites =
      GlobalKey<NavigatorState>(debugLabel: 'shellFavorites');
  static final GlobalKey<NavigatorState> shellNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
  static final GlobalKey<NavigatorState> shellNavigatorBasket =
      GlobalKey<NavigatorState>(debugLabel: 'shellBasket');

  static GoRouter? _instance;

  /// Clears the cached router instance so it can be recreated.
  static void resetRouter() {
    _instance = null;
  }

  /// GoRouter instance.
  static GoRouter get router {
    _instance ??= createRouter();
    return _instance!;
  }

  /// Factory method to create a new GoRouter instance.
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      routes: [
        // Splash (no bottom nav)
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splashNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const SplashScreen(),
        ),

        // Login (no bottom nav)
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const LoginPage(),
        ),

        // Notifications (no bottom nav)
        GoRoute(
          path: AppRoutes.notifications,
          name: AppRoutes.notificationsNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const NotificationsScreen(),
        ),

        // Product Details (no bottom nav)
        GoRoute(
          path: AppRoutes.productDetails,
          name: AppRoutes.productDetailsNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final productId = state.pathParameters['productId'] ?? '';
            return BlocProvider<ProductDetailsCubit>(
              create: (_) => ProductsDI.createProductDetailsCubit(),
              child: ProductDetailsScreen(productId: productId),
            );
          },
        ),

        // Orders History Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.orders,
          name: AppRoutes.ordersNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const OrdersScreen(),
        ),

        // Checkout Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.checkout,
          name: AppRoutes.checkoutNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final cartCubit = state.extra as CartCubit?;
            return cartCubit != null
                ? BlocProvider<CartCubit>.value(
                    value: cartCubit,
                    child: const CheckoutScreen(),
                  )
                : BlocProvider<CartCubit>(
                    create: (_) => CartDI.createCartCubit()..loadCart(),
                    child: const CheckoutScreen(),
                  );
          },
        ),

        // Payment Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.payment,
          name: AppRoutes.paymentNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final cartCubit = state.extra as CartCubit?;
            return cartCubit != null
                ? BlocProvider<CartCubit>.value(
                    value: cartCubit,
                    child: const PaymentScreen(),
                  )
                : BlocProvider<CartCubit>(
                    create: (_) => CartDI.createCartCubit()..loadCart(),
                    child: const PaymentScreen(),
                  );
          },
        ),

        // Order Success (no bottom nav)
        GoRoute(
          path: AppRoutes.orderSuccess,
          name: AppRoutes.orderSuccessNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final order = state.extra as OrderEntity?;
            return OrderSuccessScreen(order: order);
          },
        ),

        // Discount Card Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.discountCard,
          name: AppRoutes.discountCardNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => BlocProvider<DiscountCardCubit>(
            create: (_) => DiscountCardDI.createDiscountCardCubit(),
            child: const DiscountCardScreen(),
          ),
        ),

        // Card Details Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.cardDetails,
          name: AppRoutes.cardDetailsNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final card = state.extra as UserCardEntity?;
            return CardDetailsScreen(card: card);
          },
        ),

        // Order Details Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.orderDetails,
          name: AppRoutes.orderDetailsNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final order = state.extra as OrderEntity;
            return BlocProvider<OrdersCubit>(
              create: (_) => OrdersDI.initCubit(),
              child: OrderDetailsScreen(order: order),
            );
          },
        ),

        // Merchant Details Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.merchantDetails,
          name: AppRoutes.merchantDetailsNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final merchantId = state.pathParameters['merchantId'] ?? '';
            return BlocProvider<MerchantDetailsCubit>(
              create: (_) => MerchantsDI.createMerchantDetailsCubit(),
              child: MerchantDetailsScreen(merchantId: merchantId),
            );
          },
        ),

        // Category Products Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.categoryProducts,
          name: AppRoutes.categoryProductsNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? '';
            final categoryName =
                state.uri.queryParameters['name'] ?? 'منتجات الفئة';
            return BlocProvider<CategoryProductsCubit>(
              create: (_) => CategoryProductsCubit(
                repository: ProductsDI.createProductsRepository(),
              ),
              child: CategoryProductsScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              ),
            );
          },
        ),

        // Search Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.search,
          name: AppRoutes.searchNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final query = state.uri.queryParameters['q'] ?? '';
            return BlocProvider<SearchCubit>(
              create: (_) => SearchDI.createSearchCubit(),
              child: SearchScreen(initialQuery: query),
            );
          },
        ),

        // Edit Profile Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.editProfile,
          name: AppRoutes.editProfileNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) {
            final profile = state.extra as ProfileEntity?;
            return BlocProvider<EditProfileCubit>(
              create: (_) => EditProfileCubit(
                repository: ProfileDI.createProfileRepository(),
              ),
              child: EditProfileScreen(currentProfile: profile),
            );
          },
        ),

        // Change Password Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.changePassword,
          name: AppRoutes.changePasswordNamed,
          parentNavigatorKey: rootNavigatorKey,

          builder: (context, state) => BlocProvider<ChangePasswordCubit>(
            create: (_) => ProfileDI.createChangePasswordCubit(),
            child: const ChangePasswordScreen(),
          ),
        ),

        // Flash Sale Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.flashSale,
          name: AppRoutes.flashSaleNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => BlocProvider<FlashSaleCubit>(
            create: (_) => FlashSaleDI.createFlashSaleCubit(
              apiClient: CoreDI.sl<ApiClient>(),
            ),
            child: const FlashSaleScreen(),
          ),
        ),

        // All Merchants / Partners Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.merchants,
          name: AppRoutes.merchantsNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final categoryId =
                state.uri.queryParameters['categoryId'] ??
                state.uri.queryParameters['category'];
            final categoryName =
                state.uri.queryParameters['name'] ??
                state.uri.queryParameters['categoryName'];
            return BlocProvider<MerchantsCubit>(
              create: (_) => MerchantsDI.createMerchantsCubit(),
              child: MerchantsScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              ),
            );
          },
        ),

        // All Products Catalog Screen (no bottom nav)
        GoRoute(
          path: AppRoutes.allProducts,
          name: AppRoutes.allProductsNamed,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final filterParam = state.uri.queryParameters['filter'];
            final initialFilter = ProductCatalogFilter.fromString(filterParam);
            return BlocProvider<AllProductsCubit>(
              create: (_) => ProductsDI.createAllProductsCubit(),
              child: AllProductsScreen(initialFilter: initialFilter),
            );
          },
        ),

        // Main shell with persistent bottom navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider<ProfileCubit>(
              create: (_) => ProfileDI.createProfileCubit()..loadProfile(),
              child: MainShell(
                navigationShell: navigationShell,
                child: navigationShell,
              ),
            );
          },
          branches: [
            // 0: Home tab (الرئيسية)
            StatefulShellBranch(
              navigatorKey: shellNavigatorHome,
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  name: AppRoutes.homeNamed,
                  builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider<HomeCubit>(
                        create: (_) => HomeDI.createHomeCubit(),
                      ),
                      BlocProvider<StartupPromotionCubit>(
                        create: (_) =>
                            PromotionsDI.createStartupPromotionCubit(),
                      ),
                      BlocProvider<CartCubit>(
                        create: (_) => CartDI.createCartCubit()..loadCart(),
                      ),
                    ],
                    child: const HomeScreen(),
                  ),
                ),
              ],
            ),

            // 1: Categories tab (الأقسام)
            StatefulShellBranch(
              navigatorKey: shellNavigatorCategories,
              routes: [
                GoRoute(
                  path: AppRoutes.categories,
                  name: AppRoutes.categoriesNamed,
                  builder: (context, state) => BlocProvider<CategoriesCubit>(
                    create: (_) => CategoriesDI.createCategoriesCubit(),
                    child: const CategoriesScreen(),
                  ),
                ),
              ],
            ),

            // 2: Profile tab (الحساب)
            StatefulShellBranch(
              navigatorKey: shellNavigatorProfile,
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  name: AppRoutes.profileNamed,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),

            // 3: Favorites tab (المفضلة)
            StatefulShellBranch(
              navigatorKey: shellNavigatorFavorites,
              routes: [
                GoRoute(
                  path: AppRoutes.favorites,
                  name: AppRoutes.favoritesNamed,
                  builder: (context, state) => BlocProvider<FavoritesCubit>(
                    create: (_) =>
                        FavoritesDI.createFavoritesCubit()..loadFavorites(),
                    child: const FavoritesScreen(),
                  ),
                ),
              ],
            ),

            // 4: Cart tab (سلتي)
            StatefulShellBranch(
              navigatorKey: shellNavigatorBasket,
              routes: [
                GoRoute(
                  path: AppRoutes.basket,
                  name: AppRoutes.basketNamed,
                  builder: (context, state) => BlocProvider<CartCubit>(
                    create: (_) => CartDI.createCartCubit()..loadCart(),
                    child: const BasketScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
