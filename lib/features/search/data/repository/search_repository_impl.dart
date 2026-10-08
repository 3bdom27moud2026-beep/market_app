// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/search/domain/entities/search_result_entity.dart';
import 'package:market/features/search/domain/repository/search_repository.dart';
import 'package:market/features/search/data/datasource/remote/search_remote_datasource.dart';

/// Implementation of [SearchRepository].
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl({required SearchRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, SearchResultEntity>> search({
    required String query,
    String type = 'all',
  }) async {
    try {
      final resultModel = await _remoteDataSource.search(
        query: query,
        type: type,
      );
      return Right(resultModel.toEntity());
    } catch (e) {
      return Left(
        AppErrorHandler.handleToFailure(
          e,
          defaultMessage: 'حدث خطأ أثناء البحث، يرجى المحاولة لاحقاً.',
        ),
      );
    }
  }
}
