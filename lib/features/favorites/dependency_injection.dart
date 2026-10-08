import 'package:get_it/get_it.dart';
import 'package:market/core/utils/api_client.dart';
import 'data/datasource/favorites_remote_datasource.dart';
import 'data/repository/favorites_repository_impl.dart';
import 'domain/repository/favorites_repository.dart';
import 'domain/usecases/favorites_usecases.dart';
import 'presentation/cubit/favorites_cubit.dart';

abstract final class FavoritesDI {
  static void init(GetIt sl) {
    // Datasource
    sl.registerLazySingleton<FavoritesRemoteDataSource>(
      () => FavoritesRemoteDataSource(apiClient: sl<ApiClient>()),
    );

    // Repository
    sl.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(
        remoteDataSource: sl<FavoritesRemoteDataSource>(),
      ),
    );

    // UseCases
    sl.registerLazySingleton<GetFavoritesUseCase>(
      () => GetFavoritesUseCase(sl<FavoritesRepository>()),
    );
    sl.registerLazySingleton<GetFavoriteMerchantsUseCase>(
      () => GetFavoriteMerchantsUseCase(sl<FavoritesRepository>()),
    );
    sl.registerLazySingleton<ToggleFavoriteUseCase>(
      () => ToggleFavoriteUseCase(sl<FavoritesRepository>()),
    );
  }

  static FavoritesCubit createFavoritesCubit() {
    final sl = GetIt.instance;
    return FavoritesCubit(
      getFavoritesUseCase: sl<GetFavoritesUseCase>(),
      getFavoriteMerchantsUseCase: sl<GetFavoriteMerchantsUseCase>(),
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
    );
  }
}
