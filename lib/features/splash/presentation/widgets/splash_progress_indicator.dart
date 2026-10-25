import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Animated loading progress bar with an orange indicator sliding left to right.
///
/// Wrapped in [RepaintBoundary] to isolate repaints from the rest of the tree.
class SplashProgressIndicator extends StatefulWidget {
  final double opacity;

  const SplashProgressIndicator({super.key, this.opacity = 1.0});

  @override
  State<SplashProgressIndicator> createState() =>
      _SplashProgressIndicatorState();
}

class _SplashProgressIndicatorState extends State<SplashProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation =
        TweenSequence<Alignment>([
          TweenSequenceItem(
            tween: AlignmentTween(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: AlignmentTween(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
        );
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
        child: SizedBox(
          width: 140.w,
          height: 3.5.h,
          child: Stack(
            children: [
              // Track
              Container(
                width: 140.w,
                height: 3.5.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Moving indicator
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Align(
                    alignment: _animation.value,
                    child: Container(
                      width: 42.w,
                      height: 3.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEF8226),
                            Color(0xFFFFA366),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x77EF8226),
                            blurRadius: 4.r,
                            offset: Offset(0, 0.5.h),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
