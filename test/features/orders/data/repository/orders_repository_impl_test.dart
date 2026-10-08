import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/cart/data/models/order_model.dart';
import 'package:market/features/orders/data/datasource/remote/orders_remote_datasource.dart';
import 'package:market/features/orders/data/repository/orders_repository_impl.dart';

class FakeOrdersRemoteDataSource implements OrdersRemoteDataSource {
  List<OrderModel>? mockOrders;
  OrderModel? mockOrderDetails;
  bool? mockCancelResult;
  Exception? shouldThrow;

  @override
  Future<List<OrderModel>> getOrders() async {
    if (shouldThrow != null) throw shouldThrow!;
    return mockOrders ?? [];
  }

  @override
  Future<OrderModel> getOrderDetails(int orderId) async {
    if (shouldThrow != null) throw shouldThrow!;
    return mockOrderDetails ??
        OrderModel(
          id: orderId,
          orderNo: 'ORD-$orderId',
          userId: 1,
          merchantId: 1,
          totalPrice: 100,
          savings: 10,
          paymentMethodType: 'cash',
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  @override
  Future<bool> cancelOrder(int orderId) async {
    if (shouldThrow != null) throw shouldThrow!;
    return mockCancelResult ?? true;
  }
}

void main() {
  late FakeOrdersRemoteDataSource fakeRemoteDataSource;
  late OrdersRepositoryImpl repository;

  setUp(() {
    fakeRemoteDataSource = FakeOrdersRemoteDataSource();
    repository = OrdersRepositoryImpl(remoteDataSource: fakeRemoteDataSource);
  });

  final testOrders = [
    OrderModel(
      id: 8,
      orderNo: 'ORD-5534',
      userId: 13,
      merchantId: 4,
      totalPrice: 1299.0,
      savings: 901.0,
      paymentMethodType: 'cash',
      status: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  test('getOrders returns Right(orders) on success', () async {
    fakeRemoteDataSource.mockOrders = testOrders;

    final result = await repository.getOrders();

    expect(result, isA<Right>());
    result.fold(
      (failure) => fail('Should be right'),
      (orders) => expect(orders.length, 1),
    );
  });

  test('getOrderDetails returns Right(order) on success', () async {
    fakeRemoteDataSource.mockOrderDetails = testOrders.first;

    final result = await repository.getOrderDetails(8);

    expect(result, isA<Right>());
    result.fold(
      (failure) => fail('Should be right'),
      (order) => expect(order.id, 8),
    );
  });

  test('getOrders returns Left(error) on exception', () async {
    fakeRemoteDataSource.shouldThrow = Exception('Server error');

    final result = await repository.getOrders();

    expect(result, isA<Left>());
  });

  test('cancelOrder returns Right(true) on success', () async {
    fakeRemoteDataSource.mockCancelResult = true;

    final result = await repository.cancelOrder(8);

    expect(result, const Right(true));
  });
}
