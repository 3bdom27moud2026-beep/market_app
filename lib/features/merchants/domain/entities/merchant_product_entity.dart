import 'package:equatable/equatable.dart';

/// Represents a product listed under a merchant.
class MerchantProductEntity extends Equatable {
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

  const MerchantProductEntity({
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

  int get discountPercent {
    if (oldPrice > price && oldPrice > 0) {
      return (((oldPrice - price) / oldPrice) * 100).round();
    }
    return 0;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    description,
    price,
    oldPrice,
    image,
    thumbnails,
    specs,
    rating,
    reviewCount,
    stock,
    isFlashSale,
    isActive,
  ];
}
