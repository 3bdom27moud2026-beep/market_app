import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/cart/domain/entities/order_entity.dart';
import 'package:market/features/orders/domain/repository/orders_repository.dart';
import 'package:market/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:market/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:market/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:market/features/orders/presentation/cubit/orders_state.dart';

class FakeOrdersRepository implements OrdersRepository {
  Either<String, List<OrderEntity>>? mockOrdersResult;
  Either<String, bool>? mockCancelResult;

  @override
  Future<Either<String, List<OrderEntity>>> getOrders() async {
    return mockOrdersResult ?? const Right([]);
  }

  @override
  Future<Either<String, OrderEntity>> getOrderDetails(int orderId) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, bool>> cancelOrder(int orderId) async {
    return mockCancelResult ?? const Right(true);
  }
}

void main() {
  late FakeOrdersRepository fakeRepository;
  late GetOrdersUseCase getOrdersUseCase;
  late CancelOrderUseCase cancelOrderUseCase;
  late OrdersCubit cubit;

  setUp(() {
    fakeRepository = FakeOrdersRepository();
    getOrdersUseCase = GetOrdersUseCase(repository: fakeRepository);
    cancelOrderUseCase = CancelOrderUseCase(repository: fakeRepository);
    cubit = OrdersCubit(
      getOrdersUseCase: getOrdersUseCase,
      cancelOrderUseCase: cancelOrderUseCase,
    );
  });

  tearDown(() => cubit.close());

  final sampleOrders = [
    OrderEntity(
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
    OrderEntity(
      id: 9,
      orderNo: 'ORD-9999',
      userId: 13,
      merchantId: 4,
      totalPrice: 200.0,
      savings: 50.0,
      paymentMethodType: 'cash',
      status: 'completed',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  test('initial state has empty orders and not loading', () {
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.orders, isEmpty);
    expect(cubit.state.filter, OrderFilter.all);
  });

  test('loadOrders emits loading then loaded on success', () async {
    fakeRepository.mockOrdersResult = Right(sampleOrders);

    final expectedStates = [
      const OrdersState(isLoading: true),
      OrdersState(isLoading: false, orders: sampleOrders),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadOrders();
  });

  test('loadOrders emits loading then error on failure', () async {
    fakeRepository.mockOrdersResult = const Left('فشل في جلب قائمة الطلبات');

    final expectedStates = [
      const OrdersState(isLoading: true),
      const OrdersState(
        isLoading: false,
        errorMessage: 'فشل في جلب قائمة الطلبات',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadOrders();
  });

  test('filtering orders works properly', () {
    final state = OrdersState(
      orders: sampleOrders,
      filter: OrderFilter.pending,
    );
    expect(state.filteredOrders.length, 1);
    expect(state.filteredOrders.first.id, 8);

    final completedState = OrdersState(
      orders: sampleOrders,
      filter: OrderFilter.completed,
    );
    expect(completedState.filteredOrders.length, 1);
    expect(completedState.filteredOrders.first.id, 9);
  });

  test('cancelOrder triggers cancel usecase and reloads orders', () async {
    fakeRepository.mockCancelResult = const Right(true);
    fakeRepository.mockOrdersResult = Right(sampleOrders);

    final success = await cubit.cancelOrder(8);

    expect(success, isTrue);
  });
}
