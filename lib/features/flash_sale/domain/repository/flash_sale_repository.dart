import 'package:dartz/dartz.dart';
import '../entities/flash_sale_entity.dart';

/// Repository interface for flash sale data.
abstract class FlashSaleRepository {
  /// Fetches flash sale products with optional filters.
  Future<Either<String, FlashSaleEntity>> getFlashSale({
    String? category,
    String? sort,
    int page = 1,
    int perPage = 10,
  });
}
