import 'package:dartz/dartz.dart';
import '../repository/cart_repository.dart';

/// Use case for clearing the entire cart (DELETE /v1/cart-clear).
class ClearCartUseCase {
  final CartRepository _repository;

  const ClearCartUseCase(this._repository);

  Future<Either<String, void>> call() {
    return _repository.clearCart();
  }
}
