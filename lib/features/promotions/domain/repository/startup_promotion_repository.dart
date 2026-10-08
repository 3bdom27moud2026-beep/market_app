import 'package:dartz/dartz.dart';
import '../entities/startup_promotion_entity.dart';

/// Abstract repository for startup promotion data.
abstract class StartupPromotionRepository {
  /// Fetches the startup promotion from the API.
  Future<Either<String, StartupPromotionEntity?>> getStartupPromotion();

  /// Checks if the promotion has been shown in this session.
  Future<bool> isPromotionShown();

  /// Marks the promotion as shown for this session.
  Future<void> setPromotionShown();
}
