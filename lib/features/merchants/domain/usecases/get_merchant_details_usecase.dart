import 'package:dartz/dartz.dart';
import '../entities/merchant_entity.dart';
import '../entities/merchant_product_entity.dart';
import '../repository/merchants_repository.dart';

/// Use case for fetching merchant details.
class GetMerchantDetailsUseCase {
  final MerchantsRepository _repository;

  const GetMerchantDetailsUseCase(this._repository);

  Future<Either<String, (MerchantEntity, List<MerchantProductEntity>)>> call(
    String id,
  ) => _repository.getMerchantDetails(id);
}
