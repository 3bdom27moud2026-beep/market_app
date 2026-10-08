import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/home/domain/repository/home_repository.dart';
import 'package:market/features/home/domain/usecases/get_home_data.dart';
import 'package:market/features/home/data/datasource/remote/home_remote_datasource.dart';
import 'package:market/features/home/data/datasource/local/home_local_datasource.dart';
import 'package:market/features/home/data/repository/home_repository_impl.dart';
import 'package:market/features/home/presentation/cubit/home_cubit.dart';

/// Dependency injection for the home feature.
///
/// This class provides static helper methods to create the dependencies
/// and providers needed for the home screen.
abstract final class HomeDI {
  /// Initializes the home feature dependencies.
  ///
  /// Should be called once in the app's main initialization.
  static void init() {
    // Dependencies are created lazily in providers
  }

  /// Creates a [HomeCubit] with all its dependencies.
  static HomeCubit createHomeCubit() {
    final apiClient = CoreDI.sl<ApiClient>();
    final prefs = CacheHelper.prefs;

    final remoteDataSource = HomeRemoteDataSource(apiClient: apiClient);
    final localDataSource = HomeLocalDataSource(prefs: prefs);
    final repository =
        HomeRepositoryImpl(
              remoteDataSource: remoteDataSource,
              localDataSource: localDataSource,
            )
            as HomeRepository;
    final useCase = GetHomeData(repository: repository);

    return HomeCubit(getHomeData: useCase);
  }
}
