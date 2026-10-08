import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

/// {@template discount_card_loading}
/// Shimmer loading placeholder for the discount card screen.
/// {@endtemplate}
class DiscountCardLoading extends StatelessWidget {
  const DiscountCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.backgroundTertiary,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Column(
          children: [
            // Membership card placeholder
            Container(
              height: 280.h,
              decoration: BoxDecoration(
                color: context.colors.textOnPrimary,
                borderRadius: BorderRadius.circular(AppRadius.large.r),
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            // QR placeholder
            Container(
              width: 200.r,
              height: 200.r,
              decoration: BoxDecoration(
                color: context.colors.textOnPrimary,
                borderRadius: BorderRadius.circular(AppRadius.large.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            // Subscription status placeholder
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: context.colors.textOnPrimary,
                borderRadius: BorderRadius.circular(AppRadius.medium.r),
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            // Statistics row placeholder
            Row(
              children: List.generate(
                3,
                (_) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: context.colors.textOnPrimary,
                      borderRadius: BorderRadius.circular(AppRadius.medium.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            // Category tiles placeholder
            ...List.generate(
              4,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
                child: Container(
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: context.colors.textOnPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.medium.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
