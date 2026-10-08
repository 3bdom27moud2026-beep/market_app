import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:market/features/cart/presentation/pages/basket_screen.dart';
import 'package:market/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

class FakeAuthRepository implements AuthRepository {
  final bool loggedIn;
  FakeAuthRepository({required this.loggedIn});

  @override
  bool isLoggedIn() => loggedIn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCartRepo implements CartRepository {
  final Either<String, CartDataEntity> cartResult;
  int updateQuantityCalls = 0;
  int deleteCartItemCalls = 0;
  int clearCartCalls = 0;
  int? lastUpdatedItemId;
  int? lastUpdatedQty;
  int? lastDeletedItemId;

  FakeCartRepo(this.cartResult);

  @override
  Future<Either<String, CartDataEntity>> getCart() async => cartResult;

  @override
  Future<Either<String, void>> addToCart({
    required int productId,
    required int qty,
  }) async => const Right(null);

  @override
  Future<Either<String, void>> updateCartItemQuantity({
    required int cartItemId,
    required int qty,
  }) async {
    updateQuantityCalls++;
    lastUpdatedItemId = cartItemId;
    lastUpdatedQty = qty;
    return const Right(null);
  }

  @override
  Future<Either<String, void>> deleteCartItem(int cartItemId) async {
    deleteCartItemCalls++;
    lastDeletedItemId = cartItemId;
    return const Right(null);
  }

  @override
  Future<Either<String, void>> clearCart() async {
    clearCartCalls++;
    return const Right(null);
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

  @override
  Future<Either<String, OrderEntity>> placeOrder({
    String paymentMethod = 'cash',
    String? address,
    String? phone,
    bool usePoints = false,
    int pointsToRedeem = 0,
  }) async => throw UnimplementedError();

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
  const testProduct = ProductEntity(
    id: '5',
    name: 'مشروب لاتيه مثلج',
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

  CartCubit createCubit({
    required Either<String, CartDataEntity> result,
    bool loggedIn = true,
    FakeCartRepo? repo,
  }) {
    final effectiveRepo = repo ?? FakeCartRepo(result);
    return CartCubit(
      getCartUseCase: GetCartUseCase(effectiveRepo),
      updateQuantityUseCase: UpdateQuantityUseCase(effectiveRepo),
      updateCartItemQuantityUseCase: UpdateCartItemQuantityUseCase(
        effectiveRepo,
      ),
      deleteCartItemUseCase: DeleteCartItemUseCase(effectiveRepo),
      clearCartUseCase: ClearCartUseCase(effectiveRepo),
      removeCartItemUseCase: RemoveCartItemUseCase(effectiveRepo),
      applyCouponUseCase: ApplyCouponUseCase(effectiveRepo),
      placeOrderUseCase: PlaceOrderUseCase(effectiveRepo),
      addToCartUseCase: AddToCartUseCase(effectiveRepo),
      cartRepository: effectiveRepo,
      checkAuthUseCase: CheckAuthUseCase(
        FakeAuthRepository(loggedIn: loggedIn),
      ),
    );
  }

  Widget buildTestableWidget(CartCubit cubit) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        home: BlocProvider<CartCubit>.value(
          value: cubit,
          child: const BasketScreen(),
        ),
      ),
    );
  }

