import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Sticky bottom button for adding product to cart.
class AddToCartButton extends StatelessWidget {
  final bool isLoading;
  final bool isService;
  final bool isAdded;
  final String? customLabel;
  final VoidCallback? onPressed;

  const AddToCartButton({
    super.key,
    this.isLoading = false,
    this.isService = false,
    this.isAdded = false,
    this.customLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = isAdded
        ? 'تم الإضافة بنجاح'
        : (customLabel ??
            (isService
                ? (isLoading ? 'جاري الإرسال...' : 'طلب معاينة الخدمة')
                : (isLoading ? 'جاري الإضافة...' : 'إضافة إلى سلة المشتريات')));

    final effectiveIcon = isAdded
        ? Icons.check_circle_outline
        : (isService
            ? Icons.assignment_turned_in_outlined
            : Icons.shopping_cart);

    final bool isDisabled = isLoading || isAdded;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton.icon(
            onPressed: isDisabled ? null : onPressed,
            icon: isLoading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: context.colors.textOnPrimary,
                    ),
                  )
                : Icon(
                    effectiveIcon,
                    size: 20.r,
                    color: isAdded
                        ? context.colors.textOnPrimary
                        : null,
                  ),
            label: Text(
              effectiveLabel,
              style: AppTextStyles.buttonOrange.copyWith(
                fontSize: 11.sp,
                color: isAdded
                    ? context.colors.textOnPrimary
                    : null,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdded
                  ? context.colors.accentGreen
                  : (isService
                      ? context.colors.accentOrange
                      : context.colors.primary),
              foregroundColor: context.colors.textOnPrimary,
              disabledBackgroundColor: isAdded
                  ? context.colors.accentGreen
                  : (isService
                          ? context.colors.accentOrange
                          : context.colors.primary)
                      .withValues(alpha: 0.7),
              disabledForegroundColor: isAdded
                  ? context.colors.textOnPrimary
                  : context.colors.textOnPrimary60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
