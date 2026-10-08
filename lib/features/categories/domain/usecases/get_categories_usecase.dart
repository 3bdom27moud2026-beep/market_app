import '../entities/category_entity.dart';
import '../entities/banner_entity.dart';
import '../repository/categories_repository.dart';

/// Use case for fetching categories data.
class GetCategoriesUseCase {
  final CategoriesRepository _repository;

  GetCategoriesUseCase(this._repository);

  /// Executes the use case to fetch categories.
  Future<Tuple2<BannerEntity, List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}