  group('BasketScreen Widget Tests', () {
    testWidgets('renders EmptyCartWidget during CartEmpty', (tester) async {
      final cubit = createCubit(result: const Right(emptyCartData));

      await tester.pumpWidget(buildTestableWidget(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyCartWidget), findsOneWidget);
      expect(find.text('السلة فارغة'), findsOneWidget);
      cubit.close();
    });

    testWidgets(
      'renders unauthenticated message and login button on CartUnauthenticated',
      (tester) async {
        final cubit = createCubit(
          result: const Right(testCartData),
          loggedIn: false,
        );

        await tester.pumpWidget(buildTestableWidget(cubit));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('سجل الدخول لعرض سلة التسوق'), findsOneWidget);
        expect(find.text('تسجيل الدخول'), findsOneWidget);
        cubit.close();
      },
    );

    testWidgets('renders authoritative items and backend totals on CartLoaded', (
      tester,
    ) async {
      final cubit = createCubit(result: const Right(testCartData));

      await tester.pumpWidget(buildTestableWidget(cubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify product name and brand rendered
      expect(find.text('مشروب لاتيه مثلج'), findsOneWidget);
      expect(find.text('ستاربكس'), findsWidgets);

      // Verify authoritative backend totals rendered (130 ج.م and 110 ج.م savings)
      expect(find.text('130 ج.م'), findsWidgets);
      expect(find.text('وفرت 110 ج.م'), findsOneWidget);
      expect(find.text('عضو مميز'), findsOneWidget);

      cubit.close();
    });

    testWidgets(
      'tapping increase quantity calls updateQuantity with item id and qty + 1',
      (tester) async {
        final fakeRepo = FakeCartRepo(const Right(testCartData));
        final cubit = createCubit(
          result: const Right(testCartData),
          repo: fakeRepo,
        );

        await tester.pumpWidget(buildTestableWidget(cubit));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Find the add icon in QuantitySelector
        final addIcon = find.byIcon(Icons.add_rounded);
        expect(addIcon, findsOneWidget);

        await tester.tap(addIcon);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(fakeRepo.updateQuantityCalls, 1);
        expect(fakeRepo.lastUpdatedItemId, 16);
        expect(fakeRepo.lastUpdatedQty, 3);

        cubit.close();
      },
    );

    testWidgets(
      'tapping delete icon shows confirmation dialog and cancels on cancel press',
      (tester) async {
        final fakeRepo = FakeCartRepo(const Right(testCartData));
        final cubit = createCubit(
          result: const Right(testCartData),
          repo: fakeRepo,
        );

        await tester.pumpWidget(buildTestableWidget(cubit));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        final deleteIcon = find.byIcon(Icons.delete_outline_rounded);
        expect(deleteIcon, findsOneWidget);

        await tester.tap(deleteIcon);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('حذف المنتج؟'), findsOneWidget);
        expect(
          find.text('هل أنت متأكد من حذف هذا المنتج من سلة التسوق؟'),
          findsOneWidget,
        );

        // Tap cancel
        await tester.tap(find.text('إلغاء'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(fakeRepo.deleteCartItemCalls, 0);

        cubit.close();
      },
    );

    testWidgets(
      'tapping delete icon and confirming calls deleteCartItem with cart item id',
      (tester) async {
        final fakeRepo = FakeCartRepo(const Right(testCartData));
        final cubit = createCubit(
          result: const Right(testCartData),
          repo: fakeRepo,
        );

        await tester.pumpWidget(buildTestableWidget(cubit));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        final deleteIcon = find.byIcon(Icons.delete_outline_rounded);
        await tester.tap(deleteIcon);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Tap confirm delete
        await tester.tap(find.text('حذف'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(fakeRepo.deleteCartItemCalls, 1);
        expect(fakeRepo.lastDeletedItemId, 16);

        cubit.close();
      },
    );

    testWidgets(
      'tapping clear cart button shows confirmation dialog and cancels on cancel press',
      (tester) async {
        final fakeRepo = FakeCartRepo(const Right(testCartData));
        final cubit = createCubit(
          result: const Right(testCartData),
          repo: fakeRepo,
        );

        await tester.pumpWidget(buildTestableWidget(cubit));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        final clearButton = find.text('إفراغ السلة');
        expect(clearButton, findsOneWidget);

        await tester.tap(clearButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('إفراغ السلة؟'), findsOneWidget);
        expect(
          find.text('هل أنت متأكد من حذف جميع المنتجات من سلة التسوق؟'),
          findsOneWidget,
        );

        // Tap cancel
        await tester.tap(find.text('إلغاء'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(fakeRepo.clearCartCalls, 0);

        cubit.close();
      },
    );

    testWidgets('tapping clear cart button and confirming calls clearCart', (
      tester,
    ) async {
      final fakeRepo = FakeCartRepo(const Right(testCartData));
      final cubit = createCubit(
        result: const Right(testCartData),
        repo: fakeRepo,
      );

      await tester.pumpWidget(buildTestableWidget(cubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final clearButton = find.text('إفراغ السلة');
      await tester.tap(clearButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap confirm clear button inside the dialog
      final dialogConfirmButton = find.widgetWithText(
        ElevatedButton,
        'إفراغ السلة',
      );
      await tester.tap(dialogConfirmButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(fakeRepo.clearCartCalls, 1);

      cubit.close();
    });
  });
}
