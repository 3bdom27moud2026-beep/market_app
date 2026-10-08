// ignore_for_file: prefer_initializing_formals
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import '../../models/search_result_model.dart';

/// Remote data source for global search operations.
class SearchRemoteDataSource {
  final ApiClient _apiClient;

  SearchRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetches search results from GET /v1/search?q={query}&type={type}.
  Future<SearchResultModel> search({
    required String query,
    String type = 'all',
  }) async {
    try {
      final response = await _apiClient.get(
        EndPoints.search,
        queryParameters: {'q': query, 'type': type},
      );

      return SearchResultModel.fromJson(response.data);
    } catch (_) {
      rethrow;
    }
  }
}
