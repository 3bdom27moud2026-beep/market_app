import 'package:dartz/dartz.dart';
import '../entities/favorite_entity.dart';

/// Abstract repository for favorites operations.
abstract class FavoritesRepository {
  /// Fetch the user's favorites products list.
  Future<Either<String, List<FavoriteEntity>>> getFavorites();

  /// Fetch the user's favorites merchants list.
  Future<Either<String, List<FavoriteMerchantEntity>>> getFavoriteMerchants();

  /// Toggle favorite for an item (product or merchant) by [id].
  /// Returns `true` if added, `false` if removed.
  Future<Either<String, bool>> toggleFavorite(
    String id, {
    String type = 'product',
  });
}
