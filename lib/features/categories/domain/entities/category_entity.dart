import 'package:equatable/equatable.dart';

/// Represents a category item with subcategories and custom icon support.
class CategoryEntity extends Equatable {
  final String id;
  final String? parentId;
  final String name;
  final String icon;
  final String? customIconUrl;
  final int storesCount;
  final String? color;
  final String? iconColor;
  final String? slug;
  final String? type;
  final List<CategoryEntity> subcategories;

  const CategoryEntity({
    required this.id,
    this.parentId,
    required this.name,
    required this.icon,
    this.customIconUrl,
    required this.storesCount,
    this.color,
    this.iconColor,
    this.slug,
    this.type,
    this.subcategories = const [],
  });

  bool get hasSubcategories => subcategories.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    parentId,
    name,
    icon,
    customIconUrl,
    storesCount,
    color,
    iconColor,
    slug,
    type,
    subcategories,
  ];
}
