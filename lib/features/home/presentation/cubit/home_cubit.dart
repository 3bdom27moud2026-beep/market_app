// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/favorites/domain/usecases/favorites_usecases.dart';
import '../../domain/usecases/get_home_data.dart';
import 'home_state.dart';

/// Cubit for the Home Screen.
///
/// Manages the loading, refreshing, filtering, and timer state for all
/// home screen sections.
class HomeCubit extends Cubit<HomeState> {
  final GetHomeData _getHomeData;
  final ToggleFavoriteUseCase? _toggleFavoriteUseCase;
  Timer? _autoPlayTimer;
  Timer? _flashSaleTimer;
  int _timerSeconds = 0;

  HomeCubit({
    required GetHomeData getHomeData,
    ToggleFavoriteUseCase? toggleFavoriteUseCase,
  })  : _getHomeData = getHomeData,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
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
        final initialFavorites = <String>{};
        for (final p in data.newestProducts) {
          if (p.isFavorite) {
            initialFavorites.add(p.id);
          }
        }
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
            favoriteProductIds: initialFavorites,
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
        final initialFavorites = <String>{};
        for (final p in data.newestProducts) {
          if (p.isFavorite) {
            initialFavorites.add(p.id);
          }
        }
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
            favoriteProductIds: initialFavorites,
          ),
        );
      },
    );
  }

  /// Optimistically toggle a product's favorite status.
  Future<bool?> toggleFavorite(String productId) async {
    final updatedFavorites = Set<String>.from(state.favoriteProductIds);
    final bool wasFavorite = updatedFavorites.contains(productId);

    if (wasFavorite) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    emit(state.copyWith(favoriteProductIds: updatedFavorites));

    if (_toggleFavoriteUseCase != null) {
      final result = await _toggleFavoriteUseCase(productId, type: 'product');
      return result.fold(
        (_) {
          // Revert on failure
          final reverted = Set<String>.from(state.favoriteProductIds);
          if (wasFavorite) {
            reverted.add(productId);
          } else {
            reverted.remove(productId);
          }
          if (!isClosed) {
            emit(state.copyWith(favoriteProductIds: reverted));
          }
          return null;
        },
        (isFav) {
          final synced = Set<String>.from(state.favoriteProductIds);
          if (isFav) {
            synced.add(productId);
          } else {
            synced.remove(productId);
          }
          if (!isClosed) {
            emit(state.copyWith(favoriteProductIds: synced));
          }
          return isFav;
        },
      );
    }
    return !wasFavorite;
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
