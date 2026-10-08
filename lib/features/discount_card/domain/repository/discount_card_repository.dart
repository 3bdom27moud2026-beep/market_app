import 'package:dartz/dartz.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';

/// Abstract repository for discount card data.
abstract class DiscountCardRepository {
  /// Fetches all data for the discount card screen.
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData();

  /// Submits a discount card request.
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  );

  /// Fetches the user's card status from GET /v1/card/status.
  Future<Either<String, UserCardEntity?>> getCardStatus();

  /// Fetches the user's card info (alias for getCardStatus).
  Future<Either<String, UserCardEntity?>> getMembership();

  /// Fetches discount statistics.
  Future<Either<String, List<StatisticsEntity>>> getStatistics();

  /// Fetches categories with their merchants.
  Future<Either<String, List<DiscountCategoryEntity>>> getCategories();

  /// Fetches merchants for a specific category.
  Future<Either<String, List<MerchantEntity>>> getMerchants(String categoryId);

  /// Fetches benefits list.
  Future<Either<String, List<BenefitEntity>>> getBenefits();

  /// Toggles subscription status.
  Future<Either<String, bool>> cancelSubscription();
}
