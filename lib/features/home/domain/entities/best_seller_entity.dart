import 'package:equatable/equatable.dart';

/// Represents a best seller product.
class BestSellerEntity extends Equatable {
  final String id;
  final String title;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;

  /// Brand/store name (e.g. 'برجر كينج', 'Nike').
  final String brand;

  /// Number of reviews for this product.
  final int reviewCount;

  /// Merchant name that sells this product.
  final String merchantName;

  /// Price shown to the current user (display_price).
  final double displayPrice;

  /// Member-exclusive discounted price.
  final double memberPrice;

  /// Original price before any discount.
  final double originalPrice;

  /// Whether the current user gets a discount.
  final bool hasDiscount;

  /// Amount saved vs original price.
  final double savingsAmount;

  /// Whether this product is part of a flash sale.
  final bool isFlashSale;

  /// Whether the current user is a member.
  final bool isMember;

  const BestSellerEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
    this.brand = '',
    this.reviewCount = 0,
    this.merchantName = '',
    this.displayPrice = 0,
    this.memberPrice = 0,
    this.originalPrice = 0,
    this.hasDiscount = false,
    this.savingsAmount = 0,
    this.isFlashSale = false,
    this.isMember = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    price,
    oldPrice,
    rating,
    discount,
    brand,
    reviewCount,
    merchantName,
    displayPrice,
    memberPrice,
    originalPrice,
    hasDiscount,
    savingsAmount,
    isFlashSale,
    isMember,
  ];
}
