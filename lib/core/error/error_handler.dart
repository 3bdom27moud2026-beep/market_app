import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:market/core/utils/app_strings.dart';
import 'failures.dart';

/// Central error handler for the application.
///
/// Converts any technical error, [DioException], [SocketException], timeout,
/// HTTP status code, or server response into a clear, user-friendly Arabic message.
class AppErrorHandler {
  AppErrorHandler._();

  /// Returns a clean, user-friendly Arabic error message for UI display.
  static String getMessage(dynamic error, {String? defaultMessage}) {
    if (error == null) {
      return defaultMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
    }

    if (error is Failure) {
      return error.message;
    }

    if (error is DioException) {
      return _handleDioException(error, defaultMessage: defaultMessage);
    }

    if (error is SocketException) {
      return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
    }

    if (error is HttpException) {
      return 'حدث خطأ في الاتصال بالشبكة. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
    }

    if (error is FormatException) {
      return 'حدث خطأ في معالجة البيانات المستلمة. يرجى المحاولة لاحقاً.';
    }

    if (error is TimeoutException) {
      return 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
    }

    // Inspect error string representation
    final str = error.toString();
    return _cleanGenericErrorString(str, defaultMessage: defaultMessage);
  }

  /// Maps [error] to a specific domain [Failure] subclass.
  static Failure handleToFailure(dynamic error, {String? defaultMessage}) {
    if (error is Failure) return error;

    if (error is DioException) {
      if (_isConnectionOrTimeoutDio(error)) {
        return NetworkFailure(
          getMessage(error, defaultMessage: defaultMessage),
        );
      }

      final statusCode = error.response?.statusCode;
      final path = error.requestOptions.path.toLowerCase();
      final isAuthEndpoint =
          path.contains('login') || path.contains('register');

      if (statusCode == 401) {
        if (isAuthEndpoint) {
          return ValidationFailure(
            getMessage(error, defaultMessage: defaultMessage),
          );
        }
        return UnauthorizedFailure(
          getMessage(error, defaultMessage: defaultMessage),
        );
      }
      if (statusCode == 400 || statusCode == 422 || statusCode == 409) {
        return ValidationFailure(
          getMessage(error, defaultMessage: defaultMessage),
        );
      }

      return ServerFailure(
        getMessage(error, defaultMessage: defaultMessage),
        code: statusCode?.toString(),
      );
    }

    if (error is SocketException || _matchesNetworkKeywords(error.toString())) {
      return NetworkFailure(getMessage(error, defaultMessage: defaultMessage));
    }

    return ServerFailure(getMessage(error, defaultMessage: defaultMessage));
  }

