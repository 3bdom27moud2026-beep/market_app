import 'package:equatable/equatable.dart';

/// Represents a flash sale product item.
class FlashSaleProductEntity extends Equatable {
  final String id;
  final String title;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final int remaining;
  final String discount;

  const FlashSaleProductEntity({
    required this.id,
    required this.title,
    required this.store,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.remaining,
    required this.discount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    store,
    image,
    price,
    oldPrice,
    rating,
    remaining,
    discount,
  ];
}
