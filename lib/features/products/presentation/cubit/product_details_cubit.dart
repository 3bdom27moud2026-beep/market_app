// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/repository/products_repository.dart';
import 'product_details_state.dart';

/// Cubit for managing product details screen state.
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetails _getProductDetails;
  final ProductsRepository _repository;
  final AddToCartUseCase _addToCartUseCase;
  final GetCartUseCase? _getCartUseCase;

  ProductDetailsCubit({
    required GetProductDetails getProductDetails,
    required ProductsRepository repository,
    required AddToCartUseCase addToCartUseCase,
    GetCartUseCase? getCartUseCase,
  }) : _getProductDetails = getProductDetails,
       _repository = repository,
       _addToCartUseCase = addToCartUseCase,
       _getCartUseCase = getCartUseCase,
       super(const ProductDetailsState());

  /// Load product details by [id].
  Future<void> loadProduct(String id) async {
    if (isClosed) return;
    final bool cachedInCart = CacheHelper.isProductInCart(id);
    emit(
      state.copyWith(
        status: ProductDetailsStatus.loading,
        isAddedToCart: cachedInCart,
      ),
    );

    final result = await _getProductDetails(id);
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: ProductDetailsStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (product) async {
        if (!isClosed) {
          final bool inCart =
              CacheHelper.isProductInCart(product.id) || cachedInCart;

          emit(
            state.copyWith(
              status: ProductDetailsStatus.loaded,
              product: product,
              isAddedToCart: inCart,
            ),
          );

          // Verify with server cart if authenticated and usecase available
          if (_getCartUseCase != null && CacheHelper.isLoggedIn) {
            try {
              final cartResult = await _getCartUseCase();
              if (!isClosed) {
                cartResult.fold(
                  (_) {},
                  (cartData) {
                    final serverProductIds =
                        cartData.cart.map((e) => e.product.id).toList();
                    CacheHelper.setCartProductIds(serverProductIds);
                    final bool serverInCart = serverProductIds
                        .map((e) => e.toString())
                        .contains(product.id.toString());
                    if (!isClosed && state.isAddedToCart != serverInCart) {
                      emit(state.copyWith(isAddedToCart: serverInCart));
                    }
                  },
                );
              }
            } catch (_) {}
          }
        }
      },
    );
  }

  /// Toggle favorite status for the current product.
  ///
  /// Returns `null` if the user is not authenticated.
  /// Returns `true` when added to favorites, `false` when removed, or
  /// an error message string on failure.
  Future<Object?> toggleFavorite() async {
    final product = state.product;
    if (product == null) return null;

    // Check authentication
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();
    if (!checkAuth()) return 'unauthenticated';

    // Optimistic update
    emit(
      state.copyWith(
        product: product.copyWith(isFavorite: !product.isFavorite),
      ),
    );

    final result = await _repository.toggleFavorite(product.id);
    return result.fold(
      (error) {
        // Rollback on failure
        emit(
          state.copyWith(
            product: product.copyWith(isFavorite: product.isFavorite),
          ),
        );
        return error;
      },
      (isFavorite) {
        emit(state.copyWith(product: product.copyWith(isFavorite: isFavorite)));
        return isFavorite;
      },
    );
  }

  /// Share the current product.
  Future<void> shareProduct() async {
    final product = state.product;
    if (product == null) return;

    await _repository.shareProduct(product.id);
  }

  /// Add current product to cart via POST /v1/cart.
  ///
  /// Sends payload `{ "product_id": productId, "quantity": quantity }`.
  /// Returns `true` if added successfully, `false` otherwise.
  Future<bool> addToCart({int quantity = 1}) async {
    final product = state.product;
    if (product == null || state.isAddingToCart || state.isAddedToCart) {
      return false;
    }

    emit(state.copyWith(isAddingToCart: true));

    final String rawId = product.id;
    final dynamic productId = int.tryParse(rawId) ?? rawId;

    final result = await _addToCartUseCase(
      productId: productId,
      quantity: quantity,
    );

    return result.fold(
      (error) {
        emit(state.copyWith(isAddingToCart: false, errorMessage: error));
        return false;
      },
      (_) {
        CacheHelper.addCartProductId(product.id);
        emit(state.copyWith(isAddingToCart: false, isAddedToCart: true));
        CartEventBus.instance.notifyCartUpdated();
        return true;
      },
    );
  }
}
