import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Splash logo with fade-in and scale-up entrance animation.
///
/// The animation values ([opacity], [scale]) are driven from the parent
/// [SplashContent] via a single [AnimationController], eliminating the need
/// for a separate controller and avoiding unnecessary rebuilds.
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
          width: AppSpacing.logoContainerSize.r,
          height: AppSpacing.logoContainerSize.r,
          decoration: BoxDecoration(
            color: context.colors.logoBackground,
            borderRadius: BorderRadius.circular(AppRadius.logoContainer.r),
            boxShadow: [
              BoxShadow(
                color: context.colors.logoShadow,
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: SvgPicture.asset(AppAssets.logoSvg, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
