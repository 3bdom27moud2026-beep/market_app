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

  // -- Splash Screen (always on brand gradient — keep white) --
  static TextStyle get splashTitle => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get splashSubtitle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xCCFFFFFF),
  );

  // -- Headings (no hardcoded color — use context.colors) --
  static TextStyle get headingLarge =>
      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold);
  static TextStyle get headingMedium =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get headingSmall =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);

  // -- Section Headers --
  static TextStyle get sectionTitle =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get sectionViewAll =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);

  // -- Body --
  static TextStyle get bodyLarge =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal);
  static TextStyle get bodyMedium =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);
  static TextStyle get bodySmall =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal);

  // -- White text variants (always on dark/brand backgrounds) --
  static TextStyle get whiteHeading => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get whiteBody => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xCCFFFFFF),
  );
  static TextStyle get whiteSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Color(0x99FFFFFF),
  );

  // -- Price --
  static TextStyle get price =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle get oldPrice => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle get discountBadge => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  // -- Timer (always on dark banner) --
  static TextStyle get timerNumber => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get timerLabel => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: Color(0x99FFFFFF),
  );

  // -- App Bar --
  static TextStyle get appBarTitle =>
      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold);

  // -- Buttons (always on primary/orange backgrounds) --
  static TextStyle get buttonOrange => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get buttonSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );

  // -- Search --
  static TextStyle get searchHint =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);
  static TextStyle get searchText =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);

  // -- Filter Chip (selected always on dark chip background) --
  static TextStyle get chipSelected => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle get chipUnselected =>
      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500);

  // -- Location Banner --
  static TextStyle get locationTitle =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle get locationText =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold);

  // -- Partner / Store --
  static TextStyle get storeName =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600);
  static TextStyle get ratingSmall =>
      TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500);
}
