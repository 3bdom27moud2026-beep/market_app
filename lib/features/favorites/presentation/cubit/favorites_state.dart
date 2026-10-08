import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_entity.dart';

enum FavoritesStatus { initial, loading, loaded, error, unauthenticated }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteEntity> favorites;
  final List<FavoriteMerchantEntity> favoriteMerchants;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.favoriteMerchants = const [],
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteEntity>? favorites,
    List<FavoriteMerchantEntity>? favoriteMerchants,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteMerchants: favoriteMerchants ?? this.favoriteMerchants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    favoriteMerchants,
    errorMessage,
  ];
}
