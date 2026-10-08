import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// Entity representing a merchant/seller grouping cart items.
class MerchantEntity extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;
  final bool isVerified;
  final double? rating;
  final List<CartItemEntity> items;

  const MerchantEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    this.isVerified = true,
    this.rating,
    required this.items,
  });

  MerchantEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    bool? isVerified,
    double? rating,
    List<CartItemEntity>? items,
  }) {
    return MerchantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, name, logoUrl, isVerified, rating, items];
}
