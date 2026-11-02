import 'package:market/features/discount_card/data/models/payment_method_model.dart';
import 'package:market/features/discount_card/data/models/subscription_plan_model.dart';
import '../../domain/entities/cart_data_entity.dart';
import 'cart_item_model.dart';

class CartResponseModel extends CartDataEntity {
  const CartResponseModel({
    required super.status,
    required super.isMember,
    required super.cart,
    required super.cartTotal,
    required super.cartSavings,
    required super.cartCount,
    super.cartTotalWithoutCard,
    super.cartTotalWithCard,
    super.cartPotentialCardSavings,
    super.cardUpsell,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    final bool statusVal = json['status'] as bool? ?? true;
    final bool isMemberVal = json['is_member'] as bool? ?? false;

    final dynamic cartRaw = json['cart'] ?? json['items'] ?? json['data'];
    final List<CartItemModel> items = [];
    if (cartRaw is List) {
      for (final item in cartRaw) {
        if (item is Map<String, dynamic>) {
          items.add(CartItemModel.fromJson(item));
        }
      }
    }

    final num cartTotalVal = _parseNum(json['cart_total']);
    final num cartSavingsVal = _parseNum(
      json['cart_potential_card_savings'] ?? json['cart_savings'],
    );
    final int cartCountVal = _parseInt(json['cart_count'], items.length);

    final num? cartTotalWithoutCardVal = json['cart_total_without_card'] != null
        ? _parseNum(json['cart_total_without_card'])
        : null;
    final num? cartTotalWithCardVal = json['cart_total_with_card'] != null
        ? _parseNum(json['cart_total_with_card'])
        : null;
    final num? cartPotentialCardSavingsVal =
        json['cart_potential_card_savings'] != null
        ? _parseNum(json['cart_potential_card_savings'])
        : null;

    CardUpsellEntity? upsell;
    if (json['card_upsell'] is Map<String, dynamic>) {
      final u = json['card_upsell'] as Map<String, dynamic>;

      final rawPlans = u['plans'];
      final List<SubscriptionPlanModel> parsedPlans = [];
      if (rawPlans is List) {
        for (final p in rawPlans) {
          if (p is Map<String, dynamic>) {
            parsedPlans.add(SubscriptionPlanModel.fromJson(p));
          }
        }
      }

      final rawMethods = u['payment_methods'];
      final List<PaymentMethodModel> parsedMethods = [];
      if (rawMethods is List) {
        for (final m in rawMethods) {
          if (m is Map<String, dynamic>) {
            parsedMethods.add(PaymentMethodModel.fromJson(m));
          }
        }
      }

      upsell = CardUpsellEntity(
        showUpsell: u['show_upsell'] as bool? ?? true,
        potentialSavings: (u['potential_savings'] as num?)?.toDouble() ?? 0.0,
        savingsPercentage: (u['savings_percentage'] as num?)?.toDouble() ?? 0.0,
        title: u['title']?.toString() ?? '',
        message: u['message']?.toString() ?? '',
        badge: u['badge']?.toString() ?? '',
        subscriptionActionUrl:
            u['subscription_action_url']?.toString() ?? '/discount-card',
        ctaText: u['cta_text']?.toString() ?? 'اشترك ووفر الآن',
        plans: parsedPlans,
        paymentMethods: parsedMethods,
      );
    }

    return CartResponseModel(
      status: statusVal,
      isMember: isMemberVal,
      cart: items,
      cartTotal: cartTotalVal,
      cartSavings: cartSavingsVal,
      cartCount: cartCountVal,
      cartTotalWithoutCard: cartTotalWithoutCardVal,
      cartTotalWithCard: cartTotalWithCardVal,
      cartPotentialCardSavings: cartPotentialCardSavingsVal,
      cardUpsell: upsell,
    );
  }

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ??
          (double.tryParse(value)?.toInt() ?? defaultValue);
    }
    return defaultValue;
  }

  static num _parseNum(dynamic value, [num defaultValue = 0.0]) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_member': isMember,
      'cart': cart.map((e) => (e as CartItemModel).toJson()).toList(),
      'cart_total': cartTotal,
      'cart_savings': cartSavings,
      'cart_count': cartCount,
      if (cartTotalWithoutCard != null)
        'cart_total_without_card': cartTotalWithoutCard,
      if (cartTotalWithCard != null)
        'cart_total_with_card': cartTotalWithCard,
      if (cartPotentialCardSavings != null)
        'cart_potential_card_savings': cartPotentialCardSavings,
    };
  }
}
