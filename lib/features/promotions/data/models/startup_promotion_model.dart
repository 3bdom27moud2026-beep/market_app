import 'package:equatable/equatable.dart';
import '../../domain/entities/startup_promotion_entity.dart';

/// Model for startup promotion response from the API.
class StartupPromotionModel extends Equatable {
  final String id;
  final String title;
  final String store;
  final String brand;
  final String merchantName;
  final String image;
  final double price;
  final double oldPrice;
  final int discount;
  final double rating;
  final int reviews;
  final String description;
  final String stockMessage;
  final String buttonText;
  final String specialOffer;

  const StartupPromotionModel({
    required this.id,
    required this.title,
    required this.store,
    this.brand = '',
    this.merchantName = '',
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.stockMessage,
    required this.buttonText,
    required this.specialOffer,
  });

  factory StartupPromotionModel.fromJson(Map<String, dynamic> json) {
    final double price =
        (json['member_price'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0;
    final double oldPrice =
        (json['original_price'] as num?)?.toDouble() ??
        (json['oldPrice'] as num?)?.toDouble() ??
        (json['old_price'] as num?)?.toDouble() ??
        (price > 0 ? price : 0.0);

    int discount = (json['discount'] as num?)?.toInt() ?? 0;
    if (discount == 0 && oldPrice > price && oldPrice > 0) {
      discount = (((oldPrice - price) / oldPrice) * 100).round();
    }

    final String brand = json['brand']?.toString() ?? '';
    String merchantName = '';
    if (json['merchant'] is Map) {
      merchantName = (json['merchant'] as Map)['name']?.toString() ?? '';
    }

    String store = json['store']?.toString() ?? '';
    if (store.isEmpty) {
      store = brand.isNotEmpty ? brand : merchantName;
    }

    return StartupPromotionModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      store: store,
      brand: brand,
      merchantName: merchantName,
      image: json['image']?.toString() ?? '',
      price: price,
      oldPrice: oldPrice,
      discount: discount,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviews:
          (json['reviews'] as num?)?.toInt() ??
          (json['review_count'] as num?)?.toInt() ??
          0,
      description:
          json['description_badge']?.toString() ??
          json['headline']?.toString() ??
          'عرض حصري لفترة محدودة!',
      stockMessage:
          json['stock_message']?.toString() ??
          json['tagline']?.toString() ??
          'اطلب الآن — الكمية محدودة والتوصيل سريع',
      buttonText: json['button_text']?.toString() ?? 'تسوق الآن',
      specialOffer: json['special_offer']?.toString() ?? 'عرض خاص',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'store': store,
      'brand': brand,
      'merchant_name': merchantName,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'discount': discount,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'stock_message': stockMessage,
      'button_text': buttonText,
      'special_offer': specialOffer,
    };
  }

  StartupPromotionEntity toEntity() {
    return StartupPromotionEntity(
      id: id,
      title: title,
      store: store,
      brand: brand,
      merchantName: merchantName,
      image: image,
      price: price,
      oldPrice: oldPrice,
      discount: discount,
      rating: rating,
      reviews: reviews,
      description: description,
      stockMessage: stockMessage,
      buttonText: buttonText,
      specialOffer: specialOffer,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    store,
    brand,
    merchantName,
    image,
    price,
    oldPrice,
    discount,
    rating,
    reviews,
    description,
    stockMessage,
    buttonText,
    specialOffer,
  ];
}
