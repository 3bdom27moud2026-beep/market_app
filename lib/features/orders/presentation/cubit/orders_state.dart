import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/order_entity.dart';

enum OrderFilter { all, pending, completed, cancelled }

class OrdersState extends Equatable {
  final bool isLoading;
  final bool isCancelling;
  final List<OrderEntity> orders;
  final OrderFilter filter;
  final String? errorMessage;
  final String? cancelMessage;

  const OrdersState({
    this.isLoading = false,
    this.isCancelling = false,
    this.orders = const [],
    this.filter = OrderFilter.all,
    this.errorMessage,
    this.cancelMessage,
  });

  List<OrderEntity> get filteredOrders {
    switch (filter) {
      case OrderFilter.pending:
        return orders
            .where(
              (o) =>
                  o.status.toLowerCase() == 'pending' ||
                  o.status.toLowerCase() == 'processing' ||
                  o.status.toLowerCase() == 'confirmed',
            )
            .toList();
      case OrderFilter.completed:
        return orders
            .where(
              (o) =>
                  o.status.toLowerCase() == 'completed' ||
                  o.status.toLowerCase() == 'delivered',
            )
            .toList();
      case OrderFilter.cancelled:
        return orders
            .where(
              (o) =>
                  o.status.toLowerCase() == 'cancelled' ||
                  o.status.toLowerCase() == 'canceled',
            )
            .toList();
      case OrderFilter.all:
        return orders;
    }
  }

  OrdersState copyWith({
    bool? isLoading,
    bool? isCancelling,
    List<OrderEntity>? orders,
    OrderFilter? filter,
    String? errorMessage,
    String? cancelMessage,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      orders: orders ?? this.orders,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
      cancelMessage: cancelMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isCancelling,
    orders,
    filter,
    errorMessage,
    cancelMessage,
  ];
}
