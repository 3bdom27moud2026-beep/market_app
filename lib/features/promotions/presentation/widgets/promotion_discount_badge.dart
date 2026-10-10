import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Discount badge widget showing the discount percentage.
class PromotionDiscountBadge extends StatelessWidget {
  final int discount;

  const PromotionDiscountBadge({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '-$discount%',
        style: TextStyle(
          color: context.colors.textOnPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
