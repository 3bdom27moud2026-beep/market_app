import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';

/// Splash logo app icon card with fade-in and scale-up entrance animation.
///
/// Features a pure-white squircle card matching modern app icon design:
/// - Stylized cart SVG brand mark with navy basket and orange wheels
class SplashLogo extends StatelessWidget {
  /// Current opacity (0.0 – 1.0).
  final double opacity;

  /// Current scale factor.
  final double scale;

  const SplashLogo({super.key, required this.opacity, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 98.r,
          height: 98.r,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF06152B).withValues(alpha: 0.35),
                blurRadius: 28.r,
                offset: Offset(0, 12.h),
              ),
              BoxShadow(
                color: const Color(0xFF06152B).withValues(alpha: 0.10),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(18.r),
            child: SvgPicture.asset(
              AppAssets.logoSvg,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
