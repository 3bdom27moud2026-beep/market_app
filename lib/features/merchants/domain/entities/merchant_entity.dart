import 'package:equatable/equatable.dart';

/// Represents a merchant category.
class MerchantCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String icon;
  final String color;
  final String iconColor;

  const MerchantCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  List<Object?> get props => [id, name, slug, icon, color, iconColor];
}

/// Represents a governorate.
class GovernorateEntity extends Equatable {
  final int id;
  final String name;
  final String slug;

  const GovernorateEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

/// Represents an administrative center.
class CenterEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final GovernorateEntity? governorate;

  const CenterEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.governorate,
  });

  @override
  List<Object?> get props => [id, name, slug, governorate];
}

/// Represents an area / district.
class AreaEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final CenterEntity? center;

  const AreaEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.center,
  });

  @override
  List<Object?> get props => [id, name, slug, center];
}

/// Full merchant details entity.
class MerchantEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final String phone;
  final String whatsapp;
  final String email;
  final String address;
  final double lat;
  final double lng;
  final String discount;
  final String type;
  final double rating;
  final int reviewCount;
  final int orderCount;
  final bool supportsInstallment;
  final bool isWholesale;
  final String status;
  final String distance;
  final String categoryId;
  final MerchantCategoryEntity? category;
  final AreaEntity? area;
  final String? mapUrl;
  final List<String> gallery;

  const MerchantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.discount,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.orderCount,
    required this.supportsInstallment,
    required this.isWholesale,
    required this.status,
    required this.distance,
    this.categoryId = '',
    this.category,
    this.area,
    this.mapUrl,
    this.gallery = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    image,
    phone,
    whatsapp,
    email,
    address,
    lat,
    lng,
    discount,
    type,
    rating,
    reviewCount,
    orderCount,
    supportsInstallment,
    isWholesale,
    status,
    distance,
    categoryId,
    category,
    area,
    mapUrl,
    gallery,
  ];
}
