import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market/core/routes/app_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/notifications/data/datasource/notifications_remote_datasource.dart';
import 'package:market/firebase_options.dart';

/// Top-level background message handler for FCM.
/// Must be annotated with `@pragma('vm:entry-point')` so it can be invoked
/// from an isolated background context.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase already initialized or platform specific
  }

  FCMService.logNotification(
    source: 'FCM BACKGROUND MESSAGE (APP INACTIVE / TERMINATED)',
    message: message,
    actionNote: 'Processed by top-level background isolate handler',
  );
}

/// Top-level background notification response handler for local notifications.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  FCMService.logLocalNotificationResponse(
    source: 'LOCAL NOTIFICATION TAP (BACKGROUND ENTRY)',
    response: response,
  );
}

/// Centralized service for Firebase Cloud Messaging (FCM) and Push Notifications.
class FCMService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationsRemoteDataSource? remoteDataSource;

  static const String channelId = 'shopguide_high_importance_channel';
  static const String channelName = 'ShopGuide Notifications';
  static const String channelDescription =
      'Important notifications for orders, promotions, and deals';

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

  /// Target route pending navigation after the splash screen finishes.
  static String? pendingRoute;

  /// Full notification data payload pending inspection or navigation.
  static Map<String, dynamic>? pendingNotificationData;

  /// Consumes and returns the pending route (used by SplashCubit after initialization).
  static String? consumePendingRoute() {
    final route = pendingRoute;
    pendingRoute = null;
    return route;
  }

  FCMService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    this.remoteDataSource,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  /// Initialize FCM, local notifications channel, permissions, and event listeners.
  Future<void> init() async {
    await _initLocalNotifications();
    await _setupMessageHandlers();

    // Run network tasks (permissions, token registration, topic subscriptions)
    // asynchronously to avoid blocking the main startup thread and prevent frame drops.
    _requestPermissions().then((_) async {
      await _registerToken();
      await _subscribeToDefaultTopics();
    });
  }

  /// Configure Android and iOS local notifications plugin.
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logLocalNotificationResponse(
          source: 'LOCAL NOTIFICATION CLICKED',
          response: response,
        );
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = extractPayloadMap(response.payload!);
            handleNotificationTap(
              data,
              source: 'ON_DID_RECEIVE_NOTIFICATION_RESPONSE',
            );
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[FCMService] Error decoding local payload: $e');
            }
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Create high-importance Android channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// Request notification permissions (Android 13+ and iOS).
  Future<NotificationSettings> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint(
        '[FCMService] User granted permission: ${settings.authorizationStatus}',
      );
    }
    return settings;
  }

  /// Retrieve FCM device token and register token refresh listener.
  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) {
          debugPrint('[FCMService] FCM Token: $token');
        }
        await CacheHelper.saveFcmToken(token);
        await syncTokenWithBackend(token: token);
      }

      // Listen for token updates
      _messaging.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
          debugPrint('[FCMService] FCM Token refreshed: $newToken');
        }
        await CacheHelper.saveFcmToken(newToken);
        await syncTokenWithBackend(token: newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCMService] Error getting token: $e');
      }
    }
  }

  /// Sync device FCM token to backend API if authenticated or endpoint available.
  Future<bool> syncTokenWithBackend({String? token}) async {
    final fcmToken = token ?? CacheHelper.fcmToken;
    if (fcmToken == null || fcmToken.isEmpty) return false;

    if (remoteDataSource != null) {
      return await remoteDataSource!.updateFcmToken(
        fcmToken: fcmToken,
        deviceType: defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'android',
      );
    }
    return false;
  }

  /// Subscribe to general topics for promotional and system updates.
  Future<void> _subscribeToDefaultTopics() async {
    try {
      await subscribeToTopic('all_users');
      await subscribeToTopic('offers');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCMService] Topic subscription warning: $e');
      }
    }
  }

  /// Subscribe to a specific FCM topic.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        debugPrint('[FCMService] Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCMService] Failed to subscribe to topic: $topic ($e)');
      }
    }
  }

  /// Unsubscribe from a specific FCM topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        debugPrint('[FCMService] Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[FCMService] Failed to unsubscribe from topic: $topic ($e)',
        );
      }
    }
  }

  /// Set up foreground, background, and initial app opening listeners.
  Future<void> _setupMessageHandlers() async {
    // 1. Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logNotification(
        source: 'FOREGROUND MESSAGE RECEIVED',
        message: message,
        actionNote: 'Displaying heads-up banner notification',
      );
      showForegroundNotification(message);
    });

    // 2. Notification opened app from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logNotification(
        source: 'NOTIFICATION OPENED APP (FROM BACKGROUND)',
        message: message,
        actionNote: 'Processing notification tap from background',
      );
      handleNotificationTap(message.data, source: 'ON_MESSAGE_OPENED_APP');
    });

    // 3. App launched from terminated state via FCM notification click
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      logNotification(
        source: 'APP LAUNCHED FROM TERMINATED STATE (FCM INITIAL MESSAGE)',
        message: initialMessage,
        actionNote: 'Saving pendingRoute for post-splash navigation',
      );
      handleNotificationTap(
        initialMessage.data,
        source: 'GET_INITIAL_MESSAGE (TERMINATED)',
      );
    }

    // 4. App launched from terminated state via local notification click
    try {
      final launchDetails = await _localNotifications
          .getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        final payload = launchDetails.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          logLocalNotificationResponse(
            source: 'APP LAUNCHED FROM TERMINATED (LOCAL NOTIFICATION DETAILS)',
            response: launchDetails.notificationResponse!,
          );
          final data = extractPayloadMap(payload);
          handleNotificationTap(
            data,
            source: 'LOCAL_LAUNCH_DETAILS (TERMINATED)',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[FCMService] getNotificationAppLaunchDetails check warning: $e',
        );
      }
    }
  }

  /// Display a heads-up banner notification when a message arrives while app is open.
  Future<void> showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title =
        notification?.title ?? message.data['title']?.toString() ?? 'شوب جايد';
    final body = notification?.body ?? message.data['body']?.toString() ?? '';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final notificationId = message.messageId.hashCode;
    final payloadMap = Map<String, dynamic>.from(message.data);
    if (!payloadMap.containsKey('title') && title.isNotEmpty) {
      payloadMap['title'] = title;
    }
    if (!payloadMap.containsKey('body') && body.isNotEmpty) {
      payloadMap['body'] = body;
    }
    final payloadString = jsonEncode(payloadMap);

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: payloadString,
    );
  }

  /// Extracts and flattens data payload, resolving nested JSON strings if present.
  static Map<String, dynamic> extractPayloadMap(dynamic rawData) {
    if (rawData == null) return {};
    Map<String, dynamic> result = {};
    if (rawData is Map) {
      result = Map<String, dynamic>.from(rawData);
    } else if (rawData is String) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map) {
          result = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    // Unpack nested JSON strings in common wrapper keys ('data', 'payload', 'body', 'message')
    for (final key in ['data', 'payload', 'body', 'message']) {
      if (result.containsKey(key) && result[key] is String) {
        final str = (result[key] as String).trim();
        if (str.startsWith('{') && str.endsWith('}')) {
          try {
            final nested = jsonDecode(str);
            if (nested is Map) {
              for (final entry in nested.entries) {
                result.putIfAbsent(entry.key.toString(), () => entry.value);
              }
            }
          } catch (_) {}
        }
      }
    }
    return result;
  }

  /// Pure helper to resolve the appropriate deep link route from notification payload data.
  static String resolveRouteFromData(Map<String, dynamic> rawData) {
    final data = extractPayloadMap(rawData);

    // 1. Explicit route or screen specified
    final explicitCandidate =
        data['route'] ??
        data['path'] ??
        data['target_route'] ??
        data['screen'] ??
        data['page'] ??
        data['target'] ??
        data['destination'];

    if (explicitCandidate != null) {
      final routeStr = explicitCandidate.toString().trim();
      if (routeStr.isNotEmpty) {
        final mapped = _mapScreenNameToRoute(routeStr);
        if (mapped != null) return mapped;

        if (routeStr.startsWith('/')) {
          return routeStr;
        } else {
          return '/$routeStr';
        }
      }
    }

    final refId =
        (data['reference_id'] ??
                data['order_id'] ??
                data['product_id'] ??
                data['merchant_id'] ??
                data['category_id'] ??
                data['id'] ??
                data['item_id'])
            ?.toString()
            .trim();

    final type =
        (data['type'] ??
                data['notification_type'] ??
                data['action'] ??
                data['category'] ??
                'general')
            .toString()
            .toLowerCase();

    // 2. Orders & Order Tracking
    if (type.contains('order') || data.containsKey('order_id')) {
      return AppRoutes.orders;
    }

    // 3. Categories
    if (type.contains('category') || data.containsKey('category_id')) {
      if (refId != null && refId.isNotEmpty) {
        return '/category-products/$refId';
      }
      return AppRoutes.categories;
    }

    // 4. Products
    if (type.contains('product') || data.containsKey('product_id')) {
      if (refId != null && refId.isNotEmpty) {
        return '/product-details/$refId';
      }
      return AppRoutes.allProducts;
    }

    // 5. Merchants / Partners
    if (type.contains('merchant') || data.containsKey('merchant_id')) {
      if (refId != null && refId.isNotEmpty) {
        return '/merchant-details/$refId';
      }
      return AppRoutes.merchants;
    }

    // 6. Flash Sale & Deals
    if (type.contains('flash') || type.contains('sale')) {
      return AppRoutes.flashSale;
    }

    // 7. Promotions / Offers
    if (type.contains('offer') || type.contains('promo')) {
      return AppRoutes.home;
    }

    // 8. Discount Card
    if (type.contains('card') || type.contains('discount')) {
      return AppRoutes.discountCard;
    }

    // 9. Abandoned Cart
    if (type.contains('cart') || type.contains('basket')) {
      return AppRoutes.basket;
    }

    // 10. Favorites / Wishlist
    if (type.contains('favorite') || type.contains('wishlist')) {
      return AppRoutes.favorites;
    }

    // 11. Profile / Account
    if (type.contains('profile') || type.contains('account')) {
      return AppRoutes.profile;
    }

    // Default fallback: Notifications screen
    return AppRoutes.notifications;
  }

  static String? _mapScreenNameToRoute(String screen) {
    final s = screen.toLowerCase().replaceAll(RegExp(r'[\/\-_]'), '');
    switch (s) {
      case 'home':
        return AppRoutes.home;
      case 'orders':
      case 'order':
      case 'myorders':
        return AppRoutes.orders;
      case 'notifications':
      case 'notification':
      case 'alerts':
        return AppRoutes.notifications;
      case 'basket':
      case 'cart':
        return AppRoutes.basket;
      case 'favorites':
      case 'favorite':
      case 'wishlist':
        return AppRoutes.favorites;
      case 'profile':
      case 'account':
        return AppRoutes.profile;
      case 'discountcard':
      case 'card':
        return AppRoutes.discountCard;
      case 'flashsale':
      case 'sale':
      case 'deals':
        return AppRoutes.flashSale;
      case 'merchants':
      case 'partners':
      case 'stores':
        return AppRoutes.merchants;
      case 'products':
      case 'allproducts':
        return AppRoutes.allProducts;
      case 'categories':
        return AppRoutes.categories;
      default:
        return null;
    }
  }

  /// Formats and logs comprehensive notification details to the debug console.
  static void logNotification({
    required String source,
    RemoteMessage? message,
    Map<String, dynamic>? data,
    String? title,
    String? body,
    String? resolvedRoute,
    String? actionNote,
  }) {
    if (!kDebugMode) return;

    final msgId = message?.messageId ?? 'N/A';
    final notifTitle =
        title ??
        message?.notification?.title ??
        data?['title']?.toString() ??
        '(No Title)';
    final notifBody =
        body ??
        message?.notification?.body ??
        data?['body']?.toString() ??
        '(No Body)';
    final effectiveData = data ?? message?.data ?? {};
    final route = resolvedRoute ?? resolveRouteFromData(effectiveData);

    String prettyJson = '{}';
    try {
      prettyJson = const JsonEncoder.withIndent('  ').convert(effectiveData);
    } catch (_) {
      prettyJson = effectiveData.toString();
    }

    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln(
      '╔════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 🔔 [FCM NOTIFICATION LOG]');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 📌 Source / Event : $source');
    buffer.writeln('║ 🆔 Message ID     : $msgId');
    buffer.writeln('║ 🏷️ Title          : $notifTitle');
    buffer.writeln('║ 💬 Body           : $notifBody');
    buffer.writeln('║ 🧭 Resolved Route : $route');
    if (actionNote != null && actionNote.isNotEmpty) {
      buffer.writeln('║ 🚀 Action / Status: $actionNote');
    }
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 📦 DATA PAYLOAD (RAW MAP):');
    buffer.writeln('║ $effectiveData');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln(
      '║ 📄 FORMATTED JSON (Copy & Inspect for backend handling):',
    );
    for (final line in prettyJson.split('\n')) {
      buffer.writeln('║ $line');
    }
    buffer.writeln(
      '╚════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('');

    debugPrint(buffer.toString());
  }

  /// Logs details for local notification responses (user tapping heads-up banner).
  static void logLocalNotificationResponse({
    required String source,
    required NotificationResponse response,
  }) {
    if (!kDebugMode) return;

    Map<String, dynamic> decodedPayload = {};
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        final decoded = jsonDecode(response.payload!);
        if (decoded is Map) {
          decodedPayload = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    final route = resolveRouteFromData(decodedPayload);

    String pretty = '{}';
    try {
      pretty = const JsonEncoder.withIndent('  ').convert(decodedPayload);
    } catch (_) {
      pretty = decodedPayload.toString();
    }

    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln(
      '╔════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 🔔 [LOCAL NOTIFICATION RESPONSE / TAP]');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 📌 Source / Event  : $source');
    buffer.writeln('║ 🆔 Notification ID : ${response.id}');
    buffer.writeln('║ 🏷️ Action ID        : ${response.actionId ?? "(None)"}');
    buffer.writeln('║ 🧭 Target Route     : $route');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 📦 Raw Payload String:');
    buffer.writeln('║ ${response.payload}');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ 📄 Decoded Payload:');
    for (final line in pretty.split('\n')) {
      buffer.writeln('║ $line');
    }
    buffer.writeln(
      '╚════════════════════════════════════════════════════════════════════════════════',
    );
    buffer.writeln('');

    debugPrint(buffer.toString());
  }

  /// Handle notification tap and navigate to the target screen using AppRouter.
  void handleNotificationTap(Map<String, dynamic> rawData, {String? source}) {
    final data = extractPayloadMap(rawData);
    final targetRoute = resolveRouteFromData(data);

    // Determine if the app is still in splash screen or if navigator is ready
    final navContext = AppRouter.rootNavigatorKey.currentContext;
    bool isStillOnSplash = true;

    if (navContext != null) {
      try {
        final currentUri =
            AppRouter.router.routeInformationProvider.value.uri.path;
        isStillOnSplash = (currentUri == AppRoutes.splash || currentUri == '/');
      } catch (_) {
        isStillOnSplash = false;
      }
    }

    if (isStillOnSplash || navContext == null) {
      pendingRoute = targetRoute;
      pendingNotificationData = data;
      logNotification(
        source: source ?? 'NOTIFICATION CLICK (QUEUED FOR POST-SPLASH)',
        data: data,
        resolvedRoute: targetRoute,
        actionNote:
            'App is initializing or on SplashScreen. Route [$targetRoute] queued as pendingRoute.',
      );
    } else {
      logNotification(
        source: source ?? 'NOTIFICATION CLICK (IMMEDIATE NAVIGATION)',
        data: data,
        resolvedRoute: targetRoute,
        actionNote: 'Pushing route directly to GoRouter: $targetRoute',
      );

      try {
        AppRouter.router.push(targetRoute);
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            '[FCMService] AppRouter.push failed ($e). Attempting AppRouter.go($targetRoute)...',
          );
        }
        try {
          AppRouter.router.go(targetRoute);
        } catch (err) {
          if (kDebugMode) {
            debugPrint('[FCMService] Navigation failed: $err');
          }
        }
      }
    }
  }
}
