// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/search/domain/entities/search_result_entity.dart';
import 'package:market/features/search/domain/repository/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;
  Timer? _debounceTimer;

  SearchCubit({required SearchRepository repository})
    : _repository = repository,
      super(const SearchState());

  /// Performs search with optional debounce.
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      if (isClosed) return;
      emit(
        state.copyWith(
          query: '',
          status: SearchStatus.initial,
          results: const SearchResultEntity(),
        ),
      );
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(query: query));
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      performSearch();
    });
  }

  /// Changes the search filter type ('all', 'product', 'merchant') and re-searches.
  void changeType(String type) {
    if (state.type == type) return;
    if (isClosed) return;
    emit(state.copyWith(type: type));
    if (state.query.trim().isNotEmpty) {
      performSearch();
    }
  }

  /// Direct search execution
  Future<void> performSearch() async {
    final query = state.query.trim();
    if (query.isEmpty) return;

    if (isClosed) return;
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _repository.search(query: query, type: state.type);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: SearchStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (searchResults) {
        if (isClosed) return;
        if (searchResults.isEmpty) {
          emit(
            state.copyWith(status: SearchStatus.empty, results: searchResults),
          );
        } else {
          emit(
            state.copyWith(status: SearchStatus.loaded, results: searchResults),
          );
        }
      },
    );
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    if (isClosed) return;
    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
