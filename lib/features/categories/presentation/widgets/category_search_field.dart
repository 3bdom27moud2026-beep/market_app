import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Search field widget for filtering categories.
///
/// Provides a text input with search icon and placeholder.
class CategorySearchField extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final String? initialValue;

  const CategorySearchField({
    super.key,
    required this.onSearch,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? context.colors.border : const Color(0xFFE2E8F0);
    final fieldBg = isDark ? context.colors.surface : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          onChanged: onSearch,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12.sp,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن فئة...',
            hintStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12.sp,
              color: isDark
                  ? context.colors.textQuaternary
                  : const Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark
                  ? context.colors.textQuaternary
                  : const Color(0xFF94A3B8),
              size: 22.r,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }
}
