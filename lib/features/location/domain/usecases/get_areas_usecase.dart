import 'package:dartz/dartz.dart';
import '../repository/location_repository.dart';
import '../entities/area_entity.dart';

/// Use case for fetching areas by center ID.
class GetAreasUseCase {
  final LocationRepository repository;

  GetAreasUseCase(this.repository);

  Future<Either<String, List<AreaEntity>>> call(int centerId) async {
    return await repository.getAreas(centerId);
  }
}
