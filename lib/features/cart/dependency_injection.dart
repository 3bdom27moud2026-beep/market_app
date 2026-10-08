import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'data/datasource/local/cart_local_datasource.dart';
import 'data/datasource/remote/cart_remote_datasource.dart';
import 'data/repository/cart_repository_impl.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/clear_cart_usecase.dart';
import 'domain/usecases/delete_cart_item_usecase.dart';
import 'domain/usecases/get_cart_usecase.dart';
import 'domain/usecases/update_cart_item_quantity_usecase.dart';
import 'domain/usecases/update_quantity_usecase.dart';
import 'domain/usecases/remove_cart_item_usecase.dart';
import 'domain/usecases/apply_coupon_usecase.dart';
import 'domain/usecases/place_order_usecase.dart';
import 'presentation/cubit/cart_cubit.dart';

abstract final class CartDI {
  static void init() {}

  static CartCubit createCartCubit() {
    final apiClient = CoreDI.sl<ApiClient>();
    final checkAuthUseCase = CoreDI.sl<CheckAuthUseCase>();
    final localDataSource = CartLocalDataSource();
    final remoteDataSource = CartRemoteDataSource(apiClient: apiClient);
    final repository = CartRepositoryImpl(localDataSource, remoteDataSource);

    final getCartUseCase = GetCartUseCase(repository);
    final updateQuantityUseCase = UpdateQuantityUseCase(repository);
    final updateCartItemQuantityUseCase = UpdateCartItemQuantityUseCase(
      repository,
    );
    final deleteCartItemUseCase = DeleteCartItemUseCase(repository);
    final clearCartUseCase = ClearCartUseCase(repository);
    final removeCartItemUseCase = RemoveCartItemUseCase(repository);
    final applyCouponUseCase = ApplyCouponUseCase(repository);
    final placeOrderUseCase = PlaceOrderUseCase(repository);
    final addToCartUseCase = AddToCartUseCase(repository);

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
      cartRepository: repository,
      checkAuthUseCase: checkAuthUseCase,
    );
  }
}
