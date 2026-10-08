// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/products/domain/repository/products_repository.dart';
import 'category_products_state.dart';

/// Cubit that loads products filtered by a category ID, with search and favorite features.
class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final ProductsRepository _repository;

  CategoryProductsCubit({required ProductsRepository repository})
    : _repository = repository,
      super(const CategoryProductsInitial());

  /// Loads products for the given [categoryId].
  Future<void> loadProducts(String categoryId) async {
    if (isClosed) return;
    emit(const CategoryProductsLoading());

    final result = await _repository.getProductsByCategory(categoryId);
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(CategoryProductsError(message: error));
        }
      },
      (products) {
        if (isClosed) return;
        if (products.isEmpty) {
          emit(const CategoryProductsEmpty());
        } else {
          final initialFavorites = <String>{};
          for (final product in products) {
            if (product.isFavorite) {
              initialFavorites.add(product.id);
            }
          }
          emit(
            CategoryProductsLoaded(
              products: products,
              filteredProducts: products,
              favoriteProductIds: initialFavorites,
            ),
          );
        }
      },
    );
  }

  /// Filters loaded products by search [query] locally in real time.
  void searchProducts(String query) {
    if (state is! CategoryProductsLoaded) return;
    final currentState = state as CategoryProductsLoaded;
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      emit(
        currentState.copyWith(
          filteredProducts: currentState.products,
          searchQuery: '',
        ),
      );
      return;
    }

    final filtered = currentState.products.where((p) {
      final name = p.name.toLowerCase();
      final store = p.store.toLowerCase();
      final brand = p.brand.toLowerCase();
      final description = p.description.toLowerCase();

      return name.contains(trimmed) ||
          store.contains(trimmed) ||
          brand.contains(trimmed) ||
          description.contains(trimmed);
    }).toList();

    emit(currentState.copyWith(filteredProducts: filtered, searchQuery: query));
  }

  /// Toggles favorite status for a product.
  Future<void> toggleFavorite(String productId) async {
    if (state is! CategoryProductsLoaded) return;
    final currentState = state as CategoryProductsLoaded;
    final updatedFavorites = Set<String>.from(currentState.favoriteProductIds);

    final wasFavorite = updatedFavorites.contains(productId);
    if (wasFavorite) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    emit(currentState.copyWith(favoriteProductIds: updatedFavorites));

    // Call API in background
    try {
      final result = await _repository.toggleFavorite(productId);
      result.fold(
        (_) {
          // Revert on failure
          if (state is CategoryProductsLoaded) {
            final s = state as CategoryProductsLoaded;
            final reverted = Set<String>.from(s.favoriteProductIds);
            if (wasFavorite) {
              reverted.add(productId);
            } else {
              reverted.remove(productId);
            }
            emit(s.copyWith(favoriteProductIds: reverted));
          }
        },
        (isFavorited) {
          if (state is CategoryProductsLoaded) {
            final s = state as CategoryProductsLoaded;
            final synced = Set<String>.from(s.favoriteProductIds);
            if (isFavorited) {
              synced.add(productId);
            } else {
              synced.remove(productId);
            }
            emit(s.copyWith(favoriteProductIds: synced));
          }
        },
      );
    } catch (_) {}
  }

  /// Refreshes the products for [categoryId].
  Future<void> refresh(String categoryId) => loadProducts(categoryId);
}
