import 'package:flutter/material.dart';

/// Master Palette of all static constant colors used across the entire application.
///
/// All color definitions, hex values, and brand color tokens are centralized here
/// in one single file.
abstract final class AppPalette {
  // ── Primary Brand (Navy) ──────────────────────────────────────────────────
  static const Color brandNavy = Color(0xFF1B4270);
  static const Color primaryDark = Color(0xFF0D2B4E);
  static const Color primary = Color(0xFF123D73);
  static const Color primaryLight = Color(0xFF1F4E87);
  static const Color primaryLightest = Color(0xFF2A6CB8);
  static const Color navyDeep = Color(0xFF081628);
  static const Color navyContainer = Color(0xFF173D69);
  static const Color navySoft = Color(0xFF183B64);
  static const Color flashSaleBlue = Color(0xFF0A1E36);

  // ── Accent Brand (Orange) ─────────────────────────────────────────────────
  /// Vibrant brand orange matching active bottom navigation and key actions.
  static const Color brandOrange = Color(0xFFEF8226);
  static const Color accentOrange = Color(0xFFFF8C42);
  static const Color accentOrangeLight = Color(0xFFFFA366);
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color orangeDeep = Color(0xFFFF6D00);
  static const Color orangeLightBg = Color(0xFFFFF7ED);
  static const Color softOrangeGlow = Color(0x33EF8226);

  // ── Success & Green ───────────────────────────────────────────────────────
  static const Color green = Color(0xFF4CAF50);
  static const Color greenSuccess = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF059669);
  static const Color greenEmerald = Color(0xFF2E7D32);
  static const Color greenLightBg = Color(0xFFECFDF5);

  // ── Danger, Red & Badges ──────────────────────────────────────────────────
  static const Color red = Color(0xFFE53935);
  static const Color redError = Color(0xFFEF4444);
  static const Color redDark = Color(0xFFDC2626);
  static const Color redSoft = Color(0xFFFF5B5B);
  static const Color discountRed = Color(0xFFE53935);
  static const Color badgeRed = Color(0xFFE53935);
  static const Color heartRed = Color(0xFFE53935);

  // ── Gold, Amber & Ratings ─────────────────────────────────────────────────
  static const Color gold = Color(0xFFFFB800);
  static const Color primaryGold = Color(0xFFC59B27);
  static const Color borderGold = Color(0xFFD4AF37);
  static const Color goldBronze = Color(0xFFC89528);
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color ratingYellow = Color(0xFFFFC107);
  static const Color ratingAmber = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFD97706);
  static const Color amberDeep = Color(0xFF92400E);
  static const Color amberLightBg = Color(0xFFFEF3C7);
  static const Color amberMuted = Color(0xFFFDE68A);

  // ── Info & Sky Blue ───────────────────────────────────────────────────────
  static const Color blue = Color(0xFF2563EB);
  static const Color blueSky = Color(0xFF0284C7);
  static const Color blueLightBg = Color(0xFFEFF6FF);
  static const Color blueMuted = Color(0xFF8FA7C6);
  static const Color blueLight = Color(0xFFA5C1E5);
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFF2DD4BF);

  // ── Neutral White & Opacities ─────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white38 = Color(0x61FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white06 = Color(0x0FFFFFFF);

  // ── Neutral Black & Opacities ─────────────────────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color black87 = Color(0xDD000000);
  static const Color black54 = Color(0x8A000000);
  static const Color black38 = Color(0x61000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x1F000000);

  // ── Greys (Material Standard) ─────────────────────────────────────────────
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  static const Color inactiveGrey = Color(0xFF8E8E93);
  static const Color ratingGrey = Color(0xFFBDBDBD);
  static const Color heartGrey = Color(0xFFBDBDBD);

  // ── Slates & Modern Cool Greys ────────────────────────────────────────────
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // ── Dark Theme Surfaces ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceSecondary = Color(0xFF252525);
  static const Color darkCard = Color(0xFF1E2838);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkBorderLight = Color(0xFF2A2A2A);

  // ── Shadows ───────────────────────────────────────────────────────────────
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x29000000);
  static const Color shadowDark = Color(0x3D000000);
}

