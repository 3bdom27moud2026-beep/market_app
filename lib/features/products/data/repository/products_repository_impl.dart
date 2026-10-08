// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/products_repository.dart';
import '../datasource/remote/products_remote_datasource.dart';

/// Implementation of [ProductsRepository].
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepositoryImpl({required ProductsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, ProductEntity>> getProductDetails(String id) async {
    try {
      final model = await _remoteDataSource.getProductDetails(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل بيانات المنتج',
        ),
      );
    }
  }

  @override
  Future<Either<String, bool>> toggleFavorite(String productId) async {
    try {
      final isFavorite = await _remoteDataSource.toggleFavorite(productId);
      return Right(isFavorite);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحديث المفضلة',
        ),
      );
    }
  }

  @override
  Future<Either<String, void>> shareProduct(String productId) async {
    try {
      // Share implementation using platform channel or url_launcher
      return const Right(null);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في مشاركة المنتج',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل المنتجات',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      final models = await _remoteDataSource.getProductsByCategory(categoryId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل منتجات الفئة',
        ),
      );
    }
  }
}
