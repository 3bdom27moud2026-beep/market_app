import 'package:dartz/dartz.dart';
import '../entities/merchant_entity.dart';
import '../repository/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository _repository;

  const UpdateQuantityUseCase(this._repository);

  Future<Either<String, List<MerchantEntity>>> call({
    required String itemId,
    required int newQuantity,
  }) {
    return _repository.updateItemQuantity(
      itemId: itemId,
      newQuantity: newQuantity,
    );
  }
}
