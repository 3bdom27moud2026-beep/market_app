import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import 'splash_logo.dart';
import 'splash_title.dart';
import 'splash_subtitle.dart';
import 'splash_progress_indicator.dart';
import 'splash_page_indicator.dart';

/// Orchestrates all splash content with staggered entrance animations.
class SplashContent extends StatefulWidget {
  /// Called once initial animations complete and content is fully visible.
  final VoidCallback? onAnimationsComplete;

  const SplashContent({super.key, this.onAnimationsComplete});

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Staggered animation thresholds (0.0 – 1.0) over splashAutoNavigate
  static const double _logoEnd = 0.30;
  static const double _titleStart = 0.25;
  static const double _titleEnd = 0.50;
  static const double _subtitleStart = 0.45;
  static const double _subtitleEnd = 0.65;
  static const double _progressStart = 0.55;
  static const double _progressEnd = 0.80;
  static const double _indicatorsStart = 0.70;
  static const double _indicatorsEnd = 0.90;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.splashAutoNavigate,
    );

    // Start entrance sequence
    _controller.forward();

    // Notify parent when full sequence completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationsComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static double _staggeredOpacity(double progress, double start, double end) {
    if (progress < start) return 0.0;
    if (progress > end) return 1.0;
    return (progress - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _controller.value;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 58.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SplashLogo(
                  opacity: _staggeredOpacity(progress, 0.0, _logoEnd),
                  scale:
                      0.85 +
                      (0.15 * _staggeredOpacity(progress, 0.0, _logoEnd)),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                SplashTitle(
                  opacity: _staggeredOpacity(progress, _titleStart, _titleEnd),
                ),
                SizedBox(height: AppSpacing.sm.h),
                SplashSubtitle(
                  opacity: _staggeredOpacity(
                    progress,
                    _subtitleStart,
                    _subtitleEnd,
                  ),
                ),
                SizedBox(height: (AppSpacing.xl + AppSpacing.xl).h),
                SplashProgressIndicator(
                  opacity: _staggeredOpacity(
                    progress,
                    _progressStart,
                    _progressEnd,
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                SplashPageIndicator(
                  opacity: _staggeredOpacity(
                    progress,
                    _indicatorsStart,
                    _indicatorsEnd,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
