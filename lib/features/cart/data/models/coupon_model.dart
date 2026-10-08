import '../../domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.code,
    required super.discountAmount,
    required super.discountPercentage,
    required super.description,
    super.isValid,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] as String? ?? '',
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      isValid: json['is_valid'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_amount': discountAmount,
      'discount_percentage': discountPercentage,
      'description': description,
      'is_valid': isValid,
    };
  }
}
