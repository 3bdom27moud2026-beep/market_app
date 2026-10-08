import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Three animated page indicators that cycle through active dots.
///
/// Wrapped in [RepaintBoundary] to isolate repaints from the rest of the tree.
class SplashPageIndicator extends StatefulWidget {
  final double opacity;

  const SplashPageIndicator({super.key, this.opacity = 1.0});

  @override
  State<SplashPageIndicator> createState() => _SplashPageIndicatorState();
}

class _SplashPageIndicatorState extends State<SplashPageIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity.clamp(0.0, 1.0),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final double phase = index / 3.0;
                final double value = _animation.value;
                double distance = (value - phase).abs();
                if (distance > 0.5) distance = 1.0 - distance;
                final double activeFactor = (1.0 - (distance * 3.0)).clamp(
                  0.0,
                  1.0,
                );
                final double dotWidth = (8.0 + (12.0 * activeFactor)).w;
                final double dotOpacity = 0.3 + (0.7 * activeFactor);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: dotWidth,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: activeFactor > 0.4
                          ? context.colors.accentOrange.withValues(
                              alpha: dotOpacity,
                            )
                          : context.colors.textOnPrimary.withValues(
                              alpha: dotOpacity,
                            ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
