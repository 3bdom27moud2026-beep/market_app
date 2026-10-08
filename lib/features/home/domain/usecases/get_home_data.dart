import 'package:dartz/dartz.dart';
import '../entities/home_data_entity.dart';
import '../repository/home_repository.dart';

/// Use case for fetching home screen data.
///
/// Follows Clean Architecture: the presentation layer calls this use case,
/// which in turn calls the repository.
class GetHomeData {
  final HomeRepository repository;

  GetHomeData({required this.repository});

  /// Execute the use case.
  Future<Either<String, HomeDataEntity>> call() {
    return repository.getHomeData();
  }
}
