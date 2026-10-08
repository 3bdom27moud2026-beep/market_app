import 'package:dartz/dartz.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterRequestModel request) {
    return _repository.register(request);
  }
}
