import 'package:equatable/equatable.dart';
import 'merchant_entity.dart';

/// Represents a discount category with its merchants.
class DiscountCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int merchantsCount;
  final double maxDiscount;
  final List<MerchantEntity> merchants;

  const DiscountCategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.merchantsCount,
    required this.maxDiscount,
    this.merchants = const [],
  });

  DiscountCategoryEntity copyWith({
    String? id,
    String? name,
    String? icon,
    int? merchantsCount,
    double? maxDiscount,
    List<MerchantEntity>? merchants,
  }) {
    return DiscountCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      merchantsCount: merchantsCount ?? this.merchantsCount,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      merchants: merchants ?? this.merchants,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    merchantsCount,
    maxDiscount,
    merchants,
  ];
}
