import 'package:dartz/dartz.dart';
import '../repository/cart_repository.dart';

/// Use case for updating the quantity of a cart line item (PUT /v1/cart/{id}).
class UpdateCartItemQuantityUseCase {
  final CartRepository _repository;

  const UpdateCartItemQuantityUseCase(this._repository);

  Future<Either<String, void>> call({
    required int cartItemId,
    required int qty,
  }) {
    return _repository.updateCartItemQuantity(cartItemId: cartItemId, qty: qty);
  }
}
