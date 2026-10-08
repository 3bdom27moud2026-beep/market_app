import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/features/categories/domain/entities/category_entity.dart';
import 'package:market/features/categories/domain/usecases/get_categories_usecase.dart';
import 'categories_state.dart';

/// Cubit for managing categories screen state.
///
/// Handles loading, searching, and filtering categories by purchase mode (retail / wholesale).
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit(this._getCategoriesUseCase)
    : super(const CategoriesInitial());

  /// Loads categories from the API.
  Future<void> loadCategories() async {
    try {
      if (isClosed) return;
      emit(const CategoriesLoading());
      final result = await _getCategoriesUseCase();
      if (isClosed) return;
      final banner = result.item1;
      final categories = result.item2;

      if (categories.isEmpty) {
        emit(const CategoriesEmpty());
        return;
      }

      final filtered = _filterCategoriesList(
        categories,
        state.purchaseMode,
        state.searchQuery,
      );

      if (isClosed) return;
      emit(
        CategoriesLoaded(
          banner: banner,
          categories: categories,
          filteredCategories: filtered,
          purchaseMode: state.purchaseMode,
          searchQuery: state.searchQuery,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        CategoriesError(
          errorMessage: AppErrorHandler.getMessage(
            e,
            defaultMessage: 'تعذر تحميل الأقسام. يرجى المحاولة لاحقاً.',
          ),
        ),
      );
    }
  }

  /// Searches categories by query and active purchase mode.
  void searchCategories(String query) {
    if (state is! CategoriesLoaded) return;

    final currentState = state as CategoriesLoaded;
    final filtered = _filterCategoriesList(
      currentState.categories,
      currentState.purchaseMode,
      query,
    );

    emit(
      currentState.copyWith(searchQuery: query, filteredCategories: filtered),
    );
  }

  /// Changes the purchase mode ('retail' or 'wholesale') and filters categories instantly.
  void changePurchaseMode([String? targetMode]) {
    if (state is! CategoriesLoaded) return;

    final currentState = state as CategoriesLoaded;
    final newMode =
        targetMode ??
        (currentState.purchaseMode == 'retail' ? 'wholesale' : 'retail');

    final filtered = _filterCategoriesList(
      currentState.categories,
      newMode,
      currentState.searchQuery,
    );

    emit(
      currentState.copyWith(
        purchaseMode: newMode,
        filteredCategories: filtered,
      ),
    );
  }

  /// Helper to filter categories based on purchaseMode (type) and searchQuery.
  List<CategoryEntity> _filterCategoriesList(
    List<CategoryEntity> categories,
    String purchaseMode,
    String searchQuery,
  ) {
    final query = searchQuery.trim().toLowerCase();

    return categories.where((category) {
      final type = category.type?.toLowerCase();

      // Filter by type:
      // 'retail' mode -> type is 'retail', 'both', or null/empty
      // 'wholesale' mode -> type is 'wholesale' or 'both'
      final matchesMode = (purchaseMode == 'wholesale')
          ? (type == 'wholesale' || type == 'both')
          : (type == 'retail' ||
                type == 'both' ||
                type == null ||
                type.isEmpty);

      // Filter by search query
      final matchesQuery =
          query.isEmpty || category.name.toLowerCase().contains(query);

      return matchesMode && matchesQuery;
    }).toList();
  }

  /// Refreshes the categories.
  Future<void> refresh() async {
    await loadCategories();
  }
}
