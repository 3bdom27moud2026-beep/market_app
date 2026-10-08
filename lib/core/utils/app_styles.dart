import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Typography and Text Styles for the application.
///
/// Use [AppStyles] across the app to maintain consistent typography,
/// font weights, and text styling adhering to the design system.
///
/// Styles on themed surfaces (backgrounds that change per light/dark mode)
/// do NOT include a `color` — widgets should apply `context.colors.textPrimary`
/// etc. as needed.
///
/// Styles always placed on brand-colored surfaces (splash, flash-sale banners,
/// discount badges, primary buttons, cards) keep their hard-coded white color
/// since those surfaces don't change.
abstract final class AppStyles {
  // ── Font Family ──────────────────────────────────────────────────────────
  /// Main application font family.
  static const String fontFamily = 'Alexandria';

  // ── Font Weights ─────────────────────────────────────────────────────────
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ── Display & Splash Styles (always on brand gradient — keep white) ─────
  static TextStyle get splashTitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 34.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get splashSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: medium,
    color: Color(0xCCFFFFFF),
  );

  static TextStyle get displayLarge =>
      TextStyle(fontFamily: fontFamily, fontSize: 30.sp, fontWeight: bold);

  static TextStyle get displayMedium =>
      TextStyle(fontFamily: fontFamily, fontSize: 26.sp, fontWeight: bold);

  // ── Headings & Titles ────────────────────────────────────────────────────
  static TextStyle get headingLarge =>
      TextStyle(fontFamily: fontFamily, fontSize: 20.sp, fontWeight: bold);

  static TextStyle get headingMedium =>
      TextStyle(fontFamily: fontFamily, fontSize: 16.sp, fontWeight: bold);

  static TextStyle get headingSmall =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, fontWeight: semiBold);

  static TextStyle get appBarTitle =>
      TextStyle(fontFamily: fontFamily, fontSize: 18.sp, fontWeight: bold);

  static TextStyle get appBarTitleWhite => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get sectionTitle =>
      TextStyle(fontFamily: fontFamily, fontSize: 16.sp, fontWeight: bold);

  static TextStyle get sectionViewAll =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: medium);

  static TextStyle get cardTitle =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, fontWeight: bold);

  static TextStyle get dialogTitle =>
      TextStyle(fontFamily: fontFamily, fontSize: 16.sp, fontWeight: bold);

  // ── Body Text Styles ─────────────────────────────────────────────────────
  static TextStyle get bodyLarge =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, fontWeight: regular);

  static TextStyle get bodyLargeBold =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, fontWeight: bold);

  static TextStyle get bodyMedium =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: regular);

  static TextStyle get bodyMediumBold =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: bold);

  static TextStyle get bodySmall =>
      TextStyle(fontFamily: fontFamily, fontSize: 10.sp, fontWeight: regular);

  static TextStyle get bodySmallBold =>
      TextStyle(fontFamily: fontFamily, fontSize: 10.sp, fontWeight: semiBold);

  static TextStyle get caption =>
      TextStyle(fontFamily: fontFamily, fontSize: 9.sp, fontWeight: regular);

  static TextStyle get captionBold =>
      TextStyle(fontFamily: fontFamily, fontSize: 9.sp, fontWeight: semiBold);

  // ── White Text Variants (For dark containers / banners) ──────────────────
  static TextStyle get whiteDisplay => TextStyle(
    fontFamily: fontFamily,
    fontSize: 26.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get whiteHeading => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get whiteHeadingMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get whiteBodyLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: regular,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get whiteBody => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: regular,
    color: Color(0xCCFFFFFF),
  );

  static TextStyle get whiteBodyBold => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get whiteSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: regular,
    color: Color(0x99FFFFFF),
  );

  static TextStyle get whiteCaption => TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: regular,
    color: Color(0x99FFFFFF),
  );

  // ── Pricing & Discount Styles ────────────────────────────────────────────
  static TextStyle get price =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, fontWeight: bold);

  static TextStyle get priceLarge =>
      TextStyle(fontFamily: fontFamily, fontSize: 18.sp, fontWeight: bold);

  static TextStyle get priceSmall =>
      TextStyle(fontFamily: fontFamily, fontSize: 11.sp, fontWeight: bold);

  static TextStyle get oldPrice => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: regular,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get oldPriceSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 8.sp,
    fontWeight: regular,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get discountBadge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get discountBadgeLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get savingsText => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: bold,
    color: Color(0xFF4CAF50),
  );

  // ── Button Styles (always on colored backgrounds — keep white) ──────────
  static TextStyle get buttonLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get buttonMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get buttonOrange => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get buttonSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: semiBold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get textButton =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: bold);

  static TextStyle get textButtonOrange => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: bold,
    color: Color(0xFFFF8C42),
  );

  // ── Form Input Styles ────────────────────────────────────────────────────
  static TextStyle get inputText =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: regular);

  static TextStyle get inputLabel =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: medium);

  static TextStyle get inputHint =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: regular);

  static TextStyle get inputError => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: regular,
    color: Color(0xFFE53935),
  );

  static TextStyle get searchHint =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: regular);

  static TextStyle get searchText =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: regular);

  // ── Chips, Tabs & Navigation ─────────────────────────────────────────────
  static TextStyle get chipSelected => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: semiBold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get chipUnselected =>
      TextStyle(fontFamily: fontFamily, fontSize: 11.sp, fontWeight: medium);

  static TextStyle get tabSelected => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get tabUnselected =>
      TextStyle(fontFamily: fontFamily, fontSize: 11.sp, fontWeight: regular);

  static TextStyle get navLabel =>
      TextStyle(fontFamily: fontFamily, fontSize: 9.sp, fontWeight: regular);

  static TextStyle get navLabelActive => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: bold,
    color: Color(0xFFFF8C42),
  );

  // ── Banners, Timer & Specialized Widgets ──────────────────────────────────
  static TextStyle get locationTitle =>
      TextStyle(fontFamily: fontFamily, fontSize: 10.sp, fontWeight: medium);

  static TextStyle get locationText =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: bold);

  static TextStyle get timerNumber => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get timerLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 8.sp,
    fontWeight: medium,
    color: Color(0x99FFFFFF),
  );

  static TextStyle get storeName =>
      TextStyle(fontFamily: fontFamily, fontSize: 10.sp, fontWeight: semiBold);

  static TextStyle get ratingSmall =>
      TextStyle(fontFamily: fontFamily, fontSize: 9.sp, fontWeight: medium);

  static TextStyle get cardNumber => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: bold,
    letterSpacing: 1.5,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get cardHolderName => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: semiBold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle get cardExpiry => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: regular,
    color: Color(0xCCFFFFFF),
  );
}
