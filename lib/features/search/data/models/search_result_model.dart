import 'package:equatable/equatable.dart';
import 'package:market/features/products/data/models/product_model.dart';
import 'package:market/features/merchants/data/models/merchant_model.dart';
import '../../domain/entities/search_result_entity.dart';

/// Data model for search response from API.
class SearchResultModel extends Equatable {
  final List<ProductModel> products;
  final List<MerchantModel> merchants;

  const SearchResultModel({
    this.products = const [],
    this.merchants = const [],
  });

  factory SearchResultModel.fromJson(dynamic json) {
    List<ProductModel> parsedProducts = [];
    List<MerchantModel> parsedMerchants = [];

    dynamic rootData = json;
    if (json is Map<String, dynamic>) {
      if (json['data'] != null) {
        rootData = json['data'];
      }
    }

    if (rootData is Map<String, dynamic>) {
      // 1. Parse products if present
      final dynamic productsRaw = rootData['products'] ?? rootData['items'];
      if (productsRaw is List) {
        parsedProducts = productsRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }

      // 2. Parse merchants if present
      final dynamic merchantsRaw = rootData['merchants'] ?? rootData['stores'];
      if (merchantsRaw is List) {
        parsedMerchants = merchantsRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => MerchantModel.fromJson(item))
            .toList();
      }
    } else if (rootData is List) {
      // Flat list of results - categorize by presence of specific fields
      for (final item in rootData) {
        if (item is Map<String, dynamic>) {
          // If it has 'price' or 'store' or 'specs', treat as product
          if (item.containsKey('price') ||
              item.containsKey('old_price') ||
              item.containsKey('brand')) {
            parsedProducts.add(ProductModel.fromJson(item));
          } else if (item.containsKey('phone') ||
              item.containsKey('address') ||
              item.containsKey('is_wholesale')) {
            parsedMerchants.add(MerchantModel.fromJson(item));
          } else {
            // Default to product fallback
            parsedProducts.add(ProductModel.fromJson(item));
          }
        }
      }
    }

    return SearchResultModel(
      products: parsedProducts,
      merchants: parsedMerchants,
    );
  }

  SearchResultEntity toEntity() {
    return SearchResultEntity(
      products: products.map((m) => m.toEntity()).toList(),
      merchants: merchants.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [products, merchants];
}
