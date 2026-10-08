import 'package:equatable/equatable.dart';

/// Represents a product in the newest products section.
class NewestProductEntity extends Equatable {
  final String id;
  final String title;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;
  final bool isFavorite;

  const NewestProductEntity({
    required this.id,
    required this.title,
    required this.store,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
    this.isFavorite = false,
  });

  NewestProductEntity copyWith({
    String? id,
    String? title,
    String? store,
    String? image,
    double? price,
    double? oldPrice,
    double? rating,
    String? discount,
    bool? isFavorite,
  }) {
    return NewestProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      store: store ?? this.store,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    store,
    image,
    price,
    oldPrice,
    rating,
    discount,
    isFavorite,
  ];
}
