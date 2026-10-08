import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Extensions on [BuildContext] for common operations.
extension ContextExtensions on BuildContext {
  /// MediaQuery shortcut
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen size
  Size get screenSize => mediaQuery.size;

  /// Screen width
  double get screenWidth => screenSize.width;

  /// Screen height
  double get screenHeight => screenSize.height;

  /// Whether the device is a tablet (width >= 600)
  bool get isTablet => screenWidth >= 600;

  /// Whether the device is a desktop (width >= 1024)
  bool get isDesktop => screenWidth >= 1024;

  /// Theme
  ThemeData get theme => Theme.of(this);

  /// TextTheme
  TextTheme get textTheme => theme.textTheme;

  /// ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Theme-aware color palette with fallback to light palette when no extension is configured.
  AppColors get colors => theme.extension<AppColors>() ?? AppColors.light;

  /// Navigator
  NavigatorState get navigator => Navigator.of(this);

  /// Default text direction
  TextDirection get textDirection => Directionality.of(this);

  /// Whether text direction is RTL
  bool get isRtl => textDirection == TextDirection.rtl;

  /// MediaQuery padding
  EdgeInsets get padding => mediaQuery.padding;

  /// MediaQuery viewInsets
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Shortcut to pop the current route using Navigator
  void popNavigator([Object? result]) => navigator.pop(result);
}
