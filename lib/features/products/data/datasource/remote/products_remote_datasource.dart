// ignore_for_file: prefer_initializing_formals
import 'package:market/core/utils/api_client.dart';
import '../../models/product_model.dart';

/// Remote data source for product operations.
class ProductsRemoteDataSource {
  final ApiClient _apiClient;

  ProductsRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Get products list from GET /v1/products API.
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.get('/v1/products');
      final raw = response.data;
      final List<dynamic> listData;
      if (raw is List) {
        listData = raw;
      } else if (raw is Map<String, dynamic>) {
        if (raw['products'] is List) {
          listData = raw['products'] as List;
        } else if (raw['data'] is List) {
          listData = raw['data'] as List;
        } else {
          listData = [];
        }
      } else {
        listData = [];
      }

      return listData
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  /// Get product details by [id] from GET /v1/products/$id.
  Future<ProductModel> getProductDetails(String id) async {
    try {
      final response = await _apiClient.get('/v1/products/$id');
      final data = response.data as Map<String, dynamic>;
      final Map<String, dynamic> payload;

      if (data['product'] is Map<String, dynamic>) {
        payload = data['product'] as Map<String, dynamic>;
      } else if (data['data'] is Map<String, dynamic>) {
        payload = data['data'] as Map<String, dynamic>;
      } else {
        payload = data;
      }

      return ProductModel.fromJson(payload);
    } catch (_) {
      rethrow;
    }
  }

  /// Fetches all products from GET /v1/products and filters by
  /// [categoryId], matching against each product's merchant.category_id field.
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _apiClient.get(
        '/v1/products',
        queryParameters: categoryId.isNotEmpty
            ? {'category_id': categoryId}
            : null,
      );
      final raw = response.data;
      final List<dynamic> listData;
      if (raw is List) {
        listData = raw;
      } else if (raw is Map<String, dynamic>) {
        if (raw['products'] is List) {
          listData = raw['products'] as List;
        } else if (raw['data'] is List) {
          listData = raw['data'] as List;
        } else {
          listData = [];
        }
      } else {
        listData = [];
      }

      // Parse all products and filter by merchant.category_id == categoryId
      final allProducts = listData
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (categoryId.isEmpty) return allProducts;

      final filtered = allProducts
          .where((product) => product.merchantCategoryId == categoryId)
          .toList();

      return filtered;
    } catch (_) {
      rethrow;
    }
  }

  /// Toggle favorite status for a product via POST /v1/favorites/toggle.
  ///
  /// Sends `{ "product_id": <int> }` and reads `"action"` from response.
  /// Returns `true` when action is "added", `false` when "removed".
  Future<bool> toggleFavorite(String productId) async {
    final int? idAsInt = int.tryParse(productId);
    final response = await _apiClient.post(
      '/v1/favorites/toggle',
      data: {'product_id': idAsInt ?? productId},
    );
    final data = response.data as Map<String, dynamic>;
    // API returns: { "status": true, "action": "added"/"removed", "message": "..." }
    final action = data['action']?.toString();
    return action == 'added';
  }
}
