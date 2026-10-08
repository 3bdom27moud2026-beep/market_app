import 'package:flutter/material.dart';

/// Centralized shadow constants.
///
/// Shadow colors use opacity-based black which works on both
/// light and dark surfaces, so these values are theme-invariant.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> cardElevated = [
    BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> banner = [
    BoxShadow(color: Color(0x3D000000), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> productCard = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(0, -2)),
  ];
}
