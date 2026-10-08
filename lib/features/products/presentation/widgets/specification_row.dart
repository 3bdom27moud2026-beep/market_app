import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// A single specification row with title and value.
class SpecificationRow extends StatelessWidget {
  final String title;
  final String value;

  const SpecificationRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          SizedBox(
            width: 110.w,
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          // Value
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
