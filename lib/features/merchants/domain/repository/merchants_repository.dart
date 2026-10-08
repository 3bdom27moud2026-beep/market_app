import 'package:dartz/dartz.dart';
import '../entities/merchant_entity.dart';
import '../entities/merchant_product_entity.dart';

/// Contract for the merchants repository.
abstract interface class MerchantsRepository {
  /// Fetches merchant details and products from GET /v1/merchants/{id}.
  Future<Either<String, (MerchantEntity, List<MerchantProductEntity>)>>
  getMerchantDetails(String id);

  /// Fetches merchants belonging to [categoryId].
  Future<Either<String, List<MerchantEntity>>> getMerchantsByCategory(
    String categoryId,
  );
}
