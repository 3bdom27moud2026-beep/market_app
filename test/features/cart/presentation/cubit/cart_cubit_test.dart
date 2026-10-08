import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/cart/domain/entities/cart_data_entity.dart';
import 'package:market/features/cart/domain/entities/cart_item_entity.dart';
import 'package:market/features/cart/domain/entities/coupon_entity.dart';
import 'package:market/features/cart/domain/entities/delivery_address_entity.dart';
import 'package:market/features/cart/domain/entities/merchant_entity.dart';
import 'package:market/features/cart/domain/entities/order_entity.dart';
import 'package:market/features/cart/domain/entities/payment_method_entity.dart';
import 'package:market/features/cart/domain/repository/cart_repository.dart';
import 'package:market/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/apply_coupon_usecase.dart';
import 'package:market/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/delete_cart_item_usecase.dart';
import 'package:market/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/place_order_usecase.dart';
import 'package:market/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:market/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:market/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/cubit/cart_state.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

class FakeAuthRepo implements AuthRepository {
  final bool loggedIn;
  FakeAuthRepo({required this.loggedIn});

  @override
  bool isLoggedIn() => loggedIn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCartRepo implements CartRepository {
  Either<String, CartDataEntity>? mockCartResult;
  Either<String, void>? mockAddToCartResult;
  Either<String, void>? mockUpdateCartItemQuantityResult;
  Either<String, void>? mockDeleteCartItemResult;
  Either<String, void>? mockClearCartResult;
  int getCartCalls = 0;
  int addToCartCalls = 0;
  int updateCartItemQuantityCalls = 0;
  int deleteCartItemCalls = 0;
  int clearCartCalls = 0;
  int? lastUpdatedCartItemId;
  int? lastUpdatedQty;
  int? lastDeletedCartItemId;

  @override
  Future<Either<String, CartDataEntity>> getCart() async {
    getCartCalls++;
    return mockCartResult ?? const Right(CartDataEntity.empty());
  }

  @override
  Future<Either<String, void>> addToCart({
    required int productId,
    required int qty,
  }) async {
    addToCartCalls++;
    return mockAddToCartResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  }) async {
    updateCartItemQuantityCalls++;
    lastUpdatedCartItemId = cartItemId;
    lastUpdatedQty = qty;
    return mockUpdateCartItemQuantityResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> deleteCartItem(int cartItemId) async {
    deleteCartItemCalls++;
    lastDeletedCartItemId = cartItemId;
    return mockDeleteCartItemResult ?? const Right(null);
  }

  @override
  Future<Either<String, void>> clearCart() async {
    clearCartCalls++;
    return mockClearCartResult ?? const Right(null);
  }

  @override
  Future<Either<String, List<DeliveryAddressEntity>>> getAddresses() async =>
      const Right([]);

  @override
  Future<Either<String, List<PaymentMethodEntity>>> getPaymentMethods() async =>
      const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<String, CouponEntity>> applyCoupon(String code) async =>
      throw UnimplementedError();

  @override
  Future<Either<String, List<MerchantEntity>>> getCartMerchants() async =>
      const Right([]);

  String? lastPlaceOrderPaymentMethod;
  Either<String, OrderEntity>? mockPlaceOrderResult;

  @override
  Future<Either<String, OrderEntity>> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async {
    lastPlaceOrderPaymentMethod = paymentMethod;
    return mockPlaceOrderResult ??
        Right(
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
  late FakeCartRepo fakeCartRepo;
  late GetCartUseCase getCartUseCase;
  late AddToCartUseCase addToCartUseCase;
  late UpdateQuantityUseCase updateQuantityUseCase;
  late UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  late DeleteCartItemUseCase deleteCartItemUseCase;
  late ClearCartUseCase clearCartUseCase;
  late RemoveCartItemUseCase removeCartItemUseCase;
  late ApplyCouponUseCase applyCouponUseCase;
  late PlaceOrderUseCase placeOrderUseCase;

  const testProduct = ProductEntity(
    id: '5',
    name: 'مشروب لاتيه',
    store: 'ستاربكس',
    image: '',
    price: 65,
    oldPrice: 120,
    discount: 45,
    rating: 4.8,
    displayPrice: 65,
    originalPrice: 120,
    memberPrice: 65,
    savingsAmount: 55,
  );

  const testCartItem = CartItemEntity(
    id: 16,
    qty: 2,
    lineTotal: 130,
    lineSavings: 110,
    product: testProduct,
  );

  const testCartData = CartDataEntity(
    status: true,
    isMember: true,
    cart: [testCartItem],
    cartTotal: 130,
    cartSavings: 110,
    cartCount: 1,
  );

  const emptyCartData = CartDataEntity(
    status: true,
    isMember: false,
    cart: [],
    cartTotal: 0,
    cartSavings: 0,
    cartCount: 0,
  );

  setUp(() {
    fakeCartRepo = FakeCartRepo();
    getCartUseCase = GetCartUseCase(fakeCartRepo);
    addToCartUseCase = AddToCartUseCase(fakeCartRepo);
    updateQuantityUseCase = UpdateQuantityUseCase(fakeCartRepo);
    updateCartItemQuantityUseCase = UpdateCartItemQuantityUseCase(fakeCartRepo);
    deleteCartItemUseCase = DeleteCartItemUseCase(fakeCartRepo);
    clearCartUseCase = ClearCartUseCase(fakeCartRepo);
    removeCartItemUseCase = RemoveCartItemUseCase(fakeCartRepo);
    applyCouponUseCase = ApplyCouponUseCase(fakeCartRepo);
    placeOrderUseCase = PlaceOrderUseCase(fakeCartRepo);
  });

  CartCubit createCubit({bool loggedIn = true}) {
    return CartCubit(
      getCartUseCase: getCartUseCase,
      updateQuantityUseCase: updateQuantityUseCase,
      updateCartItemQuantityUseCase: updateCartItemQuantityUseCase,
      deleteCartItemUseCase: deleteCartItemUseCase,
      clearCartUseCase: clearCartUseCase,
      removeCartItemUseCase: removeCartItemUseCase,
      applyCouponUseCase: applyCouponUseCase,
      placeOrderUseCase: placeOrderUseCase,
      addToCartUseCase: addToCartUseCase,
      cartRepository: fakeCartRepo,
      checkAuthUseCase: CheckAuthUseCase(FakeAuthRepo(loggedIn: loggedIn)),
    );
  }

  group('CartCubit', () {
    test('initial state is CartInitial', () {
      final cubit = createCubit();
      expect(cubit.state, isA<CartInitial>());
      cubit.close();
    });

    test('emits CartUnauthenticated when user is logged out', () async {
      final cubit = createCubit(loggedIn: false);

      expectLater(cubit.stream, emitsInOrder([isA<CartUnauthenticated>()]));

      await cubit.loadCart();
      expect(cubit.state, isA<CartUnauthenticated>());
      cubit.close();
    });

    test(
      'emits [CartLoading, CartLoaded] on successful fetch of populated cart',
      () async {
        fakeCartRepo.mockCartResult = const Right(testCartData);
        final cubit = createCubit();

        expectLater(
          cubit.stream,
          emitsInOrder([isA<CartLoading>(), isA<CartLoaded>()]),
        );

        await cubit.loadCart();
        expect(cubit.state, isA<CartLoaded>());
        final loaded = cubit.state as CartLoaded;
        expect(loaded.total, 130);
        expect(loaded.savings, 110);
        expect(loaded.totalItemsCount, 1);
        expect(loaded.items.length, 1);

        cubit.close();
      },
    );

    test(
      'emits [CartLoading, CartEmpty] on successful fetch of empty cart',
      () async {
        fakeCartRepo.mockCartResult = const Right(emptyCartData);
        final cubit = createCubit();

        expectLater(
          cubit.stream,
          emitsInOrder([isA<CartLoading>(), isA<CartEmpty>()]),
        );

        await cubit.loadCart();
        expect(cubit.state, isA<CartEmpty>());
        final empty = cubit.state as CartEmpty;
        expect(empty.cartData.cart.isEmpty, true);

        cubit.close();
      },
    );

    test('emits [CartLoading, CartError] on failure', () async {
      fakeCartRepo.mockCartResult = const Left('Network connection failed');
      final cubit = createCubit();

      expectLater(
        cubit.stream,
        emitsInOrder([isA<CartLoading>(), isA<CartError>()]),
      );

      await cubit.loadCart();
      expect(cubit.state, isA<CartError>());
      final error = cubit.state as CartError;
      expect(error.message, 'Network connection failed');

      cubit.close();
    });

    test('addToCart triggers use case and reloads cart upon success', () async {
      fakeCartRepo.mockAddToCartResult = const Right(null);
      fakeCartRepo.mockCartResult = const Right(testCartData);

      final cubit = createCubit();
      final success = await cubit.addToCart(productId: 5, quantity: 2);

      expect(success, true);
      expect(fakeCartRepo.addToCartCalls, 1);
      expect(fakeCartRepo.getCartCalls, 1);

      cubit.close();
    });

    test(
      'updateQuantity triggers usecase and reloads cart upon success',
      () async {
        fakeCartRepo.mockUpdateCartItemQuantityResult = const Right(null);
        fakeCartRepo.mockCartResult = const Right(testCartData);

        final cubit = createCubit();
        final success = await cubit.updateQuantity(16, 3);

        expect(success, true);
        expect(fakeCartRepo.updateCartItemQuantityCalls, 1);
        expect(fakeCartRepo.lastUpdatedCartItemId, 16);
        expect(fakeCartRepo.lastUpdatedQty, 3);
        expect(fakeCartRepo.getCartCalls, 1);

        cubit.close();
      },
    );

    test('updateQuantity rejects quantity less than 1', () async {
      final cubit = createCubit();
      final success = await cubit.updateQuantity(16, 0);

      expect(success, false);
      expect(fakeCartRepo.updateCartItemQuantityCalls, 0);
      expect(fakeCartRepo.getCartCalls, 0);

      cubit.close();
    });

    test(
      'removeItem triggers delete usecase and reloads cart upon success',
      () async {
        fakeCartRepo.mockDeleteCartItemResult = const Right(null);
        fakeCartRepo.mockCartResult = const Right(emptyCartData);

        final cubit = createCubit();
        final success = await cubit.removeItem(16);

        expect(success, true);
        expect(fakeCartRepo.deleteCartItemCalls, 1);
        expect(fakeCartRepo.lastDeletedCartItemId, 16);
        expect(fakeCartRepo.getCartCalls, 1);

        cubit.close();
      },
    );

    test(
      'clearCart triggers clear usecase and reloads cart upon success',
      () async {
        fakeCartRepo.mockClearCartResult = const Right(null);
        fakeCartRepo.mockCartResult = const Right(emptyCartData);

        final cubit = createCubit();
        final success = await cubit.clearCart();

        expect(success, true);
        expect(fakeCartRepo.clearCartCalls, 1);
        expect(fakeCartRepo.getCartCalls, 1);

        cubit.close();
      },
    );

    test(
      'placeOrder emits [OrderProcessing, OrderSuccess] on success',
      () async {
        fakeCartRepo.mockCartResult = const Right(testCartData);
        final cubit = createCubit();
        await cubit.loadCart();

        expectLater(
          cubit.stream,
          emitsInOrder([isA<OrderProcessing>(), isA<OrderSuccess>()]),
        );

        await cubit.placeOrder(paymentMethod: 'cash');
        expect(fakeCartRepo.lastPlaceOrderPaymentMethod, 'cash');
        expect(cubit.state, isA<OrderSuccess>());

        cubit.close();
      },
    );

    test('placeOrder emits [OrderProcessing, CartError] on failure', () async {
      fakeCartRepo.mockCartResult = const Right(testCartData);
      fakeCartRepo.mockPlaceOrderResult = const Left('فشل في إتمام الطلب');
      final cubit = createCubit();
      await cubit.loadCart();

      expectLater(
        cubit.stream,
        emitsInOrder([isA<OrderProcessing>(), isA<CartError>()]),
      );

      await cubit.placeOrder(paymentMethod: 'cash');
      expect(cubit.state, isA<CartError>());
      expect((cubit.state as CartError).message, 'فشل في إتمام الطلب');

      cubit.close();
    });
  });
}
