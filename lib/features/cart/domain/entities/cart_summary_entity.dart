import 'package:equatable/equatable.dart';
import 'coupon_entity.dart';

/// Entity representing price summary calculation.
class CartSummaryEntity extends Equatable {
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final double taxAmount;
  final double serviceFee;
  final double total;
  final CouponEntity? appliedCoupon;

  const CartSummaryEntity({
    required this.subtotal,
    required this.shippingFee,
    required this.discountAmount,
    required this.taxAmount,
    this.serviceFee = 0.0,
    required this.total,
    this.appliedCoupon,
  });

  factory CartSummaryEntity.calculate({
    required double subtotal,
    required double shippingFee,
    CouponEntity? coupon,
    double taxRate = 0.0,
    double serviceFee = 0.0,
  }) {
    final discount = coupon != null ? coupon.discountAmount : 0.0;
    final taxableAmount = (subtotal - discount).clamp(0.0, double.infinity);
    final tax = taxableAmount * taxRate;
    final total = taxableAmount + shippingFee + tax + serviceFee;

    return CartSummaryEntity(
      subtotal: subtotal,
      shippingFee: shippingFee,
      discountAmount: discount,
      taxAmount: tax,
      serviceFee: serviceFee,
      total: total,
      appliedCoupon: coupon,
    );
  }

  @override
  List<Object?> get props => [
    subtotal,
    shippingFee,
    discountAmount,
    taxAmount,
    serviceFee,
    total,
    appliedCoupon,
  ];
}
