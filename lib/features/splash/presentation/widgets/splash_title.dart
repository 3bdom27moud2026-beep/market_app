import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Animated splash title "Shop Guide" with fade-in entrance.
///
/// The [opacity] value is driven from the parent [SplashContent] via a single
/// [AnimationController], eliminating the need for a separate controller.
class SplashTitle extends StatelessWidget {
  /// Current opacity (0.0 – 1.0).
  final double opacity;

  const SplashTitle({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Text('Shop Guide', style: AppTextStyles.splashTitle),
    );
  }
}
