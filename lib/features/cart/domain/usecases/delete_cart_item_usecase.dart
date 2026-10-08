import 'package:dartz/dartz.dart';
import '../repository/cart_repository.dart';

/// Use case for deleting a cart line item (DELETE /v1/cart/{id}).
class DeleteCartItemUseCase {
  final CartRepository _repository;

  const DeleteCartItemUseCase(this._repository);

  Future<Either<String, void>> call(int cartItemId) {
    return _repository.deleteCartItem(cartItemId);
  }
}
