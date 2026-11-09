import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized shadow constants.
///
/// Shadow colors use opacity-based black which works on both
/// light and dark surfaces, so these values are theme-invariant.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: AppPalette.shadowLight, blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> cardElevated = [
    BoxShadow(color: AppPalette.shadowMedium, blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> banner = [
    BoxShadow(color: AppPalette.shadowDark, blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> productCard = [
    BoxShadow(color: AppPalette.shadowLight, blurRadius: 6, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(color: AppPalette.shadowMedium, blurRadius: 12, offset: Offset(0, -2)),
  ];
}
