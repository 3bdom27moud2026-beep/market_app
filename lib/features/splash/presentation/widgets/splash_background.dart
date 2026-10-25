import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/background_grid_painter.dart';

/// Full-screen deep navy gradient background with ambient dual-glow (amber top-right,
/// radiant blue bottom-left) and subtle architectural blueprint grid overlay matching design.
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1B32), // Deep midnight navy at top
              Color(0xFF102B4E), // Oceanic navy in middle
              Color(0xFF081628), // Deep obsidian navy at bottom
            ],
            stops: [0.0, 0.50, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // 1. Warm golden/amber ambient glow in top-right corner
            Positioned(
              top: -60.h,
              right: -60.w,
              child: IgnorePointer(
                child: Container(
                  width: 340.r,
                  height: 340.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.65,
                      colors: [
                        Color(0x45E67E22), // Warm amber glow
                        Color(0x22D35400),
                        Color(0x0AE67E22),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.35, 0.70, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // 2. Soft atmospheric blue ambient glow in bottom-left
            Positioned(
              bottom: -90.h,
              left: -70.w,
              child: IgnorePointer(
                child: Container(
                  width: 360.r,
                  height: 360.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.65,
                      colors: [
                        Color(0x301E88E5), // Radiant blue glow
                        Color(0x141565C0),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // 3. Subtle grid pattern overlay
            const Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: BackgroundGridPainter(
                    gridSize: 36,
                    strokeWidth: 0.55,
                    color: Color(0x0EFFFFFF),
                  ),
                ),
              ),
            ),

            // 4. Centered content within safe area
            SafeArea(
              child: SizedBox.expand(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
