import 'package:equatable/equatable.dart';
import '../../../../core/utils/category_visual_helper.dart';
import '../../domain/entities/category_entity.dart';

/// Model class for CategoryEntity supporting subcategories and custom icon URLs.
class CategoryModel extends Equatable {
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
  final List<CategoryModel> subcategories;

  const CategoryModel({
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

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      parentId: entity.parentId,
      name: entity.name,
      icon: entity.icon,
      customIconUrl: entity.customIconUrl,
      storesCount: entity.storesCount,
      color: entity.color,
      iconColor: entity.iconColor,
      slug: entity.slug,
      type: entity.type,
      subcategories: entity.subcategories
          .map((e) => CategoryModel.fromEntity(e))
          .toList(),
    );
  }

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

    final rawCustomIcon =
        json['custom_icon_url']?.toString() ??
        json['custom_icon']?.toString();

    final rawSubcategories = json['subcategories'] ??
        json['sub_categories'] ??
        json['children'] ??
        json['child_categories'] ??
        json['subs'];
    final List<CategoryModel> parsedSubcategories = [];
    if (rawSubcategories is List) {
      for (final sub in rawSubcategories) {
        if (sub is Map<String, dynamic>) {
          parsedSubcategories.add(CategoryModel.fromJson(sub));
        }
      }
    }

    final catId = json['id']?.toString() ?? '';
    final catParentId = json['parent_id']?.toString();
    final catName = json['name']?.toString() ?? json['title']?.toString() ?? '';
    final catSlug = json['slug']?.toString();

    // Contextual fallback subcategories when backend API returns empty subcategories
    if (parsedSubcategories.isEmpty && (catParentId == null || catParentId.isEmpty)) {
      final defaultEntities = CategoryVisualHelper.getDefaultSubcategories(
        id: catId,
        name: catName,
        slug: catSlug,
      );
      parsedSubcategories.addAll(
        defaultEntities.map((e) => CategoryModel.fromEntity(e)),
      );
    }

    return CategoryModel(
      id: catId,
      parentId: catParentId,
      name: catName,
      icon: rawIcon,
      customIconUrl: rawCustomIcon,
      storesCount: parsedCount,
      color: json['color']?.toString(),
      iconColor: json['icon_color']?.toString(),
      slug: catSlug,
      type: json['type']?.toString(),
      subcategories: parsedSubcategories,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (parentId != null) 'parent_id': parentId,
      'name': name,
      'icon': icon,
      if (customIconUrl != null) 'custom_icon_url': customIconUrl,
      'stores_count': storesCount,
      if (color != null) 'color': color,
      if (iconColor != null) 'icon_color': iconColor,
      if (slug != null) 'slug': slug,
      if (type != null) 'type': type,
      if (subcategories.isNotEmpty)
        'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      parentId: parentId,
      name: name,
      icon: icon,
      customIconUrl: customIconUrl,
      storesCount: storesCount,
      color: color,
      iconColor: iconColor,
      slug: slug,
      type: type,
      subcategories: subcategories.map((e) => e.toEntity()).toList(),
    );
  }

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
