import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/cart_data_entity.dart';
import '../../domain/entities/merchant_entity.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/entities/delivery_address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repository/cart_repository.dart';
import '../datasource/local/cart_local_datasource.dart';
import '../datasource/remote/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<String, CartDataEntity>> getCart() async {
    try {
      final cartResponse = await _remoteDataSource.getCart();
      return Right(cartResponse);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تحميل السلة'),
      );
    }
  }

  @override
  Future<Either<String, void>> addToCart({
    required int productId,
    required int qty,
  }) async {
    try {
      await _remoteDataSource.addToCart(productId: productId, qty: qty);
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في إضافة المنتج إلى السلة',
        ),
      );
    }
  }

  @override
  Future<Either<String, void>> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  }) async {
    try {
      await _remoteDataSource.updateCartItemQuantity(
        cartItemId: cartItemId,
        qty: qty,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تحديث الكمية'),
      );
    }
  }

  @override
  Future<Either<String, void>> deleteCartItem(int cartItemId) async {
    try {
      await _remoteDataSource.deleteCartItem(cartItemId);
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في حذف المنتج من السلة',
        ),
      );
    }
  }

  @override
  Future<Either<String, void>> clearCart() async {
    try {
      await _remoteDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في إفراغ السلة'),
      );
    }
  }

  @override
  Future<Either<String, List<MerchantEntity>>> getCartMerchants() async {
    try {
      final merchants = await _remoteDataSource.getCartMerchants();
      return Right(merchants);
    } catch (e) {
      try {
        final cached = await _localDataSource.getCartMerchants();
        return Right(cached);
      } catch (_) {
        return Left(
          AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تحميل السلة'),
        );
      }
    }
  }

  @override
  Future<Either<String, List<MerchantEntity>>> updateItemQuantity({
    required String itemId,
    required int newQuantity,
  }) async {
    try {
      final merchants = await _remoteDataSource.updateItemQuantity(
        itemId: itemId,
        newQuantity: newQuantity,
      );
      return Right(merchants);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تحديث الكمية'),
      );
    }
  }

  @override
  Future<Either<String, List<MerchantEntity>>> removeCartItem(
    String itemId,
  ) async {
    try {
      final merchants = await _remoteDataSource.removeCartItem(itemId);
      return Right(merchants);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في حذف المنتج'),
      );
    }
  }

  @override
  Future<Either<String, CouponEntity>> applyCoupon(String code) async {
    try {
      final coupon = await _remoteDataSource.applyCoupon(code);
      return Right(coupon);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'كود الخصم غير صالح أو منتهي الصلاحية',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<DeliveryAddressEntity>>> getAddresses() async {
    try {
      final addresses = await _remoteDataSource.getAddresses();
      if (addresses.isNotEmpty) {
        return Right(addresses.cast<DeliveryAddressEntity>());
      }
      final cached = await _localDataSource.getAddresses();
      return Right(cached.cast<DeliveryAddressEntity>());
    } catch (_) {
      return const Right([
        DeliveryAddressEntity(
          id: 'default',
          title: 'العنوان الرئيسي',
          recipientName: 'مستخدم تسوق',
          phoneNumber: '01014548578',
          governorate: 'القاهرة',
          city: 'مدينة نصر',
          addressDetails: 'شارع 15',
          isDefault: true,
        ),
      ]);
    }
  }

  @override
  Future<Either<String, List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final methods = await _remoteDataSource.getPaymentMethods();
      if (methods.isNotEmpty) {
        return Right(methods);
      }
      final cached = await _localDataSource.getPaymentMethods();
      return Right(cached);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تحميل طرق الدفع'),
      );
    }
  }

  @override
  Future<Either<String, OrderEntity>> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async {
    try {
      final order = await _remoteDataSource.placeOrder(
        paymentMethod: paymentMethod,
        address: address,
        phone: phone,
        usePoints: usePoints,
        pointsToRedeem: pointsToRedeem,
      );
      return Right(order);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في إتمام الطلب'),
      );
    }
  }
}
