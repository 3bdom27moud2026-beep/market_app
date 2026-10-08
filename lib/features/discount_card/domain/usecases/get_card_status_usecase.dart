import 'package:dartz/dartz.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// Use case for fetching the real discount card status from GET /v1/card/status.
class GetCardStatusUseCase {
  final DiscountCardRepository _repository;

  const GetCardStatusUseCase(this._repository);

  Future<Either<String, UserCardEntity?>> call() {
    return _repository.getCardStatus();
  }
}
