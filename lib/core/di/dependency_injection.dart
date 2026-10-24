import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/cache_helper.dart';

import 'package:market/core/theme/theme_cubit.dart';
import 'package:market/features/auth/dependency_injection.dart';
import 'package:market/features/favorites/dependency_injection.dart';
import 'package:market/features/notifications/dependency_injection.dart';
import 'package:market/features/orders/orders_di.dart';

/// Core dependency injection container using GetIt.
abstract final class CoreDI {
  static final GetIt sl = GetIt.instance;

  /// Initialize all core dependencies.
  static Future<void> init({required String baseUrl}) async {
    // CacheHelper
    await CacheHelper.init();

    // Date formatting localization
    await initializeDateFormatting('ar', null);

    // Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add AuthInterceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = CacheHelper.authToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    sl.registerLazySingleton<Dio>(() => dio);

    // ApiClient
    sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

    // Auth DI
    AuthDI.init(sl);

    // Favorites DI
    FavoritesDI.init(sl);

    // Notifications DI
    NotificationsDI.init(sl);

    // Orders DI
    OrdersDI.init(sl);

    // Theme Cubit
    sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  }
}
