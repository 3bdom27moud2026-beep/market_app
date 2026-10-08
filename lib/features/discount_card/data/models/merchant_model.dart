import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';

/// JSON-serializable model for a merchant.
class MerchantModel extends MerchantEntity {
  const MerchantModel({
    required super.id,
    required super.name,
    required super.discountPercentage,
    super.image,
    required super.categoryId,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      image: json['image'],
      categoryId: json['category_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'discount_percentage': discountPercentage,
    'image': image,
    'category_id': categoryId,
  };
}
