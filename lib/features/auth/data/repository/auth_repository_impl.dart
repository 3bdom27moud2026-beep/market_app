// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/error/failures.dart';
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
      return Left(_handleDioError(e));
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
      return Left(_handleDioError(e));
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

  /// Categorizes DioException into domain Failure types.
  Failure _handleDioError(DioException e) {
    if (AppErrorHandler.isNetworkError(e)) {
      return const NetworkFailure();
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    if (statusCode == 401) {
      return const UnauthorizedFailure();
    }

    if (responseData is Map<String, dynamic>) {
      final message =
          responseData['message']?.toString() ??
          responseData['error']?.toString();
      if (message != null && message.isNotEmpty) {
        if (message.contains('email')) {
          return const ValidationFailure('البريد الإلكتروني مسجل بالفعل');
        }
        if (message.contains('phone')) {
          return const ValidationFailure('رقم الهاتف مسجل بالفعل');
        }
      }
    }

    return AppErrorHandler.handleToFailure(e);
  }
}
