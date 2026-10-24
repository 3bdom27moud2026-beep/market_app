import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/constants/app_shadows.dart';

/// Price card with current price, old price, and discount badge.
class ProductPriceCard extends StatelessWidget {
  final double price;
  final double oldPrice;
  final int discount;
  final double savingsAmount;
  final bool isService;

  const ProductPriceCard({
    super.key,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.savingsAmount = 0,
    this.isService = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isService || price <= 0) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          boxShadow: AppShadows.card,
          border: Border.all(
            color: context.colors.accentOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: context.colors.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm.r),
              ),
              child: Icon(
                Icons.build_circle_outlined,
                color: context.colors.accentOrange,
                size: 26.sp,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'القيمة تحدد بعد المعاينة',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: context.colors.primary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'خدمة فنية - يتم تحديد التكلفة النهائية بدقة بعد فحص الموقع أو المعاينة',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final hasDiscount = oldPrice > price && oldPrice > 0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'السعر الحالي',
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price and Old Price row
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${price.toStringAsFixed(0)} ج.م',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (hasDiscount) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '${oldPrice.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: context.colors.textTertiary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
              // Discount badge
              if (discount > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.discountRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'توفير $discount%',
                    style: TextStyle(
                      color: context.colors.discountRed,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (savingsAmount > 0 && !hasDiscount) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.savings_outlined,
                  size: 15.sp,
                  color: context.colors.accentGreen,
                ),
                SizedBox(width: 4.w),
                Text(
                  'وفرت ${savingsAmount.toStringAsFixed(0)} ج.م مع هذا العرض',
                  style: TextStyle(
                    color: context.colors.accentGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
