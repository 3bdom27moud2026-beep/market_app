import 'package:dartz/dartz.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';

/// Use case for requesting a discount card via POST /v1/card/request.
class RequestCardUseCase {
  final DiscountCardRepository _repository;

  const RequestCardUseCase(this._repository);

  Future<Either<String, CardRequestResultEntity>> call(
    CardRequestModel request,
  ) {
    return _repository.requestCard(request);
  }
}
