import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';
import 'cart_summary_entity.dart';
import 'delivery_address_entity.dart';
import 'merchant_entity.dart';
import 'payment_method_entity.dart';

/// Entity representing completed order.
class OrderEntity extends Equatable {
  final int id;
  final String orderNo;
  final int userId;
  final int merchantId;
  final double totalPrice;
  final double savings;
  final String paymentMethodType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MerchantEntity? merchant;
  final List<CartItemEntity> items;
  final DeliveryAddressEntity? address;
  final PaymentMethodEntity? paymentMethod;
  final double pointsDiscount;
  final int earnedPoints;
  final double savedAmount;
  final String shareMessage;
  final String shareUrl;
  final String? trackingUrl;
  final String? trackingNumber;

  const OrderEntity({
    this.id = 0,
    this.orderNo = '',
    this.userId = 0,
    this.merchantId = 0,
    this.totalPrice = 0.0,
    this.savings = 0.0,
    this.paymentMethodType = 'cash',
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
    this.merchant,
    this.items = const [],
    this.address,
    this.paymentMethod,
    this.pointsDiscount = 0.0,
    this.earnedPoints = 0,
    this.savedAmount = 0.0,
    this.shareMessage = '',
    this.shareUrl = '',
    this.trackingUrl,
    this.trackingNumber,
  });

  /// Convenience getter for order identifier (e.g. ORD-5534 or #8)
  String get orderId =>
      orderNo.isNotEmpty ? orderNo : (id > 0 ? id.toString() : '');

  /// Convenience getter for order creation date
  DateTime get orderDate => createdAt;

  /// Convenience getter for estimated delivery date (default 2 days after creation)
  DateTime get estimatedDeliveryDate => createdAt.add(const Duration(days: 2));

  /// Convenience getter for order summary
  CartSummaryEntity get summary => CartSummaryEntity(
    subtotal: totalPrice + savings,
    shippingFee: 0.0,
    discountAmount: savings,
    taxAmount: 0.0,
    total: totalPrice,
  );

  @override
  List<Object?> get props => [
    id,
    orderNo,
    userId,
    merchantId,
    totalPrice,
    savings,
    paymentMethodType,
    status,
    createdAt,
    updatedAt,
    merchant,
    items,
    address,
    paymentMethod,
    pointsDiscount,
    earnedPoints,
    savedAmount,
    shareMessage,
    shareUrl,
    trackingUrl,
    trackingNumber,
  ];
}
