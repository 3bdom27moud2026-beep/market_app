import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Search bar widget matching the brand design mockup:
/// - Pill-shaped white container
/// - Magnifying glass search icon on the left
/// - Arabic placeholder text in the middle
/// - Vertical divider and filter sliders icon on the right
class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({
    super.key,
    this.onTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              // Search icon on the left
              Icon(
                Icons.search,
                color: const Color(0xFF9CA3AF),
                size: 22.r,
              ),
              SizedBox(width: 8.w),

              // Placeholder text (Arabic RTL)
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'ابحث عن منتج، خدمة، عقار أو أي شيء تحتاجه...',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 11.5.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Thin vertical divider line
              Container(
                height: 18.h,
                width: 1.w,
                color: const Color(0xFFE5E7EB),
              ),
              SizedBox(width: 8.w),

              // Filter sliders icon on the right
              GestureDetector(
                onTap: onFilterTap ?? onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Icon(
                    Icons.tune_rounded,
                    color: const Color(0xFF0F2B48),
                    size: 20.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
