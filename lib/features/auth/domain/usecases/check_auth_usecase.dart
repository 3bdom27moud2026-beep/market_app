import 'package:market/features/auth/domain/repository/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository _repository;

  CheckAuthUseCase(this._repository);

  bool call() {
    return _repository.isLoggedIn();
  }
}
