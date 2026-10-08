import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  StreamSubscription<AuthEvent>? _authSubscription;

  OrdersCubit({
    required this.getOrdersUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrdersState()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn) {
        loadOrders();
      } else if (event.type == AuthEventType.loggedOut) {
        emit(const OrdersState());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> loadOrders() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getOrdersUseCase();
    if (isClosed) return;
    result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, errorMessage: error));
        }
      },
      (orders) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              orders: orders,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  void setFilter(OrderFilter filter) {
    if (isClosed) return;
    emit(state.copyWith(filter: filter));
  }

  Future<bool> cancelOrder(int orderId) async {
    if (isClosed) return false;
    emit(state.copyWith(isCancelling: true, cancelMessage: null));
    final result = await cancelOrderUseCase(orderId);
    if (isClosed) return false;
    return result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(isCancelling: false, errorMessage: error));
        }
        return false;
      },
      (success) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isCancelling: false,
              cancelMessage: 'تم إلغاء الطلب بنجاح',
            ),
          );
          loadOrders();
        }
        return true;
      },
    );
  }
}
