import 'package:equatable/equatable.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

/// Available product catalog filters.
enum ProductCatalogFilter {
  all,
  flashSale,
  bestSellers,
  newest;

  String get label {
    switch (this) {
      case ProductCatalogFilter.all:
        return 'الكل';
      case ProductCatalogFilter.flashSale:
        return 'فلاش سيل';
      case ProductCatalogFilter.bestSellers:
        return 'الأكثر مبيعاً';
      case ProductCatalogFilter.newest:
        return 'أحدث المنتجات';
    }
  }

  static ProductCatalogFilter fromString(String? value) {
    switch (value) {
      case 'flash_sale':
      case 'flashSale':
      case 'flash':
        return ProductCatalogFilter.flashSale;
      case 'best_sellers':
      case 'bestSellers':
      case 'best_seller':
        return ProductCatalogFilter.bestSellers;
      case 'newest':
      case 'latest':
        return ProductCatalogFilter.newest;
      case 'all':
      default:
        return ProductCatalogFilter.all;
    }
  }
}

/// States for [AllProductsCubit].
abstract class AllProductsState extends Equatable {
  const AllProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial/idle state before loading starts.
class AllProductsInitial extends AllProductsState {
  const AllProductsInitial();
}

/// Loading state.
class AllProductsLoading extends AllProductsState {
  const AllProductsLoading();
}

/// Loaded state containing products, active filter, query, and favorites.
class AllProductsLoaded extends AllProductsState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final ProductCatalogFilter selectedFilter;
  final String searchQuery;
  final Set<String> favoriteProductIds;

  const AllProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedFilter = ProductCatalogFilter.all,
    this.searchQuery = '',
    this.favoriteProductIds = const {},
  });

  AllProductsLoaded copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    ProductCatalogFilter? selectedFilter,
    String? searchQuery,
    Set<String>? favoriteProductIds,
  }) {
    return AllProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    selectedFilter,
    searchQuery,
    favoriteProductIds,
  ];
}

/// Empty state when no products exist under current criteria.
class AllProductsEmpty extends AllProductsState {
  final ProductCatalogFilter selectedFilter;

  const AllProductsEmpty({this.selectedFilter = ProductCatalogFilter.all});

  @override
  List<Object?> get props => [selectedFilter];
}

/// Error state when fetching fails.
class AllProductsError extends AllProductsState {
  final String message;

  const AllProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
