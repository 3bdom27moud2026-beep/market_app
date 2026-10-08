import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Segmented control for switching between purchase modes.
///
/// Shows two options: retail (شراء قطاعي) and wholesale (شراء جملة).
class CategoryTypeSwitch extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;

  const CategoryTypeSwitch({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? context.colors.surface : const Color(0xFFF1F5F9);
    final borderColor = isDark ? context.colors.border : const Color(0xFFE2E8F0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            _buildOption(context, 'retail', 'شراء قطاعي 🛍️', isDark),
            _buildOption(context, 'wholesale', 'شراء جملة 📦', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String mode,
    String label,
    bool isDark,
  ) {
    final isSelected = selectedMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? context.colors.backgroundSecondary : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF1B4270))
                    : (isDark
                        ? context.colors.textTertiary
                        : const Color(0xFF5A6E85)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
