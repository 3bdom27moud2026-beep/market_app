import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Custom dropdown widget for location selection.
class LocationDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final T? selectedItem;
  final bool isEnabled;
  final bool isLoading;
  final String Function(T item)? itemLabelBuilder;
  final ValueChanged<T?> onChanged;

  const LocationDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.selectedItem,
    this.isEnabled = true,
    this.isLoading = false,
    this.itemLabelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Container(
          decoration: BoxDecoration(
            color: isEnabled
                ? context.colors.background
                : context.colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.medium.r),
            border: Border.all(
              color: isEnabled ? context.colors.border : context.colors.divider,
              width: 1.w,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<T>(
                value: selectedItem,
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.w,
                    vertical: AppSpacing.md.h,
                  ),
                  child: Text(
                    hint,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.textQuaternary,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                icon: isLoading
                    ? Padding(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        child: SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: context.colors.primary,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isEnabled
                              ? context.colors.textTertiary
                              : context.colors.textQuaternary,
                          size: 24.r,
                        ),
                      ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                  fontSize: 13.sp,
                ),
                dropdownColor: context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.medium.r),
                items: items.map((item) {
                  final label = itemLabelBuilder != null
                      ? itemLabelBuilder!(item)
                      : item.toString();
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg.w,
                        vertical: AppSpacing.md.h,
                      ),
                      child: Text(label),
                    ),
                  );
                }).toList(),
                onChanged: (isEnabled && !isLoading) ? onChanged : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
