import 'package:equatable/equatable.dart';
import '../../domain/entities/offer_banner_entity.dart';
import '../../domain/entities/flash_sale_product_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/best_seller_entity.dart';
import '../../domain/entities/partner_entity.dart';
import '../../domain/entities/newest_product_entity.dart';

/// Enum for the possible loading states.
enum LoadingStatus { initial, loading, loaded, error, refreshing }

/// Enum for filtering newest products.
enum NewestFilter { newest, highestDiscount, lowestPrice, highestRating }

/// State for [HomeCubit].
class HomeState extends Equatable {
  final LoadingStatus loadingStatus;
  final String errorMessage;
  final List<OfferBannerEntity> offers;
  final List<FlashSaleProductEntity> flashSale;
  final List<CategoryEntity> categories;
  final List<BestSellerEntity> bestSellers;
  final List<PartnerEntity> partners;
  final List<NewestProductEntity> newestProducts;
  final NewestFilter selectedFilter;
  final int currentBannerIndex;
  final Duration flashSaleTimer;

  /// Whether the current user is a member (has a discount card).
  final bool isMember;

  const HomeState({
    this.loadingStatus = LoadingStatus.initial,
    this.errorMessage = '',
    this.offers = const [],
    this.flashSale = const [],
    this.categories = const [],
    this.bestSellers = const [],
    this.partners = const [],
    this.newestProducts = const [],
    this.selectedFilter = NewestFilter.newest,
    this.currentBannerIndex = 0,
    this.flashSaleTimer = Duration.zero,
    this.isMember = false,
  });

  HomeState copyWith({
    LoadingStatus? loadingStatus,
    String? errorMessage,
    List<OfferBannerEntity>? offers,
    List<FlashSaleProductEntity>? flashSale,
    List<CategoryEntity>? categories,
    List<BestSellerEntity>? bestSellers,
    List<PartnerEntity>? partners,
    List<NewestProductEntity>? newestProducts,
    NewestFilter? selectedFilter,
    int? currentBannerIndex,
    Duration? flashSaleTimer,
    bool? isMember,
  }) {
    return HomeState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      offers: offers ?? this.offers,
      flashSale: flashSale ?? this.flashSale,
      categories: categories ?? this.categories,
      bestSellers: bestSellers ?? this.bestSellers,
      partners: partners ?? this.partners,
      newestProducts: newestProducts ?? this.newestProducts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      flashSaleTimer: flashSaleTimer ?? this.flashSaleTimer,
      isMember: isMember ?? this.isMember,
    );
  }

  @override
  List<Object?> get props => [
    loadingStatus,
    errorMessage,
    offers,
    flashSale,
    categories,
    bestSellers,
    partners,
    newestProducts,
    selectedFilter,
    currentBannerIndex,
    flashSaleTimer,
    isMember,
  ];
}
