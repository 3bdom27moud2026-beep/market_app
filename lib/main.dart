import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/routes/app_router.dart';
import 'core/di/dependency_injection.dart';
import 'core/utils/end_points.dart';
import 'features/notifications/dependency_injection.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await CoreDI.init(baseUrl: EndPoints.baseUrl);

  // Initialize FCM service
  try {
    await NotificationsDI.fcmService.init();
  } catch (e) {
    debugPrint('FCM init error: $e');
  }

  runApp(const MarketApp());
}

class MarketApp extends StatelessWidget {
  final ThemeCubit? themeCubit;

  const MarketApp({super.key, this.themeCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) {
            if (themeCubit != null) return themeCubit!;
            if (CoreDI.sl.isRegistered<ThemeCubit>()) {
              return CoreDI.sl<ThemeCubit>();
            }
            return ThemeCubit();
          },
        ),
        BlocProvider<CartCubit>(
          create: (_) => CartDI.createCartCubit()..loadCart(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'ShopGuide',
                debugShowCheckedModeBanner: false,
                locale: const Locale('ar'),
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.noScaling),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
