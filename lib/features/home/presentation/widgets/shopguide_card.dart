import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// ShopGuide membership card with a dark blue background, text, and an orange
/// CTA button.
class ShopGuideCard extends StatelessWidget {
  final VoidCallback? onGetItTap;

  const ShopGuideCard({super.key, this.onGetItTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      padding: EdgeInsets.all(AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: context.colors.primaryDark,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        boxShadow: [
          BoxShadow(
            color: context.colors.primaryDark.withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'كارت شوب جايد',
                  style: AppTextStyles.whiteHeading.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  'خصم فوري عند جميع شركائنا',
                  style: AppTextStyles.whiteSmall.copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onGetItTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accentOrange,
              foregroundColor: context.colors.textOnPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl.w,
                vertical: AppSpacing.sm.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
            ),
            child: Text(
              'احصل عليه',
              style: AppTextStyles.buttonSmall.copyWith(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
