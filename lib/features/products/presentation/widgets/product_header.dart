import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Product header with store name, brand, product name, and rating.
class ProductHeader extends StatelessWidget {
  final String store;
  final String name;
  final double rating;
  final String brand;
  final int reviewCount;

  const ProductHeader({
    super.key,
    required this.store,
    required this.name,
    required this.rating,
    this.brand = '',
    this.reviewCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = brand.isNotEmpty && brand != store
        ? '$store ($brand)'
        : store;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store & Brand name
        if (displayName.isNotEmpty) ...[
          Text(
            displayName,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        // Product name
        Text(
          name,
          style: TextStyle(
            color: const Color(0xFF101828),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
        SizedBox(height: 6.h),
        // Rating row (in RTL: Star -> 4.9 -> (120 تقييم))
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 20.sp,
              color: const Color(0xFFFFB800),
            ),
            SizedBox(width: 4.w),
            Text(
              rating > 0 ? rating.toStringAsFixed(1) : '4.9',
              style: TextStyle(
                color: const Color(0xFFF59E0B),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              reviewCount > 0 ? '($reviewCount تقييم)' : '(120 تقييم)',
              style: TextStyle(
                color: const Color(0xFF667085),
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
