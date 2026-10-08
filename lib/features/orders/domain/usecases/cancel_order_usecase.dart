import 'package:dartz/dartz.dart';
import '../repository/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository repository;

  const CancelOrderUseCase({required this.repository});

  Future<Either<String, bool>> call(int orderId) {
    return repository.cancelOrder(orderId);
  }
}
