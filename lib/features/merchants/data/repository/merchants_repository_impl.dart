// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';
import 'package:market/features/merchants/domain/entities/merchant_product_entity.dart';
import 'package:market/features/merchants/domain/repository/merchants_repository.dart';
import '../datasource/remote/merchants_remote_datasource.dart';

/// Implementation of [MerchantsRepository].
class MerchantsRepositoryImpl implements MerchantsRepository {
  final MerchantsRemoteDataSource _remoteDataSource;

  MerchantsRepositoryImpl({required MerchantsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, (MerchantEntity, List<MerchantProductEntity>)>>
  getMerchantDetails(String id) async {
    try {
      final (merchantModel, productModels) = await _remoteDataSource
          .getMerchantDetails(id);
      final merchant = merchantModel.toEntity();
      final products = productModels.map((p) => p.toEntity()).toList();
      return Right((merchant, products));
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل بيانات التاجر',
        ),
      );
    }
  }

  @override
  Future<Either<String, List<MerchantEntity>>> getMerchantsByCategory(
    String categoryId,
  ) async {
    try {
      final merchantModels = await _remoteDataSource.getMerchantsByCategory(
        categoryId,
      );
      final entities = merchantModels.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(
        AppErrorHandler.getMessage(
          e,
          defaultMessage: 'حدث خطأ في تحميل التجار',
        ),
      );
    }
  }
}
