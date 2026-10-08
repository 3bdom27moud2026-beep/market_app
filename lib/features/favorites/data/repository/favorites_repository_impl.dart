import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repository/favorites_repository.dart';
import '../datasource/favorites_remote_datasource.dart';

/// Implementation of [FavoritesRepository].
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<FavoriteEntity>>> getFavorites() async {
    try {
      final models = await remoteDataSource.getFavorites();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في تحميل قائمة المفضلة',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<FavoriteMerchantEntity>>>
  getFavoriteMerchants() async {
    try {
      final merchants = await remoteDataSource.getFavoriteMerchants();
      return Right(merchants);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'فشل في تحميل قائمة التجار المفضلة',
        ),
      );
    }
  }

  @override
  Future<Either<String, bool>> toggleFavorite(
    String id, {
    String type = 'product',
  }) async {
    try {
      final isFav = await remoteDataSource.toggleFavorite(id, type: type);
      return Right(isFav);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(e, defaultMessage: 'فشل في تعديل المفضلة'),
      );
    }
  }
}
