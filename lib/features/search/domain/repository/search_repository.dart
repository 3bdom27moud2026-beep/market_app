import 'package:dartz/dartz.dart';
import 'package:market/core/error/failures.dart';
import '../entities/search_result_entity.dart';

/// Contract for Search repository operations.
abstract class SearchRepository {
  /// Performs global search with query string [query] and search type [type].
  Future<Either<Failure, SearchResultEntity>> search({
    required String query,
    String type = 'all',
  });
}
