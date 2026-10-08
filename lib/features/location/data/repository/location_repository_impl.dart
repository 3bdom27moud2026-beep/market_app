import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/governorate_entity.dart';
import '../../domain/entities/center_entity.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/repository/location_repository.dart';
import '../datasource/remote/location_remote_datasource.dart';

/// Implementation of [LocationRepository].
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<GovernorateEntity>>> getGovernorates() async {
    try {
      final models = await remoteDataSource.getGovernorates();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'تعذر جلب المحافظات. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<CenterEntity>>> getCenters(
    int governorateId,
  ) async {
    try {
      final models = await remoteDataSource.getCenters(governorateId);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'تعذر جلب المراكز. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<AreaEntity>>> getAreas(int centerId) async {
    try {
      final models = await remoteDataSource.getAreas(centerId);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'تعذر جلب المناطق. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }

  @override
  Future<Either<String, void>> saveUserLocation({
    required int governorateId,
    required int centerId,
    required int areaId,
  }) async {
    try {
      await remoteDataSource.saveUserLocation(
        governorateId: governorateId,
        centerId: centerId,
        areaId: areaId,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'تعذر حفظ الموقع. يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }
}
