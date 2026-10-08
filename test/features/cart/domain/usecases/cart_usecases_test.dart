import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/cart/domain/entities/cart_data_entity.dart';
import 'package:market/features/cart/domain/entities/coupon_entity.dart';
import 'package:market/features/cart/domain/entities/delivery_address_entity.dart';
import 'package:market/features/cart/domain/entities/merchant_entity.dart';
import 'package:market/features/cart/domain/entities/order_entity.dart';
import 'package:market/features/cart/domain/entities/payment_method_entity.dart';
import 'package:market/features/cart/domain/repository/cart_repository.dart';
import 'package:market/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/delete_cart_item_usecase.dart';
import 'package:market/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/place_order_usecase.dart';
import 'package:market/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';

class FakeCartRepository implements CartRepository {
  Either<String, CartDataEntity>? mockGetCartResult;
  Either<String, void>? mockAddToCartResult;
  Either<String, void>? mockUpdateCartItemQuantityResult;
  Either<String, void>? mockDeleteCartItemResult;
  Either<String, void>? mockClearCartResult;

  int? lastAddedProductId;
  int? lastAddedQty;
  int? lastUpdatedCartItemId;
  int? lastUpdatedQty;
  int? lastDeletedCartItemId;
  int getCartCallCount = 0;
  int clearCartCallCount = 0;

  @override
  Future<Either<String, CartDataEntity>> getCart() async {
    getCartCallCount++;
    return mockGetCartResult ?? const Right(CartDataEntity.empty());
  }

  @override
  Future<Either<String, void>> addToCart({
    required int productId,
    required int qty,
  }) async {
    lastAddedProductId = productId;
    lastAddedQty = qty;
    return mockAddToCartResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  }) async {
    lastUpdatedCartItemId = cartItemId;
    lastUpdatedQty = qty;
    return mockUpdateCartItemQuantityResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> deleteCartItem(int cartItemId) async {
    lastDeletedCartItemId = cartItemId;
    return mockDeleteCartItemResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> clearCart() async {
    clearCartCallCount++;
    return mockClearCartResult ?? const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<String, CouponEntity>> applyCoupon(String code) async =>
      throw UnimplementedError();

  @override
  Future<Either<String, List<DeliveryAddressEntity>>> getAddresses() async =>
      const Right([]);

  @override
  Future<Either<String, List<MerchantEntity>>> getCartMerchants() async =>
      const Right([]);

  @override
  Future<Either<String, List<PaymentMethodEntity>>> getPaymentMethods() async =>
      const Right([]);

  String? lastPlaceOrderPaymentMethod;

  @override
  Future<Either<String, OrderEntity>> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async {
    lastPlaceOrderPaymentMethod = paymentMethod;
    return Right(
      OrderEntity(
        id: 101,
        orderNo: 'ORD-101',
        totalPrice: 1299,
        savings: 901,
        status: 'pending',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        items: const [],
      ),
    );
  }

  @override
  Future<Either<String, List<MerchantEntity>>> removeCartItem(
    String itemId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<String, List<MerchantEntity>>> updateItemQuantity({
    required String itemId,
    required int newQuantity,
  }) async => throw UnimplementedError();
}

void main() {
  late FakeCartRepository fakeRepository;
  late GetCartUseCase getCartUseCase;
  late AddToCartUseCase addToCartUseCase;
  late UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  late DeleteCartItemUseCase deleteCartItemUseCase;
  late ClearCartUseCase clearCartUseCase;
  late PlaceOrderUseCase placeOrderUseCase;

  setUp(() {
    fakeRepository = FakeCartRepository();
    getCartUseCase = GetCartUseCase(fakeRepository);
    addToCartUseCase = AddToCartUseCase(fakeRepository);
    updateCartItemQuantityUseCase = UpdateCartItemQuantityUseCase(
      fakeRepository,
    );
    deleteCartItemUseCase = DeleteCartItemUseCase(fakeRepository);
    clearCartUseCase = ClearCartUseCase(fakeRepository);
    placeOrderUseCase = PlaceOrderUseCase(fakeRepository);
  });

  group('Cart UseCases', () {
    const testCartData = CartDataEntity(
      status: true,
      isMember: true,
      cart: [],
      cartTotal: 0,
      cartSavings: 0,
      cartCount: 0,
    );

    test('GetCartUseCase should delegate to repository.getCart()', () async {
      fakeRepository.mockGetCartResult = const Right(testCartData);

      final result = await getCartUseCase();

      expect(result, const Right(testCartData));
      expect(fakeRepository.getCartCallCount, 1);
    });

    test(
      'AddToCartUseCase should parse String productId and call repository.addToCart()',
      () async {
        fakeRepository.mockAddToCartResult = const Right(null);

        final result = await addToCartUseCase(productId: '5', quantity: 2);

        expect(result, const Right(null));
        expect(fakeRepository.lastAddedProductId, 5);
        expect(fakeRepository.lastAddedQty, 2);
      },
    );

    test(
      'UpdateCartItemQuantityUseCase should delegate to repository.updateCartItemQuantity()',
      () async {
        fakeRepository.mockUpdateCartItemQuantityResult = const Right(null);

        final result = await updateCartItemQuantityUseCase(
          cartItemId: 16,
          qty: 4,
        );

        expect(result, const Right(null));
        expect(fakeRepository.lastUpdatedCartItemId, 16);
        expect(fakeRepository.lastUpdatedQty, 4);
      },
    );

    test(
      'DeleteCartItemUseCase should delegate to repository.deleteCartItem()',
      () async {
        fakeRepository.mockDeleteCartItemResult = const Right(null);

        final result = await deleteCartItemUseCase(16);

        expect(result, const Right(null));
        expect(fakeRepository.lastDeletedCartItemId, 16);
      },
    );

    test(
      'ClearCartUseCase should delegate to repository.clearCart()',
      () async {
        fakeRepository.mockClearCartResult = const Right(null);

        final result = await clearCartUseCase();

        expect(result, const Right(null));
        expect(fakeRepository.clearCartCallCount, 1);
      },
    );

    test(
      'PlaceOrderUseCase should delegate to repository.placeOrder(paymentMethod: "cash")',
      () async {
        final result = await placeOrderUseCase(paymentMethod: 'cash');

        expect(result.isRight(), true);
        expect(fakeRepository.lastPlaceOrderPaymentMethod, 'cash');
      },
    );
  });
}
