import 'package:dartz/dartz.dart';
import '../repository/location_repository.dart';
import '../entities/center_entity.dart';

/// Use case for fetching centers by governorate ID.
class GetCentersUseCase {
  final LocationRepository repository;

  GetCentersUseCase(this.repository);

  Future<Either<String, List<CenterEntity>>> call(int governorateId) async {
    return await repository.getCenters(governorateId);
  }
}
