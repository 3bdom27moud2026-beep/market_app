import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

/// Card widget displaying installment options matching the design in the screenshot.
/// Only displayed when installment data exists and is supported.
class ProductInstallmentCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onPlansTap;

  const ProductInstallmentCard({
    super.key,
    required this.product,
    this.onPlansTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!product.supportsInstallment) {
      return const SizedBox.shrink();
    }

    // Determine monthly installment amount
    final double monthlyPrice = product.monthlyInstallment ??
        (product.price > 0 ? (product.price / 12).roundToDouble() : 20.0);
    final String partner = product.installmentPartner.isNotEmpty
        ? product.installmentPartner
        : 'مايلو';

    const Color roseBg = Color(0xFFFFF0F5);
    const Color roseBorder = Color(0xFFFCE7EC);
    const Color berryPrimary = Color(0xFFC2185B);
    const Color darkText = Color(0xFF101828);

    return InkWell(
      onTap: onPlansTap ?? () => _showInstallmentPlansBottomSheet(context, partner, monthlyPrice),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: roseBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: roseBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Right info
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: berryPrimary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'تقسيط متاح',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'تقسيط مع $partner',
                        style: TextStyle(
                          color: berryPrimary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'يبدأ من ${monthlyPrice.toStringAsFixed(0)} ج.م / الشهر',
                    style: TextStyle(
                      color: darkText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Left action (in RTL: text on right, chevron pointing left on left)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'عرض الخطط',
                  style: TextStyle(
                    color: berryPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 11.sp,
                  color: berryPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInstallmentPlansBottomSheet(
    BuildContext context,
    String partner,
    double minMonthly,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'خطط التقسيط مع $partner',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF101828),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'يمكنك تقسيط مشترياتك عبر $partner بخطط ميسرة تبدأ من ${minMonthly.toStringAsFixed(0)} ج.م شهرياً وبدون فوائد لفترات مختارة.',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF475467),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2185B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: const Text('حسناً'),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
