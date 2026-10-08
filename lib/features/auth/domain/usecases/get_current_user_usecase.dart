import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  UserEntity? call() {
    return _repository.getCurrentUser();
  }
}
