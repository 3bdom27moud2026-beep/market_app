import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// Domain entity representing card upsell motivation banner.
class CardUpsellEntity extends Equatable {
  final double potentialSavings;
  final String message;
  final String subscriptionActionUrl;

  const CardUpsellEntity({
    required this.potentialSavings,
    required this.message,
    required this.subscriptionActionUrl,
  });

  @override
  List<Object?> get props => [potentialSavings, message, subscriptionActionUrl];
}

/// Domain entity representing the complete authoritative cart response from the backend.
class CartDataEntity extends Equatable {
  final bool status;
  final bool isMember;
  final List<CartItemEntity> cart;
  final num cartTotal;
  final num cartSavings;
  final int cartCount;
  final CardUpsellEntity? cardUpsell;

  const CartDataEntity({
    required this.status,
    required this.isMember,
    required this.cart,
    required this.cartTotal,
    required this.cartSavings,
    required this.cartCount,
    this.cardUpsell,
  });

  /// An empty cart fallback entity.
  const CartDataEntity.empty()
    : status = true,
      isMember = false,
      cart = const [],
      cartTotal = 0,
      cartSavings = 0,
      cartCount = 0,
      cardUpsell = null;

  @override
  List<Object?> get props => [
    status,
    isMember,
    cart,
    cartTotal,
    cartSavings,
    cartCount,
    cardUpsell,
  ];
}
