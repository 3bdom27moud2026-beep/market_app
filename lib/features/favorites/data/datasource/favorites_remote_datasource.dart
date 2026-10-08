// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:market/core/utils/api_client.dart';
import '../../domain/entities/favorite_entity.dart';
import '../models/favorite_model.dart';

/// Remote data source for favorites operations.
class FavoritesRemoteDataSource {
  final ApiClient _apiClient;

  FavoritesRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetch favorites from GET /v1/favorites.
  ///
  /// Response shape: `{ "status": true, "favorites": [ ... ] }`
  Future<List<FavoriteModel>> getFavorites() async {
    final response = await _apiClient.get('/v1/favorites');
    final data = response.data;

    if (kDebugMode) {
      debugPrint('[FavoritesRemoteDataSource] getFavorites response: $data');
    }

    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      if (data['products'] is List) {
        list = data['products'] as List;
      } else if (data['favorites'] is List) {
        list = data['favorites'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      }
    } else if (data is List) {
      list = data;
    }

    return list
        .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch favorite merchants from GET /v1/favorites.
  Future<List<FavoriteMerchantEntity>> getFavoriteMerchants() async {
    List<dynamic> list = [];

    try {
      final response = await _apiClient.get('/v1/favorites');
      final data = response.data;

      if (kDebugMode) {
        debugPrint(
          '[FavoritesRemoteDataSource] getFavoriteMerchants response: $data',
        );
      }

      list = _extractMerchantsList(data);

      // If nothing found in /v1/favorites, try /v1/favorites?type=merchant
      if (list.isEmpty) {
        try {
          final queryResponse = await _apiClient.get(
            '/v1/favorites',
            queryParameters: {'type': 'merchant'},
          );
          final queryData = queryResponse.data;
          final queryList = _extractMerchantsList(queryData);
          if (queryList.isNotEmpty) {
            list = queryList;
          }
        } catch (_) {}
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FavoritesRemoteDataSource] Error fetching merchants: $e');
      }
      rethrow;
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => FavoriteMerchantEntity.fromJson(e))
        .toList();
  }

  List<dynamic> _extractMerchantsList(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['merchants'] is List) {
        return data['merchants'] as List;
      } else if (data['favorite_merchants'] is List) {
        return data['favorite_merchants'] as List;
      } else if (data['favoriteMerchants'] is List) {
        return data['favoriteMerchants'] as List;
      } else if (data['data'] is Map<String, dynamic>) {
        final innerData = data['data'] as Map<String, dynamic>;
        if (innerData['merchants'] is List) {
          return innerData['merchants'] as List;
        } else if (innerData['favorite_merchants'] is List) {
          return innerData['favorite_merchants'] as List;
        } else if (innerData['favoriteMerchants'] is List) {
          return innerData['favoriteMerchants'] as List;
        }
      } else if (data['data'] is List) {
        final dynamicList = data['data'] as List;
        return dynamicList.where((item) {
          if (item is Map) {
            return item.containsKey('merchant') ||
                item['type'] == 'merchant' ||
                item.containsKey('store_name') ||
                item.containsKey('merchant_id');
          }
          return false;
        }).toList();
      }
    } else if (data is List) {
      return data.where((item) {
        if (item is Map) {
          return item.containsKey('merchant') ||
              item['type'] == 'merchant' ||
              item.containsKey('store_name') ||
              item.containsKey('merchant_id');
        }
        return false;
      }).toList();
    }
    return [];
  }

  /// Toggle favorite via POST /v1/favorites/toggle.
  ///
  /// Payload: `{"type": "product"|"merchant", "id": 5, ...}`
  /// Response: `{ "status": true, "action": "added"/"removed", "message": "..." }`
  Future<bool> toggleFavorite(dynamic id, {String type = 'product'}) async {
    final int? idAsInt = id is int ? id : int.tryParse(id.toString());
    final Map<String, dynamic> payload = {'type': type, 'id': idAsInt ?? id};
    if (type == 'merchant') {
      payload['merchant_id'] = idAsInt ?? id;
    } else {
      payload['product_id'] = idAsInt ?? id;
    }

    final response = await _apiClient.post(
      '/v1/favorites/toggle',
      data: payload,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final action = data['action']?.toString();
      if (action != null) {
        return action == 'added';
      }
      if (data['is_favorite'] is bool) {
        return data['is_favorite'] as bool;
      }
      if (data['status'] == true) {
        return true;
      }
    }
    return true;
  }
}
