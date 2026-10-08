import 'package:dartz/dartz.dart';
import '../entities/startup_promotion_entity.dart';
import '../repository/startup_promotion_repository.dart';

/// Use case for fetching the startup promotion.
class GetStartupPromotion {
  final StartupPromotionRepository repository;

  GetStartupPromotion({required this.repository});

  /// Execute the use case.
  Future<Either<String, StartupPromotionEntity?>> call() {
    return repository.getStartupPromotion();
  }
}
