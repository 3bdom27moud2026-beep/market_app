// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import '../../domain/entities/flash_sale_entity.dart';
import '../../domain/repository/flash_sale_repository.dart';
import '../datasource/remote/flash_sale_remote_datasource.dart';

/// Implementation of [FlashSaleRepository] using the remote data source.
class FlashSaleRepositoryImpl implements FlashSaleRepository {
  final FlashSaleRemoteDataSource _remoteDataSource;

  FlashSaleRepositoryImpl({required FlashSaleRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, FlashSaleEntity>> getFlashSale({
    String? category,
    String? sort,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final model = await _remoteDataSource.getFlashSale(
        category: category,
        sort: sort,
        page: page,
        perPage: perPage,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل عروض التخفيضات',
        ),
      );
    }
  }
}
