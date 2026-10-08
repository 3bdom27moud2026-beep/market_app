import 'package:dartz/dartz.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register(RegisterRequestModel request);
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request);
  Future<Either<Failure, void>> logout();
  UserEntity? getCurrentUser();
  bool isLoggedIn();
}
