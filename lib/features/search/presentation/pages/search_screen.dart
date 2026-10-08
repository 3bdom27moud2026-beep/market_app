import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/products/presentation/widgets/category_product_card.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';
import 'package:market/features/search/presentation/cubit/search_cubit.dart';
import 'package:market/features/search/presentation/cubit/search_state.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      context.read<SearchCubit>().onQueryChanged(widget.initialQuery);
    }
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
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(6.r),
          child: const AppBackButton(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const CartBadgeButton(),
          ),
        ],
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: AppSpacing.md.w),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: widget.initialQuery.isEmpty,
              textInputAction: TextInputAction.search,
              onChanged: (val) =>
                  context.read<SearchCubit>().onQueryChanged(val),
              onSubmitted: (val) => context.read<SearchCubit>().performSearch(),
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'ابحث عن المنتجات، الخدمات، أو المتاجر...',
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: context.colors.textQuaternary,
                  size: 20.r,
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: context.colors.textTertiary,
                        size: 18.r,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchCubit>().clearSearch();
                      },
                    );
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: AppSpacing.xs.h),
          // Filter Types Selector Row
          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (prev, curr) => prev.type != curr.type,
            builder: (context, state) {
              return Container(
                height: 40.h,
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'الكل',
                      isSelected: state.type == 'all',
                      onTap: () =>
                          context.read<SearchCubit>().changeType('all'),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    _FilterChip(
                      label: 'المنتجات',
                      isSelected: state.type == 'product',
                      onTap: () =>
                          context.read<SearchCubit>().changeType('product'),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    _FilterChip(
                      label: 'المتاجر',
                      isSelected: state.type == 'merchant',
                      onTap: () =>
                          context.read<SearchCubit>().changeType('merchant'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(height: 16.h, color: context.colors.divider),
          // Body Content
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return const _InitialSearchView();

                  case SearchStatus.loading:
                    return const _SearchShimmerLoading();

                  case SearchStatus.error:
                    return _ErrorView(
                      message: state.errorMessage,
                      onRetry: () =>
                          context.read<SearchCubit>().performSearch(),
                    );

                  case SearchStatus.empty:
                    return _EmptySearchView(query: state.query);

                  case SearchStatus.loaded:
                    return _SearchResultsContent(state: state);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.xs.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected
                  ? context.colors.textOnPrimary
                  : context.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialSearchView extends StatelessWidget {
  const _InitialSearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              size: 54.r,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'ابحث عن منتج، متجر، أو فئة',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'اكتب في خانة البحث بالأعلى لعرض النتائج مباشرة',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  final String query;

  const _EmptySearchView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.r,
              color: context.colors.textQuaternary,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'لا توجد نتائج بحث لمطابقة "$query"',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'تأكد من كتابة الكلمات بشكل صحيح أو حاول البحث بكلمات أخرى',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56.r,
              color: context.colors.accentRed,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18.r),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.md.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsContent extends StatelessWidget {
  final SearchState state;

  const _SearchResultsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final products = state.results.products;
    final merchants = state.results.merchants;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Merchants Section
          if (merchants.isNotEmpty &&
              (state.type == 'all' || state.type == 'merchant')) ...[
            Text(
              'المتاجر (${merchants.length})',
              style: AppTextStyles.headingSmall.copyWith(
                color: context.colors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: merchants.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
              itemBuilder: (context, index) {
                final merchant = merchants[index];
                return _MerchantSearchCard(merchant: merchant);
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
          ],

          // Products Section
          if (products.isNotEmpty &&
              (state.type == 'all' || state.type == 'product')) ...[
            Text(
              'المنتجات (${products.length})',
              style: AppTextStyles.headingSmall.copyWith(
                color: context.colors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.sm.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: AppSpacing.sm.w,
                mainAxisSpacing: AppSpacing.sm.h,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return CategoryProductCard(product: product);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _MerchantSearchCard extends StatelessWidget {
  final MerchantEntity merchant;

  const _MerchantSearchCard({required this.merchant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/merchant-details/${merchant.id}'),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm.r),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadowLight,
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo / Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm.r),
              child: CachedNetworkImage(
                imageUrl: merchant.image,
                width: 60.r,
                height: 60.r,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: context.colors.backgroundSecondary),
                errorWidget: (context, url, error) => Container(
                  color: context.colors.backgroundSecondary,
                  child: Icon(
                    Icons.storefront,
                    color: context.colors.textTertiary,
                    size: 24.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (merchant.address.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      merchant.address,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (merchant.rating > 0) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 14.r,
                          color: context.colors.ratingYellow,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          merchant.rating.toStringAsFixed(1),
                          style: AppTextStyles.ratingSmall.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                      ],
                      if (merchant.discount.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.discountRed.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'خصم ${merchant.discount}',
                            style: AppTextStyles.discountBadge.copyWith(
                              color: context.colors.discountRed,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.r,
              color: context.colors.textQuaternary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchShimmerLoading extends StatelessWidget {
  const _SearchShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md.r),
        child: Column(
          children: [
            Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: AppSpacing.sm.w,
                mainAxisSpacing: AppSpacing.sm.h,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
