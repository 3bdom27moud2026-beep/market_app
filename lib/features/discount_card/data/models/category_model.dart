import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/data/models/merchant_model.dart';

/// JSON-serializable model for a discount category.
class DiscountCategoryModel extends DiscountCategoryEntity {
  const DiscountCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.merchantsCount,
    required super.maxDiscount,
    super.merchants = const [],
  });

  factory DiscountCategoryModel.fromJson(Map<String, dynamic> json) {
    final merchantsList =
        (json['merchants'] as List<dynamic>?)
            ?.map((m) => MerchantModel.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];

    final dynamic rawCount =
        json['merchants_count'] ??
        json['merchantsCount'] ??
        json['count'] ??
        json['merchants_total'] ??
        merchantsList.length;
    final int parsedCount = rawCount is num
        ? rawCount.toInt()
        : int.tryParse(rawCount?.toString() ?? '') ?? merchantsList.length;

    final dynamic rawDiscount =
        json['max_discount'] ??
        json['maxDiscount'] ??
        json['discount'] ??
        json['discount_percentage'] ??
        json['up_to_discount'] ??
        0;
    final double parsedDiscount = rawDiscount is num
        ? rawDiscount.toDouble()
        : double.tryParse(rawDiscount?.toString() ?? '') ?? 0.0;

    return DiscountCategoryModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? json['title'] ?? '').toString(),
      icon: (json['icon'] ?? json['image'] ?? '').toString(),
      merchantsCount: parsedCount,
      maxDiscount: parsedDiscount,
      merchants: merchantsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'merchants_count': merchantsCount,
    'max_discount': maxDiscount,
    'merchants': merchants.map((m) => (m as MerchantModel).toJson()).toList(),
  };
}
