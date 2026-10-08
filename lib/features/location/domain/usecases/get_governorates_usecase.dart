import 'package:dartz/dartz.dart';
import '../repository/location_repository.dart';
import '../entities/governorate_entity.dart';

/// Use case for fetching all governorates.
class GetGovernoratesUseCase {
  final LocationRepository repository;

  GetGovernoratesUseCase(this.repository);

  Future<Either<String, List<GovernorateEntity>>> call() async {
    return await repository.getGovernorates();
  }
}
