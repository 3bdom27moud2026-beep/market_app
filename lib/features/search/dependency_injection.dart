import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/search/data/datasource/remote/search_remote_datasource.dart';
import 'package:market/features/search/data/repository/search_repository_impl.dart';
import 'package:market/features/search/domain/repository/search_repository.dart';
import 'package:market/features/search/presentation/cubit/search_cubit.dart';

/// Dependency injection for the search feature.
abstract final class SearchDI {
  /// Creates a [SearchCubit] with all required dependencies.
  static SearchCubit createSearchCubit() {
    final apiClient = CoreDI.sl<ApiClient>();
    final remoteDataSource = SearchRemoteDataSource(apiClient: apiClient);
    final repository =
        SearchRepositoryImpl(remoteDataSource: remoteDataSource)
            as SearchRepository;
    return SearchCubit(repository: repository);
  }
}
