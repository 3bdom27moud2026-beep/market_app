import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/error/failures.dart';

void main() {
  group('AppErrorHandler.getMessage', () {
    test('returns network message on Dio connectionError', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/profile'),
        type: DioExceptionType.connectionError,
        error: const SocketException(
          "Failed host lookup: 'shopguide.medguide.software'",
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(
        message,
        'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.',
      );
    });

    test('returns timeout message on Dio timeouts', () {
      final timeoutTypes = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ];

      for (final type in timeoutTypes) {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: type,
        );
        final message = AppErrorHandler.getMessage(dioException);
        expect(
          message,
          'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.',
        );
      }
    });

    test('returns session expired message on 401 status code', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'Unauthenticated.'},
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول.');
    });

    test('returns forbidden message on 403 status code', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'message': 'Forbidden.'},
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'غير مصرح لك بالوصول إلى هذا المحتوى.');
    });

    test('returns not found message on 404 status code', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'البيانات المطلوبة غير متوفرة حالياً.');
    });

    test('extracts nested field validation error message on 422', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'message': 'The given data was invalid.',
            'errors': {
              'phone': ['رقم الهاتف مسجل بالفعل'],
            },
          },
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'رقم الهاتف مسجل بالفعل');
    });

    test('translates standard English validation message on 422', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {'message': 'The given data was invalid.'},
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(
        message,
        'البيانات المدخلة غير صحيحة، يرجى مراجعة البيانات والمحاولة مجدداً.',
      );
    });

    test('returns clean server error message on 500 status code', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {'message': 'Server Error'},
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'حدث خطأ في الخادم، يرجى المحاولة في وقت لاحق.');
    });

    test('filters out technical stack traces and SQL errors', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {
            'message':
                'SQLSTATE[HY000]: General error: 1364 Field cannot be null',
          },
        ),
      );

      final message = AppErrorHandler.getMessage(dioException);
      expect(message, 'حدث خطأ في الخادم، يرجى المحاولة في وقت لاحق.');
    });

    test('handles direct SocketException', () {
      const socketException = SocketException('Failed host lookup');
      final message = AppErrorHandler.getMessage(socketException);
      expect(
        message,
        'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.',
      );
    });

    test('handles raw Exception string with DioException text', () {
      const raw =
          'Exception: فشل في جلب بيانات الملف الشخصي: DioException [connection error]: The connection errored: Failed host lookup';
      final message = AppErrorHandler.getMessage(raw);
      expect(
        message,
        'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.',
      );
    });
  });

  group('AppErrorHandler.handleToFailure', () {
    test('returns NetworkFailure for connection errors', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final failure = AppErrorHandler.handleToFailure(dioException);
      expect(failure, isA<NetworkFailure>());
    });

    test('returns UnauthorizedFailure for 401', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      final failure = AppErrorHandler.handleToFailure(dioException);
      expect(failure, isA<UnauthorizedFailure>());
    });

    test('returns ValidationFailure for 422', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'errors': {
              'email': ['البريد الإلكتروني غير صالح'],
            },
          },
        ),
      );

      final failure = AppErrorHandler.handleToFailure(dioException);
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'البريد الإلكتروني غير صالح');
    });

    test('returns ServerFailure for 500', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      final failure = AppErrorHandler.handleToFailure(dioException);
      expect(failure, isA<ServerFailure>());
    });
  });

  group('AppErrorHandler.isNetworkError', () {
    test('identifies socket exceptions and connection errors', () {
      expect(
        AppErrorHandler.isNetworkError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        ),
        isTrue,
      );
      expect(
        AppErrorHandler.isNetworkError(const SocketException('no route')),
        isTrue,
      );
      expect(
        AppErrorHandler.isNetworkError(const NetworkFailure('فشل الاتصال')),
        isTrue,
      );
      expect(
        AppErrorHandler.isNetworkError('Failed host lookup error'),
        isTrue,
      );
    });
  });
}
