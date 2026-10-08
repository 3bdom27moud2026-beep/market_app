import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/favorites/domain/usecases/favorites_usecases.dart';
import 'package:market/features/merchants/data/datasource/remote/merchants_remote_datasource.dart';
import 'package:market/features/merchants/data/repository/merchants_repository_impl.dart';
import 'package:market/features/merchants/domain/repository/merchants_repository.dart';
import 'package:market/features/merchants/domain/usecases/get_merchant_details_usecase.dart';
import 'package:market/features/merchants/presentation/cubit/merchant_details_cubit.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_cubit.dart';

/// Dependency injection for the merchants feature.
abstract final class MerchantsDI {
  /// Creates a [MerchantsRepository] with its dependencies.
  static MerchantsRepository createMerchantsRepository() {
    final apiClient = CoreDI.sl<ApiClient>();
    final remoteDataSource = MerchantsRemoteDataSource(apiClient: apiClient);
    return MerchantsRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  /// Creates a [MerchantDetailsCubit] with all its dependencies.
  static MerchantDetailsCubit createMerchantDetailsCubit() {
    final repository = createMerchantsRepository();
    final useCase = GetMerchantDetailsUseCase(repository);

    return MerchantDetailsCubit(getMerchantDetails: useCase);
  }

  /// Creates a [MerchantsCubit] with all its dependencies.
  static MerchantsCubit createMerchantsCubit() {
    final repository = createMerchantsRepository();
    ToggleFavoriteUseCase? toggleFavoriteUseCase;
    GetFavoriteMerchantsUseCase? getFavoriteMerchantsUseCase;

    if (CoreDI.sl.isRegistered<ToggleFavoriteUseCase>()) {
      toggleFavoriteUseCase = CoreDI.sl<ToggleFavoriteUseCase>();
    }
    if (CoreDI.sl.isRegistered<GetFavoriteMerchantsUseCase>()) {
      getFavoriteMerchantsUseCase = CoreDI.sl<GetFavoriteMerchantsUseCase>();
    }

    return MerchantsCubit(
      repository: repository,
      toggleFavoriteUseCase: toggleFavoriteUseCase,
      getFavoriteMerchantsUseCase: getFavoriteMerchantsUseCase,
    );
  }
}
