import '../../domain/entities/favorite_entity.dart';

/// Data model for a favorite product from the API.
class FavoriteModel {
  final String id;
  final String name;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;

  const FavoriteModel({
    required this.id,
    required this.name,
    required this.store,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
  });

  /// Parse from API response.
  ///
  /// The API may wrap each item under a `product` key:
  /// `{ "id": 1, "product": { "id": 3, "name": "...", ... } }`
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    // Unwrap the product if nested
    final Map<String, dynamic> p = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : json;

    final double priceVal = (p['price'] as num?)?.toDouble() ?? 0.0;
    final double oldPriceVal =
        (p['old_price'] as num?)?.toDouble() ??
        (p['oldPrice'] as num?)?.toDouble() ??
        0.0;

    final String discountVal = (oldPriceVal > priceVal && oldPriceVal > 0)
        ? '${(((oldPriceVal - priceVal) / oldPriceVal) * 100).round()}%'
        : '';

    final String storeVal = p['merchant'] is Map<String, dynamic>
        ? ((p['merchant'] as Map<String, dynamic>)['name']?.toString() ?? '')
        : (p['brand']?.toString() ?? p['store']?.toString() ?? '');

    return FavoriteModel(
      id: p['id']?.toString() ?? json['id']?.toString() ?? '',
      name: p['name']?.toString() ?? '',
      store: storeVal,
      image: p['image']?.toString() ?? '',
      price: priceVal,
      oldPrice: oldPriceVal,
      rating: (p['rating'] as num?)?.toDouble() ?? 0.0,
      discount: discountVal,
    );
  }

  FavoriteEntity toEntity() => FavoriteEntity(
    id: id,
    name: name,
    store: store,
    image: image,
    price: price,
    oldPrice: oldPrice,
    rating: rating,
    discount: discount,
  );
}
