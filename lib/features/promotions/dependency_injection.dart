import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/promotions/domain/repository/startup_promotion_repository.dart';
import 'package:market/features/promotions/domain/usecases/get_startup_promotion_usecase.dart';
import 'package:market/features/promotions/data/datasource/remote/startup_promotion_remote_datasource.dart';
import 'package:market/features/promotions/data/datasource/local/startup_promotion_local_datasource.dart';
import 'package:market/features/promotions/data/repository/startup_promotion_repository_impl.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';

/// Dependency injection for the promotions feature.
abstract final class PromotionsDI {
  /// Initializes the promotions feature dependencies.
  static void init() {
    // Dependencies are created lazily in providers
  }

  /// Creates a [StartupPromotionCubit] with all its dependencies.
  static StartupPromotionCubit createStartupPromotionCubit() {
    final apiClient = CoreDI.sl<ApiClient>();
    final prefs = CacheHelper.prefs;

    final remoteDataSource = StartupPromotionRemoteDataSource(
      apiClient: apiClient,
    );
    final localDataSource = StartupPromotionLocalDataSource(prefs: prefs);
    final repository =
        StartupPromotionRepositoryImpl(
              remoteDataSource: remoteDataSource,
              localDataSource: localDataSource,
            )
            as StartupPromotionRepository;
    final useCase = GetStartupPromotion(repository: repository);

    return StartupPromotionCubit(getStartupPromotion: useCase);
  }
}
