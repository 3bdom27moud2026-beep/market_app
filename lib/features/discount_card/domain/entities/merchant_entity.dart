import 'package:equatable/equatable.dart';

/// Represents a single merchant/store offering a discount.
class MerchantEntity extends Equatable {
  final String id;
  final String name;
  final double discountPercentage;
  final String? image;
  final String categoryId;

  const MerchantEntity({
    required this.id,
    required this.name,
    required this.discountPercentage,
    this.image,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, name, discountPercentage, image, categoryId];
}
