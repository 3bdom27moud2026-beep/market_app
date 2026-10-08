// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/data/datasource/remote/discount_card_remote_datasource.dart';

/// Implementation of [DiscountCardRepository].
class DiscountCardRepositoryImpl implements DiscountCardRepository {
  final DiscountCardRemoteDataSource _remoteDataSource;

  DiscountCardRepositoryImpl({
    required DiscountCardRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async {
    final result = await _remoteDataSource.getDiscountCardData();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async {
    final result = await _remoteDataSource.requestCard(request);
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async {
    final result = await _remoteDataSource.getCardStatus();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async {
    final result = await _remoteDataSource.getMembership();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, List<StatisticsEntity>>> getStatistics() async {
    final result = await _remoteDataSource.getStatistics();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, List<DiscountCategoryEntity>>> getCategories() async {
    final result = await _remoteDataSource.getCategories();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, List<MerchantEntity>>> getMerchants(
    String categoryId,
  ) async {
    final result = await _remoteDataSource.getMerchants(categoryId);
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, List<BenefitEntity>>> getBenefits() async {
    final result = await _remoteDataSource.getBenefits();
    return result.fold((error) => Left(error), (data) => Right(data));
  }

  @override
  Future<Either<String, bool>> cancelSubscription() async {
    final result = await _remoteDataSource.cancelSubscription();
    return result.fold((error) => Left(error), (data) => Right(data));
  }
}
