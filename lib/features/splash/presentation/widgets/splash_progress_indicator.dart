import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extensions.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width * 0.6;
            return SizedBox(
              width: maxWidth.clamp(160.w, 400.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: Container(
                  height: 4.h,
                  color: context.colors.textOnPrimary.withValues(alpha: 0.2),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Align(
                        alignment: _animation.value,
                        child: Container(
                          width: maxWidth * 0.4,
                          height: 4.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            gradient: LinearGradient(
                              colors: [
                                context.colors.accentOrange,
                                context.colors.accentOrangeLight,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
