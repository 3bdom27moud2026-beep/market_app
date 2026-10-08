import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_data_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/merchant_entity.dart';
import '../../domain/entities/cart_summary_entity.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/entities/delivery_address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/order_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  int get totalItemsCount => 0;

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state.
class CartInitial extends CartState {}

/// Loading state while fetching or mutating cart.
class CartLoading extends CartState {}

/// State when the user is not authenticated.
class CartUnauthenticated extends CartState {}

/// State when the cart is empty, preserving backend envelope metadata if available.
class CartEmpty extends CartState {
  final CartDataEntity cartData;

  const CartEmpty({this.cartData = const CartDataEntity.empty()});

  @override
  List<Object?> get props => [cartData];
}

/// Error state.
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Populated loaded state containing the authoritative backend cart.
class CartLoaded extends CartState {
  final CartDataEntity cartData;
  final CouponEntity? coupon;
  final DeliveryAddressEntity? selectedAddress;
  final PaymentMethodEntity? selectedPaymentMethod;
  final List<DeliveryAddressEntity> availableAddresses;
  final List<PaymentMethodEntity> availablePaymentMethods;
  final String? couponError;
  final bool isApplyingCoupon;
  final int? updatingCartItemId;
  final int? deletingCartItemId;

  const CartLoaded({
    required this.cartData,
    this.coupon,
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.availableAddresses = const [],
    this.availablePaymentMethods = const [],
    this.couponError,
    this.isApplyingCoupon = false,
    this.updatingCartItemId,
    this.deletingCartItemId,
  });

  /// Authoritative list of cart items.
  List<CartItemEntity> get items => cartData.cart;

  /// Authoritative cart count from backend.
  @override
  int get totalItemsCount => cartData.cartCount;

  /// Authoritative total from backend.
  num get total => cartData.cartTotal;

  /// Authoritative savings from backend.
  num get savings => cartData.cartSavings;

  /// Backwards-compatible summary entity derived from backend authoritative values.
  CartSummaryEntity get summary => CartSummaryEntity(
    subtotal: cartData.cartTotal.toDouble(),
    shippingFee: 0,
    discountAmount: cartData.cartSavings.toDouble(),
    taxAmount: 0,
    total: cartData.cartTotal.toDouble(),
  );

  /// Backwards-compatible merchants list for checkout screens.
  List<MerchantEntity> get merchants {
    final Map<String, List<CartItemEntity>> grouped = {};
    final Map<String, String> names = {};

    for (final item in cartData.cart) {
      final key = item.product.store.isNotEmpty ? item.product.store : '1';
      grouped.putIfAbsent(key, () => []).add(item);
      names[key] = item.product.store.isNotEmpty
          ? item.product.store
          : 'المتجر';
    }

    return grouped.entries.map((e) {
      return MerchantEntity(
        id: e.key,
        name: names[e.key] ?? 'المتجر',
        items: e.value,
      );
    }).toList();
  }

  CartLoaded copyWith({
    CartDataEntity? cartData,
    CouponEntity? coupon,
    bool nullifyCoupon = false,
    DeliveryAddressEntity? selectedAddress,
    PaymentMethodEntity? selectedPaymentMethod,
    List<DeliveryAddressEntity>? availableAddresses,
    List<PaymentMethodEntity>? availablePaymentMethods,
    String? couponError,
    bool nullifyCouponError = false,
    bool? isApplyingCoupon,
    int? updatingCartItemId,
    bool nullifyUpdatingCartItemId = false,
    int? deletingCartItemId,
    bool nullifyDeletingCartItemId = false,
  }) {
    return CartLoaded(
      cartData: cartData ?? this.cartData,
      coupon: nullifyCoupon ? null : (coupon ?? this.coupon),
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      availableAddresses: availableAddresses ?? this.availableAddresses,
      availablePaymentMethods:
          availablePaymentMethods ?? this.availablePaymentMethods,
      couponError: nullifyCouponError
          ? null
          : (couponError ?? this.couponError),
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
      updatingCartItemId: nullifyUpdatingCartItemId
          ? null
          : (updatingCartItemId ?? this.updatingCartItemId),
      deletingCartItemId: nullifyDeletingCartItemId
          ? null
          : (deletingCartItemId ?? this.deletingCartItemId),
    );
  }

  @override
  List<Object?> get props => [
    cartData,
    coupon,
    selectedAddress,
    selectedPaymentMethod,
    availableAddresses,
    availablePaymentMethods,
    couponError,
    isApplyingCoupon,
    updatingCartItemId,
    deletingCartItemId,
  ];
}

class OrderProcessing extends CartState {}

class OrderSuccess extends CartState {
  final OrderEntity order;

  const OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}
