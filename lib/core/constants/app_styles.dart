import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Centralized Typography and Text Styles for the application.
///
/// Use [AppStyles] (or [AppTextStyles]) across the entire application to maintain
/// consistent typography, font weights, and text styling adhering to the design system.
///
/// Rules:
/// - Styles that are used on themed surfaces (backgrounds that change per
///   light/dark mode) do NOT hardcode a color — widgets should apply
///   `color: context.colors.textPrimary` etc. as needed.
/// - Styles that are always placed on brand-colored surfaces (splash,
///   flash-sale banners, discount badges, primary buttons) use [AppColors]
///   centralized constants.
abstract final class AppStyles {
  // ── Font Family ──────────────────────────────────────────────────────────
  /// Main application font family.
  static const String fontFamily = 'Alexandria';

  /// Fallback font family stack.
  static const List<String> fontFamilyFallback = ['sans-serif'];

  // ── Font Weights ─────────────────────────────────────────────────────────
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ── Universal Style Builder ──────────────────────────────────────────────
  /// Helper builder ensuring every text style automatically includes
  /// Alexandria and sans-serif fallback.
  static TextStyle style({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ── Splash & Display Styles ──────────────────────────────────────────────
  static TextStyle get splashTitle => style(
        fontSize: 28.sp,
        fontWeight: extraBold,
        color: AppColors.white,
        letterSpacing: 0.2,
      );

  static TextStyle get splashSubtitle => style(
        fontSize: 15.sp,
        fontWeight: medium,
        color: const Color(0xCCE2EAF2),
        letterSpacing: 0.2,
      );

  static TextStyle get displayLarge =>
      style(fontSize: 30.sp, fontWeight: bold);

  static TextStyle get displayMedium =>
      style(fontSize: 26.sp, fontWeight: bold);

  // ── Headings & Titles ────────────────────────────────────────────────────
  static TextStyle get headingLarge =>
      style(fontSize: 22.sp, fontWeight: bold);

  static TextStyle get headingMedium =>
      style(fontSize: 18.sp, fontWeight: bold);

  static TextStyle get headingSmall =>
      style(fontSize: 16.sp, fontWeight: semiBold);

  static TextStyle get titleLarge =>
      style(fontSize: 20.sp, fontWeight: bold);

  static TextStyle get titleMedium =>
      style(fontSize: 16.sp, fontWeight: bold);

  static TextStyle get titleSmall =>
      style(fontSize: 14.sp, fontWeight: semiBold);

  static TextStyle get sectionTitle =>
      style(fontSize: 18.sp, fontWeight: bold);

  static TextStyle get sectionViewAll =>
      style(fontSize: 14.sp, fontWeight: medium);

  static TextStyle get cardTitle =>
      style(fontSize: 14.sp, fontWeight: bold);

  static TextStyle get dialogTitle =>
      style(fontSize: 16.sp, fontWeight: bold);

  static TextStyle get appBarTitle =>
      style(fontSize: 20.sp, fontWeight: bold);

  static TextStyle get appBarTitleWhite => style(
        fontSize: 18.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  // ── Body Styles ──────────────────────────────────────────────────────────
  static TextStyle get bodyLarge =>
      style(fontSize: 16.sp, fontWeight: regular);

  static TextStyle get bodyLargeBold =>
      style(fontSize: 16.sp, fontWeight: bold);

  static TextStyle get bodyMedium =>
      style(fontSize: 14.sp, fontWeight: regular);

  static TextStyle get bodyMediumBold =>
      style(fontSize: 14.sp, fontWeight: bold);

  static TextStyle get bodySmall =>
      style(fontSize: 12.sp, fontWeight: regular);

  static TextStyle get bodySmallBold =>
      style(fontSize: 12.sp, fontWeight: semiBold);

  static TextStyle get caption =>
      style(fontSize: 10.sp, fontWeight: regular);

  static TextStyle get captionBold =>
      style(fontSize: 10.sp, fontWeight: semiBold);

  // ── White Text Variants (Always on dark/brand surfaces) ──────────────────
  static TextStyle get whiteDisplay => style(
        fontSize: 26.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get whiteHeading => style(
        fontSize: 22.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get whiteHeadingMedium => style(
        fontSize: 16.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get whiteBodyLarge => style(
        fontSize: 16.sp,
        fontWeight: regular,
        color: AppColors.white,
      );

  static TextStyle get whiteBody => style(
        fontSize: 14.sp,
        fontWeight: regular,
        color: AppColors.white80,
      );

  static TextStyle get whiteBodyBold => style(
        fontSize: 14.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get whiteSmall => style(
        fontSize: 13.sp,
        fontWeight: regular,
        color: AppColors.white,
      );

  static TextStyle get whiteCaption => style(
        fontSize: 10.sp,
        fontWeight: regular,
        color: AppColors.white60,
      );

  // ── Pricing & Discount Styles ────────────────────────────────────────────
  static TextStyle get price =>
      style(fontSize: 18.sp, fontWeight: bold);

  static TextStyle get priceLarge =>
      style(fontSize: 20.sp, fontWeight: bold);

  static TextStyle get priceSmall =>
      style(fontSize: 13.sp, fontWeight: bold);

  static TextStyle get oldPrice => style(
        fontSize: 14.sp,
        fontWeight: regular,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle get oldPriceSmall => style(
        fontSize: 11.sp,
        fontWeight: regular,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle get discountBadge => style(
        fontSize: 11.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get discountBadgeLarge => style(
        fontSize: 12.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get savingsText => style(
        fontSize: 13.sp,
        fontWeight: bold,
        color: AppColors.green,
      );

  // ── Button Styles ────────────────────────────────────────────────────────
  static TextStyle get buttonOrange => style(
        fontSize: 14.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get buttonLarge => style(
        fontSize: 16.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get buttonMedium => style(
        fontSize: 14.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get buttonSmall => style(
        fontSize: 12.sp,
        fontWeight: semiBold,
        color: AppColors.white,
      );

  static TextStyle get textButton =>
      style(fontSize: 14.sp, fontWeight: bold);

  static TextStyle get textButtonOrange => style(
        fontSize: 13.sp,
        fontWeight: bold,
        color: AppColors.brandOrange,
      );

  // ── Form Input Styles ────────────────────────────────────────────────────
  static TextStyle get inputLabel =>
      style(fontSize: 13.sp, fontWeight: medium);

  static TextStyle get inputText =>
      style(fontSize: 14.sp, fontWeight: regular);

  static TextStyle get inputHint =>
      style(fontSize: 13.sp, fontWeight: regular);

  static TextStyle get inputError => style(
        fontSize: 11.sp,
        fontWeight: regular,
        color: AppColors.red,
      );

  static TextStyle get searchHint =>
      style(fontSize: 14.sp, fontWeight: regular);

  static TextStyle get searchText =>
      style(fontSize: 14.sp, fontWeight: regular);

  // ── Chips, Tabs & Navigation ─────────────────────────────────────────────
  static TextStyle get chipSelected => style(
        fontSize: 13.sp,
        fontWeight: semiBold,
        color: AppColors.white,
      );

  static TextStyle get chipUnselected =>
      style(fontSize: 13.sp, fontWeight: medium);

  static TextStyle get tabSelected => style(
        fontSize: 13.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get tabUnselected =>
      style(fontSize: 13.sp, fontWeight: regular);

  static TextStyle get navLabel =>
      style(fontSize: 10.sp, fontWeight: regular);

  static TextStyle get navLabelActive => style(
        fontSize: 10.sp,
        fontWeight: bold,
        color: AppColors.brandOrange,
      );

  // ── Timer & Banners ──────────────────────────────────────────────────────
  static TextStyle get timerNumber => style(
        fontSize: 20.sp,
        fontWeight: bold,
        color: AppColors.white,
      );

  static TextStyle get timerLabel => style(
        fontSize: 10.sp,
        fontWeight: medium,
        color: AppColors.white60,
      );

  static TextStyle get locationTitle => style(
        fontSize: 12.sp,
        fontWeight: regular,
        color: AppColors.slate400,
      );

  static TextStyle get locationText =>
      style(fontSize: 14.sp, fontWeight: bold);

  // ── Partner & Store ──────────────────────────────────────────────────────
  static TextStyle get storeName =>
      style(fontSize: 12.sp, fontWeight: semiBold);

  static TextStyle get ratingSmall =>
      style(fontSize: 11.sp, fontWeight: medium);

  // ── Discount Card Specific Styles ────────────────────────────────────────
  static TextStyle get cardNumber => style(
        fontSize: 15.sp,
        fontWeight: bold,
        letterSpacing: 1.5,
        color: AppColors.white,
      );

  static TextStyle get cardHolderName => style(
        fontSize: 13.sp,
        fontWeight: semiBold,
        color: AppColors.white,
      );

  static TextStyle get cardExpiry => style(
        fontSize: 11.sp,
        fontWeight: regular,
        color: AppColors.white80,
      );
}

/// Backward compatibility alias so existing usages of [AppTextStyles]
/// work completely seamlessly across the application.
typedef AppTextStyles = AppStyles;
