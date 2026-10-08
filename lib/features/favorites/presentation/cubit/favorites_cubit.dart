// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/favorites_usecases.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final GetFavoriteMerchantsUseCase _getFavoriteMerchantsUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  StreamSubscription<AuthEvent>? _authSubscription;

  FavoritesCubit({
    required GetFavoritesUseCase getFavoritesUseCase,
    required GetFavoriteMerchantsUseCase getFavoriteMerchantsUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  }) : _getFavoritesUseCase = getFavoritesUseCase,
       _getFavoriteMerchantsUseCase = getFavoriteMerchantsUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       super(const FavoritesState()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn) {
        loadFavorites();
      } else if (event.type == AuthEventType.loggedOut) {
        emit(state.copyWith(status: FavoritesStatus.unauthenticated));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> loadFavorites() async {
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();
    if (!checkAuth()) {
      if (!isClosed) {
        emit(state.copyWith(status: FavoritesStatus.unauthenticated));
      }
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(status: FavoritesStatus.loading));

    final result = await _getFavoritesUseCase();
    final merchantsResult = await _getFavoriteMerchantsUseCase();

    if (isClosed) return;

    List<FavoriteEntity> favorites = [];
    List<FavoriteMerchantEntity> merchants = [];
    String? errorMsg;

    result.fold((error) => errorMsg = error, (items) => favorites = items);

    merchantsResult.fold(
      (error) => errorMsg ??= error,
      (mList) => merchants = mList,
    );

    if (isClosed) return;

    if (errorMsg != null && favorites.isEmpty && merchants.isEmpty) {
      emit(
        state.copyWith(status: FavoritesStatus.error, errorMessage: errorMsg),
      );
    } else {
      emit(
        state.copyWith(
          status: FavoritesStatus.loaded,
          favorites: favorites,
          favoriteMerchants: merchants,
        ),
      );
    }
  }

  Future<void> removeFavorite(String productId) async {
    // Optimistic removal from current list
    final currentList = state.favorites;
    final updatedList = currentList
        .where((item) => item.id != productId)
        .toList();
    emit(state.copyWith(favorites: updatedList));

    final result = await _toggleFavoriteUseCase(productId, type: 'product');
    result.fold(
      (error) {
        // Rollback on error
        emit(state.copyWith(favorites: currentList));
      },
      (isAdded) {
        // If server says added (unexpected), sync list
        if (isAdded) {
          loadFavorites();
        }
      },
    );
  }

  Future<void> removeFavoriteMerchant(int merchantId) async {
    final currentMerchants = state.favoriteMerchants;
    final updatedMerchants = currentMerchants
        .where((item) => item.id != merchantId)
        .toList();
    emit(state.copyWith(favoriteMerchants: updatedMerchants));

    final result = await _toggleFavoriteUseCase(
      merchantId.toString(),
      type: 'merchant',
    );
    result.fold(
      (error) {
        emit(state.copyWith(favoriteMerchants: currentMerchants));
      },
      (isAdded) {
        if (isAdded) {
          loadFavorites();
        }
      },
    );
  }
}
