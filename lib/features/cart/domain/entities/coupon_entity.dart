import 'package:equatable/equatable.dart';

/// Entity representing a coupon code.
class CouponEntity extends Equatable {
  final String code;
  final double discountAmount;
  final double discountPercentage;
  final String description;
  final bool isValid;

  const CouponEntity({
    required this.code,
    required this.discountAmount,
    required this.discountPercentage,
    required this.description,
    this.isValid = true,
  });

  @override
  List<Object?> get props => [
    code,
    discountAmount,
    discountPercentage,
    description,
    isValid,
  ];
}
