import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Reusable green savings card widget for profile screen matching the design.
class SavingsCard extends StatelessWidget {
  final double totalSavings;
  final String currency;

  const SavingsCard({
    super.key,
    required this.totalSavings,
    this.currency = 'ج.م',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: const Color(0xFF00A86B),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x2000A86B),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Money Pouch Icon (on right in RTL, or left in standard Row)
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              color: Color(0x33FFFFFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('💰', style: TextStyle(fontSize: 18.sp)),
            ),
          ),

          SizedBox(width: AppSpacing.md.w),

          // Savings Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Title + Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي ما وفرته',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.colors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm.w,
                        vertical: AppSpacing.xs.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '☀️ توفير ممتاز',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: context.colors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Amount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${totalSavings.toInt()}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      currency,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textOnPrimary.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
