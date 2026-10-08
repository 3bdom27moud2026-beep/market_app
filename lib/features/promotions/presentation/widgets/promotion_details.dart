import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Product details widget showing right-aligned title, store/brand, and merchant row.
class PromotionDetails extends StatelessWidget {
  final String title;
  final String store;
  final String brand;
  final String merchantName;

  const PromotionDetails({
    super.key,
    required this.title,
    required this.store,
    this.brand = '',
    this.merchantName = '',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBrand = brand.isNotEmpty ? brand : store;
    final effectiveMerchant = merchantName.isNotEmpty
        ? merchantName
        : (brand.isNotEmpty && brand != store ? store : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product title (large bold white)
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Brand / Store subtitle
        if (effectiveBrand.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            effectiveBrand,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: context.colors.textOnPrimary.withValues(alpha: 0.95),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],

        // Merchant row with store icon
        if (effectiveMerchant.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 14.r,
                color: context.colors.textOnPrimary.withValues(alpha: 0.8),
              ),
              SizedBox(width: 4.w),
              Text(
                'من $effectiveMerchant',
                style: TextStyle(
                  color: context.colors.textOnPrimary.withValues(alpha: 0.85),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ] else if (effectiveBrand.isNotEmpty && effectiveMerchant.isEmpty) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 14.r,
                color: context.colors.textOnPrimary.withValues(alpha: 0.8),
              ),
              SizedBox(width: 4.w),
              Text(
                'من $effectiveBrand',
                style: TextStyle(
                  color: context.colors.textOnPrimary.withValues(alpha: 0.85),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
