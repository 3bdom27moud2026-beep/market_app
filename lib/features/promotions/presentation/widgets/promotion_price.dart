import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Price and rating widget showing current price, old strikethrough price, and rating.
class PromotionPrice extends StatelessWidget {
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;

  const PromotionPrice({
    super.key,
    required this.price,
    required this.oldPrice,
    this.rating = 4.7,
    this.reviews = 310,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Row (Right-aligned in RTL: Big price first, then strikethrough price)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // Current price in bold orange
            Text(
              '${price.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                color: const Color(0xFFEF8226),
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),

            // Old price with strike-through
            if (oldPrice > price) ...[
              SizedBox(width: 8.w),
              Text(
                '${oldPrice.toStringAsFixed(0)} ج.م',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textOnPrimary.withValues(alpha: 0.65),
                  decoration: TextDecoration.lineThrough,
                  decorationColor: context.colors.textOnPrimary.withValues(
                    alpha: 0.65,
                  ),
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: 2.h),

        // Rating row (in RTL: Star -> 4.7 -> (310))
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: const Color(0xFFFFC107),
              size: 12.r,
            ),
            SizedBox(width: 2.w),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                color: const Color(0xFFFFC107),
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '($reviews)',
              style: TextStyle(
                color: context.colors.textOnPrimary.withValues(alpha: 0.75),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
