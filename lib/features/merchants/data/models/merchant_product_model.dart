import 'package:market/features/merchants/domain/entities/merchant_product_entity.dart';

/// Data model for a product under a merchant.
class MerchantProductModel {
  final int id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double oldPrice;
  final String image;
  final List<String> thumbnails;
  final Map<String, String> specs;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFlashSale;
  final bool isActive;

  const MerchantProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.thumbnails,
    required this.specs,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.isFlashSale,
    required this.isActive,
  });

  factory MerchantProductModel.fromJson(Map<String, dynamic> json) {
    final rawThumbnails = json['thumbnails'];
    final List<String> thumbs = rawThumbnails is List
        ? rawThumbnails.map((e) => e.toString()).toList()
        : <String>[];

    final rawSpecs = json['specs'];
    final Map<String, String> specsMap = {};
    if (rawSpecs is Map<String, dynamic>) {
      rawSpecs.forEach((k, v) => specsMap[k] = v.toString());
    }

    return MerchantProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['old_price'] as num?)?.toDouble() ?? 0.0,
      image: json['image']?.toString() ?? '',
      thumbnails: thumbs,
      specs: specsMap,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isFlashSale: json['is_flash_sale'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  MerchantProductEntity toEntity() {
    return MerchantProductEntity(
      id: id,
      name: name,
      brand: brand,
      description: description,
      price: price,
      oldPrice: oldPrice,
      image: image,
      thumbnails: thumbnails,
      specs: specs,
      rating: rating,
      reviewCount: reviewCount,
      stock: stock,
      isFlashSale: isFlashSale,
      isActive: isActive,
    );
  }
}
