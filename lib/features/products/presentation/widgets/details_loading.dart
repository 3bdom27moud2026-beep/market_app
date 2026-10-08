import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Shimmer loading placeholder for product details screen.
class DetailsLoading extends StatelessWidget {
  const DetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Column(
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            // Store name placeholder
            Container(
              width: 100.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs.r),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            // Product name placeholder
            Container(
              width: 200.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs.r),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            // Rating placeholder
            Container(
              width: 120.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            // Price card placeholder
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            // Specifications placeholder
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
