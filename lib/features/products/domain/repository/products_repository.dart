import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';

/// Abstract repository for product operations.
abstract class ProductsRepository {
  /// Get product details by [id].
  Future<Either<String, ProductEntity>> getProductDetails(String id);

  /// Toggle favorite status for a product.
  Future<Either<String, bool>> toggleFavorite(String productId);

  /// Share a product.
  Future<Either<String, void>> shareProduct(String productId);

  /// Get all products.
  Future<Either<String, List<ProductEntity>>> getProducts();

  /// Get products filtered by category [categoryId].
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );
}
