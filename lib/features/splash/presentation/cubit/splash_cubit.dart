import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/utils/cache_helper.dart';
import 'splash_state.dart';

/// Cubit responsible for splash screen initialization and navigation.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  /// Initializes the app and navigates to the appropriate screen.
  Future<void> initializeApp() async {
    try {
      await CacheHelper.init();
      await Future.delayed(AppDurations.splashAutoNavigate);
      emit(const SplashReady());
    } catch (e) {
      if (!isClosed) {
        emit(
          SplashError(
            AppErrorHandler.getMessage(
              e,
              defaultMessage: 'فشل في تهيئة التطبيق، يرجى إعادة المحاولة',
            ),
          ),
        );
      }
    }
  }

  /// Navigates to the main home screen, or pushes pending notification deep link.
  void navigateToNext(GoRouter router) {
    final pending = FCMService.consumePendingRoute();
    if (pending != null &&
        pending.isNotEmpty &&
        pending != AppRoutes.home &&
        pending != '/') {
      // First establish home screen as the root of navigation stack
      router.goNamed(AppRoutes.homeNamed);
      // Then push the target notification deep link
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          router.push(pending);
        } catch (_) {
          router.go(pending);
        }
      });
    } else {
      router.goNamed(AppRoutes.homeNamed);
    }
  }
}
