// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../domain/entities/delivery_address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/delete_cart_item_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_quantity_usecase.dart';
import '../../domain/usecases/update_quantity_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/repository/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  // ignore: unused_field
  final UpdateQuantityUseCase? _updateQuantityUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;
  final DeleteCartItemUseCase _deleteCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;
  // ignore: unused_field
  final RemoveCartItemUseCase? _removeCartItemUseCase;
  final ApplyCouponUseCase _applyCouponUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final CartRepository _cartRepository;
  final CheckAuthUseCase? _checkAuthUseCase;

  bool _isMutating = false;
  StreamSubscription<AuthEvent>? _authSubscription;
  StreamSubscription<void>? _cartBusSubscription;

  CartCubit({
    required GetCartUseCase getCartUseCase,
    UpdateQuantityUseCase? updateQuantityUseCase,
    required UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase,
    required DeleteCartItemUseCase deleteCartItemUseCase,
    required ClearCartUseCase clearCartUseCase,
    RemoveCartItemUseCase? removeCartItemUseCase,
    required ApplyCouponUseCase applyCouponUseCase,
    required PlaceOrderUseCase placeOrderUseCase,
    required AddToCartUseCase addToCartUseCase,
    required CartRepository cartRepository,
    CheckAuthUseCase? checkAuthUseCase,
  }) : _getCartUseCase = getCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _updateCartItemQuantityUseCase = updateCartItemQuantityUseCase,
       _deleteCartItemUseCase = deleteCartItemUseCase,
       _clearCartUseCase = clearCartUseCase,
       _removeCartItemUseCase = removeCartItemUseCase,
       _applyCouponUseCase = applyCouponUseCase,
       _placeOrderUseCase = placeOrderUseCase,
       _addToCartUseCase = addToCartUseCase,
       _cartRepository = cartRepository,
       _checkAuthUseCase = checkAuthUseCase,
       super(CartInitial()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn) {
        loadCart();
      } else if (event.type == AuthEventType.loggedOut) {
        emit(CartUnauthenticated());
      }
    });
    _cartBusSubscription = CartEventBus.instance.stream.listen((_) {
      if (!_isMutating) {
        loadCart();
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cartBusSubscription?.cancel();
    return super.close();
  }

  bool _isAuthenticated() {
    try {
      final checkAuth = _checkAuthUseCase ?? CoreDI.sl<CheckAuthUseCase>();
      return checkAuth();
    } catch (_) {
      return true;
    }
  }

  /// Load authoritative user cart from GET /v1/cart
  Future<void> loadCart() async {
    if (!_isAuthenticated()) {
      emit(CartUnauthenticated());
      return;
    }

    emit(CartLoading());

    final cartResult = await _getCartUseCase();
    if (isClosed) return;

    final addressResult = await _cartRepository.getAddresses();
    final paymentResult = await _cartRepository.getPaymentMethods();
    if (isClosed) return;

    cartResult.fold(
      (failure) {
        if (!isClosed) {
          emit(CartError(failure));
        }
      },
      (cartData) {
        if (isClosed) return;

        if (cartData.cart.isEmpty) {
          emit(CartEmpty(cartData: cartData));
          return;
        }

        final List<DeliveryAddressEntity> addresses = addressResult.getOrElse(
          () => <DeliveryAddressEntity>[],
        );
        final List<PaymentMethodEntity> paymentMethods = paymentResult
            .getOrElse(() => <PaymentMethodEntity>[]);

        var defaultAddress = addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addresses.isNotEmpty
              ? addresses.first
              : const DeliveryAddressEntity(
                  id: 'default',
                  title: 'العنوان الرئيسى',
                  recipientName: 'العميل',
                  phoneNumber: '01000000000',
                  governorate: 'القاهرة',
                  city: 'مدينة نصر',
                  addressDetails: 'شارع 15',
                ),
        );

        if (state is CartLoaded) {
          final previousAddress = (state as CartLoaded).selectedAddress;
          if (previousAddress != null &&
              addresses.any((a) => a.id == previousAddress.id)) {
            defaultAddress = previousAddress;
          }
        }

        final effectivePaymentMethods = paymentMethods.isNotEmpty
            ? paymentMethods
            : const [
                PaymentMethodEntity(
                  id: 'pay_cash',
                  title: 'الدفع عند الاستلام (كاش)',
                  subtitle: 'الدفع نقداً عند استلام الطلب',
                  type: PaymentType.cash,
                  icon: 'assets/icons/cod.png',
                ),
                PaymentMethodEntity(
                  id: 'pay_instapay',
                  title: 'انستاباي (InstaPay)',
                  subtitle: 'التحويل المباشر عبر تطبيق انستاباي',
                  type: PaymentType.instapay,
                  icon: 'assets/icons/instapay.png',
                ),
                PaymentMethodEntity(
                  id: 'pay_wallet',
                  title: 'محفظة كاش',
                  subtitle: 'فودافون كاش، أورنج، اتصالات، وي كاش',
                  type: PaymentType.vodafoneCash,
                  icon: 'assets/icons/wallet.png',
                ),
              ];
        PaymentMethodEntity defaultPayment = effectivePaymentMethods.first;
        if (state is CartLoaded) {
          final previousPayment = (state as CartLoaded).selectedPaymentMethod;
          if (previousPayment != null &&
              effectivePaymentMethods.any((m) => m.id == previousPayment.id)) {
            defaultPayment = previousPayment;
          }
        }

        final productIds =
            cartData.cart.map((e) => e.product.id).toList();
        CacheHelper.setCartProductIds(productIds);

        emit(
          CartLoaded(
            cartData: cartData,
            availableAddresses: addresses,
            availablePaymentMethods: effectivePaymentMethods,
            selectedAddress: defaultAddress,
            selectedPaymentMethod: defaultPayment,
          ),
        );
      },
    );
  }

  /// Add a product to the cart via POST /v1/cart.
  /// After successful mutation, calls GET /v1/cart to re-sync authoritative totals.
  Future<bool> addToCart({required dynamic productId, int quantity = 1}) async {
    if (_isMutating) return false;
    _isMutating = true;

    try {
      final result = await _addToCartUseCase(
        productId: productId,
        quantity: quantity,
      );

      _isMutating = false;

      return result.fold(
        (failure) {
          return false;
        },
        (_) {
          CacheHelper.addCartProductId(productId);
          loadCart();
          CartEventBus.instance.notifyCartUpdated();
          return true;
        },
      );
    } catch (_) {
      _isMutating = false;
      return false;
    }
  }

  /// Update quantity of a cart item via PUT /v1/cart/{id}.
  /// Quantity must never be less than 1.
  /// After successful update, calls loadCart() to re-sync authoritative totals.
  Future<bool> updateQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity < 1 || _isMutating) return false;
    _isMutating = true;

    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(updatingCartItemId: cartItemId));
    }

    try {
      final result = await _updateCartItemQuantityUseCase(
        cartItemId: cartItemId,
        qty: newQuantity,
      );

      _isMutating = false;

      return result.fold(
        (failure) {
          if (!isClosed && state is CartLoaded) {
            emit(
              (state as CartLoaded).copyWith(nullifyUpdatingCartItemId: true),
            );
          }
          return false;
        },
        (_) {
          loadCart();
          return true;
        },
      );
    } catch (_) {
      _isMutating = false;
      if (!isClosed && state is CartLoaded) {
        emit((state as CartLoaded).copyWith(nullifyUpdatingCartItemId: true));
      }
      return false;
    }
  }

  /// Remove a cart line item via DELETE /v1/cart/{id}.
  /// After successful deletion, calls loadCart() to re-sync authoritative totals.
  Future<bool> removeItem(int cartItemId) async {
    if (_isMutating) return false;
    _isMutating = true;

    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(deletingCartItemId: cartItemId));
    }

    try {
      final result = await _deleteCartItemUseCase(cartItemId);

      _isMutating = false;

      return result.fold(
        (failure) {
          if (!isClosed && state is CartLoaded) {
            emit(
              (state as CartLoaded).copyWith(nullifyDeletingCartItemId: true),
            );
          }
          return false;
        },
        (_) {
          loadCart();
          CartEventBus.instance.notifyCartUpdated();
          return true;
        },
      );
    } catch (_) {
      _isMutating = false;
      if (!isClosed && state is CartLoaded) {
        emit((state as CartLoaded).copyWith(nullifyDeletingCartItemId: true));
      }
      return false;
    }
  }

  /// Clear entire cart via DELETE /v1/cart-clear.
  /// After successful clear, calls loadCart() to re-sync authoritative cart data.
  Future<bool> clearCart() async {
    if (_isMutating) return false;
    _isMutating = true;

    emit(CartLoading());

    try {
      final result = await _clearCartUseCase();

      _isMutating = false;

      return result.fold(
        (failure) {
          if (!isClosed) {
            emit(CartError(failure));
          }
          return false;
        },
        (_) {
          CacheHelper.setCartProductIds([]);
          loadCart();
          CartEventBus.instance.notifyCartUpdated();
          return true;
        },
      );
    } catch (e) {
      _isMutating = false;
      if (!isClosed) {
        emit(
          CartError(
            AppErrorHandler.getMessage(e, defaultMessage: 'فشل في إفراغ السلة'),
          ),
        );
      }
      return false;
    }
  }

  Future<void> applyCoupon(String code) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    if (code.trim().isEmpty) {
      emit(currentState.copyWith(couponError: 'يرجى إدخال كود الخصم'));
      return;
    }

    emit(
      currentState.copyWith(isApplyingCoupon: true, nullifyCouponError: true),
    );

    final result = await _applyCouponUseCase(code);
    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          currentState.copyWith(isApplyingCoupon: false, couponError: error),
        );
      },
      (coupon) {
        emit(
          currentState.copyWith(
            isApplyingCoupon: false,
            coupon: coupon,
            nullifyCouponError: true,
          ),
        );
      },
    );
  }

  void removeCoupon() {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(nullifyCoupon: true, nullifyCouponError: true));
  }

  void selectAddress(DeliveryAddressEntity address) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final updatedAddresses = List<DeliveryAddressEntity>.from(
      currentState.availableAddresses,
    );
    final idx = updatedAddresses.indexWhere((a) => a.id == address.id);
    if (idx >= 0) {
      updatedAddresses[idx] = address;
    } else {
      updatedAddresses.add(address);
    }

    emit(
      currentState.copyWith(
        selectedAddress: address,
        availableAddresses: updatedAddresses,
      ),
    );
  }

  void selectPaymentMethod(PaymentMethodEntity paymentMethod) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(selectedPaymentMethod: paymentMethod));
  }

  Future<void> placeOrder({
    String? paymentMethod,
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(OrderProcessing());

    final selectedAddressText =
        address ?? currentState.selectedAddress?.fullAddress;
    final selectedPhone = phone ?? currentState.selectedAddress?.phoneNumber;

    String resolvePaymentMethod() {
      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        return paymentMethod;
      }
      final selected = currentState.selectedPaymentMethod;
      if (selected == null) return 'cash';
      switch (selected.type) {
        case PaymentType.cash:
        case PaymentType.cashOnDelivery:
          return 'cash';
        case PaymentType.instapay:
          return 'instapay';
        case PaymentType.visaMastercard:
          return 'card';
        case PaymentType.vodafoneCash:
          return 'vodafone_cash';
        case PaymentType.wallet:
          return 'wallet';
        case PaymentType.applePay:
          return 'apple_pay';
        case PaymentType.googlePay:
          return 'google_pay';
      }
    }

    final effectivePaymentMethod = resolvePaymentMethod();

    final result = await _placeOrderUseCase(
      paymentMethod: effectivePaymentMethod,
      address: selectedAddressText,
      phone: selectedPhone,
      usePoints: usePoints,
      pointsToRedeem: pointsToRedeem,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(CartError(failure)),
      (order) => emit(OrderSuccess(order)),
    );
  }
}
