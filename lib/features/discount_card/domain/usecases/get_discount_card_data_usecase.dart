import 'package:dartz/dartz.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';

/// Use case for fetching all discount card data.
class GetDiscountCardDataUseCase {
  final DiscountCardRepository _repository;

  const GetDiscountCardDataUseCase(this._repository);

  Future<Either<String, DiscountCardDataEntity>> call() {
    return _repository.getDiscountCardData();
  }
}
