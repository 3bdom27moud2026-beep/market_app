import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Clean, responsive search field widget for filtering categories.
///
/// Features:
/// - Explicitly disables theme input background fill to prevent visual overlapping glitches.
/// - Full RTL alignment with search icon on the right.
/// - Clear button on the left when text is typed.
/// - Clean elevation and border matching the app's modern design system.
class CategorySearchField extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String? initialValue;

  const CategorySearchField({
    super.key,
    required this.onSearch,
    this.initialValue,
  });

  @override
  State<CategorySearchField> createState() => _CategorySearchFieldState();
}

class _CategorySearchFieldState extends State<CategorySearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CategorySearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? context.colors.border
        : const Color(0xFFE2E8F0);
    final fieldBg = isDark ? context.colors.surface : Colors.white;

    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: _controller,
          onChanged: (val) {
            setState(() {});
            widget.onSearch(val);
          },
          textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12.5.sp,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: false,
            fillColor: Colors.transparent,
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
            prefixIconConstraints: BoxConstraints(
              minWidth: 44.w,
              minHeight: 48.h,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _controller.clear();
                      widget.onSearch('');
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Icon(
                        Icons.cancel_rounded,
                        color: isDark
                            ? context.colors.textQuaternary
                            : const Color(0xFF94A3B8),
                        size: 18.r,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: BoxConstraints(
              minWidth: 36.w,
              minHeight: 48.h,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ),
    );
  }
}
