// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repository/products_repository.dart';

/// Use case for retrieving product details.
class GetProductDetails {
  final ProductsRepository _repository;

  GetProductDetails({required ProductsRepository repository})
    : _repository = repository;

  /// Get product details by [id].
  Future<Either<String, ProductEntity>> call(String id) {
    return _repository.getProductDetails(id);
  }
}
