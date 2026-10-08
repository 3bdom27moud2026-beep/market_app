import 'package:dartz/dartz.dart';
import '../entities/cart_data_entity.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;

  const GetCartUseCase(this._repository);

  Future<Either<String, CartDataEntity>> call() {
    return _repository.getCart();
  }
}
