import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/location/data/datasource/remote/location_remote_datasource.dart';

class FakeApiClient implements ApiClient {
  String? lastPostPath;
  dynamic lastPostData;
  bool shouldThrowOnPost = false;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  void dispose() {}

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return Response<T>(
      data:
          [
                {
                  'id': 1,
                  'name': 'البحيرة',
                  'centers': [
                    {
                      'id': 10,
                      'name': 'دمنهور',
                      'areas': [
                        {'id': 101, 'name': 'شبرا'},
                      ],
                    },
                  ],
                },
              ]
              as dynamic,
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
    if (shouldThrowOnPost) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        response: Response(
          statusCode: 404,
          data: {
            'message': "The route api/v1/locations/user could not be found.",
          },
          requestOptions: RequestOptions(path: path),
        ),
      );
    }
    return Response<T>(
      data: {'status': true} as dynamic,
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
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}

void main() {
  late FakeApiClient fakeApiClient;
  late LocationRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeApiClient();
    dataSource = LocationRemoteDataSourceImpl(fakeApiClient);
  });

  group('LocationRemoteDataSource saveUserLocation Tests', () {
    test('sends payload to endpoint when available', () async {
      await dataSource.saveUserLocation(
        governorateId: 1,
        centerId: 10,
        areaId: 101,
      );

      expect(fakeApiClient.lastPostPath, equals('${EndPoints.location}/user'));
      expect(
        fakeApiClient.lastPostData,
        equals({'governorate_id': 1, 'center_id': 10, 'area_id': 101}),
      );
    });

    test(
      'handles 404 or network error gracefully without throwing exception',
      () async {
        fakeApiClient.shouldThrowOnPost = true;

        // Must complete without throwing
        await expectLater(
          dataSource.saveUserLocation(
            governorateId: 1,
            centerId: 10,
            areaId: 101,
          ),
          completes,
        );
      },
    );
  });
}
