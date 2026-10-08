import 'package:dartz/dartz.dart';
import '../../../cart/domain/entities/order_entity.dart';
import '../repository/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository repository;

  const GetOrdersUseCase({required this.repository});

  Future<Either<String, List<OrderEntity>>> call() {
    return repository.getOrders();
  }
}
