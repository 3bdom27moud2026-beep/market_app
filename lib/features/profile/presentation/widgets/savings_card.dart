import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Reusable green savings card widget for profile screen matching Image 1 & Image 2 design.
class SavingsCard extends StatelessWidget {
  final double totalSavings;
  final String currency;

  const SavingsCard({
    super.key,
    required this.totalSavings,
    this.currency = 'ج',
  });

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = totalSavings == totalSavings.roundToDouble()
        ? '${totalSavings.toInt()}'
        : totalSavings.toStringAsFixed(1);

    // Format currency to simple 'ج' as in the design
    final String displayCurrency = (currency == 'ج.م' || currency == 'EGP' || currency == 'ج')
        ? 'ج'
        : currency;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D8E4F),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D8E4F).withValues(alpha: 0.25),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: IntrinsicHeight(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Right part (Vibrant green with Title, Subtitle, and Golden Badge)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        // Golden Sun/Star Badge
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAB308),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 22.r,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'إجمـالي مـا وفرتـه',
                                style: TextStyle(
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'ما تم توفيره من جميع فواتيرك حتى الآن',
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Left part (Darker green section with the total savings amount)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF096838),
                  ),
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formattedAmount,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            displayCurrency,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
