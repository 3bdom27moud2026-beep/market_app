import 'package:dartz/dartz.dart';
import '../repository/cart_repository.dart';

/// Use case for adding a product to the shopping cart (POST /v1/cart).
class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase(this._repository);

  Future<Either<String, void>> call({
    required dynamic productId,
    required int quantity,
  }) {
    final int parsedId = productId is int
        ? productId
        : (int.tryParse(productId.toString()) ?? 0);

    return _repository.addToCart(productId: parsedId, qty: quantity);
  }
}
