import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/products/presentation/cubit/category_products_cubit.dart';
import 'package:market/features/products/presentation/cubit/category_products_state.dart';
import 'package:market/features/products/presentation/widgets/category_header_banner.dart';
import 'package:market/features/products/presentation/widgets/category_product_card.dart';

/// Screen that displays products belonging to a specific category.
class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProductsCubit>().loadProducts(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFFEF8226),
            onRefresh: () async {
              _searchController.clear();
              await context.read<CategoryProductsCubit>().refresh(
                widget.categoryId,
              );
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── Top Category Banner with 3D Illustration & Back Button ────
                SliverToBoxAdapter(
                  child: CategoryHeaderBanner(
                    categoryName: widget.categoryName,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),

                // ── Search Field & Counter ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg.w,
                      vertical: AppSpacing.md.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Input Box
                        Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: context.colors.borderLight,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            textDirection: TextDirection.rtl,
                            onChanged: (val) => context
                                .read<CategoryProductsCubit>()
                                .searchProducts(val),
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13.sp,
                              color: context.colors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن منتج...',
                              hintStyle: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13.sp,
                                color: context.colors.textSecondary,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: context.colors.textSecondary,
                                size: 22.r,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: context.colors.textSecondary,
                                        size: 18.r,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        context
                                            .read<CategoryProductsCubit>()
                                            .searchProducts('');
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Product Counter
                        if (state is CategoryProductsLoaded)
                          Text(
                            '${state.filteredProducts.length} منتج',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: context.colors.textPrimary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Dynamic Body (Loading / Error / Empty / Grid) ─────────────
                if (state is CategoryProductsLoading)
                  const _LoadingSliverGrid()
                else if (state is CategoryProductsError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<CategoryProductsCubit>()
                          .loadProducts(widget.categoryId),
                    ),
                  )
                else if (state is CategoryProductsEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyView(),
                  )
                else if (state is CategoryProductsLoaded)
                  if (state.filteredProducts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _NoSearchResultsView(
                        query: state.searchQuery,
                        onClear: () {
                          _searchController.clear();
                          context.read<CategoryProductsCubit>().searchProducts(
                            '',
                          );
                          setState(() {});
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg.w,
                        0,
                        AppSpacing.lg.w,
                        AppSpacing.xxxl.h,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.58,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = state.filteredProducts[index];
                          final isFav = state.favoriteProductIds.contains(
                            product.id,
                          );
                          return CategoryProductCard(
                            product: product,
                            isFavorite: isFav,
                            onFavoriteTap: () => context
                                .read<CategoryProductsCubit>()
                                .toggleFavorite(product.id),
                          );
                        }, childCount: state.filteredProducts.length),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Loading Skeleton ──────────────────────────────────────────────────────────

class _LoadingSliverGrid extends StatelessWidget {
  const _LoadingSliverGrid();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const _SkeletonProductCard(),
          childCount: 4,
        ),
      ),
    );
  }
}

class _SkeletonProductCard extends StatelessWidget {
  const _SkeletonProductCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            height: 128.h,
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(context, width: 100.w, height: 12.h),
                SizedBox(height: 8.h),
                _shimmer(context, width: 70.w, height: 10.h),
                SizedBox(height: 8.h),
                _shimmer(context, width: 50.w, height: 10.h),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmer(context, width: 60.w, height: 14.h),
                    _shimmer(context, width: 28.r, height: 28.r, radius: 7.r),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer(
    BuildContext context, {
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Empty View ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 72.r,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'لا توجد منتجات في هذه الفئة',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'تحقق مجدداً لاحقاً لتصفح أحدث العروض والمنتجات',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12.sp,
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── No Search Results View ───────────────────────────────────────────────────

class _NoSearchResultsView extends StatelessWidget {
  final String query;
  final VoidCallback onClear;

  const _NoSearchResultsView({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.r,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'لم يتم العثور على منتجات لـ "$query"',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md.h),
            TextButton.icon(
              onPressed: onClear,
              icon: Icon(Icons.clear_rounded, size: 16.r),
              label: Text('مسح البحث', style: TextStyle(fontSize: 13.sp)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF8226),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.r,
              color: context.colors.accentRed,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'حدث خطأ في تحميل المنتجات',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 18.r),
              label: Text('إعادة المحاولة', style: TextStyle(fontSize: 13.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF8226),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.md.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
