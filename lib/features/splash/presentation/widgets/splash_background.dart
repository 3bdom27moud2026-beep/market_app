import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/background_grid_painter.dart';

/// Full-screen gradient background with a soft orange glow and subtle grid overlay.
///
/// Wrapped in [RepaintBoundary] to prevent repainting when child animations update.
class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colors.gradientTop,
              context.colors.gradientMiddle,
              context.colors.gradientBottom,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Soft orange glow in top-right corner
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.r,
                height: 300.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.softOrangeGlow,
                ),
              ),
            ),
            // Subtle grid pattern overlay using reusable painter
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: const BackgroundGridPainter()),
              ),
            ),
            // SafeArea content
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
