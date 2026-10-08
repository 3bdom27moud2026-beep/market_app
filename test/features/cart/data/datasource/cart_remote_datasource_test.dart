import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/cart/data/datasource/remote/cart_remote_datasource.dart';

class FakeApiClient implements ApiClient {
  String? lastGetPath;
  String? lastPostPath;
  String? lastPutPath;
  String? lastDeletePath;
  dynamic lastPostData;
  dynamic lastPutData;

  Response<dynamic>? mockGetResponse;
  Response<dynamic>? mockPostResponse;
  Response<dynamic>? mockPutResponse;
  Response<dynamic>? mockDeleteResponse;

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
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastPutPath = path;
    lastPutData = data;
    return (mockPutResponse as Response<T>?) ??
        Response<T>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: path),
        );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastDeletePath = path;
    return (mockDeleteResponse as Response<T>?) ??
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
  late CartRemoteDataSource dataSource;

  setUp(() {
    fakeApiClient = FakeApiClient();
    dataSource = CartRemoteDataSource(apiClient: fakeApiClient);
  });

  group('CartRemoteDataSource', () {
    const mockCartJson = {
      "status": true,
      "is_member": true,
      "cart": [
        {
          "id": 16,
          "qty": 2,
          "line_total": 130,
          "line_savings": 110,
          "product": {
            "id": 5,
            "merchant_id": 6,
            "name": "مشروب لاتيه",
            "price": 65,
            "old_price": 120,
            "merchant": {"id": 6, "name": "ستاربكس"},
          },
        },
      ],
      "cart_total": 130,
      "cart_savings": 110,
      "cart_count": 1,
    };

    test(
      'getCart should call GET /v1/cart and return parsed CartResponseModel',
      () async {
        fakeApiClient.mockGetResponse = Response(
          data: mockCartJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.userCart),
        );

        final result = await dataSource.getCart();

        expect(fakeApiClient.lastGetPath, EndPoints.userCart);
        expect(result.status, true);
        expect(result.cartTotal, 130);
        expect(result.cart.length, 1);
        expect(result.cart.first.id, 16);
      },
    );

    test(
      'addToCart should send exact payload {product_id: int, qty: int} and NO quantity field',
      () async {
        fakeApiClient.mockPostResponse = Response(
          data: {'status': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.userCart),
        );

        await dataSource.addToCart(productId: 5, qty: 2);

        expect(fakeApiClient.lastPostPath, EndPoints.userCart);
        expect(fakeApiClient.lastPostData, {'product_id': 5, 'qty': 2});
        expect(
          (fakeApiClient.lastPostData as Map).containsKey('quantity'),
          isFalse,
        );
      },
    );

    test(
      'updateCartItemQuantity should send PUT /v1/cart/{id} with {qty: int}',
      () async {
        fakeApiClient.mockPutResponse = Response(
          data: {'status': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: '${EndPoints.userCart}/16'),
        );

        await dataSource.updateCartItemQuantity(cartItemId: 16, qty: 3);

        expect(fakeApiClient.lastPutPath, '${EndPoints.userCart}/16');
        expect(fakeApiClient.lastPutData, {'qty': 3});
      },
    );

    test('deleteCartItem should send DELETE /v1/cart/{id}', () async {
      fakeApiClient.mockDeleteResponse = Response(
        data: {'status': true},
        statusCode: 200,
        requestOptions: RequestOptions(path: '${EndPoints.userCart}/16'),
      );

      await dataSource.deleteCartItem(16);

      expect(fakeApiClient.lastDeletePath, '${EndPoints.userCart}/16');
    });

    test('clearCart should send DELETE /v1/cart-clear', () async {
      fakeApiClient.mockDeleteResponse = Response(
        data: {'status': true},
        statusCode: 200,
        requestOptions: RequestOptions(path: EndPoints.cartClear),
      );

      await dataSource.clearCart();

      expect(fakeApiClient.lastDeletePath, EndPoints.cartClear);
    });

    test(
      'placeOrder should send POST /v1/orders with exact {"payment_method": "cash"}',
      () async {
        fakeApiClient.mockPostResponse = Response(
          data: {
            'status': true,
            'message': 'تم تسجيل الطلب بنجاح',
            'orders': [
              {
                'id': 8,
                'order_no': 'ORD-5534',
                'user_id': 13,
                'merchant_id': 4,
                'total_price': 1299,
                'savings': 901,
                'payment_method': 'cash',
                'status': 'pending',
                'created_at': '2026-08-17T19:06:32.000000Z',
                'updated_at': '2026-08-17T19:06:32.000000Z',
                'items': [],
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.orders),
        );

        final order = await dataSource.placeOrder(paymentMethod: 'cash');

        expect(fakeApiClient.lastPostPath, EndPoints.orders);
        expect(fakeApiClient.lastPostData, {'payment_method': 'cash'});
        expect(order.orderId, 'ORD-5534');
        expect(order.id, 8);
        expect(order.totalPrice, 1299.0);
      },
    );

    test('blocked operations should throw UnimplementedError', () async {
      expect(
        () => dataSource.updateItemQuantity(itemId: '16', newQuantity: 3),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => dataSource.removeCartItem('16'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
