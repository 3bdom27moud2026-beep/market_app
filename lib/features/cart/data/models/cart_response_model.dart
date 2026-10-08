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
    final num cartSavingsVal = _parseNum(json['cart_savings']);
    final int cartCountVal = _parseInt(json['cart_count'], items.length);

    CardUpsellEntity? upsell;
    if (json['card_upsell'] is Map<String, dynamic>) {
      final u = json['card_upsell'] as Map<String, dynamic>;
      upsell = CardUpsellEntity(
        potentialSavings: (u['potential_savings'] as num?)?.toDouble() ?? 0.0,
        message: u['message']?.toString() ?? '',
        subscriptionActionUrl:
            u['subscription_action_url']?.toString() ?? '/card/subscribe',
      );
    }

    return CartResponseModel(
      status: statusVal,
      isMember: isMemberVal,
      cart: items,
      cartTotal: cartTotalVal,
      cartSavings: cartSavingsVal,
      cartCount: cartCountVal,
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
    };
  }
}
