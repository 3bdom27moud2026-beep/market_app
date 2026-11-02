import 'package:equatable/equatable.dart';
import 'package:market/features/discount_card/domain/entities/payment_method_entity.dart';
import 'package:market/features/discount_card/domain/entities/subscription_plan_entity.dart';
import 'cart_item_entity.dart';

/// Domain entity representing card upsell motivation banner and quick subscription.
class CardUpsellEntity extends Equatable {
  final bool showUpsell;
  final double potentialSavings;
  final double savingsPercentage;
  final String title;
  final String message;
  final String badge;
  final String subscriptionActionUrl;
  final String ctaText;
  final List<SubscriptionPlanEntity> plans;
  final List<PaymentMethodEntity> paymentMethods;

  const CardUpsellEntity({
    this.showUpsell = true,
    required this.potentialSavings,
    this.savingsPercentage = 0,
    this.title = '',
    required this.message,
    this.badge = '',
    required this.subscriptionActionUrl,
    this.ctaText = 'اشترك ووفر الآن',
    this.plans = const [],
    this.paymentMethods = const [],
  });

  @override
  List<Object?> get props => [
    showUpsell,
    potentialSavings,
    savingsPercentage,
    title,
    message,
    badge,
    subscriptionActionUrl,
    ctaText,
    plans,
    paymentMethods,
  ];
}

/// Domain entity representing the complete authoritative cart response from the backend.
class CartDataEntity extends Equatable {
  final bool status;
  final bool isMember;
  final List<CartItemEntity> cart;
  final num cartTotal;
  final num cartSavings;
  final int cartCount;
  final num? cartTotalWithoutCard;
  final num? cartTotalWithCard;
  final num? cartPotentialCardSavings;
  final CardUpsellEntity? cardUpsell;

  const CartDataEntity({
    required this.status,
    required this.isMember,
    required this.cart,
    required this.cartTotal,
    required this.cartSavings,
    required this.cartCount,
    this.cartTotalWithoutCard,
    this.cartTotalWithCard,
    this.cartPotentialCardSavings,
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
      cartTotalWithoutCard = 0,
      cartTotalWithCard = 0,
      cartPotentialCardSavings = 0,
      cardUpsell = null;

  @override
  List<Object?> get props => [
    status,
    isMember,
    cart,
    cartTotal,
    cartSavings,
    cartCount,
    cartTotalWithoutCard,
    cartTotalWithCard,
    cartPotentialCardSavings,
    cardUpsell,
  ];
}
