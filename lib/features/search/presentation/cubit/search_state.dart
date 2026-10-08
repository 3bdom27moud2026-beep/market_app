import 'package:equatable/equatable.dart';
import 'package:market/features/search/domain/entities/search_result_entity.dart';

enum SearchStatus { initial, loading, loaded, empty, error }

class SearchState extends Equatable {
  final String query;
  final String type;
  final SearchStatus status;
  final SearchResultEntity results;
  final String errorMessage;

  const SearchState({
    this.query = '',
    this.type = 'all',
    this.status = SearchStatus.initial,
    this.results = const SearchResultEntity(),
    this.errorMessage = '',
  });

  SearchState copyWith({
    String? query,
    String? type,
    SearchStatus? status,
    SearchResultEntity? results,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      type: type ?? this.type,
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [query, type, status, results, errorMessage];
}
