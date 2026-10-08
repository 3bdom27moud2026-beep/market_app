import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/cart/data/models/order_model.dart';

abstract class OrdersRemoteDataSource {
  /// Fetches list of orders for the authenticated user.
  Future<List<OrderModel>> getOrders();

  /// Fetches details for a specific order by ID.
  Future<OrderModel> getOrderDetails(int orderId);

  /// Cancels an order with the given ID.
  Future<bool> cancelOrder(int orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;

  const OrdersRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await apiClient.get(EndPoints.orders);
      final rawData = response.data;

      List<dynamic> ordersList = [];
      if (rawData is Map<String, dynamic>) {
        if (rawData['orders'] is List) {
          ordersList = rawData['orders'] as List;
        } else if (rawData['data'] is List) {
          ordersList = rawData['data'] as List;
        }
      } else if (rawData is List) {
        ordersList = rawData;
      }

      return ordersList
          .map(
            (e) => OrderModel.fromJson(
              e is Map<String, dynamic> ? e : <String, dynamic>{},
            ),
          )
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<OrderModel> getOrderDetails(int orderId) async {
    try {
      final response = await apiClient.get('${EndPoints.orders}/$orderId');
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        if (rawData['order'] is Map<String, dynamic>) {
          return OrderModel.fromJson(rawData['order'] as Map<String, dynamic>);
        }
        if (rawData['data'] is Map<String, dynamic>) {
          return OrderModel.fromJson(rawData['data'] as Map<String, dynamic>);
        }
        return OrderModel.fromJson(rawData);
      }
      throw const FormatException('Invalid order details response');
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await apiClient.post(
        '${EndPoints.orders}/$orderId/cancel',
      );
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        return raw['status'] == true || raw['success'] == true;
      }
      return true;
    } catch (_) {
      rethrow;
    }
  }
}
