import 'package:equatable/equatable.dart';

/// Represents a startup promotion product.
class StartupPromotionEntity extends Equatable {
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

  const StartupPromotionEntity({
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
