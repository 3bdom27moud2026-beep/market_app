import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Bottom bar controls featuring Skip, Page Indicator dots, and Next / Get Started button.
class OnboardingBottomControls extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;

  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.onSkip,
    required this.onNext,
    required this.onGetStarted,
  });

  bool get isLastPage => currentIndex == totalCount - 1;

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFEF8226);
    const navyColor = Color(0xFF173D69);

    // Left-to-Right directionality ensures Skip is on the left and Next on the right
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl.w,
          vertical: 16.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Skip Button ──────────────────────────────────────────────
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: navyColor,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: navyColor,
                ),
              ),
            ),

            // ── Animated Dots Indicator ──────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalCount, (index) {
                final isActive = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 3.5.w),
                  width: isActive ? 22.w : 7.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                    color: isActive ? primaryOrange : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),

            // ── Next / Get Started CTA Button ────────────────────────────
            InkWell(
              onTap: isLastPage ? onGetStarted : onNext,
              borderRadius: BorderRadius.circular(14.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(
                  horizontal: isLastPage ? 20.w : 22.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: primaryOrange,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withValues(alpha: 0.32),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16.r,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