/// Theme-aware color palette using [ThemeExtension].
///
/// Access dynamically via `context.colors` or statically via [AppPalette] / [AppColors].
class AppColors extends ThemeExtension<AppColors> {
  // ── Static Shortcuts to Master Palette ────────────────────────────────────
  static const Color brandNavy = AppPalette.brandNavy;
  static const Color brandOrange = AppPalette.brandOrange;
  static const Color green = AppPalette.green;
  static const Color greenSuccess = AppPalette.greenSuccess;
  static const Color red = AppPalette.red;
  static const Color redError = AppPalette.redError;
  static const Color gold = AppPalette.gold;
  static const Color blue = AppPalette.blue;
  static const Color blueSky = AppPalette.blueSky;
  static const Color teal = AppPalette.teal;
  static const Color tealLight = AppPalette.tealLight;
  static const Color white = AppPalette.white;
  static const Color white80 = AppPalette.white80;
  static const Color white60 = AppPalette.white60;
  static const Color black = AppPalette.black;
  static const Color black87 = AppPalette.black87;
  static const Color black54 = AppPalette.black54;
  static const Color inactiveGrey = AppPalette.inactiveGrey;
  static const Color darkBackground = AppPalette.darkBackground;
  static const Color darkSurface = AppPalette.darkSurface;
  static const Color darkCard = AppPalette.darkCard;
  static const Color darkBorder = AppPalette.darkBorder;
  static const Color slate400 = AppPalette.slate400;
  static const Color slate500 = AppPalette.slate500;
  static const Color slate600 = AppPalette.slate600;

  // ── Dynamic Backgrounds & Surfaces ────────────────────────────────────────
  final Color background;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color surface;
  final Color cardBackground;

  // ── Dynamic Primary Brand Palette ─────────────────────────────────────────
  final Color primaryDark;
  final Color primary;
  final Color primaryLight;
  final Color primaryLightest;

  // ── Dynamic Brand Containers ──────────────────────────────────────────────
  final Color darkBlueContainer;
  final Color flashSaleBlue;

  // ── Dynamic Text Colors ───────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textQuaternary;
  final Color textOnPrimary;
  final Color textOnPrimary80;
  final Color textOnPrimary60;

  // ── Dynamic Accent & Actions ──────────────────────────────────────────────
  final Color accentOrange;
  final Color accentOrangeLight;
  final Color accentGreen;
  final Color accentRed;

  // ── Dynamic Discounts & Badges ────────────────────────────────────────────
  final Color discountRed;
  final Color discountOrange;

  // ── Dynamic Borders & Dividers ────────────────────────────────────────────
  final Color border;
  final Color borderLight;
  final Color divider;

  // ── Dynamic Gold & Loyalty ────────────────────────────────────────────────
  final Color primaryGold;
  final Color borderGold;
  final Color ratingGold;

  // ── Dynamic Shadows ───────────────────────────────────────────────────────
  final Color shadowLight;
  final Color shadowMedium;
  final Color shadowDark;

  // ── Dynamic Ratings & Favorites ───────────────────────────────────────────
  final Color ratingYellow;
  final Color ratingGrey;
  final Color heartRed;
  final Color heartGrey;

  // ── Dynamic Chips ─────────────────────────────────────────────────────────
  final Color chipSelectedBackground;
  final Color chipUnselectedBackground;

  // ── Dynamic Gradients ─────────────────────────────────────────────────────
  final Color gradientTop;
  final Color gradientMiddle;
  final Color gradientBottom;

  // ── Specialized Accents ───────────────────────────────────────────────────
  final Color softOrangeGlow;
  final Color gridLine;
  final Color logoBackground;
  final Color logoShadow;

  // ── Dynamic App Bar ───────────────────────────────────────────────────────
  final Color appBar;
  final Color appBarIcon;
  final Color badgeRed;

