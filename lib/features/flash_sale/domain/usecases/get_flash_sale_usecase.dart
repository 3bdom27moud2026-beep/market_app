import 'package:dartz/dartz.dart';
import '../entities/flash_sale_entity.dart';
import '../repository/flash_sale_repository.dart';

/// Use case for fetching flash sale data.
class GetFlashSaleUseCase {
  final FlashSaleRepository repository;

  GetFlashSaleUseCase({required this.repository});

  /// Executes the use case to fetch flash sale products.
  Future<Either<String, FlashSaleEntity>> call({
    String? category,
    String? sort,
    int page = 1,
    int perPage = 10,
  }) {
    return repository.getFlashSale(
      category: category,
      sort: sort,
      page: page,
      perPage: perPage,
    );
  }
}
