import 'package:dartz/dartz.dart';
import '../entities/governorate_entity.dart';
import '../entities/center_entity.dart';
import '../entities/area_entity.dart';

/// Repository interface for location-related operations.
abstract class LocationRepository {
  Future<Either<String, List<GovernorateEntity>>> getGovernorates();
  Future<Either<String, List<CenterEntity>>> getCenters(int governorateId);
  Future<Either<String, List<AreaEntity>>> getAreas(int centerId);
  Future<Either<String, void>> saveUserLocation({
    required int governorateId,
    required int centerId,
    required int areaId,
  });
}