  const AppColors._({
    required this.background,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.surface,
    required this.cardBackground,
    required this.primaryDark,
    required this.primary,
    required this.primaryLight,
    required this.primaryLightest,
    required this.darkBlueContainer,
    required this.flashSaleBlue,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textQuaternary,
    required this.textOnPrimary,
    required this.textOnPrimary80,
    required this.textOnPrimary60,
    required this.accentOrange,
    required this.accentOrangeLight,
    required this.accentGreen,
    required this.accentRed,
    required this.discountRed,
    required this.discountOrange,
    required this.border,
    required this.borderLight,
    required this.divider,
    required this.primaryGold,
    required this.borderGold,
    required this.ratingGold,
    required this.shadowLight,
    required this.shadowMedium,
    required this.shadowDark,
    required this.ratingYellow,
    required this.ratingGrey,
    required this.heartRed,
    required this.heartGrey,
    required this.chipSelectedBackground,
    required this.chipUnselectedBackground,
    required this.gradientTop,
    required this.gradientMiddle,
    required this.gradientBottom,
    required this.softOrangeGlow,
    required this.gridLine,
    required this.logoBackground,
    required this.logoShadow,
    required this.appBar,
    required this.appBarIcon,
    required this.badgeRed,
  });

  // ── Light Theme Palette ───────────────────────────────────────────────────
  static const AppColors light = AppColors._(
    background: AppPalette.white,
    backgroundSecondary: AppPalette.grey100,
    backgroundTertiary: AppPalette.grey50,
    surface: AppPalette.white,
    cardBackground: AppPalette.white,
    primaryDark: AppPalette.primaryDark,
    primary: AppPalette.primary,
    primaryLight: AppPalette.primaryLight,
    primaryLightest: AppPalette.primaryLightest,
    darkBlueContainer: AppPalette.primaryDark,
    flashSaleBlue: AppPalette.flashSaleBlue,
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF333333),
    textTertiary: Color(0xFF666666),
    textQuaternary: Color(0xFF999999),
    textOnPrimary: AppPalette.white,
    textOnPrimary80: AppPalette.white80,
    textOnPrimary60: AppPalette.white60,
    accentOrange: AppPalette.accentOrange,
    accentOrangeLight: AppPalette.accentOrangeLight,
    accentGreen: AppPalette.green,
    accentRed: AppPalette.red,
    discountRed: AppPalette.discountRed,
    discountOrange: AppPalette.orangeDeep,
    border: AppPalette.grey300,
    borderLight: AppPalette.grey200,
    divider: AppPalette.grey200,
    primaryGold: AppPalette.primaryGold,
    borderGold: AppPalette.borderGold,
    ratingGold: AppPalette.ratingGold,
    shadowLight: AppPalette.shadowLight,
    shadowMedium: AppPalette.shadowMedium,
    shadowDark: AppPalette.shadowDark,
    ratingYellow: AppPalette.ratingYellow,
    ratingGrey: AppPalette.ratingGrey,
    heartRed: AppPalette.heartRed,
    heartGrey: AppPalette.heartGrey,
    chipSelectedBackground: AppPalette.primaryDark,
    chipUnselectedBackground: AppPalette.white,
    gradientTop: AppPalette.primary,
    gradientMiddle: AppPalette.primaryLight,
    gradientBottom: Color(0xFF143A6A),
    softOrangeGlow: AppPalette.softOrangeGlow,
    gridLine: AppPalette.white06,
    logoBackground: AppPalette.white,
    logoShadow: AppPalette.shadowMedium,
    appBar: AppPalette.white,
    appBarIcon: Color(0xFF333333),
    badgeRed: AppPalette.badgeRed,
  );

  // ── Dark Theme Palette ────────────────────────────────────────────────────
  static const AppColors dark = AppColors._(
    background: AppPalette.darkBackground,
    backgroundSecondary: AppPalette.darkSurface,
    backgroundTertiary: AppPalette.darkSurfaceSecondary,
    surface: AppPalette.darkSurface,
    cardBackground: AppPalette.darkCard,
    primaryDark: AppPalette.primaryDark,
    primary: AppPalette.primary,
    primaryLight: AppPalette.primaryLight,
    primaryLightest: AppPalette.primaryLightest,
    darkBlueContainer: AppPalette.primaryDark,
    flashSaleBlue: AppPalette.flashSaleBlue,
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFD0D0D0),
    textTertiary: Color(0xFFA0A0A0),
    textQuaternary: Color(0xFF757575),
    textOnPrimary: AppPalette.white,
    textOnPrimary80: AppPalette.white80,
    textOnPrimary60: AppPalette.white60,
    accentOrange: AppPalette.accentOrange,
    accentOrangeLight: AppPalette.accentOrangeLight,
    accentGreen: AppPalette.green,
    accentRed: AppPalette.red,
    discountRed: AppPalette.discountRed,
    discountOrange: AppPalette.orangeDeep,
    border: AppPalette.darkBorder,
    borderLight: AppPalette.darkBorderLight,
    divider: AppPalette.darkBorderLight,
    primaryGold: AppPalette.primaryGold,
    borderGold: AppPalette.borderGold,
    ratingGold: AppPalette.ratingGold,
    shadowLight: AppPalette.shadowLight,
    shadowMedium: Color(0x1F000000),
    shadowDark: AppPalette.shadowMedium,
    ratingYellow: AppPalette.ratingYellow,
    ratingGrey: AppPalette.ratingGrey,
    heartRed: AppPalette.heartRed,
    heartGrey: AppPalette.heartGrey,
    chipSelectedBackground: AppPalette.primaryLight,
    chipUnselectedBackground: AppPalette.darkBorderLight,
    gradientTop: AppPalette.primary,
    gradientMiddle: AppPalette.primaryLight,
    gradientBottom: Color(0xFF143A6A),
    softOrangeGlow: AppPalette.softOrangeGlow,
    gridLine: AppPalette.white06,
    logoBackground: AppPalette.darkSurface,
    logoShadow: AppPalette.shadowLight,
    appBar: AppPalette.darkSurface,
    appBarIcon: Color(0xFFE0E0E0),
    badgeRed: AppPalette.badgeRed,
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? surface,
    Color? cardBackground,
    Color? primaryDark,
    Color? primary,
    Color? primaryLight,
    Color? primaryLightest,
    Color? darkBlueContainer,
    Color? flashSaleBlue,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textQuaternary,
    Color? textOnPrimary,
    Color? textOnPrimary80,
    Color? textOnPrimary60,
    Color? accentOrange,
    Color? accentOrangeLight,
    Color? accentGreen,
    Color? accentRed,
    Color? discountRed,
    Color? discountOrange,
    Color? border,
    Color? borderLight,
    Color? divider,
    Color? primaryGold,
    Color? borderGold,
    Color? ratingGold,
    Color? shadowLight,
    Color? shadowMedium,
    Color? shadowDark,
    Color? ratingYellow,
    Color? ratingGrey,
    Color? heartRed,
    Color? heartGrey,
    Color? chipSelectedBackground,
    Color? chipUnselectedBackground,
    Color? gradientTop,
    Color? gradientMiddle,
    Color? gradientBottom,
    Color? softOrangeGlow,
    Color? gridLine,
    Color? logoBackground,
    Color? logoShadow,
    Color? appBar,
    Color? appBarIcon,
    Color? badgeRed,
  }) {
    return AppColors._(
      background: background ?? this.background,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      primaryDark: primaryDark ?? this.primaryDark,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryLightest: primaryLightest ?? this.primaryLightest,
      darkBlueContainer: darkBlueContainer ?? this.darkBlueContainer,
      flashSaleBlue: flashSaleBlue ?? this.flashSaleBlue,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textQuaternary: textQuaternary ?? this.textQuaternary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnPrimary80: textOnPrimary80 ?? this.textOnPrimary80,
      textOnPrimary60: textOnPrimary60 ?? this.textOnPrimary60,
      accentOrange: accentOrange ?? this.accentOrange,
      accentOrangeLight: accentOrangeLight ?? this.accentOrangeLight,
      accentGreen: accentGreen ?? this.accentGreen,
      accentRed: accentRed ?? this.accentRed,
      discountRed: discountRed ?? this.discountRed,
      discountOrange: discountOrange ?? this.discountOrange,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      divider: divider ?? this.divider,
      primaryGold: primaryGold ?? this.primaryGold,
      borderGold: borderGold ?? this.borderGold,
      ratingGold: ratingGold ?? this.ratingGold,
      shadowLight: shadowLight ?? this.shadowLight,
      shadowMedium: shadowMedium ?? this.shadowMedium,
      shadowDark: shadowDark ?? this.shadowDark,
      ratingYellow: ratingYellow ?? this.ratingYellow,
      ratingGrey: ratingGrey ?? this.ratingGrey,
      heartRed: heartRed ?? this.heartRed,
      heartGrey: heartGrey ?? this.heartGrey,
      chipSelectedBackground:
          chipSelectedBackground ?? this.chipSelectedBackground,
      chipUnselectedBackground:
          chipUnselectedBackground ?? this.chipUnselectedBackground,
      gradientTop: gradientTop ?? this.gradientTop,
      gradientMiddle: gradientMiddle ?? this.gradientMiddle,
      gradientBottom: gradientBottom ?? this.gradientBottom,
      softOrangeGlow: softOrangeGlow ?? this.softOrangeGlow,
      gridLine: gridLine ?? this.gridLine,
      logoBackground: logoBackground ?? this.logoBackground,
      logoShadow: logoShadow ?? this.logoShadow,
      appBar: appBar ?? this.appBar,
      appBarIcon: appBarIcon ?? this.appBarIcon,
      badgeRed: badgeRed ?? this.badgeRed,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors._(
      background: Color.lerp(background, other.background, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundTertiary:
          Color.lerp(backgroundTertiary, other.backgroundTertiary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryLightest:
          Color.lerp(primaryLightest, other.primaryLightest, t)!,
      darkBlueContainer:
          Color.lerp(darkBlueContainer, other.darkBlueContainer, t)!,
      flashSaleBlue: Color.lerp(flashSaleBlue, other.flashSaleBlue, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textQuaternary:
          Color.lerp(textQuaternary, other.textQuaternary, t)!,
      textOnPrimary:
          Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnPrimary80:
          Color.lerp(textOnPrimary80, other.textOnPrimary80, t)!,
      textOnPrimary60:
          Color.lerp(textOnPrimary60, other.textOnPrimary60, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentOrangeLight: Color.lerp(
          accentOrangeLight, other.accentOrangeLight, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      discountRed: Color.lerp(discountRed, other.discountRed, t)!,
      discountOrange:
          Color.lerp(discountOrange, other.discountOrange, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryGold: Color.lerp(primaryGold, other.primaryGold, t)!,
      borderGold: Color.lerp(borderGold, other.borderGold, t)!,
      ratingGold: Color.lerp(ratingGold, other.ratingGold, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      shadowMedium: Color.lerp(shadowMedium, other.shadowMedium, t)!,
      shadowDark: Color.lerp(shadowDark, other.shadowDark, t)!,
      ratingYellow: Color.lerp(ratingYellow, other.ratingYellow, t)!,
      ratingGrey: Color.lerp(ratingGrey, other.ratingGrey, t)!,
      heartRed: Color.lerp(heartRed, other.heartRed, t)!,
      heartGrey: Color.lerp(heartGrey, other.heartGrey, t)!,
      chipSelectedBackground: Color.lerp(
          chipSelectedBackground, other.chipSelectedBackground, t)!,
      chipUnselectedBackground: Color.lerp(
          chipUnselectedBackground, other.chipUnselectedBackground, t)!,
      gradientTop: Color.lerp(gradientTop, other.gradientTop, t)!,
      gradientMiddle:
          Color.lerp(gradientMiddle, other.gradientMiddle, t)!,
      gradientBottom:
          Color.lerp(gradientBottom, other.gradientBottom, t)!,
      softOrangeGlow:
          Color.lerp(softOrangeGlow, other.softOrangeGlow, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      logoBackground:
          Color.lerp(logoBackground, other.logoBackground, t)!,
      logoShadow: Color.lerp(logoShadow, other.logoShadow, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      appBarIcon: Color.lerp(appBarIcon, other.appBarIcon, t)!,
      badgeRed: Color.lerp(badgeRed, other.badgeRed, t)!,
    );
  }
}
