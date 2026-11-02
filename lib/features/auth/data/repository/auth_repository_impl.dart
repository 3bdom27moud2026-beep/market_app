// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/core/utils/app_strings.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final userModel = await _remoteDataSource.register(request);
      await _localDataSource.saveAuthData(userModel);
      return Right(userModel);
    } on DioException catch (e) {
      return Left(_handleRegisterDioError(e));
    } catch (e) {
      return Left(
        AppErrorHandler.handleToFailure(
          e,
          defaultMessage: 'فشل في إنشاء الحساب، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request) async {
    try {
      final userModel = await _remoteDataSource.login(request);
      await _localDataSource.saveAuthData(userModel);
      return Right(userModel);
    } on DioException catch (e) {
      return Left(_handleLoginDioError(e));
    } catch (e) {
      return Left(
        AppErrorHandler.handleToFailure(
          e,
          defaultMessage: 'فشل في تسجيل الدخول، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.handleToFailure(
          e,
          defaultMessage: 'فشل في تسجيل الخروج',
        ),
      );
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return _localDataSource.getCachedUser();
  }

  @override
  bool isLoggedIn() {
    return _localDataSource.isLoggedIn();
  }

  /// Categorizes DioException specifically for login attempts.
  Failure _handleLoginDioError(DioException e) {
    if (AppErrorHandler.isNetworkError(e)) {
      return const NetworkFailure(AppStrings.networkError);
    }

    final statusCode = e.response?.statusCode;
    final message = AppErrorHandler.getMessage(
      e,
      defaultMessage: AppStrings.invalidCredentials,
    );

    // Safeguard: Ensure login failure never displays "Session expired"
    final cleanMessage = (message.contains('انتهت صلاحية الجلسة') ||
            message.toLowerCase().contains('unauthenticated') ||
            message.toLowerCase().contains('unauthorized'))
        ? AppStrings.invalidCredentials
        : message;

    if (statusCode == 401 || statusCode == 400 || statusCode == 422) {
      return ValidationFailure(cleanMessage);
    }

    return ServerFailure(cleanMessage, code: statusCode?.toString());
  }

  /// Categorizes DioException specifically for registration / card request attempts.
  Failure _handleRegisterDioError(DioException e) {
    if (AppErrorHandler.isNetworkError(e)) {
      return const NetworkFailure(AppStrings.networkError);
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    // Check specific validation errors
    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        if (errors.containsKey('phone')) {
          final val = errors['phone'];
          final msg = (val is List && val.isNotEmpty)
              ? val.first.toString().toLowerCase()
              : val.toString().toLowerCase();
          if (msg.contains('taken') || msg.contains('مسجل') || msg.contains('exists')) {
            return const ValidationFailure(AppStrings.phoneAlreadyRegistered);
          }
          if (msg.contains('digit') || msg.contains('11') || msg.contains('invalid')) {
            return const ValidationFailure('رقم الهاتف يجب أن يتكون من 11 رقماً صالحاً.');
          }
        }
        if (errors.containsKey('email')) {
          final val = errors['email'];
          final msg = (val is List && val.isNotEmpty)
              ? val.first.toString().toLowerCase()
              : val.toString().toLowerCase();
          if (msg.contains('taken') || msg.contains('مسجل') || msg.contains('exists')) {
            return const ValidationFailure(AppStrings.emailAlreadyRegistered);
          }
        }
        if (errors.containsKey('referral_code')) {
          return const ValidationFailure(AppStrings.invalidReferralCode);
        }
        if (errors.containsKey('password')) {
          return const ValidationFailure(AppStrings.passwordMinLength);
        }
        if (errors.containsKey('area_id')) {
          return const ValidationFailure(AppStrings.selectAreaPrompt);
        }
      }
    }

    final message = AppErrorHandler.getMessage(
      e,
      defaultMessage: 'تعذر إنشاء الحساب، يرجى مراجعة البيانات المدخلة والمحاولة مجدداً.',
    );

    final cleanMessage = (message.contains('انتهت صلاحية الجلسة') ||
            message.toLowerCase().contains('unauthenticated') ||
            message.toLowerCase().contains('unauthorized'))
        ? 'تعذر إنشاء الحساب، يرجى مراجعة البيانات المدخلة والمحاولة مجدداً.'
        : message;

    if (statusCode == 400 || statusCode == 422 || statusCode == 409) {
      return ValidationFailure(cleanMessage);
    }

    return ServerFailure(cleanMessage, code: statusCode?.toString());
  }
}
