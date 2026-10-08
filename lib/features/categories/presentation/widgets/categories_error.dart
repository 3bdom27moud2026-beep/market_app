import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Error widget displayed when categories fail to load.
///
/// Shows an error message with a retry button to attempt loading categories again.
class CategoriesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CategoriesErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: context.colors.accentRed,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'حدث خطأ',
              style: AppTextStyles.bodyLarge.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.textOnPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.md.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
