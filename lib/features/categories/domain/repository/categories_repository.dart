import '../entities/category_entity.dart';
import '../entities/banner_entity.dart';

/// Abstract repository for categories feature.
///
/// Defines the contract for fetching categories data.
abstract class CategoriesRepository {
  /// Fetches categories data from the API.
  ///
  /// Returns a tuple of (banner, categories).
  Future<Tuple2<BannerEntity, List<CategoryEntity>>> getCategories();

  /// Fetches categories filtered by search query.
  Future<List<CategoryEntity>> searchCategories(String query);

  /// Fetches categories by purchase mode.
  Future<List<CategoryEntity>> getCategoriesByMode(String mode);
}

/// Simple tuple class for returning two values.
class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  const Tuple2(this.item1, this.item2);
}
