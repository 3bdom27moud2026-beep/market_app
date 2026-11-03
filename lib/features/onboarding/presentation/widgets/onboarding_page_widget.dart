import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/onboarding_item_model.dart';

/// Single page widget inside the Onboarding PageView.
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          children: [
            SizedBox(height: 8.h),

            // ── 3D Hero Illustration ───────────────────────────────────────
            Center(
              child: SizedBox(
                height: 290.h,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 22.h),

            // ── Arabic Main Title ──────────────────────────────────────────
            Text(
              item.titleAr,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 21.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF173D69),
                height: 1.3,
              ),
            ),

            SizedBox(height: 8.h),

            // ── English Sub-headline ───────────────────────────────────────
            Text(
              item.titleEn,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF173D69),
                height: 1.3,
              ),
            ),

            SizedBox(height: 18.h),

            // ── Arabic Body Description ────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                item.subtitleAr,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // ── English Body Description ───────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                item.subtitleEn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
