import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/remote/home_remote_datasource.dart';
import '../datasource/local/home_local_datasource.dart';

/// Implementation of [HomeRepository].
///
/// Tries to fetch from remote first. On failure, falls back to local cache.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, HomeDataEntity>> getHomeData() async {
    try {
      final model = await remoteDataSource.getHomeData();
      // Cache the result
      await localDataSource.cacheHomeData(model);
      return Right(model.toEntity());
    } catch (e) {
      // Try local cache
      final cached = localDataSource.getCachedHomeData();
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage:
              'حدث خطأ في تحميل الصفحة الرئيسية. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }
}
