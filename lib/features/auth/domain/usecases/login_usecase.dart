import 'package:dartz/dartz.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginRequestModel request) {
    return _repository.login(request);
  }
}
