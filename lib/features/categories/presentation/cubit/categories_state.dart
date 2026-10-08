import 'package:equatable/equatable.dart';
import 'package:market/features/categories/domain/entities/category_entity.dart';
import 'package:market/features/categories/domain/entities/banner_entity.dart';

/// States for the CategoriesCubit.
abstract class CategoriesState extends Equatable {
  final BannerEntity? banner;
  final List<CategoryEntity> categories;
  final List<CategoryEntity> filteredCategories;
  final String purchaseMode;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.banner,
    this.categories = const [],
    this.filteredCategories = const [],
    this.purchaseMode = 'retail', // 'retail' or 'wholesale'
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
    banner,
    categories,
    filteredCategories,
    purchaseMode,
    searchQuery,
    isLoading,
    error,
  ];
}

/// Initial state
class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

/// Loading state
class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

/// Loaded state with data
class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    super.banner,
    super.categories,
    super.filteredCategories,
    super.purchaseMode,
    super.searchQuery,
    super.isLoading = false,
    super.error,
  });

  /// Creates a copy of this state with the given fields replaced.
  CategoriesLoaded copyWith({
    BannerEntity? banner,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? filteredCategories,
    String? purchaseMode,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesLoaded(
      banner: banner ?? this.banner,
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      purchaseMode: purchaseMode ?? this.purchaseMode,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Error state
class CategoriesError extends CategoriesState {
  final String errorMessage;

  const CategoriesError({
    required this.errorMessage,
    super.categories = const [],
    super.filteredCategories = const [],
  });

  @override
  List<Object?> get props => [errorMessage, categories, filteredCategories];
}

/// Empty state
class CategoriesEmpty extends CategoriesState {
  const CategoriesEmpty();
}
