import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_cubit.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_state.dart';
import 'package:market/features/products/presentation/widgets/category_header_banner.dart';
import 'package:market/features/products/presentation/widgets/category_merchant_card.dart';

import 'package:market/features/categories/domain/entities/category_entity.dart';
import 'package:market/core/utils/category_visual_helper.dart';

/// Screen that displays all partner merchants (شركاء التميز).
class MerchantsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final List<CategoryEntity>? subcategories;

  const MerchantsScreen({
    super.key,
    this.categoryId,
    this.categoryName,
    this.subcategories,
  });

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSubcategoryId;

  List<CategoryEntity> get _effectiveSubcategories {
    if (widget.subcategories != null && widget.subcategories!.isNotEmpty) {
      return widget.subcategories!;
    }
    if (widget.categoryId != null || widget.categoryName != null) {
      return CategoryVisualHelper.getDefaultSubcategories(
        id: widget.categoryId ?? '',
        name: widget.categoryName ?? '',
      );
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MerchantsCubit>().loadMerchants(
        categoryId: widget.categoryId,
      );
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
      body: BlocBuilder<MerchantsCubit, MerchantsState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFFEF8226),
            onRefresh: () async {
              _searchController.clear();
              final cubit = context.read<MerchantsCubit>();
              await cubit.refresh(
                categoryId: widget.categoryId,
              );
              if (!mounted) return;
              if (_selectedSubcategoryId != null) {
                final sub = _effectiveSubcategories.firstWhere(
                  (s) => s.id == _selectedSubcategoryId,
                  orElse: () => _effectiveSubcategories.first,
                );
                cubit.filterBySubcategory(sub);
              }
            },
            child: SafeArea(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  // ── Top Header Banner with 3D Illustration & Back Button ──────
                  SliverToBoxAdapter(
                    child: CategoryHeaderBanner(
                      categoryName: widget.categoryName ?? 'شركاء التميز',
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // ── Subcategories Horizontal Filter Chips ─────────────────────
                  if (_effectiveSubcategories.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildSubcategoriesFilterBar(),
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
                                  .read<MerchantsCubit>()
                                  .searchMerchants(val),
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13.sp,
                                color: context.colors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'ابحث عن تاجر أو متجر...',
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
                                              .read<MerchantsCubit>()
                                              .searchMerchants('');
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

                          // Merchant Counter
                          if (state is MerchantsLoaded)
                            Text(
                              '${state.filteredMerchants.length} تاجر',
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
                  if (state is MerchantsLoading)
                    const _LoadingSliverGrid()
                  else if (state is MerchantsError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ErrorView(
                        message: state.message,
                        onRetry: () => context
                            .read<MerchantsCubit>()
                            .loadMerchants(
                              categoryId:
                                  _selectedSubcategoryId ?? widget.categoryId,
                            ),
                      ),
                    )
                  else if (state is MerchantsEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyView(),
                    )
                  else if (state is MerchantsLoaded)
                    if (state.filteredMerchants.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _NoSearchResultsView(
                          query: state.searchQuery,
                          onClear: () {
                            _searchController.clear();
                            setState(() {
                              _selectedSubcategoryId = null;
                            });
                            context.read<MerchantsCubit>().filterBySubcategory(null);
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: 0.60,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final merchant = state.filteredMerchants[index];
                            final isFav = state.favoriteMerchantIds.contains(
                              merchant.id,
                            );
                            return CategoryMerchantCard(
                              merchant: merchant,
                              isFavorite: isFav,
                              onFavoriteTap: () => context
                                  .read<MerchantsCubit>()
                                  .toggleFavorite(merchant.id),
                            );
                          }, childCount: state.filteredMerchants.length),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubcategoriesFilterBar() {
    final subcategories = _effectiveSubcategories;
    if (subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final isAllSelected = _selectedSubcategoryId == null;

    return Container(
      height: 42.h,
      margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: subcategories.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilterChip(
              label: 'الكل',
              isSelected: isAllSelected,
              onTap: () {
                if (!isAllSelected) {
                  setState(() {
                    _selectedSubcategoryId = null;
                  });
                  _searchController.clear();
                  context.read<MerchantsCubit>().filterBySubcategory(null);
                }
              },
            );
          }

          final sub = subcategories[index - 1];
          final isSelected = _selectedSubcategoryId == sub.id;

          return _buildFilterChip(
            label: sub.name,
            isSelected: isSelected,
            onTap: () {
              if (!isSelected) {
                setState(() {
                  _selectedSubcategoryId = sub.id;
                });
                _searchController.clear();
                context.read<MerchantsCubit>().filterBySubcategory(sub);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFFEF8226);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isDark ? context.colors.surface : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isDark ? context.colors.borderLight : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
        ),
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
          childAspectRatio: 0.60,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const _SkeletonMerchantCard(),
          childCount: 4,
        ),
      ),
    );
  }
}

class _SkeletonMerchantCard extends StatelessWidget {
  const _SkeletonMerchantCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(
            context,
            width: double.infinity,
            height: 120.h,
            radius: 15.r,
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                _shimmer(context, width: 80.w, height: 12.h),
                SizedBox(height: 6.h),
                _shimmer(context, width: 60.w, height: 10.h),
                SizedBox(height: 6.h),
                _shimmer(context, width: 100.w, height: 10.h),
                SizedBox(height: 10.h),
                _shimmer(
                  context,
                  width: double.infinity,
                  height: 32.h,
                  radius: 8.r,
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
              Icons.storefront_outlined,
              size: 72.r,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'لا يوجد تجار حالياً',
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
              'تحقق مجدداً لاحقاً',
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
    final hasQuery = query.trim().isNotEmpty;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasQuery
                  ? Icons.search_off_rounded
                  : Icons.store_mall_directory_outlined,
              size: 64.r,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              hasQuery
                  ? 'لم يتم العثور على نتائج لـ "$query"'
                  : 'لا يوجد تجار متاحين في هذا القسم الفرعي حالياً',
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
              icon: Icon(
                hasQuery ? Icons.clear_rounded : Icons.view_list_rounded,
                size: 16.r,
              ),
              label: Text(
                hasQuery ? 'مسح البحث' : 'عرض كل التجار',
                style: TextStyle(fontSize: 13.sp),
              ),
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
              'حدث خطأ في تحميل التجار',
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
