import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// A filter chip that can be selected or unselected.
/// Selected chips have a dark blue background, unselected chips are white.
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.chipSelectedBackground
              : context.colors.chipUnselectedBackground,
          borderRadius: BorderRadius.circular(AppSpacing.xl.r),
          border: Border.all(
            color: isSelected
                ? context.colors.chipSelectedBackground
                : context.colors.border,
            width: 1.w,
          ),
        ),
        child: Text(
          label,
          style:
              (isSelected
                      ? AppTextStyles.chipSelected
                      : AppTextStyles.chipUnselected)
                  .copyWith(fontSize: 12.sp),
        ),
      ),
    );
  }
}
