import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/category_entity.dart';

class CategoryModel extends Equatable {
  final String id;
  final String title;
  final String icon;

  /// Background color hex string (e.g. '#FFF5F5').
  final String color;

  /// Icon tint color hex string (e.g. '#FF4D4D').
  final String iconColor;

  /// Number of partner stores/merchants in this category.
  final int storesCount;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    this.color = '',
    this.iconColor = '',
    this.storesCount = 0,
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

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      icon:
          ImageUrlFormatter.format(json['icon']?.toString()) ??
          (json['icon']?.toString() ?? ''),
      color: json['color']?.toString() ?? '',
      iconColor: json['icon_color']?.toString() ?? '',
      storesCount: parsedCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'color': color,
      'icon_color': iconColor,
      'stores_count': storesCount,
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
      icon: icon,
      color: color,
      iconColor: iconColor,
      storesCount: storesCount,
    );
  }

  @override
  List<Object?> get props => [id, title, icon, color, iconColor, storesCount];
}
