/// Represents a single favorite product item.
class FavoriteEntity {
  final String id;
  final String name;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;

  const FavoriteEntity({
    required this.id,
    required this.name,
    required this.store,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
  });
}

/// Represents a single favorite merchant item.
class FavoriteMerchantEntity {
  final int id;
  final String name;
  final String image;
  final String category;
  final double rating;
  final String discount;

  const FavoriteMerchantEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.rating,
    required this.discount,
  });

  factory FavoriteMerchantEntity.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> m = json['merchant'] is Map<String, dynamic>
        ? json['merchant'] as Map<String, dynamic>
        : json;

    return FavoriteMerchantEntity(
      id: (m['id'] as num?)?.toInt() ?? 0,
      name: m['name']?.toString() ?? '',
      image: m['image']?.toString() ?? m['logo']?.toString() ?? '',
      category: m['category'] is Map
          ? (m['category']['name']?.toString() ?? '')
          : (m['category_name']?.toString() ?? ''),
      rating: (m['rating'] as num?)?.toDouble() ?? 4.8,
      discount: m['discount']?.toString() ?? '',
    );
  }
}
