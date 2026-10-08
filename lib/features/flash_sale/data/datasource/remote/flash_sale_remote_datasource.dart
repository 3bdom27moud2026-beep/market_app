// ignore_for_file: prefer_initializing_formals
import 'package:dio/dio.dart';
import 'package:market/core/utils/api_client.dart';
import '../../models/flash_sale_model.dart';

/// Remote data source for flash sale API calls.
class FlashSaleRemoteDataSource {
  final ApiClient _apiClient;

  FlashSaleRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetches flash sale products from the API.
  Future<FlashSaleResponseModel> getFlashSale({
    String? category,
    String? sort,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'is_flash_sale': 'true',
        'page': page,
        'per_page': perPage,
      };
      if (category != null && category.isNotEmpty && category != 'الكل') {
        queryParams['category'] = category;
      }
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }

      Response response;
      try {
        response = await _apiClient.get(
          '/v1/products',
          queryParameters: queryParams,
        );
      } catch (_) {
        response = await _apiClient.get(
          '/v1/flash-sale',
          queryParameters: queryParams,
        );
      }

      final data = response.data as Map<String, dynamic>;
      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return FlashSaleResponseModel.fromJson(payload);
    } catch (_) {
      rethrow;
    }
  }
}
