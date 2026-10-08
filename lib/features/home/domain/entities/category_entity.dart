import 'package:equatable/equatable.dart';

/// Domain entity representing a product category.
class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final String icon;

  /// Background color hex string for the category card (e.g. '#FFF5F5').
  final String color;

  /// Icon tint color hex string for the category icon (e.g. '#FF4D4D').
  final String iconColor;

  /// Number of partner stores/merchants in this category.
  final int storesCount;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.icon,
    this.color = '',
    this.iconColor = '',
    this.storesCount = 0,
  });

  /// Alias for title for consistency across features.
  String get name => title;

  @override
  List<Object?> get props => [id, title, icon, color, iconColor, storesCount];
}
