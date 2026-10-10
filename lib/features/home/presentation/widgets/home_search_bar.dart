import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Search bar widget for the home screen.
///
/// Tapping navigates to the search screen.
class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.sm.h,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: context.colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppSpacing.sm.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: context.colors.textQuaternary,
                size: 22.r,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Text(
                  'ابحث عن المنتجات، الخدمات، أو المتاجر...',
                  style: AppTextStyles.searchHint.copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
