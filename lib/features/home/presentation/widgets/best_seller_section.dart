import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/widgets/orange_custom_icon.dart';
import 'package:market/features/home/domain/entities/best_seller_entity.dart';
import 'best_seller_card.dart';

/// Best Seller section with dark blue background, header, and horizontal cards.
///
/// When [products] is empty, shows the section header with a
/// "لا توجد عروض حالياً" empty state message.
class BestSellerSection extends StatelessWidget {
  final List<BestSellerEntity> products;
  final VoidCallback? onViewAllTap;
  final void Function(String productId)? onProductTap;
  final void Function(String productId, String title)? onAddToCart;

  const BestSellerSection({
    super.key,
    required this.products,
    this.onViewAllTap,
    this.onProductTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: AppSpacing.md.h,
        horizontal: AppSpacing.md.w,
      ),
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: context.colors.flashSaleBlue,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const OrangeCustomIcon(iconData: Icons.trending_up_sharp),
                  SizedBox(width: AppSpacing.xs.w),
                  Text('الأكثر مبيعاً', style: AppTextStyles.whiteHeading),
                ],
              ),
              InkWell(
                onTap: onViewAllTap,
                child: Row(
                  children: [
                    Text('عرض الكل', style: AppTextStyles.buttonSmall),
                    SizedBox(width: AppSpacing.xs.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: context.colors.textOnPrimary,
                      size: 12.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxxl.h),
          // Products or empty state
          if (products.isEmpty)
            _EmptyState()
          else
            SizedBox(
              height: 260.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return BestSellerCard(
                    product: product,
                    onCartTap: () => onProductTap?.call(product.id),
                    onDetailsTap: () => onProductTap?.call(product.id),
                  );
                },
              ),
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
            Icons.trending_up_outlined,
            color: context.colors.textOnPrimary60,
            size: 40.r,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            'لا توجد عروض حالياً',
            style: AppTextStyles.whiteSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
