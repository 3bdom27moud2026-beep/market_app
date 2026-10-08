import 'package:dartz/dartz.dart';
import '../../../cart/domain/entities/order_entity.dart';

abstract class OrdersRepository {
  /// Fetches order history for the authenticated user.
  Future<Either<String, List<OrderEntity>>> getOrders();

  /// Fetches specific order details by ID.
  Future<Either<String, OrderEntity>> getOrderDetails(int orderId);

  /// Cancels an active order by ID.
  Future<Either<String, bool>> cancelOrder(int orderId);
}
