import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/startup_promotion_entity.dart';
import '../../domain/repository/startup_promotion_repository.dart';
import '../datasource/remote/startup_promotion_remote_datasource.dart';
import '../datasource/local/startup_promotion_local_datasource.dart';

/// Implementation of [StartupPromotionRepository].
class StartupPromotionRepositoryImpl implements StartupPromotionRepository {
  final StartupPromotionRemoteDataSource remoteDataSource;
  final StartupPromotionLocalDataSource localDataSource;

  StartupPromotionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, StartupPromotionEntity?>> getStartupPromotion() async {
    try {
      final model = await remoteDataSource.getStartupPromotion();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage:
              'حدث خطأ في تحميل العرض الترويجي. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }

  @override
  Future<bool> isPromotionShown() async {
    return localDataSource.isPromotionShown();
  }

  @override
  Future<void> setPromotionShown() async {
    await localDataSource.setPromotionShown();
  }
}
