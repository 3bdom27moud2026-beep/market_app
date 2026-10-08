import 'package:dartz/dartz.dart';
import '../../../cart/domain/entities/order_entity.dart';
import '../repository/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  const GetOrderDetailsUseCase({required this.repository});

  Future<Either<String, OrderEntity>> call(int orderId) {
    return repository.getOrderDetails(orderId);
  }
}
