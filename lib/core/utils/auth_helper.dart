import 'package:flutter/material.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';

/// Helper class for managing authentication flow and guards across the app.
abstract final class AuthHelper {
  /// Ensures the user is authenticated before executing [onAuthenticated].
  ///
  /// If the user is unauthenticated, shows the [AuthBottomSheet] instead of
  /// navigating to the login screen. After successful login/register the
  /// [onAuthenticated] callback is invoked.
  static Future<void> ensureAuthenticated(
    BuildContext context, {
    required VoidCallback onAuthenticated,
  }) async {
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();

    if (checkAuth()) {
      onAuthenticated();
      return;
    }

    final bool? authenticated = await showAuthBottomSheet(context);

    if (authenticated == true) {
      onAuthenticated();
    }
  }
}