  /// Checks if the error is network-related (e.g. offline, host lookup failed).
  static bool isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is DioException) return _isConnectionOrTimeoutDio(error);
    if (error is Failure) return error is NetworkFailure;
    return _matchesNetworkKeywords(error.toString());
  }

  static bool _isConnectionOrTimeoutDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.unknown:
        return error.error is SocketException ||
            _matchesNetworkKeywords(error.message ?? '') ||
            _matchesNetworkKeywords(error.error?.toString() ?? '');
      default:
        return false;
    }
  }

  static bool _matchesNetworkKeywords(String text) {
    final lower = text.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection timed out') ||
        lower.contains('connection error') ||
        lower.contains('no address associated with hostname') ||
        lower.contains('handshake failed') ||
        lower.contains('network error');
  }

  static String _handleDioException(
    DioException error, {
    String? defaultMessage,
  }) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';

      case DioExceptionType.badCertificate:
        return 'تعذر تأمين الاتصال بالخادم. يرجى المحاولة لاحقاً.';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب.';

      case DioExceptionType.badResponse:
        return _extractBadResponseMessage(
          error,
          defaultMessage: defaultMessage,
        );

      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException ||
            _matchesNetworkKeywords(error.message ?? '') ||
            _matchesNetworkKeywords(error.error?.toString() ?? '')) {
          return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
        }
        if (error.error is FormatException) {
          return 'حدث خطأ في معالجة البيانات المستلمة. يرجى المحاولة لاحقاً.';
        }
        return defaultMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
    }
  }

  static String _extractBadResponseMessage(
    DioException error, {
    String? defaultMessage,
  }) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final path = error.requestOptions.path.toLowerCase();
    final isLogin = path.contains('login');
    final isRegister = path.contains('register');
    final isChangePassword =
        path.contains('change-password') || path.contains('password');

    // 1. Try to extract clean message from response data
    if (data is Map<String, dynamic>) {
      // Check Laravel errors map e.g. {"errors": {"phone": ["رقم الهاتف مسجل"]}}
      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstKey = errors.keys.first.toLowerCase();
        final firstVal = errors.values.first;
        String? extracted;
        if (firstVal is List && firstVal.isNotEmpty) {
          extracted = firstVal.first.toString().trim();
        } else if (firstVal is String) {
          extracted = firstVal.trim();
        }

        if (extracted != null && extracted.isNotEmpty) {
          if (_containsArabic(extracted) && _isCleanUserFacing(extracted)) {
            return extracted;
          }
          final mapped = _mapKnownBackendEnglishMessage(
            extracted,
            field: firstKey,
            isLogin: isLogin,
          );
          if (mapped != null) return mapped;
          if (_isCleanUserFacing(extracted)) return extracted;
        }
      } else if (errors is String && errors.trim().isNotEmpty) {
        final errStr = errors.trim();
        if (_containsArabic(errStr) && _isCleanUserFacing(errStr)) {
          return errStr;
        }
        final mapped = _mapKnownBackendEnglishMessage(errStr, isLogin: isLogin);
        if (mapped != null) return mapped;
        if (_isCleanUserFacing(errStr)) return errStr;
      }

      // Check 'message' or 'error' fields
      final rawMsg = data['message'] ?? data['error'];
      if (rawMsg != null) {
        final msgStr = rawMsg.toString().trim();
        if (msgStr.isNotEmpty) {
          if (_containsArabic(msgStr) && _isCleanUserFacing(msgStr)) {
            return msgStr;
          }
          final mapped = _mapKnownBackendEnglishMessage(
            msgStr,
            isLogin: isLogin,
          );
          if (mapped != null) return mapped;
          if (_isCleanUserFacing(msgStr)) return msgStr;
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      final str = data.trim();
      if (_containsArabic(str) && _isCleanUserFacing(str)) {
        return str;
      }
      final mapped = _mapKnownBackendEnglishMessage(str, isLogin: isLogin);
      if (mapped != null) return mapped;
      if (_isCleanUserFacing(str)) return str;
    }

    // 2. Fallback to status-code specific messages
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          if (isChangePassword) {
            return AppStrings.currentPasswordIncorrect;
          }
          return 'طلب غير صالح، يرجى مراجعة البيانات والمحاولة مجدداً.';
        case 401:
          if (isLogin) {
            return AppStrings.invalidCredentials;
          }
          if (isChangePassword) {
            return AppStrings.currentPasswordIncorrect;
          }
          return AppStrings.unauthorizedError;
        case 403:
          return 'غير مصرح لك بالوصول إلى هذا المحتوى أو الحساب موقوف.';
        case 404:
          if (isLogin) {
            return AppStrings.userNotFound;
          }
          return 'البيانات المطلوبة غير متوفرة حالياً.';
        case 409:
          if (isRegister) {
            return AppStrings.phoneAlreadyRegistered;
          }
          return 'تم تنفيذ هذا الطلب مسبقاً.';
        case 422:
          if (isLogin) {
            return AppStrings.invalidCredentials;
          }
          if (isRegister) {
            return 'البيانات المدخلة غير صحيحة، يرجى مراجعة بيانات التسجيل والمحاولة مجدداً.';
          }
          return 'البيانات المدخلة غير صحيحة، يرجى التحقق منها والمحاولة مجدداً.';
        case 429:
          return AppStrings.tooManyAttempts;
        case 500:
        case 502:
        case 503:
        case 504:
          return AppStrings.serverError;
      }
    }

    return defaultMessage ?? AppStrings.genericError;
  }

  static String? _mapKnownBackendEnglishMessage(
    String message, {
    String? field,
    bool isLogin = false,
  }) {
    final lower = message.trim().toLowerCase();

    // Credentials / Login failures
    if (lower.contains('credentials') ||
        lower.contains('invalid credentials') ||
        lower.contains('do not match our records') ||
        lower.contains('incorrect password') ||
        lower.contains('wrong password') ||
        (isLogin && (lower.contains('unauthenticated') || lower.contains('unauthorized')))) {
      return AppStrings.invalidCredentials;
    }

    // Unauthenticated on protected routes
    if (lower == 'unauthenticated' || lower == 'unauthenticated.') {
      return AppStrings.unauthorizedError;
    }
    if (lower == 'unauthorized' || lower == 'unauthorized.') {
      return 'غير مصرح لك بالقيام بهذه العملية.';
    }

    // User existence & account status
    if (lower.contains('user not found') ||
        lower.contains('no user found') ||
        lower.contains('user does not exist')) {
      return AppStrings.userNotFound;
    }
    if (lower.contains('inactive') ||
        lower.contains('deactivated') ||
        lower.contains('suspended') ||
        lower.contains('blocked') ||
        lower.contains('banned')) {
      return AppStrings.accountInactive;
    }

    // Phone validation
    if (lower.contains('users_phone_unique') ||
        (lower.contains('phone') && (lower.contains('taken') || lower.contains('exists') || lower.contains('already')))) {
      return AppStrings.phoneAlreadyRegistered;
    }
    if (lower.contains('phone') && (lower.contains('digit') || lower.contains('invalid') || lower.contains('format'))) {
      return 'رقم الهاتف يجب أن يتكون من 11 رقماً صالحاً.';
    }

    // Email validation
    if (lower.contains('users_email_unique') ||
        (lower.contains('email') && (lower.contains('taken') || lower.contains('exists') || lower.contains('already')))) {
      return AppStrings.emailAlreadyRegistered;
    }
    if (lower.contains('email') && lower.contains('valid email')) {
      return 'البريد الإلكتروني غير صالح، يرجى إدخال بريد صحيح.';
    }

    // Password validation
    if (lower.contains('current password') || lower.contains('current_password')) {
      return AppStrings.currentPasswordIncorrect;
    }
    if (lower.contains('confirmation does not match') || lower.contains('passwords do not match')) {
      return AppStrings.passwordMismatch;
    }
    if (lower.contains('password') && (lower.contains('at least') || lower.contains('min') || lower.contains('short'))) {
      return AppStrings.passwordMinLength;
    }

    // Referral code
    if (lower.contains('referral') || (field != null && field.contains('referral'))) {
      return AppStrings.invalidReferralCode;
    }

    // Area & location
    if (lower.contains('area') || lower.contains('governorate') || (field != null && field.contains('area'))) {
      return AppStrings.selectAreaPrompt;
    }

    // Required fields
    if (lower.contains('is required') || lower.contains('field is required')) {
      if (field == 'phone') return 'يرجى إدخال رقم الهاتف.';
      if (field == 'password') return 'يرجى إدخال كلمة المرور.';
      if (field == 'name') return 'يرجى إدخال الاسم بالكامل.';
      if (field == 'area_id') return AppStrings.selectAreaPrompt;
      return AppStrings.requiredField;
    }

    // Cart / E-Commerce
    if (lower.contains('cart is empty') || lower.contains('empty cart')) {
      return 'سلة المشتريات فارغة، يرجى إضافة منتجات أولاً.';
    }
    if (lower.contains('out of stock') || lower.contains('not enough stock')) {
      return 'الكمية المطلوبة غير متوفرة في المخزون حالياً.';
    }
    if (lower.contains('coupon') && (lower.contains('invalid') || lower.contains('expired') || lower.contains('not found'))) {
      return 'كوبون الخصم غير صالح أو انتهت صلاحيته.';
    }
    if (lower.contains('coupon') && (lower.contains('already') || lower.contains('used'))) {
      return 'تم استخدام كوبون الخصم هذا مسبقاً.';
    }

    // General
    if (lower == 'forbidden' || lower == 'forbidden.') {
      return 'غير مصرح لك بالوصول إلى هذا المحتوى.';
    }
    if (lower == 'not found' || lower == 'resource not found.') {
      return 'البيانات المطلوبة غير متوفرة حالياً.';
    }
    if (lower == 'the given data was invalid.' || lower == 'the given data was invalid') {
      return 'البيانات المدخلة غير صحيحة، يرجى مراجعة البيانات والمحاولة مجدداً.';
    }
    if (lower == 'too many requests' || lower.contains('too many attempts')) {
      return AppStrings.tooManyAttempts;
    }
    if (lower == 'server error' || lower == 'internal server error') {
      return AppStrings.serverError;
    }

    return null;
  }

  static bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  static bool _isCleanUserFacing(String message) {
    if (message.isEmpty) return false;
    final lower = message.toLowerCase();

    // Check if it contains technical code indicators
    if (lower.contains('exception') ||
        lower.contains('stack trace') ||
        lower.contains('sqlstate') ||
        lower.contains('syntaxerror') ||
        lower.contains('call to undefined') ||
        lower.contains('dioerror') ||
        lower.contains('dioexception') ||
        lower.contains('line ') && lower.contains('file ') ||
        lower.contains('null pointer') ||
        lower.contains('fatal error') ||
        lower.contains('class not found')) {
      return false;
    }

    return true;
  }

  static String _cleanGenericErrorString(String raw, {String? defaultMessage}) {
    if (_matchesNetworkKeywords(raw)) {
      return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
    }

    if (raw.toLowerCase().contains('timeout')) {
      return 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
    }

    // Strip "Exception: "
    String cleaned = raw;
    if (cleaned.startsWith('Exception: ')) {
      cleaned = cleaned.substring('Exception: '.length).trim();
    }

    // If it still contains technical tags like DioException, return default
    if (!_isCleanUserFacing(cleaned)) {
      return defaultMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
    }

    return cleaned.isNotEmpty
        ? cleaned
        : (defaultMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.');
  }
}
