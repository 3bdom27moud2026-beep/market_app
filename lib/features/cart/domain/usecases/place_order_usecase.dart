import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repository/cart_repository.dart';

class PlaceOrderUseCase {
  final CartRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<Either<String, OrderEntity>> call({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) {
    return _repository.placeOrder(
      paymentMethod: paymentMethod,
      address: address,
      phone: phone,
      usePoints: usePoints,
      pointsToRedeem: pointsToRedeem,
    );
  }
}
