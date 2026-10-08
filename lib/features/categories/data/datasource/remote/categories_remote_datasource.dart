// ignore_for_file: prefer_initializing_formals
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/categories/data/models/category_model.dart';
import 'package:market/features/categories/data/models/banner_model.dart';

/// Remote data source for categories feature.
///
/// Fetches categories data from the API using [ApiClient].
class CategoriesRemoteDataSource {
  final ApiClient _apiClient;

  CategoriesRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetches categories data from the API.
  ///
  /// Returns a tuple of (BannerModel, List&lt;CategoryModel&gt;).
  Map<String, int>? _cachedMerchantsCounts;

  Future<Map<String, int>> _fetchMerchantsCounts() async {
    if (_cachedMerchantsCounts != null && _cachedMerchantsCounts!.isNotEmpty) {
      return _cachedMerchantsCounts!;
    }
    try {
      final response = await _apiClient.get(
        '${EndPoints.merchants}?per_page=100',
      );
      final raw = response.data;
      List<dynamic> merchantsList = [];
      if (raw is List) {
        merchantsList = raw;
      } else if (raw is Map) {
        final merchantsVal = raw['merchants'];
        if (merchantsVal is List) {
          merchantsList = merchantsVal;
        } else if (merchantsVal is Map && merchantsVal['data'] is List) {
          merchantsList = merchantsVal['data'] as List;
        } else if (raw['partners'] is List) {
          merchantsList = raw['partners'] as List;
        } else if (raw['data'] is List) {
          merchantsList = raw['data'] as List;
        }
      }
      final Map<String, int> counts = {};
      for (final item in merchantsList) {
        if (item is Map) {
          final catId =
              item['category_id']?.toString() ??
              (item['category'] is Map
                  ? item['category']['id']?.toString()
                  : null) ??
              '';
          if (catId.isNotEmpty) {
            counts[catId] = (counts[catId] ?? 0) + 1;
          }
          if (item['category'] is Map) {
            final catName = item['category']['name']?.toString() ?? '';
            if (catName.isNotEmpty) {
              counts[catName] = (counts[catName] ?? 0) + 1;
            }
          }
        }
      }
      _cachedMerchantsCounts = counts;
      return counts;
    } catch (_) {
      return {};
    }
  }

  Future<Tuple2<BannerModel, List<CategoryModel>>> getCategories() async {
    try {
      final responses = await Future.wait([
        _apiClient.get(EndPoints.categories),
        _fetchMerchantsCounts(),
      ]);

      final response = responses[0] as dynamic;
      final counts = responses[1] as Map<String, int>;

      final rawData = response.data;
      final Map<String, dynamic> data;

      if (rawData is List) {
        data = {'categories': rawData};
      } else if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is List) {
          data = {'categories': rawData['data']};
        } else if (rawData['data'] is Map<String, dynamic>) {
          data = rawData['data'] as Map<String, dynamic>;
        } else {
          data = rawData;
        }
      } else {
        data = {};
      }

      final bannerJson = data['banner'] as Map<String, dynamic>?;
      final banner = bannerJson != null
          ? BannerModel.fromJson(bannerJson)
          : BannerModel(
              title: 'الفئات',
              subtitle: 'تصفح الفئات المتاحة',
              image: '',
            );

      final categoriesJson = data['categories'] as List<dynamic>? ?? [];
      final categories = categoriesJson.map((json) {
        final model = CategoryModel.fromJson(json as Map<String, dynamic>);
        final count =
            counts[model.id] ?? counts[model.name] ?? model.storesCount;
        return CategoryModel(
          id: model.id,
          name: model.name,
          icon: model.icon,
          storesCount: count,
          color: model.color,
          iconColor: model.iconColor,
          slug: model.slug,
          type: model.type,
        );
      }).toList();

      return Tuple2(banner, categories);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches categories filtered by search query.
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final responses = await Future.wait([
        _apiClient.get(
          EndPoints.categories,
          queryParameters: {'search': query},
        ),
        _fetchMerchantsCounts(),
      ]);

      final response = responses[0] as dynamic;
      final counts = responses[1] as Map<String, int>;

      final rawData = response.data;
      final List<dynamic> categoriesJson;
      if (rawData is List) {
        categoriesJson = rawData;
      } else if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is List) {
          categoriesJson = rawData['data'] as List<dynamic>;
        } else {
          categoriesJson = rawData['categories'] as List<dynamic>? ?? [];
        }
      } else {
        categoriesJson = [];
      }

      return categoriesJson.map((json) {
        final model = CategoryModel.fromJson(json as Map<String, dynamic>);
        final count =
            counts[model.id] ?? counts[model.name] ?? model.storesCount;
        return CategoryModel(
          id: model.id,
          name: model.name,
          icon: model.icon,
          storesCount: count,
          color: model.color,
          iconColor: model.iconColor,
          slug: model.slug,
          type: model.type,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches categories by purchase mode.
  Future<List<CategoryModel>> getCategoriesByMode(String mode) async {
    try {
      final responses = await Future.wait([
        _apiClient.get(EndPoints.categories, queryParameters: {'mode': mode}),
        _fetchMerchantsCounts(),
      ]);

      final response = responses[0] as dynamic;
      final counts = responses[1] as Map<String, int>;

      final rawData = response.data;
      final List<dynamic> categoriesJson;
      if (rawData is List) {
        categoriesJson = rawData;
      } else if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is List) {
          categoriesJson = rawData['data'] as List<dynamic>;
        } else {
          categoriesJson = rawData['categories'] as List<dynamic>? ?? [];
        }
      } else {
        categoriesJson = [];
      }

      return categoriesJson.map((json) {
        final model = CategoryModel.fromJson(json as Map<String, dynamic>);
        final count =
            counts[model.id] ?? counts[model.name] ?? model.storesCount;
        return CategoryModel(
          id: model.id,
          name: model.name,
          icon: model.icon,
          storesCount: count,
          color: model.color,
          iconColor: model.iconColor,
          slug: model.slug,
          type: model.type,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}

/// Simple tuple class for returning two values.
class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  const Tuple2(this.item1, this.item2);
}
