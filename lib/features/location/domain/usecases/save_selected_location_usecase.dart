import 'package:dartz/dartz.dart';
import '../repository/location_repository.dart';

/// Use case for saving the selected user location.
class SaveSelectedLocationUseCase {
  final LocationRepository repository;

  SaveSelectedLocationUseCase(this.repository);

  Future<Either<String, void>> call({
    required int governorateId,
    required int centerId,
    required int areaId,
  }) async {
    return await repository.saveUserLocation(
      governorateId: governorateId,
      centerId: centerId,
      areaId: areaId,
    );
  }
}
