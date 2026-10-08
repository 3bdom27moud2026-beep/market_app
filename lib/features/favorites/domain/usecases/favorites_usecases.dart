import 'package:dartz/dartz.dart';
import '../entities/favorite_entity.dart';
import '../repository/favorites_repository.dart';

/// Use case for fetching the user's favorites list.
class GetFavoritesUseCase {
  final FavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Either<String, List<FavoriteEntity>>> call() {
    return _repository.getFavorites();
  }
}

/// Use case for fetching the user's favorite merchants list.
class GetFavoriteMerchantsUseCase {
  final FavoritesRepository _repository;

  GetFavoriteMerchantsUseCase(this._repository);

  Future<Either<String, List<FavoriteMerchantEntity>>> call() {
    return _repository.getFavoriteMerchants();
  }
}

/// Use case for toggling a favorite status (product or merchant).
class ToggleFavoriteUseCase {
  final FavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Either<String, bool>> call(String id, {String type = 'product'}) {
    return _repository.toggleFavorite(id, type: type);
  }
}
