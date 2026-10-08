import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Merchant card skeleton 1
            _buildMerchantSkeleton(context),
            SizedBox(height: 16.h),
            // Merchant card skeleton 2
            _buildMerchantSkeleton(context),
            SizedBox(height: 16.h),
            // Coupon skeleton
            Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 16.h),
            // Summary skeleton
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 140.w,
                height: 16.h,
                color: context.colors.surface,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 70.r,
                height: 70.r,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14.h,
                      color: context.colors.surface,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 80.w,
                      height: 12.h,
                      color: context.colors.surface,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      color: context.colors.surface,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
