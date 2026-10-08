import 'package:dartz/dartz.dart';
import '../entities/merchant_entity.dart';
import '../repository/cart_repository.dart';

class RemoveCartItemUseCase {
  final CartRepository _repository;

  const RemoveCartItemUseCase(this._repository);

  Future<Either<String, List<MerchantEntity>>> call(String itemId) {
    return _repository.removeCartItem(itemId);
  }
}
