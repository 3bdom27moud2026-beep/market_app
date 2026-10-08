import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Shimmer loading grid for flash sale.
class FlashSaleLoadingView extends StatelessWidget {
  const FlashSaleLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.60,
            crossAxisSpacing: AppSpacing.md.w,
            mainAxisSpacing: AppSpacing.md.h,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: context.colors.textOnPrimary,
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
            );
          },
        ),
      ),
    );
  }
}
