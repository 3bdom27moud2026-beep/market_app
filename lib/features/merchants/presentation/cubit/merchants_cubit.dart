// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/favorites/domain/usecases/favorites_usecases.dart';
import 'package:market/features/merchants/domain/repository/merchants_repository.dart';
import 'merchants_state.dart';

/// Cubit that loads and filters all merchants.
class MerchantsCubit extends Cubit<MerchantsState> {
  final MerchantsRepository _repository;
  final ToggleFavoriteUseCase? _toggleFavoriteUseCase;
  final GetFavoriteMerchantsUseCase? _getFavoriteMerchantsUseCase;

  MerchantsCubit({
    required MerchantsRepository repository,
    ToggleFavoriteUseCase? toggleFavoriteUseCase,
    GetFavoriteMerchantsUseCase? getFavoriteMerchantsUseCase,
  }) : _repository = repository,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _getFavoriteMerchantsUseCase = getFavoriteMerchantsUseCase,
       super(const MerchantsInitial());

  /// Loads all merchants from the API, optionally filtered by [categoryId].
  Future<void> loadMerchants({String? categoryId}) async {
    if (isClosed) return;
    emit(const MerchantsLoading());

    Set<int> favoriteMerchantIds = const {};
    if (_getFavoriteMerchantsUseCase != null) {
      final favResult = await _getFavoriteMerchantsUseCase.call();
      favResult.fold((_) {}, (merchants) {
        favoriteMerchantIds = merchants.map((m) => m.id).toSet();
      });
    }

    final result = await _repository.getMerchantsByCategory(categoryId ?? '');

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(MerchantsError(message: error));
        }
      },
      (merchants) {
        if (isClosed) return;
        if (merchants.isEmpty) {
          emit(const MerchantsEmpty());
        } else {
          emit(
            MerchantsLoaded(
              merchants: merchants,
              filteredMerchants: merchants,
              selectedCategoryId: categoryId,
              favoriteMerchantIds: favoriteMerchantIds,
            ),
          );
        }
      },
    );
  }

  /// Filters loaded merchants by [categoryId].
  void filterByCategory(String? categoryId) {
    if (state is! MerchantsLoaded) return;
    final currentState = state as MerchantsLoaded;

    if (categoryId == null || categoryId.isEmpty) {
      emit(
        currentState.copyWith(
          filteredMerchants: currentState.merchants,
          clearSelectedCategoryId: true,
          searchQuery: '',
        ),
      );
      return;
    }

    final filtered = currentState.merchants.where((m) {
      final catId = m.categoryId.isNotEmpty
          ? m.categoryId
          : (m.category?.id.toString() ?? '');
      return catId == categoryId;
    }).toList();

    emit(
      currentState.copyWith(
        filteredMerchants: filtered,
        selectedCategoryId: categoryId,
        searchQuery: '',
      ),
    );
  }

  /// Filters loaded merchants by search [query] in real time.
  void searchMerchants(String query) {
    if (state is! MerchantsLoaded) return;
    final currentState = state as MerchantsLoaded;
    final trimmed = query.trim().toLowerCase();

    // Base merchants list: respect selectedCategoryId if present
    final baseList =
        (currentState.selectedCategoryId != null &&
            currentState.selectedCategoryId!.isNotEmpty)
        ? currentState.merchants.where((m) {
            final catId = m.categoryId.isNotEmpty
                ? m.categoryId
                : (m.category?.id.toString() ?? '');
            return catId == currentState.selectedCategoryId;
          }).toList()
        : currentState.merchants;

    if (trimmed.isEmpty) {
      emit(currentState.copyWith(filteredMerchants: baseList, searchQuery: ''));
      return;
    }

    final filtered = baseList.where((m) {
      final name = m.name.toLowerCase();
      final address = m.address.toLowerCase();
      final description = m.description.toLowerCase();
      final area = m.area?.name.toLowerCase() ?? '';
      final category = m.category?.name.toLowerCase() ?? '';

      return name.contains(trimmed) ||
          address.contains(trimmed) ||
          description.contains(trimmed) ||
          area.contains(trimmed) ||
          category.contains(trimmed);
    }).toList();

    emit(
      currentState.copyWith(filteredMerchants: filtered, searchQuery: query),
    );
  }

  /// Toggles favorite status for a merchant optimistically and syncs with backend.
  Future<void> toggleFavorite(int merchantId) async {
    if (state is! MerchantsLoaded) return;
    final currentState = state as MerchantsLoaded;
    final updatedFavorites = Set<int>.from(currentState.favoriteMerchantIds);
    final bool wasFavorite = updatedFavorites.contains(merchantId);

    if (wasFavorite) {
      updatedFavorites.remove(merchantId);
    } else {
      updatedFavorites.add(merchantId);
    }

    emit(currentState.copyWith(favoriteMerchantIds: updatedFavorites));

    if (_toggleFavoriteUseCase != null) {
      final result = await _toggleFavoriteUseCase.call(
        merchantId.toString(),
        type: 'merchant',
      );
      result.fold(
        (_) {
          // Revert on failure
          if (!isClosed && state is MerchantsLoaded) {
            final reverted = Set<int>.from(
              (state as MerchantsLoaded).favoriteMerchantIds,
            );
            if (wasFavorite) {
              reverted.add(merchantId);
            } else {
              reverted.remove(merchantId);
            }
            emit(
              (state as MerchantsLoaded).copyWith(
                favoriteMerchantIds: reverted,
              ),
            );
          }
        },
        (isFav) {
          if (!isClosed && state is MerchantsLoaded) {
            final synced = Set<int>.from(
              (state as MerchantsLoaded).favoriteMerchantIds,
            );
            if (isFav) {
              synced.add(merchantId);
            } else {
              synced.remove(merchantId);
            }
            emit(
              (state as MerchantsLoaded).copyWith(favoriteMerchantIds: synced),
            );
          }
        },
      );
    }
  }

  /// Refreshes all merchants.
  Future<void> refresh({String? categoryId}) =>
      loadMerchants(categoryId: categoryId);
}
