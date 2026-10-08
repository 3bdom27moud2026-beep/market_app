// ignore_for_file: prefer_initializing_formals
import 'package:dio/dio.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/home/data/models/home_data_model.dart';
import 'package:market/features/home/data/models/newest_product_model.dart';
import 'package:market/features/home/data/models/best_seller_model.dart';
import 'package:market/features/home/data/models/flash_sale_product_model.dart';
import 'package:market/features/home/data/models/category_model.dart';

/// Remote data source for the home screen.
///
/// Fetches data from the API using [ApiClient].
class HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response?> _safeGet(String endpoint) async {
    try {
      return await _apiClient.get(endpoint);
    } catch (_) {
      return null;
    }
  }

  /// Fetches home screen data from the API with high-speed primary loading.
  Future<HomeDataModel> getHomeData() async {
    try {
      final homeResponse = await _apiClient.get(EndPoints.home);

      final rawData = homeResponse.data;
      Map<String, dynamic> rawPayload = {};
      if (rawData is Map<String, dynamic>) {
        rawPayload = rawData['data'] is Map<String, dynamic>
            ? rawData['data'] as Map<String, dynamic>
            : rawData;
      }

      HomeDataModel homeData = HomeDataModel.fromJson(
        Map<String, dynamic>.from(rawPayload),
      );

      // Always fetch merchants endpoint to calculate real stores_count per category
      final bool needsBestSellers = homeData.bestSellers.isEmpty;
      final bool needsNewest = homeData.newestProducts.isEmpty;
      final bool needsFlashSale = homeData.flashSale.isEmpty;

      // Fetch missing sections + merchants (for stores_count) in parallel
      final responses = await Future.wait([
        needsBestSellers
            ? _safeGet(EndPoints.bestSellingProducts)
            : Future.value(null),
        needsNewest ? _safeGet(EndPoints.products) : Future.value(null),
        needsFlashSale
            ? _safeGet(EndPoints.flashSaleProducts)
            : Future.value(null),
        _safeGet('${EndPoints.merchants}?per_page=100'),
      ]);

      final bestSellingResponse = responses[0];
      final productsResponse = responses[1];
      final flashSaleResponse = responses[2];
      final merchantsResponse = responses[3];

      // Enrich home categories with exact stores_count calculated from /v1/merchants
      List<CategoryModel> enrichedCategories = homeData.categories;
      if (merchantsResponse != null) {
        final raw = merchantsResponse.data;
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
          } else if (raw['data'] is Map && raw['data']['merchants'] is List) {
            merchantsList = raw['data']['merchants'] as List;
          } else if (raw['data'] is Map &&
              raw['data']['merchants'] is Map &&
              raw['data']['merchants']['data'] is List) {
            merchantsList = raw['data']['merchants']['data'] as List;
          }
        }

        if (merchantsList.isNotEmpty) {
          // Count merchants per category ID and name
          final Map<String, int> countsById = {};
          final Map<String, int> countsByName = {};
          for (final item in merchantsList) {
            if (item is Map) {
              final catId =
                  item['category_id']?.toString() ??
                  (item['category'] is Map
                      ? item['category']['id']?.toString()
                      : null) ??
                  '';
              if (catId.isNotEmpty) {
                countsById[catId] = (countsById[catId] ?? 0) + 1;
              }
              if (item['category'] is Map) {
                final catName = item['category']['name']?.toString() ?? '';
                if (catName.isNotEmpty) {
                  countsByName[catName] = (countsByName[catName] ?? 0) + 1;
                }
              }
            }
          }

          enrichedCategories = homeData.categories.map((cat) {
            final count = countsById[cat.id] ?? countsByName[cat.title] ?? 0;
            return CategoryModel(
              id: cat.id,
              title: cat.title,
              icon: cat.icon,
              color: cat.color,
              iconColor: cat.iconColor,
              storesCount: count,
            );
          }).toList();
        }
      }

      // 1. Process Best Sellers response if needed
      List<BestSellerModel> fetchedBestSellers = homeData.bestSellers;
      if (fetchedBestSellers.isEmpty && bestSellingResponse != null) {
        final bsList = _extractList(bestSellingResponse.data);
        if (bsList.isNotEmpty) {
          fetchedBestSellers = bsList
              .whereType<Map<String, dynamic>>()
              .map((e) => BestSellerModel.fromJson(e))
              .toList();
        }
      }

      // 2. Process Newest Products response if needed
      List<NewestProductModel> fetchedNewest = homeData.newestProducts;
      if (fetchedNewest.isEmpty && productsResponse != null) {
        final pList = _extractList(productsResponse.data);
        if (pList.isNotEmpty) {
          fetchedNewest = pList
              .whereType<Map<String, dynamic>>()
              .map((e) => NewestProductModel.fromJson(e))
              .toList();
        }
      }

      // Fallback: If newest products are still empty, fall back to best sellers
      if (fetchedNewest.isEmpty && fetchedBestSellers.isNotEmpty) {
        fetchedNewest = fetchedBestSellers
            .map(
              (bs) => NewestProductModel(
                id: bs.id,
                title: bs.title,
                store: bs.brand.isNotEmpty ? bs.brand : bs.merchantName,
                image: bs.image,
                price: bs.price,
                oldPrice: bs.oldPrice,
                rating: bs.rating,
                discount: bs.discount,
              ),
            )
            .toList();
      }

      // 3. Process Flash Sale response if needed
      List<FlashSaleProductModel> fetchedFlashSale = homeData.flashSale;
      if (fetchedFlashSale.isEmpty && flashSaleResponse != null) {
        final fsList = _extractList(flashSaleResponse.data);
        if (fsList.isNotEmpty) {
          fetchedFlashSale = fsList
              .whereType<Map<String, dynamic>>()
              .map((e) => FlashSaleProductModel.fromJson(e))
              .toList();
        }
      }

      return HomeDataModel(
        offers: homeData.offers,
        flashSale: fetchedFlashSale,
        categories: enrichedCategories,
        bestSellers: fetchedBestSellers,
        partners: homeData.partners,
        newestProducts: fetchedNewest,
        featuredAd: homeData.featuredAd,
        isMember: homeData.isMember,
      );
    } catch (_) {
      rethrow;
    }
  }

  /// Helper to extract a list of maps from dynamic response payloads.
  List<dynamic> _extractList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      for (final key in [
        'products',
        'data',
        'items',
        'newest_products',
        'newestProducts',
        'latest_products',
        'latestProducts',
        'best_sellers',
        'bestSellers',
      ]) {
        final val = raw[key];
        if (val is List) return val;
      }
      if (raw['data'] is Map<String, dynamic>) {
        final inner = raw['data'] as Map<String, dynamic>;
        for (final key in [
          'products',
          'data',
          'items',
          'newest_products',
          'newestProducts',
          'latest_products',
          'latestProducts',
          'best_sellers',
          'bestSellers',
        ]) {
          final val = inner[key];
          if (val is List) return val;
        }
      }
    }
    return [];
  }
}
