import 'package:dartz/dartz.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
