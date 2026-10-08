import 'package:dartz/dartz.dart';
import '../entities/cart_data_entity.dart';
import '../entities/merchant_entity.dart';
import '../entities/coupon_entity.dart';
import '../entities/delivery_address_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/order_entity.dart';

/// Abstract repository interface for shopping cart operations.
abstract class CartRepository {
  /// Fetch authoritative cart from backend (GET /v1/cart).
  Future<Either<String, CartDataEntity>> getCart();

  /// Add item to cart (POST /v1/cart).
  Future<Either<String, void>> addToCart({
    required int productId,
    required int qty,
  });

  /// Update quantity of a cart line item (PUT /v1/cart/{id}).
  Future<Either<String, void>> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  });

  /// Delete a cart line item (DELETE /v1/cart/{id}).
  Future<Either<String, void>> deleteCartItem(int cartItemId);

  /// Clear the entire cart (DELETE /v1/cart-clear).
  Future<Either<String, void>> clearCart();

  /// Legacy helper for merchant-grouped items during checkout.
  Future<Either<String, List<MerchantEntity>>> getCartMerchants();

  /// Legacy update quantity helper for checkout.
  Future<Either<String, List<MerchantEntity>>> updateItemQuantity({
    required String itemId,
    required int newQuantity,
  });

  /// Remove item from cart (BLOCKED: HTTP method UNKNOWN).
  Future<Either<String, List<MerchantEntity>>> removeCartItem(String itemId);

  /// Apply promo coupon code.
  Future<Either<String, CouponEntity>> applyCoupon(String code);

  /// Get list of user delivery addresses.
  Future<Either<String, List<DeliveryAddressEntity>>> getAddresses();

  /// Get supported payment methods.
  Future<Either<String, List<PaymentMethodEntity>>> getPaymentMethods();

  /// Place an order.
  Future<Either<String, OrderEntity>> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  });
}
