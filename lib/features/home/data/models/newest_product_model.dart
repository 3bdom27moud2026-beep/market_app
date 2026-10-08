import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/newest_product_entity.dart';

class NewestProductModel extends Equatable {
  final String id;
  final String title;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final String discount;
  final bool isFavorite;

  const NewestProductModel({
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

  factory NewestProductModel.fromJson(Map<String, dynamic> json) {
    final double priceVal =
        (json['display_price'] as num?)?.toDouble() ??
        (json['member_price'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0;
    final double oldPriceVal =
        (json['original_price'] as num?)?.toDouble() ??
        (json['old_price'] as num?)?.toDouble() ??
        (json['oldPrice'] as num?)?.toDouble() ??
        0.0;
    final String discountVal =
        json['discount']?.toString() ??
        (oldPriceVal > priceVal && oldPriceVal > 0
            ? '${(((oldPriceVal - priceVal) / oldPriceVal) * 100).round()}%'
            : '');
    final String storeVal = json['merchant'] is Map<String, dynamic>
        ? (json['merchant']['name']?.toString() ?? '')
        : (json['brand']?.toString() ?? json['store']?.toString() ?? '');

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

    return NewestProductModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      store: storeVal,
      image: ImageUrlFormatter.format(imgUrl) ?? imgUrl,
      price: priceVal,
      oldPrice: oldPriceVal,
      rating:
          (json['rating'] as num?)?.toDouble() ??
          (json['rate'] as num?)?.toDouble() ??
          0.0,
      discount: discountVal,
      isFavorite:
          json['is_favorite'] as bool? ?? json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'store': store,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'discount': discount,
      'is_favorite': isFavorite,
    };
  }

  NewestProductEntity toEntity() {
    return NewestProductEntity(
      id: id,
      title: title,
      store: store,
      image: image,
      price: price,
      oldPrice: oldPrice,
      rating: rating,
      discount: discount,
      isFavorite: isFavorite,
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
