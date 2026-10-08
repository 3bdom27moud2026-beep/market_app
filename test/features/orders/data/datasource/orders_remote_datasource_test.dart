import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/orders/data/datasource/remote/orders_remote_datasource.dart';

class FakeApiClient implements ApiClient {
  String? lastGetPath;
  String? lastPostPath;
  dynamic lastPostData;

  Response<dynamic>? mockGetResponse;
  Response<dynamic>? mockPostResponse;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastGetPath = path;
    return (mockGetResponse as Response<T>?) ??
        Response<T>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: path),
        );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastPostPath = path;
    lastPostData = data;
    return (mockPostResponse as Response<T>?) ??
        Response<T>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: path),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeApiClient fakeApiClient;
  late OrdersRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeApiClient();
    dataSource = OrdersRemoteDataSourceImpl(apiClient: fakeApiClient);
  });

  final sampleOrdersResponse = {
    "status": true,
    "orders": [
      {
        "id": 8,
        "order_no": "ORD-5534",
        "user_id": 13,
        "merchant_id": 4,
        "total_price": 1299,
        "savings": 901,
        "payment_method": "cash",
        "status": "pending",
        "created_at": "2026-08-17T19:06:32.000000Z",
        "updated_at": "2026-08-17T19:06:32.000000Z",
        "merchant": {
          "id": 4,
          "category_id": 3,
          "area_id": 4,
          "name": "متجر ستايل للملابس",
          "description": "متجر ستايل للملابس",
          "image":
              "https://images.unsplash.com/photo-1441984904996-e0b6ba687e07?q=80&w=400",
          "phone": "01000000000",
          "whatsapp": "01012345678",
          "email": "merchant4@shopguide.com",
          "address": "مصر، الفرع الرئيسي للتاجر",
          "discount": "15%",
          "type": "retail",
          "rating": 4.9,
          "review_count": 120,
          "order_count": 112,
          "supports_installment": true,
          "is_wholesale": false,
          "status": "active",
          "distance": "3 كم",
        },
        "items": [
          {
            "id": 8,
            "order_id": 8,
            "product_id": 4,
            "qty": 1,
            "price": 1299,
            "savings": 901,
            "created_at": "2026-08-17T19:06:32.000000Z",
            "updated_at": "2026-08-17T19:06:32.000000Z",
            "product": {
              "id": 4,
              "merchant_id": 4,
              "name": "حذاء رياضي مريح للجري",
              "brand": "Nike",
              "price": 1299,
              "old_price": 2200,
              "image":
                  "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400",
            },
          },
        ],
      },
    ],
  };

  test(
    'getOrders returns list of OrderModel parsed correctly from response',
    () async {
      fakeApiClient.mockGetResponse = Response(
        data: sampleOrdersResponse,
        statusCode: 200,
        requestOptions: RequestOptions(path: EndPoints.orders),
      );

      final orders = await dataSource.getOrders();

      expect(fakeApiClient.lastGetPath, EndPoints.orders);
      expect(orders.length, 1);
      expect(orders.first.id, 8);
      expect(orders.first.orderNo, 'ORD-5534');
      expect(orders.first.totalPrice, 1299.0);
      expect(orders.first.savings, 901.0);
      expect(orders.first.status, 'pending');
      expect(orders.first.merchant?.name, 'متجر ستايل للملابس');
      expect(orders.first.items.length, 1);
      expect(orders.first.items.first.product.name, 'حذاء رياضي مريح للجري');
    },
  );

  test(
    'getOrderDetails returns single OrderModel parsed correctly from response',
    () async {
      fakeApiClient.mockGetResponse = Response(
        data: {
          'status': true,
          'order': (sampleOrdersResponse['orders'] as List).first,
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '${EndPoints.orders}/8'),
      );

      final order = await dataSource.getOrderDetails(8);

      expect(fakeApiClient.lastGetPath, '${EndPoints.orders}/8');
      expect(order.id, 8);
      expect(order.orderNo, 'ORD-5534');
      expect(order.totalPrice, 1299.0);
    },
  );

  test('cancelOrder calls correct endpoint and returns true', () async {
    fakeApiClient.mockPostResponse = Response(
      data: {'status': true, 'message': 'تم إلغاء الطلب'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '${EndPoints.orders}/8/cancel'),
    );

    final success = await dataSource.cancelOrder(8);

    expect(fakeApiClient.lastPostPath, '${EndPoints.orders}/8/cancel');
    expect(success, isTrue);
  });
}
