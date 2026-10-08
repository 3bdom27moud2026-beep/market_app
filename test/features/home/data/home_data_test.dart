import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/home/data/datasource/remote/home_remote_datasource.dart';
import 'package:market/features/home/data/models/home_data_model.dart';

class FakeApiClient extends Fake implements ApiClient {
  Response? homeResponse;
  Response? productsResponse;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (path.contains('/v1/products')) {
      if (productsResponse != null) return productsResponse as Response<T>;
      return Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data:
            {
                  'status': true,
                  'data': [
                    {
                      'id': 101,
                      'name': 'Fallback Product 1',
                      'price': 150.0,
                      'original_price': 200.0,
                    },
                  ],
                }
                as T,
      );
    }
    if (path.contains('/v1/merchants')) {
      return Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data:
            {
                  'merchants': {
                    'data': [
                      {'id': 1, 'category_id': 1, 'name': 'Merchant 1'},
                      {'id': 2, 'category_id': 1, 'name': 'Merchant 2'},
                    ],
                  },
                }
                as T,
      );
    }
    return (homeResponse as Response<T>?) ??
        Response<T>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data:
              {
                    'status': true,
                    'data': {
                      'categories': [
                        {'id': 1, 'name': 'Cat 1'},
                      ],
                      'best_sellers': [
                        {
                          'id': 10,
                          'name': 'Best Seller Product 1',
                          'price': 100.0,
                        },
                      ],
                    },
                  }
                  as T,
        );
  }
}

void main() {
  group('HomeDataModel Parsing Regression Tests', () {
    test('parses newest_products correctly when present', () {
      final json = {
        'status': true,
        'data': {
          'newest_products': [
            {
              'id': 1,
              'name': 'New Product 1',
              'price': 99.0,
              'original_price': 120.0,
              'rating': 4.5,
            },
          ],
        },
      };

      final model = HomeDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
      expect(model.newestProducts.length, 1);
      expect(model.newestProducts.first.title, 'New Product 1');
      expect(model.newestProducts.first.price, 99.0);
    });

    test('falls back to best_sellers when newest_products is absent', () {
      final json = {
        'status': true,
        'data': {
          'best_sellers': [
            {'id': 2, 'name': 'Best Seller Product', 'price': 250.0},
          ],
        },
      };

      final model = HomeDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
      expect(model.newestProducts.length, 1);
      expect(model.newestProducts.first.title, 'Best Seller Product');
    });
  });

  group('HomeRemoteDataSource Products Flow Tests', () {
    test(
      'fetches secondary products endpoint when home payload has empty newestProducts',
      () async {
        final fakeApi = FakeApiClient();
        final dataSource = HomeRemoteDataSource(apiClient: fakeApi);

        final homeData = await dataSource.getHomeData();

        expect(homeData.newestProducts.isNotEmpty, isTrue);
        expect(homeData.newestProducts.first.id, isNotNull);
      },
    );

    test(
      'enriches home categories with storesCount calculated from merchants endpoint',
      () async {
        final fakeApi = FakeApiClient();
        final dataSource = HomeRemoteDataSource(apiClient: fakeApi);

        final homeData = await dataSource.getHomeData();

        expect(homeData.categories.isNotEmpty, isTrue);
        final cat1 = homeData.categories.firstWhere((c) => c.id == '1');
        expect(cat1.storesCount, 2);
      },
    );
  });
}
