import 'package:equatable/equatable.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

/// States for [CategoryProductsCubit].
abstract class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial/idle state before loading starts.
class CategoryProductsInitial extends CategoryProductsState {
  const CategoryProductsInitial();
}

/// Loading products for a category.
class CategoryProductsLoading extends CategoryProductsState {
  const CategoryProductsLoading();
}

/// Products loaded successfully.
class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductEntity> products;
  final List<ProductEntity> filteredProducts;
  final String searchQuery;
  final Set<String> favoriteProductIds;

  const CategoryProductsLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.favoriteProductIds = const {},
  });

  CategoryProductsLoaded copyWith({
    List<ProductEntity>? products,
    List<ProductEntity>? filteredProducts,
    String? searchQuery,
    Set<String>? favoriteProductIds,
  }) {
    return CategoryProductsLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    searchQuery,
    favoriteProductIds,
  ];
}

/// No products found for this category.
class CategoryProductsEmpty extends CategoryProductsState {
  const CategoryProductsEmpty();
}

/// Error loading category products.
class CategoryProductsError extends CategoryProductsState {
  final String message;

  const CategoryProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
