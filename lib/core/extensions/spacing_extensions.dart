import 'package:flutter/material.dart';

/// Extensions on [num] for quick padding and sizing.
extension SpacingExtensions on num {
  /// Creates a horizontal gap using SizedBox with the given width.
  Widget get horizontalSpace => SizedBox(width: toDouble());

  /// Creates a vertical gap using SizedBox with the given height.
  Widget get verticalSpace => SizedBox(height: toDouble());

  /// Creates padding on all sides.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Creates horizontal padding.
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Creates vertical padding.
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Creates edge insets with only left padding.
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  /// Creates edge insets with only right padding.
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());

  /// Creates edge insets with only top padding.
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  /// Creates edge insets with only bottom padding.
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());
}
