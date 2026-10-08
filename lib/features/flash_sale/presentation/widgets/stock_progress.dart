import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Stock progress bar showing remaining quantity.
class StockProgress extends StatelessWidget {
  final int remaining;
  final double stockPercent;

  const StockProgress({
    super.key,
    required this.remaining,
    this.stockPercent = 65,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.r),
          child: LinearProgressIndicator(
            value: (stockPercent / 100).clamp(0.1, 1.0),
            minHeight: 4.h,
            backgroundColor: const Color(0xFFD6E4F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF183B64)),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'باقي $remaining فقط',
          style: TextStyle(
            fontSize: 7.5.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF183B64),
          ),
        ),
      ],
    );
  }
}
