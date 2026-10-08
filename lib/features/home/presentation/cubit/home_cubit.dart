// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data.dart';
import 'home_state.dart';

/// Cubit for the Home Screen.
///
/// Manages the loading, refreshing, filtering, and timer state for all
/// home screen sections.
class HomeCubit extends Cubit<HomeState> {
  final GetHomeData _getHomeData;
  Timer? _autoPlayTimer;
  Timer? _flashSaleTimer;
  int _timerSeconds = 0;

  HomeCubit({required GetHomeData getHomeData})
    : _getHomeData = getHomeData,
      super(const HomeState());

  /// Load home data from the repository.
  Future<void> loadHome() async {
    if (isClosed) return;
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    final result = await _getHomeData();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (isClosed) return;
        emit(
          state.copyWith(
            loadingStatus: LoadingStatus.loaded,
            offers: data.offers,
            flashSale: data.flashSale,
            categories: data.categories,
            bestSellers: data.bestSellers,
            partners: data.partners,
            newestProducts: data.newestProducts,
            isMember: data.isMember,
          ),
        );
        _startAutoPlay();
        startFlashSaleTimer();
      },
    );
  }

  /// Refresh home data (pull-to-refresh).
  Future<void> refresh() async {
    if (isClosed) return;
    emit(state.copyWith(loadingStatus: LoadingStatus.refreshing));

    final result = await _getHomeData();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.loaded,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        emit(
          state.copyWith(
            loadingStatus: LoadingStatus.loaded,
            offers: data.offers,
            flashSale: data.flashSale,
            categories: data.categories,
            bestSellers: data.bestSellers,
            partners: data.partners,
            newestProducts: data.newestProducts,
            isMember: data.isMember,
          ),
        );
      },
    );
  }

  /// Change the filter for the newest products section.
  void changeNewestFilter(NewestFilter filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  /// Change the current banner index (for the animated indicator).
  void changeBanner(int index) {
    emit(state.copyWith(currentBannerIndex: index));
  }

  /// Start the flash sale countdown timer.
  void startFlashSaleTimer() {
    _flashSaleTimer?.cancel();
    // Simulate a countdown (e.g., 24 hours from now)
    const totalSeconds = 24 * 60 * 60; // 24 hours
    _timerSeconds = totalSeconds;
    emit(state.copyWith(flashSaleTimer: Duration(seconds: _timerSeconds)));

    _flashSaleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        emit(state.copyWith(flashSaleTimer: Duration(seconds: _timerSeconds)));
      } else {
        _flashSaleTimer?.cancel();
      }
    });
  }

  /// Start auto-play for the offers slider.
  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (state.offers.length <= 1) return;

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final nextIndex = (state.currentBannerIndex + 1) % state.offers.length;
      changeBanner(nextIndex);
    });
  }

  @override
  Future<void> close() {
    _autoPlayTimer?.cancel();
    _flashSaleTimer?.cancel();
    return super.close();
  }
}
