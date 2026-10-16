import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/home/domain/entities/newest_product_entity.dart';
import 'package:market/features/home/presentation/cubit/home_state.dart';
import 'package:market/features/home/presentation/widgets/filter_chip.dart';
import 'package:market/features/home/presentation/widgets/newest_product_card.dart';

/// Newest Products section with filter chips and a 2-column grid layout.
///
/// When [products] is empty, shows the section header with a
/// "لا توجد عروض حالياً" empty state message.
class NewestProductsSection extends StatelessWidget {
  final List<NewestProductEntity> products;
  final NewestFilter selectedFilter;
  final Function(NewestFilter) onFilterChanged;
  final void Function(String productId)? onProductTap;
  final void Function(String productId, String title)? onAddToCart;
  final VoidCallback? onViewAllTap;

  const NewestProductsSection({
    super.key,
    required this.products,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onProductTap,
    this.onAddToCart,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أحدث المنتجات والخدمات',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 16.sp),
              ),
              InkWell(
                onTap:
                    onViewAllTap ??
                    () {
                      context.push(AppRoutes.allProducts);
                    },
                child: Row(
                  children: [
                    Text(
                      'عرض المزيد',
                      style: AppTextStyles.sectionViewAll.copyWith(
                        fontSize: 12.sp,
                        color: context.colors.primary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: context.colors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          // Filter chips
          CustomProductFilter(
            selectedFilter: selectedFilter,
            onFilterChanged: onFilterChanged,
          ),
          SizedBox(height: AppSpacing.md.h),
          // Products or empty state
          if (products.isEmpty)
            _EmptyState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: AppSpacing.md.w,
                mainAxisSpacing: AppSpacing.md.h,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return NewestProductCard(
                  product: product,
                  onCartTap: () => onProductTap?.call(product.id),
                  onFavoriteTap: () {},
                  onDetailsTap: () => onProductTap?.call(product.id),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Sort products based on the selected filter.
  static List<NewestProductEntity> sortProducts(
    List<NewestProductEntity> products,
    NewestFilter filter,
  ) {
    final sorted = List<NewestProductEntity>.from(products);
    switch (filter) {
      case NewestFilter.newest:
        // Assume already sorted by newest
        break;
      case NewestFilter.highestDiscount:
        sorted.sort((a, b) {
          final aDiscount = _parseDiscount(
            a.discount,
            price: a.price,
            oldPrice: a.oldPrice,
          );
          final bDiscount = _parseDiscount(
            b.discount,
            price: b.price,
            oldPrice: b.oldPrice,
          );
          return bDiscount.compareTo(aDiscount);
        });
        break;
      case NewestFilter.lowestPrice:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case NewestFilter.highestRating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return sorted;
  }

  static double _parseDiscount(
    String discount, {
    double price = 0,
    double oldPrice = 0,
  }) {
    final numeric = discount.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(numeric) ?? 0;
    if (parsed > 0) return parsed;
    if (oldPrice > price && oldPrice > 0) {
      return ((oldPrice - price) / oldPrice) * 100;
    }
    return 0;
  }
}

class CustomProductFilter extends StatelessWidget {
  const CustomProductFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.padding,
  });

  final NewestFilter selectedFilter;
  final Function(NewestFilter) onFilterChanged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: [
          FilterChipWidget(
            label: 'الأحدث',
            isSelected: selectedFilter == NewestFilter.newest,
            onTap: () => onFilterChanged(NewestFilter.newest),
          ),
          SizedBox(width: AppSpacing.sm.w),
          FilterChipWidget(
            label: 'الأعلى خصماً',
            isSelected: selectedFilter == NewestFilter.highestDiscount,
            onTap: () => onFilterChanged(NewestFilter.highestDiscount),
          ),
          SizedBox(width: AppSpacing.sm.w),
          FilterChipWidget(
            label: 'الأقل سعراً',
            isSelected: selectedFilter == NewestFilter.lowestPrice,
            onTap: () => onFilterChanged(NewestFilter.lowestPrice),
          ),
          SizedBox(width: AppSpacing.sm.w),
          FilterChipWidget(
            label: 'الأعلى تقييماً',
            isSelected: selectedFilter == NewestFilter.highestRating,
            onTap: () => onFilterChanged(NewestFilter.highestRating),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: context.colors.textTertiary,
            size: 40.r,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            'لا توجد عروض حالياً',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.textTertiary,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
