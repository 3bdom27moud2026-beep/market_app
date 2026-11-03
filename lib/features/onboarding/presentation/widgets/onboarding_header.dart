import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';

/// Top header banner displaying the Shop Guide brandmark and tagline.
///
/// Faithfully reproduces the design header:
/// - Stylized cart logo icon on the left
/// - Brand title 'Shop Guide' in navy
/// - Subtitle 'SHOPPING IS EASIER WITH US' in orange
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: Center(
        child: Image.asset(
          AppAssets.onboardingBrandLogo,
          height: 42.h,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) =>
              const _CodeBasedBrandHeader(),
        ),
      ),
    );
  }
}

class _CodeBasedBrandHeader extends StatelessWidget {
  const _CodeBasedBrandHeader();

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1B3E68);
    const orangeColor = Color(0xFFEF8025);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.logo,
            width: 38.r,
            height: 38.r,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shop Guide',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: navyColor,
                  letterSpacing: -0.2,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'SHOPPING IS EASIER WITH US',
                style: TextStyle(
                  fontSize: 6.sp,
                  fontWeight: FontWeight.w800,
                  color: orangeColor,
                  letterSpacing: 0.6,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

