// ignore_for_file: prefer_initializing_formals
import 'package:market/features/categories/domain/entities/category_entity.dart';
import 'package:market/features/categories/domain/entities/banner_entity.dart';
import 'package:market/features/categories/domain/repository/categories_repository.dart';
import 'package:market/features/categories/data/datasource/remote/categories_remote_datasource.dart'
    hide Tuple2;

/// Implementation of [CategoriesRepository].
///
/// Fetches categories data from the remote data source.
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource _remoteDataSource;

  CategoriesRepositoryImpl({
    required CategoriesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Tuple2<BannerEntity, List<CategoryEntity>>> getCategories() async {
    final result = await _remoteDataSource.getCategories();
    return Tuple2(
      result.item1.toEntity(),
      result.item2.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<List<CategoryEntity>> searchCategories(String query) async {
    final categories = await _remoteDataSource.searchCategories(query);
    return categories.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CategoryEntity>> getCategoriesByMode(String mode) async {
    final categories = await _remoteDataSource.getCategoriesByMode(mode);
    return categories.map((model) => model.toEntity()).toList();
  }
}
