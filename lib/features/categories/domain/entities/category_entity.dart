import 'package:equatable/equatable.dart';

/// Represents a category item with additional details for the categories screen.
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int storesCount;
  final String? color;
  final String? iconColor;
  final String? slug;
  final String? type;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.storesCount,
    this.color,
    this.iconColor,
    this.slug,
    this.type,
  });

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
