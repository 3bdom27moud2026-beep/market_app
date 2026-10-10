import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized text style constants.
///
/// Styles that are used on themed surfaces (backgrounds that change per
/// light/dark mode) do NOT include a `color` — widgets should apply
/// `context.colors.textPrimary` etc. as needed.
///
/// Styles that are always placed on brand-colored surfaces (splash,
/// flash-sale banners, discount badges, primary buttons) keep their
/// hard-coded white/brand color since those surfaces don't change.
abstract final class AppTextStyles {
  /// Default font family for the application.
  static const String fontFamily = 'Alexandria';

  /// Fallback font family stack.
  static const List<String> fontFamilyFallback = ['sans-serif'];

  /// Helper builder ensuring every text style includes Alexandria and sans-serif fallback.
  static TextStyle _style({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
    double? letterSpacing,
    double? height,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    decoration: decoration,
    letterSpacing: letterSpacing,
    height: height,
  );

  // -- Splash Screen (always on brand gradient — keep white) --
  static TextStyle get splashTitle => _style(
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
  );
  static TextStyle get splashSubtitle => _style(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xCCFFFFFF),
  );

  // -- Headings (no hardcoded color — use context.colors) --
  static TextStyle get headingLarge =>
      _style(fontSize: 22.sp, fontWeight: FontWeight.bold);
  static TextStyle get headingMedium =>
      _style(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get headingSmall =>
      _style(fontSize: 16.sp, fontWeight: FontWeight.w600);

  // -- Section Headers --
  static TextStyle get sectionTitle =>
      _style(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get sectionViewAll =>
      _style(fontSize: 14.sp, fontWeight: FontWeight.w500);

  // -- Body --
  static TextStyle get bodyLarge =>
      _style(fontSize: 16.sp, fontWeight: FontWeight.normal);
  static TextStyle get bodyMedium =>
      _style(fontSize: 14.sp, fontWeight: FontWeight.normal);
  static TextStyle get bodySmall =>
      _style(fontSize: 12.sp, fontWeight: FontWeight.normal);

  // -- White text variants (always on dark/brand backgrounds) --
  static TextStyle get whiteHeading => _style(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
  );
  static TextStyle get whiteBody => _style(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xCCFFFFFF),
  );
  static TextStyle get whiteSmall => _style(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0x99FFFFFF),
  );

  // -- Price --
  static TextStyle get price =>
      _style(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get oldPrice => _style(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle get discountBadge => _style(
    fontSize: 11.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
  );

  // -- Timer (always on dark banner) --
  static TextStyle get timerNumber => _style(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
  );
  static TextStyle get timerLabel => _style(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0x99FFFFFF),
  );

  // -- App Bar --
  static TextStyle get appBarTitle =>
      _style(fontSize: 20.sp, fontWeight: FontWeight.bold);

  // -- Buttons (always on primary/orange backgrounds) --
  static TextStyle get buttonOrange => _style(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
  );
  static TextStyle get buttonSmall => _style(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFFFFFFF),
  );

  // -- Search --
  static TextStyle get searchHint =>
      _style(fontSize: 14.sp, fontWeight: FontWeight.normal);
  static TextStyle get searchText =>
      _style(fontSize: 14.sp, fontWeight: FontWeight.normal);

  // -- Filter Chip (selected always on dark chip background) --
  static TextStyle get chipSelected => _style(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFFFFFFF),
  );
  static TextStyle get chipUnselected =>
      _style(fontSize: 13.sp, fontWeight: FontWeight.w500);

  // -- Location Banner --
  static TextStyle get locationTitle =>
      _style(fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle get locationText =>
      _style(fontSize: 14.sp, fontWeight: FontWeight.bold);

  // -- Partner / Store --
  static TextStyle get storeName =>
      _style(fontSize: 12.sp, fontWeight: FontWeight.w600);
  static TextStyle get ratingSmall =>
      _style(fontSize: 11.sp, fontWeight: FontWeight.w500);
}
