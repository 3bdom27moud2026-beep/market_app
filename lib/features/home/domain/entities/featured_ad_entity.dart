import 'package:equatable/equatable.dart';

/// Domain entity representing a featured ad on the home screen.
class FeaturedAdEntity extends Equatable {
  final String id;
  final String name;
  final String brand;

  /// Seller/merchant name.
  final String seller;
  final double price;
  final double? oldPrice;

  /// Price shown to the current user.
  final double displayPrice;

  /// Member-exclusive price.
  final double memberPrice;

  /// Original price before any discount.
  final double originalPrice;

  /// Discount percentage (0 if none).
  final int discountPercent;

  /// Whether current user is a member.
  final bool isMember;
  final String image;
  final double rating;
  final int reviews;
  final String headline;
  final String tagline;

  const FeaturedAdEntity({
    required this.id,
    required this.name,
    required this.brand,
    this.seller = '',
    required this.price,
    this.oldPrice,
    this.displayPrice = 0,
    this.memberPrice = 0,
    this.originalPrice = 0,
    this.discountPercent = 0,
    this.isMember = false,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.headline,
    required this.tagline,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    seller,
    price,
    oldPrice,
    displayPrice,
    memberPrice,
    originalPrice,
    discountPercent,
    isMember,
    image,
    rating,
    reviews,
    headline,
    tagline,
  ];
}
