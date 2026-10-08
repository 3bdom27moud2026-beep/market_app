import '../../domain/entities/merchant_entity.dart';
import 'cart_item_model.dart';

class MerchantModel extends MerchantEntity {
  const MerchantModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.isVerified,
    super.rating,
    required super.items,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    final merchantMap = json['merchant'] is Map<String, dynamic>
        ? json['merchant'] as Map<String, dynamic>
        : json;

    return MerchantModel(
      id: merchantMap['id']?.toString() ?? json['id']?.toString() ?? '',
      name: merchantMap['name']?.toString() ?? json['name']?.toString() ?? '',
      logoUrl:
          merchantMap['image']?.toString() ??
          merchantMap['logo_url']?.toString() ??
          json['logo_url']?.toString() ??
          json['image']?.toString(),
      isVerified:
          merchantMap['status'] == 'active' ||
          (merchantMap['is_verified'] as bool? ?? true),
      rating:
          (merchantMap['rating'] as num?)?.toDouble() ??
          (json['rating'] as num?)?.toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'is_verified': isVerified,
      'rating': rating,
      'items': items.map((e) => (e as CartItemModel).toJson()).toList(),
    };
  }
}
