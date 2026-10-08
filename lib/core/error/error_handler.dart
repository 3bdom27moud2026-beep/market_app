import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

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
      if (statusCode == 401) {
        return UnauthorizedFailure(
          getMessage(error, defaultMessage: defaultMessage),
        );
      }
      if (statusCode == 400 || statusCode == 422) {
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

    // 1. Try to extract clean message from response data
    if (data is Map<String, dynamic>) {
      // Check Laravel errors map e.g. {"errors": {"phone": ["رقم الهاتف مسجل"]}}
      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstVal = errors.values.first;
        if (firstVal is List && firstVal.isNotEmpty) {
          final firstMsg = firstVal.first.toString().trim();
          if (_isCleanUserFacing(firstMsg)) {
            return firstMsg;
          }
        } else if (firstVal is String && _isCleanUserFacing(firstVal)) {
          return firstVal.trim();
        }
      } else if (errors is String && _isCleanUserFacing(errors)) {
        return errors.trim();
      }

      // Check 'message' or 'error' fields
      final rawMsg = data['message'] ?? data['error'];
      if (rawMsg != null) {
        final msgStr = rawMsg.toString().trim();
        final mapped = _mapKnownBackendEnglishMessage(msgStr);
        if (mapped != null) return mapped;
        if (_isCleanUserFacing(msgStr)) return msgStr;
      }
    } else if (data is String && _isCleanUserFacing(data)) {
      final mapped = _mapKnownBackendEnglishMessage(data.trim());
      if (mapped != null) return mapped;
      return data.trim();
    }

    // 2. Fallback to status-code specific messages
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'طلب غير صالح، يرجى مراجعة البيانات والمحاولة مجدداً.';
        case 401:
          return 'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول.';
        case 403:
          return 'غير مصرح لك بالوصول إلى هذا المحتوى.';
        case 404:
          return 'البيانات المطلوبة غير متوفرة حالياً.';
        case 409:
          return 'تم تنفيذ هذا الطلب مسبقاً.';
        case 422:
          return 'البيانات المدخلة غير صحيحة، يرجى التحقق منها والمحاولة مجدداً.';
        case 429:
          return 'تم تجاوز عدد المحاولات المسموح بها، يرجى الانتظار قليلاً والمحاولة لاحقاً.';
        case 500:
        case 502:
        case 503:
        case 504:
          return 'حدث خطأ في الخادم، يرجى المحاولة في وقت لاحق.';
      }
    }

    return defaultMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
  }

  static String? _mapKnownBackendEnglishMessage(String message) {
    final lower = message.trim().toLowerCase();
    if (lower == 'unauthenticated' || lower == 'unauthenticated.') {
      return 'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول.';
    }
    if (lower == 'unauthorized' || lower == 'unauthorized.') {
      return 'غير مصرح لك بالقيام بهذه العملية.';
    }
    if (lower == 'forbidden' || lower == 'forbidden.') {
      return 'غير مصرح لك بالوصول إلى هذا المحتوى.';
    }
    if (lower == 'not found' || lower == 'resource not found.') {
      return 'البيانات المطلوبة غير متوفرة حالياً.';
    }
    if (lower == 'the given data was invalid.' ||
        lower == 'the given data was invalid') {
      return 'البيانات المدخلة غير صحيحة، يرجى مراجعة البيانات والمحاولة مجدداً.';
    }
    if (lower == 'too many requests' || lower.contains('too many attempts')) {
      return 'تم تجاوز عدد المحاولات، يرجى الانتظار قليلاً والمحاولة لاحقاً.';
    }
    if (lower == 'server error' || lower == 'internal server error') {
      return 'حدث خطأ في الخادم، يرجى المحاولة في وقت لاحق.';
    }
    return null;
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
