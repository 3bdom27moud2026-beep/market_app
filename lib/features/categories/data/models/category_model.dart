import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

/// Model class for CategoryEntity.
///
/// Handles JSON serialization and deserialization.
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int storesCount;
  final String? color;
  final String? iconColor;
  final String? slug;
  final String? type;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.storesCount,
    this.color,
    this.iconColor,
    this.slug,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawStoresCount =
        json['stores_count'] ??
        json['merchants_count'] ??
        json['shops_count'] ??
        json['partners_count'] ??
        json['storesCount'];

    int parsedCount = 0;
    if (rawStoresCount is int) {
      parsedCount = rawStoresCount;
    } else if (rawStoresCount != null) {
      parsedCount = int.tryParse(rawStoresCount.toString()) ?? 0;
    } else if (json['merchants'] is List) {
      parsedCount = (json['merchants'] as List).length;
    } else if (json['stores'] is List) {
      parsedCount = (json['stores'] as List).length;
    }

    final rawIcon =
        json['icon']?.toString() ??
        json['image']?.toString() ??
        json['icon_url']?.toString() ??
        json['image_url']?.toString() ??
        '';

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      icon: rawIcon,
      storesCount: parsedCount,
      color: json['color']?.toString(),
      iconColor: json['icon_color']?.toString(),
      slug: json['slug']?.toString(),
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'stores_count': storesCount,
      if (color != null) 'color': color,
      if (iconColor != null) 'icon_color': iconColor,
      if (slug != null) 'slug': slug,
      if (type != null) 'type': type,
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      icon: icon,
      storesCount: storesCount,
      color: color,
      iconColor: iconColor,
      slug: slug,
      type: type,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    storesCount,
    color,
    iconColor,
    slug,
    type,
  ];
}
