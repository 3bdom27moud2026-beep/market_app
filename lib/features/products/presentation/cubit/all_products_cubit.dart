// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';
import 'package:market/features/products/domain/repository/products_repository.dart';
import 'all_products_state.dart';

/// Cubit managing all products catalog with dynamic filter tabs (All, Flash Sale, Best Sellers, Newest).
class AllProductsCubit extends Cubit<AllProductsState> {
  final ProductsRepository _repository;

  AllProductsCubit({required ProductsRepository repository})
    : _repository = repository,
      super(const AllProductsInitial());

  /// Loads all products and applies the [initialFilter].
  Future<void> loadProducts({
    ProductCatalogFilter initialFilter = ProductCatalogFilter.all,
  }) async {
    if (isClosed) return;
    emit(const AllProductsLoading());

    final result = await _repository.getProducts();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(AllProductsError(message: error));
        }
      },
      (products) {
        if (isClosed) return;
        if (products.isEmpty) {
          emit(AllProductsEmpty(selectedFilter: initialFilter));
          return;
        }

        final initialFavorites = products
            .where((p) => p.isFavorite)
            .map((p) => p.id)
            .toSet();

        final filtered = _applyFilterAndSearch(
          products: products,
          filter: initialFilter,
          query: '',
        );

        emit(
          AllProductsLoaded(
            allProducts: products,
            filteredProducts: filtered,
            selectedFilter: initialFilter,
            searchQuery: '',
            favoriteProductIds: initialFavorites,
          ),
        );
      },
    );
  }

  /// Changes the active tab [filter] and recalculates the list.
  void setFilter(ProductCatalogFilter filter) {
    if (state is! AllProductsLoaded) return;
    final currentState = state as AllProductsLoaded;

    final filtered = _applyFilterAndSearch(
      products: currentState.allProducts,
      filter: filter,
      query: currentState.searchQuery,
    );

    emit(
      currentState.copyWith(selectedFilter: filter, filteredProducts: filtered),
    );
  }

  /// Searches products within the active filter in real time.
  void searchProducts(String query) {
    if (state is! AllProductsLoaded) return;
    final currentState = state as AllProductsLoaded;

    final filtered = _applyFilterAndSearch(
      products: currentState.allProducts,
      filter: currentState.selectedFilter,
      query: query,
    );

    emit(currentState.copyWith(searchQuery: query, filteredProducts: filtered));
  }

  /// Optimistically toggles product favorite and syncs with backend.
  Future<void> toggleFavorite(String productId) async {
    if (state is! AllProductsLoaded) return;
    final currentState = state as AllProductsLoaded;
    final updatedFavorites = Set<String>.from(currentState.favoriteProductIds);

    final bool wasFavorite = updatedFavorites.contains(productId);
    if (wasFavorite) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    emit(currentState.copyWith(favoriteProductIds: updatedFavorites));

    final result = await _repository.toggleFavorite(productId);
    result.fold(
      (_) {
        // Revert on failure
        final reverted = Set<String>.from(updatedFavorites);
        if (wasFavorite) {
          reverted.add(productId);
        } else {
          reverted.remove(productId);
        }
        if (state is AllProductsLoaded) {
          emit(
            (state as AllProductsLoaded).copyWith(favoriteProductIds: reverted),
          );
        }
      },
      (isFav) {
        final synced = Set<String>.from(updatedFavorites);
        if (isFav) {
          synced.add(productId);
        } else {
          synced.remove(productId);
        }
        if (state is AllProductsLoaded) {
          emit(
            (state as AllProductsLoaded).copyWith(favoriteProductIds: synced),
          );
        }
      },
    );
  }

  /// Refreshes all products while preserving active filter.
  Future<void> refresh() async {
    final currentFilter = state is AllProductsLoaded
        ? (state as AllProductsLoaded).selectedFilter
        : ProductCatalogFilter.all;
    await loadProducts(initialFilter: currentFilter);
  }

  /// Helper to filter and sort list according to tab and search query.
  List<ProductEntity> _applyFilterAndSearch({
    required List<ProductEntity> products,
    required ProductCatalogFilter filter,
    required String query,
  }) {
    List<ProductEntity> list;

    switch (filter) {
      case ProductCatalogFilter.flashSale:
        list = products
            .where((p) => p.isFlashSale || p.discount > 0 || p.hasDiscount)
            .toList();
        // Fallback: if no items have discount, show all products
        if (list.isEmpty) list = List.from(products);
        break;

      case ProductCatalogFilter.bestSellers:
        list = List.from(products);
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case ProductCatalogFilter.newest:
        list = List.from(products);
        list.sort((a, b) {
          final int aId = int.tryParse(a.id) ?? 0;
          final int bId = int.tryParse(b.id) ?? 0;
          return bId.compareTo(aId);
        });
        break;

      case ProductCatalogFilter.all:
        list = List.from(products);
        break;
    }

    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return list;

    return list.where((p) {
      final name = p.name.toLowerCase();
      final store = p.store.toLowerCase();
      final brand = p.brand.toLowerCase();
      final desc = p.description.toLowerCase();

      return name.contains(trimmed) ||
          store.contains(trimmed) ||
          brand.contains(trimmed) ||
          desc.contains(trimmed);
    }).toList();
  }
}
