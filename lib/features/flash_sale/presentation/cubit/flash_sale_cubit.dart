// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/flash_sale_entity.dart';
import '../../domain/usecases/get_flash_sale_usecase.dart';
import 'flash_sale_state.dart';

/// Cubit for the Flash Sale Screen.
class FlashSaleCubit extends Cubit<FlashSaleState> {
  final GetFlashSaleUseCase _getFlashSaleUseCase;
  Timer? _countdownTimer;

  FlashSaleCubit({required GetFlashSaleUseCase getFlashSaleUseCase})
    : _getFlashSaleUseCase = getFlashSaleUseCase,
      super(const FlashSaleState());

  /// Load the first page of flash sale products.
  Future<void> loadFlashSale() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: FlashSaleLoadingStatus.loading,
        clearProducts: true,
      ),
    );

    final result = await _getFlashSaleUseCase(
      category: state.selectedCategory == 'الكل'
          ? null
          : state.selectedCategory,
      sort: state.selectedSort.apiValue,
      page: 1,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashSaleLoadingStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: FlashSaleLoadingStatus.loaded,
            products: data.products,
            categories: data.categories,
            countdown: data.countdown,
            total: data.total,
            currentPage: 1,
            hasMore: data.pagination.hasMore,
            totalPages: data.pagination.lastPage,
          ),
        );
        _startCountdown(data.countdown);
      },
    );
  }

  /// Refresh the flash sale products.
  Future<void> refresh() async {
    if (isClosed) return;
    emit(state.copyWith(status: FlashSaleLoadingStatus.refreshing));

    final result = await _getFlashSaleUseCase(
      category: state.selectedCategory == 'الكل'
          ? null
          : state.selectedCategory,
      sort: state.selectedSort.apiValue,
      page: 1,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashSaleLoadingStatus.loaded,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: FlashSaleLoadingStatus.loaded,
            products: data.products,
            categories: data.categories,
            countdown: data.countdown,
            total: data.total,
            currentPage: 1,
            hasMore: data.pagination.hasMore,
            totalPages: data.pagination.lastPage,
          ),
        );
        _startCountdown(data.countdown);
      },
    );
  }

  /// Load the next page of products (pagination).
  Future<void> loadMore() async {
    if (state.status == FlashSaleLoadingStatus.loadingMore || !state.hasMore) {
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(status: FlashSaleLoadingStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await _getFlashSaleUseCase(
      category: state.selectedCategory == 'الكل'
          ? null
          : state.selectedCategory,
      sort: state.selectedSort.apiValue,
      page: nextPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(status: FlashSaleLoadingStatus.loaded));
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: FlashSaleLoadingStatus.loaded,
            products: [...state.products, ...data.products],
            currentPage: nextPage,
            hasMore: data.pagination.hasMore,
            totalPages: data.pagination.lastPage,
            total: data.total,
          ),
        );
      },
    );
  }

  /// Change the selected category filter.
  Future<void> changeCategory(String category) async {
    if (category == state.selectedCategory) return;
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedCategory: category,
        status: FlashSaleLoadingStatus.loading,
        clearProducts: true,
      ),
    );

    final result = await _getFlashSaleUseCase(
      category: category == 'الكل' ? null : category,
      sort: state.selectedSort.apiValue,
      page: 1,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashSaleLoadingStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: FlashSaleLoadingStatus.loaded,
            products: data.products,
            countdown: data.countdown,
            total: data.total,
            currentPage: 1,
            hasMore: data.pagination.hasMore,
            totalPages: data.pagination.lastPage,
          ),
        );
        _startCountdown(data.countdown);
      },
    );
  }

  /// Change the sort option.
  Future<void> changeSort(FlashSaleSort sort) async {
    if (sort == state.selectedSort) return;
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedSort: sort,
        status: FlashSaleLoadingStatus.loading,
        clearProducts: true,
      ),
    );

    final result = await _getFlashSaleUseCase(
      category: state.selectedCategory == 'الكل'
          ? null
          : state.selectedCategory,
      sort: sort.apiValue,
      page: 1,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashSaleLoadingStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: FlashSaleLoadingStatus.loaded,
            products: data.products,
            countdown: data.countdown,
            total: data.total,
            currentPage: 1,
            hasMore: data.pagination.hasMore,
            totalPages: data.pagination.lastPage,
          ),
        );
        _startCountdown(data.countdown);
      },
    );
  }

  /// Start the countdown timer.
  void _startCountdown(CountdownEntity countdown) {
    _countdownTimer?.cancel();
    var totalSeconds = countdown.duration.inSeconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (totalSeconds > 0) {
        totalSeconds--;
        final days = totalSeconds ~/ 86400;
        final hours = (totalSeconds % 86400) ~/ 3600;
        final minutes = (totalSeconds % 3600) ~/ 60;
        final seconds = totalSeconds % 60;

        emit(
          state.copyWith(
            countdown: CountdownEntity(
              days: days,
              hours: hours,
              minutes: minutes,
              seconds: seconds,
            ),
          ),
        );
      } else {
        _countdownTimer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
