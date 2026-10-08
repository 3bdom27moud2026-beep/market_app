// ignore_for_file: prefer_initializing_formals
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import '../../models/cart_response_model.dart';
import '../../models/merchant_model.dart';
import '../../models/coupon_model.dart';
import '../../models/delivery_address_model.dart';
import '../../models/payment_method_model.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../models/order_model.dart';

/// Remote data source for cart API operations.
class CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch authoritative user cart from GET /v1/cart
  Future<CartResponseModel> getCart() async {
    final response = await _apiClient.get(EndPoints.userCart);
    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      return CartResponseModel.fromJson(raw);
    }
    return const CartResponseModel(
      status: false,
      isMember: false,
      cart: [],
      cartTotal: 0,
      cartSavings: 0,
      cartCount: 0,
    );
  }

  /// Add a product to cart via POST /v1/cart
  ///
  /// Request body (exact confirmed contract):
  /// ```json
  /// {
  ///   "product_id": 1,
  ///   "qty": 2
  /// }
  /// ```
  Future<void> addToCart({required int productId, required int qty}) async {
    final payload = {'product_id': productId, 'qty': qty};

    await _apiClient.post(EndPoints.userCart, data: payload);
  }

  /// Update quantity of a cart line item via PUT /v1/cart/{id}
  ///
  /// Request body:
  /// ```json
  /// {
  ///   "qty": 3
  /// }
  /// ```
  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  }) async {
    final payload = {'qty': qty};
    await _apiClient.put('${EndPoints.userCart}/$cartItemId', data: payload);
  }

  /// Delete a cart line item via DELETE /v1/cart/{id}
  Future<void> deleteCartItem(int cartItemId) async {
    await _apiClient.delete('${EndPoints.userCart}/$cartItemId');
  }

  /// Legacy helper for merchant-grouped items during checkout.
  Future<List<MerchantModel>> getCartMerchants() async {
    final cartResponse = await getCart();
    final Map<String, List<dynamic>> grouped = {};
    final Map<String, String> merchantNames = {};

    for (final item in cartResponse.cart) {
      final mId = item.product.store.isNotEmpty ? item.product.store : '1';
      grouped.putIfAbsent(mId, () => []).add(item);
      merchantNames[mId] = item.product.store.isNotEmpty
          ? item.product.store
          : 'المتجر';
    }

    return grouped.entries.map((entry) {
      return MerchantModel(
        id: entry.key,
        name: merchantNames[entry.key] ?? 'المتجر',
        items: const [],
      );
    }).toList();
  }

  /// Update quantity of item in cart
  /// [BLOCKED]: HTTP method (PUT vs PATCH) is UNKNOWN.
  Future<List<MerchantModel>> updateItemQuantity({
    required String itemId,
    required int newQuantity,
  }) async {
    throw UnimplementedError(
      'Contract Blocked: HTTP method for updating cart item is UNKNOWN.',
    );
  }

  /// Remove item from cart
  /// [BLOCKED]: HTTP method is UNKNOWN.
  Future<List<MerchantModel>> removeCartItem(String itemId) async {
    throw UnimplementedError(
      'Contract Blocked: HTTP method for removing cart item is UNKNOWN.',
    );
  }

  /// Clear entire cart via DELETE /v1/cart-clear
  Future<void> clearCart() async {
    await _apiClient.delete(EndPoints.cartClear);
  }

  /// Apply promo coupon code via POST /v1/cart/coupon
  Future<CouponModel> applyCoupon(String code) async {
    final response = await _apiClient.post(
      '${EndPoints.userCart}/coupon',
      data: {'code': code},
    );

    final raw = response.data;
    final Map<String, dynamic> payload = raw is Map<String, dynamic>
        ? (raw['data'] is Map<String, dynamic>
              ? raw['data'] as Map<String, dynamic>
              : raw)
        : {};

    return CouponModel.fromJson(payload);
  }

  /// Returns user delivery addresses.
  Future<List<DeliveryAddressModel>> getAddresses() async {
    return const [
      DeliveryAddressModel(
        id: 'default',
        title: 'العنوان الرئيسي',
        recipientName: 'مستخدم تسوق',
        phoneNumber: '01014548578',
        governorate: 'القاهرة',
        city: 'مدينة نصر',
        addressDetails: 'شارع 15',
        isDefault: true,
      ),
    ];
  }

  /// Returns supported payment methods.
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return const [
      PaymentMethodModel(
        id: 'cod',
        title: 'الدفع عند الاستلام',
        subtitle: 'الدفع نقداً عند استلام طلبك',
        type: PaymentType.cashOnDelivery,
        icon: '',
      ),
      PaymentMethodModel(
        id: 'card',
        title: 'بطاقة بنكية',
        subtitle: 'فيزا / ماستركارد / بطاقات ميزة',
        type: PaymentType.visaMastercard,
        icon: '',
      ),
      PaymentMethodModel(
        id: 'wallet',
        title: 'محفظة إلكترونية',
        subtitle: 'فودافون كاش / إنستاباي / المحافظ الذكية',
        type: PaymentType.vodafoneCash,
        icon: '',
      ),
    ];
  }

  /// Place an order via POST /v1/orders
  ///
  /// Request body:
  /// ```json
  /// Place an order.
  ///
  /// ```json
  /// {
  ///   "payment_method": "cash",
  ///   "address": "...",
  ///   "phone": "...",
  ///   "use_points": true,
  ///   "points_to_redeem": 100
  /// }
  /// ```
  Future<OrderModel> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async {
    final payload = <String, dynamic>{
      'payment_method': paymentMethod,
      if (address != null && address.isNotEmpty) 'address': address,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (usePoints) 'use_points': true,
      if (usePoints && pointsToRedeem > 0) 'points_to_redeem': pointsToRedeem,
    };

    final response = await _apiClient.post(EndPoints.orders, data: payload);

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      return OrderModel.fromApiResponse(raw);
    }

    throw const FormatException('Invalid response format from /v1/orders');
  }

  /// Calculate dynamic shipping cost and estimated delivery.
  /// POST /api/v1/cart/calculate-shipping
  Future<Map<String, dynamic>> calculateShipping({
    int? governorateId,
    int? cityId,
    int? areaId,
  }) async {
    final response = await _apiClient.post(
      EndPoints.calculateShipping,
      data: {
        'governorate_id': ?governorateId,
        'city_id': ?cityId,
        'area_id': ?areaId,
      },
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }
}
