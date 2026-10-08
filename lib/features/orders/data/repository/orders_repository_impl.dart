import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../../cart/domain/entities/order_entity.dart';
import '../../domain/repository/orders_repository.dart';
import '../datasource/remote/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  const OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<OrderEntity>>> getOrders() async {
    try {
      final result = await remoteDataSource.getOrders();
      return Right(result);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في جلب قائمة الطلبات',
        ),
      );
    }
  }

  @override
  Future<Either<String, OrderEntity>> getOrderDetails(int orderId) async {
    try {
      final result = await remoteDataSource.getOrderDetails(orderId);
      return Right(result);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في جلب تفاصيل الطلب',
        ),
      );
    }
  }

  @override
  Future<Either<String, bool>> cancelOrder(int orderId) async {
    try {
      final result = await remoteDataSource.cancelOrder(orderId);
      return Right(result);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في إلغاء الطلب'),
      );
    }
  }
}
