import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Discount badge widget to display discount percentage.
class DiscountBadge extends StatelessWidget {
  final String discountText;

  const DiscountBadge({super.key, required this.discountText});

  @override
  Widget build(BuildContext context) {
    String formatted = discountText;
    if (!formatted.startsWith('-')) {
      formatted = '-$formatted';
    }
    if (!formatted.endsWith('%')) {
      formatted = '$formatted%';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFF183B64),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        formatted,
        style: TextStyle(
          color: context.colors.textOnPrimary,
          fontSize: 8.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
