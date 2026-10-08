import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/best_seller_entity.dart';

class BestSellerModel extends Equatable {
  final String id;
  final String title;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;

  /// Brand name (e.g. 'برجر كينج', 'Nike').
  final String brand;

  /// Number of reviews.
  final int reviewCount;

  /// Merchant name.
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

  const BestSellerModel({
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

  factory BestSellerModel.fromJson(Map<String, dynamic> json) {
    final double originalPriceVal =
        (json['original_price'] as num?)?.toDouble() ??
        (json['old_price'] as num?)?.toDouble() ??
        (json['oldPrice'] as num?)?.toDouble() ??
        0.0;

    final double memberPriceVal =
        (json['member_price'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0;

    final double displayPriceVal =
        (json['display_price'] as num?)?.toDouble() ?? originalPriceVal;

    // UI always shows display_price. The "effective" price for non-members is display_price.
    final double priceVal = displayPriceVal > 0
        ? displayPriceVal
        : memberPriceVal;
    final double oldPriceVal = originalPriceVal > 0
        ? originalPriceVal
        : priceVal;

    final String discountVal =
        json['discount']?.toString() ??
        (oldPriceVal > priceVal && oldPriceVal > 0
            ? '${(((oldPriceVal - priceVal) / oldPriceVal) * 100).round()}%'
            : '');

    // Extract merchant name from nested merchant object or fallback to brand or store
    final merchantJson = json['merchant'] is Map<String, dynamic>
        ? json['merchant'] as Map<String, dynamic>
        : null;
    final String merchantNameVal = merchantJson?['name']?.toString() ?? '';
    final String storeVal = json['store']?.toString() ?? '';
    final String brandVal =
        json['brand']?.toString() ??
        (merchantNameVal.isNotEmpty ? merchantNameVal : storeVal);

    String imgUrl =
        json['image']?.toString() ??
        json['image_url']?.toString() ??
        json['photo']?.toString() ??
        json['avatar']?.toString() ??
        '';
    if (imgUrl.isEmpty &&
        json['images'] is List &&
        (json['images'] as List).isNotEmpty) {
      imgUrl = (json['images'] as List).first.toString();
    }
    if (imgUrl.isEmpty &&
        json['thumbnails'] is List &&
        (json['thumbnails'] as List).isNotEmpty) {
      imgUrl = (json['thumbnails'] as List).first.toString();
    }

    final double savingsAmount =
        (json['savings_amount'] as num?)?.toDouble() ??
        (oldPriceVal - memberPriceVal).clamp(0, double.infinity);

    return BestSellerModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      image: ImageUrlFormatter.format(imgUrl) ?? imgUrl,
      price: priceVal,
      oldPrice: oldPriceVal,
      rating:
          (json['rating'] as num?)?.toDouble() ??
          (json['rate'] as num?)?.toDouble() ??
          0.0,
      discount: discountVal,
      brand: brandVal,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      merchantName: merchantNameVal,
      displayPrice: displayPriceVal,
      memberPrice: memberPriceVal,
      originalPrice: originalPriceVal,
      hasDiscount: json['has_discount'] == true,
      savingsAmount: savingsAmount,
      isFlashSale: json['is_flash_sale'] == true,
      isMember: json['is_member'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'discount': discount,
      'brand': brand,
      'review_count': reviewCount,
      'merchant_name': merchantName,
      'display_price': displayPrice,
      'member_price': memberPrice,
      'original_price': originalPrice,
      'has_discount': hasDiscount,
      'savings_amount': savingsAmount,
      'is_flash_sale': isFlashSale,
      'is_member': isMember,
    };
  }

  BestSellerEntity toEntity() {
    return BestSellerEntity(
      id: id,
      title: title,
      image: image,
      price: price,
      oldPrice: oldPrice,
      rating: rating,
      discount: discount,
      brand: brand,
      reviewCount: reviewCount,
      merchantName: merchantName,
      displayPrice: displayPrice,
      memberPrice: memberPrice,
      originalPrice: originalPrice,
      hasDiscount: hasDiscount,
      savingsAmount: savingsAmount,
      isFlashSale: isFlashSale,
      isMember: isMember,
    );
  }

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
