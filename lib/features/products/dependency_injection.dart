import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/cart/data/datasource/local/cart_local_datasource.dart';
import 'package:market/features/cart/data/datasource/remote/cart_remote_datasource.dart';
import 'package:market/features/cart/data/repository/cart_repository_impl.dart';
import 'package:market/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:market/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:market/features/products/domain/repository/products_repository.dart';
import 'package:market/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:market/features/products/data/datasource/remote/products_remote_datasource.dart';
import 'package:market/features/products/data/repository/products_repository_impl.dart';
import 'package:market/features/products/presentation/cubit/all_products_cubit.dart';
import 'package:market/features/products/presentation/cubit/product_details_cubit.dart';

/// Dependency injection for the products feature.
abstract final class ProductsDI {
  /// Creates a [ProductsRepository] with all its dependencies.
  static ProductsRepository createProductsRepository() {
    final apiClient = CoreDI.sl<ApiClient>();
    final remoteDataSource = ProductsRemoteDataSource(apiClient: apiClient);
    return ProductsRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  /// Creates an [AllProductsCubit] with all its dependencies.
  static AllProductsCubit createAllProductsCubit() {
    final repository = createProductsRepository();
    return AllProductsCubit(repository: repository);
  }

  /// Creates a [ProductDetailsCubit] with all its dependencies.
  static ProductDetailsCubit createProductDetailsCubit() {
    final apiClient = CoreDI.sl<ApiClient>();

    final remoteDataSource = ProductsRemoteDataSource(apiClient: apiClient);
    final repository =
        ProductsRepositoryImpl(remoteDataSource: remoteDataSource)
            as ProductsRepository;
    final useCase = GetProductDetails(repository: repository);

    final cartLocalDataSource = CartLocalDataSource();
    final cartRemoteDataSource = CartRemoteDataSource(apiClient: apiClient);
    final cartRepository = CartRepositoryImpl(
      cartLocalDataSource,
      cartRemoteDataSource,
    );
    final addToCartUseCase = AddToCartUseCase(cartRepository);
    final getCartUseCase = GetCartUseCase(cartRepository);

    return ProductDetailsCubit(
      getProductDetails: useCase,
      repository: repository,
      addToCartUseCase: addToCartUseCase,
      getCartUseCase: getCartUseCase,
    );
  }
}
