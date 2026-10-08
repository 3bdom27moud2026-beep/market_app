import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/flash_sale_product_entity.dart';
import '../../domain/entities/flash_sale_entity.dart';

/// Loading status for flash sale.
enum FlashSaleLoadingStatus {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
  refreshing,
}

/// Sort options for flash sale.
enum FlashSaleSort { newest, highestDiscount, lowestPrice, highestRating }

extension FlashSaleSortLabel on FlashSaleSort {
  String get label {
    switch (this) {
      case FlashSaleSort.newest:
        return 'الأحدث';
      case FlashSaleSort.highestDiscount:
        return 'الأعلى خصماً';
      case FlashSaleSort.lowestPrice:
        return 'الأقل سعراً';
      case FlashSaleSort.highestRating:
        return 'الأعلى تقييماً';
    }
  }

  String get apiValue {
    switch (this) {
      case FlashSaleSort.newest:
        return 'latest';
      case FlashSaleSort.highestDiscount:
        return 'highest_discount';
      case FlashSaleSort.lowestPrice:
        return 'lowest_price';
      case FlashSaleSort.highestRating:
        return 'highest_rating';
    }
  }
}

/// State for [FlashSaleCubit].
class FlashSaleState extends Equatable {
  final FlashSaleLoadingStatus status;
  final String errorMessage;
  final List<FlashSaleProductEntity> products;
  final List<String> categories;
  final String selectedCategory;
  final FlashSaleSort selectedSort;
  final CountdownEntity? countdown;
  final int total;
  final int currentPage;
  final bool hasMore;
  final int totalPages;

  const FlashSaleState({
    this.status = FlashSaleLoadingStatus.initial,
    this.errorMessage = '',
    this.products = const [],
    this.categories = const [],
    this.selectedCategory = 'الكل',
    this.selectedSort = FlashSaleSort.newest,
    this.countdown,
    this.total = 0,
    this.currentPage = 1,
    this.hasMore = true,
    this.totalPages = 1,
  });

  FlashSaleState copyWith({
    FlashSaleLoadingStatus? status,
    String? errorMessage,
    List<FlashSaleProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    FlashSaleSort? selectedSort,
    CountdownEntity? countdown,
    int? total,
    int? currentPage,
    bool? hasMore,
    int? totalPages,
    bool clearProducts = false,
  }) {
    return FlashSaleState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      products: clearProducts ? (products ?? []) : (products ?? this.products),
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSort: selectedSort ?? this.selectedSort,
      countdown: countdown ?? this.countdown,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    products,
    categories,
    selectedCategory,
    selectedSort,
    countdown,
    total,
    currentPage,
    hasMore,
    totalPages,
  ];
}
