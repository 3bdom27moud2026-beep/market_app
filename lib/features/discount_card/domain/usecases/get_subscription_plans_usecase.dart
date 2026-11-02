import 'package:dartz/dartz.dart';
import '../entities/subscription_plans_data_entity.dart';
import '../repository/discount_card_repository.dart';

/// Usecase to fetch active and available subscription plans and payment methods.
class GetSubscriptionPlansUseCase {
  final DiscountCardRepository _repository;

  const GetSubscriptionPlansUseCase(this._repository);

  Future<Either<String, SubscriptionPlansDataEntity>> call() {
    return _repository.getSubscriptionPlans();
  }
}
