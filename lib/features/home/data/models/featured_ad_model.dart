import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/featured_ad_entity.dart';

/// Data model representing a featured advertisement returned by the API.
class FeaturedAdModel extends Equatable {
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

  const FeaturedAdModel({
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

  factory FeaturedAdModel.fromJson(Map<String, dynamic> json) {
    final double originalPrice =
        (json['original_price'] as num?)?.toDouble() ??
        (json['oldPrice'] as num?)?.toDouble() ??
        (json['old_price'] as num?)?.toDouble() ??
        0.0;

    final double memberPrice =
        (json['member_price'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0;

    final double displayPrice =
        (json['display_price'] as num?)?.toDouble() ?? originalPrice;

    return FeaturedAdModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      seller:
          json['seller']?.toString() ??
          (json['merchant'] is Map
              ? (json['merchant'] as Map)['name']?.toString() ?? ''
              : ''),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: originalPrice > 0 ? originalPrice : null,
      displayPrice: displayPrice,
      memberPrice: memberPrice,
      originalPrice: originalPrice,
      discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
      isMember: json['is_member'] == true,
      image:
          ImageUrlFormatter.format(json['image']?.toString()) ??
          (json['image']?.toString() ?? ''),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews:
          (json['reviews'] as num?)?.toInt() ??
          (json['review_count'] as num?)?.toInt() ??
          0,
      headline: json['headline']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'seller': seller,
      'price': price,
      'oldPrice': oldPrice,
      'display_price': displayPrice,
      'member_price': memberPrice,
      'original_price': originalPrice,
      'discount_percent': discountPercent,
      'is_member': isMember,
      'image': image,
      'rating': rating,
      'reviews': reviews,
      'headline': headline,
      'tagline': tagline,
    };
  }

  FeaturedAdEntity toEntity() {
    return FeaturedAdEntity(
      id: id,
      name: name,
      brand: brand,
      seller: seller,
      price: price,
      oldPrice: oldPrice,
      displayPrice: displayPrice,
      memberPrice: memberPrice,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      isMember: isMember,
      image: image,
      rating: rating,
      reviews: reviews,
      headline: headline,
      tagline: tagline,
    );
  }

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
