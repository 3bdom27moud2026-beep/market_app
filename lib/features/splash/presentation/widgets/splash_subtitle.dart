import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Animated splash subtitle "دليل التسوق والخدمات" with fade-in entrance.
///
/// The [opacity] value is driven from the parent [SplashContent] via a single
/// [AnimationController], eliminating the need for a separate controller.
class SplashSubtitle extends StatelessWidget {
  /// Current opacity (0.0 – 1.0).
  final double opacity;

  const SplashSubtitle({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Text(
        'دليل التسوق والخدمات',
        style: AppTextStyles.splashSubtitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
