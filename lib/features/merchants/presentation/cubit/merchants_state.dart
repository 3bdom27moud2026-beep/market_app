import 'package:equatable/equatable.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';

/// States for [MerchantsCubit].
abstract class MerchantsState extends Equatable {
  const MerchantsState();

  @override
  List<Object?> get props => [];
}

/// Initial/idle state before loading starts.
class MerchantsInitial extends MerchantsState {
  const MerchantsInitial();
}

/// Loading all merchants.
class MerchantsLoading extends MerchantsState {
  const MerchantsLoading();
}

/// Merchants loaded successfully.
class MerchantsLoaded extends MerchantsState {
  final List<MerchantEntity> merchants;
  final List<MerchantEntity> filteredMerchants;
  final String searchQuery;
  final Set<int> favoriteMerchantIds;
  final String? selectedCategoryId;

  const MerchantsLoaded({
    required this.merchants,
    required this.filteredMerchants,
    this.searchQuery = '',
    this.favoriteMerchantIds = const {},
    this.selectedCategoryId,
  });

  MerchantsLoaded copyWith({
    List<MerchantEntity>? merchants,
    List<MerchantEntity>? filteredMerchants,
    String? searchQuery,
    Set<int>? favoriteMerchantIds,
    String? selectedCategoryId,
    bool clearSelectedCategoryId = false,
  }) {
    return MerchantsLoaded(
      merchants: merchants ?? this.merchants,
      filteredMerchants: filteredMerchants ?? this.filteredMerchants,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteMerchantIds: favoriteMerchantIds ?? this.favoriteMerchantIds,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  @override
  List<Object?> get props => [
    merchants,
    filteredMerchants,
    searchQuery,
    favoriteMerchantIds,
    selectedCategoryId,
  ];
}

/// No merchants found.
class MerchantsEmpty extends MerchantsState {
  const MerchantsEmpty();
}

/// Error loading merchants.
class MerchantsError extends MerchantsState {
  final String message;

  const MerchantsError({required this.message});

  @override
  List<Object?> get props => [message];
}
