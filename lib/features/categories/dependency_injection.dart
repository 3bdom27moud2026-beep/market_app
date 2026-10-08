import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/categories/domain/repository/categories_repository.dart';
import 'package:market/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:market/features/categories/data/datasource/remote/categories_remote_datasource.dart';
import 'package:market/features/categories/data/repository/categories_repository_impl.dart';
import 'package:market/features/categories/presentation/cubit/categories_cubit.dart';

/// Dependency injection for the categories feature.
///
/// This class provides static helper methods to create the dependencies
/// and providers needed for the categories screen.
abstract final class CategoriesDI {
  /// Initializes the categories feature dependencies.
  ///
  /// Should be called once in the app's main initialization.
  static void init() {
    // Dependencies are created lazily in providers
  }

  /// Creates a [CategoriesCubit] with all its dependencies.
  static CategoriesCubit createCategoriesCubit() {
    final apiClient = CoreDI.sl<ApiClient>();

    final remoteDataSource = CategoriesRemoteDataSource(apiClient: apiClient);
    final repository =
        CategoriesRepositoryImpl(remoteDataSource: remoteDataSource)
            as CategoriesRepository;
    final useCase = GetCategoriesUseCase(repository);

    return CategoriesCubit(useCase);
  }
}
