// ignore_for_file: prefer_initializing_formals
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/merchants/data/models/merchant_model.dart';
import 'package:market/features/merchants/data/models/merchant_product_model.dart';

/// Remote data source for merchant operations.
class MerchantsRemoteDataSource {
  final ApiClient _apiClient;

  MerchantsRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetch merchant details and products from GET /v1/merchants/{id}.
  Future<(MerchantModel, List<MerchantProductModel>)> getMerchantDetails(
    String id,
  ) async {
    final response = await _apiClient.get('/v1/merchants/$id');
    final raw = response.data;
    final Map<String, dynamic> data = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    final rawMerchant = data['merchant'] ?? data['data'] ?? data;
    final Map<String, dynamic> merchantJson = rawMerchant is Map
        ? Map<String, dynamic>.from(rawMerchant)
        : <String, dynamic>{};
    final merchant = MerchantModel.fromJson(merchantJson);

    final rawProducts =
        data['products'] ??
        (rawMerchant is Map ? rawMerchant['products'] : null);
    final List<MerchantProductModel> products = rawProducts is List
        ? rawProducts
              .whereType<Map>()
              .map(
                (e) =>
                    MerchantProductModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
        : [];

    return (merchant, products);
  }

  /// Fetch list of merchants belonging to [categoryId] from GET /v1/merchants,
  /// with automatic fallback to GET /v1/home partners if empty or unavailable.
  ///
  /// Always fetches all merchants first, then filters client-side by [categoryId]
  /// to avoid issues with unsupported API query parameters.
  Future<List<MerchantModel>> getMerchantsByCategory(String categoryId) async {
    List<MerchantModel> merchants = [];

    try {
      final response = await _apiClient.get(
        '/v1/merchants',
        queryParameters: {'per_page': 100},
      );
      final raw = response.data;
      final List<dynamic> listData;
      if (raw is List) {
        listData = raw;
      } else if (raw is Map) {
        // Handle paginated response: {"merchants": {"data": [...]}} or {"data": [...]}
        final merchantsVal = raw['merchants'];
        if (merchantsVal is List) {
          listData = merchantsVal;
        } else if (merchantsVal is Map && merchantsVal['data'] is List) {
          listData = merchantsVal['data'] as List;
        } else if (raw['partners'] is List) {
          listData = raw['partners'] as List;
        } else if (raw['data'] is List) {
          listData = raw['data'] as List;
        } else if (raw['data'] is Map && raw['data']['merchants'] is List) {
          listData = raw['data']['merchants'] as List;
        } else if (raw['data'] is Map &&
            raw['data']['merchants'] is Map &&
            raw['data']['merchants']['data'] is List) {
          listData = raw['data']['merchants']['data'] as List;
        } else {
          listData = [];
        }
      } else {
        listData = [];
      }

      merchants = listData
          .whereType<Map>()
          .map(
            (json) => MerchantModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (_) {
      // Ignored: fallback to /v1/home below
    }

    // Fallback to /v1/home partners if empty
    if (merchants.isEmpty) {
      try {
        final homeResponse = await _apiClient.get('/v1/home');
        final homeRaw = homeResponse.data;
        if (homeRaw is Map<String, dynamic>) {
          final payload = homeRaw['data'] is Map<String, dynamic>
              ? homeRaw['data'] as Map<String, dynamic>
              : homeRaw;
          if (payload['partners'] is List) {
            final partnersList = payload['partners'] as List;
            merchants = partnersList
                .map(
                  (json) =>
                      MerchantModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
          }
        }
      } catch (_) {}
    }

    // Filter client-side by categoryId
    if (categoryId.isNotEmpty) {
      final filtered = merchants.where((m) {
        final catId = m.categoryId.isNotEmpty
            ? m.categoryId
            : (m.categoryJson?['id']?.toString() ??
                  m.categoryJson?['category_id']?.toString() ??
                  '');
        return catId == categoryId;
      }).toList();
      return filtered;
    }

    return merchants;
  }
}
