import 'package:flutter/material.dart';

/// Theme-aware color palette using [ThemeExtension].
///
/// Access via `Theme.of(context).extension<AppColors>()!`
/// or the `context.colors` shortcut from [ContextExtensions].
class AppColors extends ThemeExtension<AppColors> {
  // ── Backgrounds ──────────────────────────────────────────────
  final Color background;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color surface;

  // ── Primary brand palette (theme-invariant) ──────────────────
  final Color primaryDark;
  final Color primary;
  final Color primaryLight;
  final Color primaryLightest;

  // ── Dark-blue containers (theme-invariant brand surfaces) ────
  final Color darkBlueContainer;
  final Color flashSaleBlue;

  // ── Text colors ──────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textQuaternary;

  /// White text used on brand-colored / dark backgrounds.
  /// Stays white in both themes.
  final Color textOnPrimary;
  final Color textOnPrimary80;
  final Color textOnPrimary60;

  // ── Accent / Action (theme-invariant) ────────────────────────
  final Color accentOrange;
  final Color accentOrangeLight;
  final Color accentGreen;
  final Color accentRed;

  // ── Discount badge (theme-invariant) ─────────────────────────
  final Color discountRed;
  final Color discountOrange;

  // ── Border & divider ────────────────────────────────────────
  final Color border;
  final Color borderLight;
  final Color divider;

  // ── Gold palette (theme-invariant) ──────────────────────────
  final Color primaryGold;
  final Color borderGold;
  final Color ratingGold;

  // ── Shadows ─────────────────────────────────────────────────
  final Color shadowLight;
  final Color shadowMedium;
  final Color shadowDark;

  // ── Rating (theme-invariant) ────────────────────────────────
  final Color ratingYellow;
  final Color ratingGrey;

  // ── Favorite / Heart (theme-invariant) ──────────────────────
  final Color heartRed;
  final Color heartGrey;

  // ── Chip ────────────────────────────────────────────────────
  final Color chipSelectedBackground;
  final Color chipUnselectedBackground;

  // ── Gradient (theme-invariant brand) ────────────────────────
  final Color gradientTop;
  final Color gradientMiddle;
  final Color gradientBottom;

  // ── Soft orange glow (theme-invariant) ─────────────────────
  final Color softOrangeGlow;

  // ── Grid overlay (theme-invariant) ─────────────────────────
  final Color gridLine;

  // ── Logo ────────────────────────────────────────────────────
  final Color logoBackground;
  final Color logoShadow;

  // ── App Bar ─────────────────────────────────────────────────
  final Color appBar;
  final Color appBarIcon;
  final Color badgeRed;

  const AppColors._({
    required this.background,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.surface,
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

  // ── Light palette ────────────────────────────────────────────
  static const AppColors light = AppColors._(
    background: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF5F5F5),
    backgroundTertiary: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    primaryDark: Color(0xFF0D2B4E),
    primary: Color(0xFF123D73),
    primaryLight: Color(0xFF1F4E87),
    primaryLightest: Color(0xFF2A6CB8),
    darkBlueContainer: Color(0xFF0D2B4E),
    flashSaleBlue: Color(0xFF0A1E36),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF333333),
    textTertiary: Color(0xFF666666),
    textQuaternary: Color(0xFF999999),
    textOnPrimary: Color(0xFFFFFFFF),
    textOnPrimary80: Color(0xCCFFFFFF),
    textOnPrimary60: Color(0x99FFFFFF),
    accentOrange: Color(0xFFFF8C42),
    accentOrangeLight: Color(0xFFFFA366),
    accentGreen: Color(0xFF4CAF50),
    accentRed: Color(0xFFE53935),
    discountRed: Color(0xFFE53935),
    discountOrange: Color(0xFFFF6D00),
    border: Color(0xFFE0E0E0),
    borderLight: Color(0xFFEEEEEE),
    divider: Color(0xFFEEEEEE),
    primaryGold: Color(0xFFC59B27),
    borderGold: Color(0xFFD4AF37),
    ratingGold: Color(0xFFFFB800),
    shadowLight: Color(0x1A000000),
    shadowMedium: Color(0x29000000),
    shadowDark: Color(0x3D000000),
    ratingYellow: Color(0xFFFFC107),
    ratingGrey: Color(0xFFBDBDBD),
    heartRed: Color(0xFFE53935),
    heartGrey: Color(0xFFBDBDBD),
    chipSelectedBackground: Color(0xFF0D2B4E),
    chipUnselectedBackground: Color(0xFFFFFFFF),
    gradientTop: Color(0xFF123D73),
    gradientMiddle: Color(0xFF1F4E87),
    gradientBottom: Color(0xFF143A6A),
    softOrangeGlow: Color(0x33FF8C42),
    gridLine: Color(0x0FFFFFFF),
    logoBackground: Color(0xFFFFFFFF),
    logoShadow: Color(0x29000000),
    appBar: Color(0xFFFFFFFF),
    appBarIcon: Color(0xFF333333),
    badgeRed: Color(0xFFE53935),
  );

  // ── Dark palette ─────────────────────────────────────────────
  static const AppColors dark = AppColors._(
    background: Color(0xFF121212),
    backgroundSecondary: Color(0xFF1E1E1E),
    backgroundTertiary: Color(0xFF252525),
    surface: Color(0xFF1E1E1E),
    primaryDark: Color(0xFF0D2B4E),
    primary: Color(0xFF123D73),
    primaryLight: Color(0xFF1F4E87),
    primaryLightest: Color(0xFF2A6CB8),
    darkBlueContainer: Color(0xFF0D2B4E),
    flashSaleBlue: Color(0xFF0A1E36),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFD0D0D0),
    textTertiary: Color(0xFFA0A0A0),
    textQuaternary: Color(0xFF757575),
    textOnPrimary: Color(0xFFFFFFFF),
    textOnPrimary80: Color(0xCCFFFFFF),
    textOnPrimary60: Color(0x99FFFFFF),
    accentOrange: Color(0xFFFF8C42),
    accentOrangeLight: Color(0xFFFFA366),
    accentGreen: Color(0xFF4CAF50),
    accentRed: Color(0xFFE53935),
    discountRed: Color(0xFFE53935),
    discountOrange: Color(0xFFFF6D00),
    border: Color(0xFF333333),
    borderLight: Color(0xFF2A2A2A),
    divider: Color(0xFF2A2A2A),
    primaryGold: Color(0xFFC59B27),
    borderGold: Color(0xFFD4AF37),
    ratingGold: Color(0xFFFFB800),
    shadowLight: Color(0x1A000000),
    shadowMedium: Color(0x1F000000),
    shadowDark: Color(0x29000000),
    ratingYellow: Color(0xFFFFC107),
    ratingGrey: Color(0xFFBDBDBD),
    heartRed: Color(0xFFE53935),
    heartGrey: Color(0xFFBDBDBD),
    chipSelectedBackground: Color(0xFF1F4E87),
    chipUnselectedBackground: Color(0xFF2A2A2A),
    gradientTop: Color(0xFF123D73),
    gradientMiddle: Color(0xFF1F4E87),
    gradientBottom: Color(0xFF143A6A),
    softOrangeGlow: Color(0x33FF8C42),
    gridLine: Color(0x0FFFFFFF),
    logoBackground: Color(0xFF1E1E1E),
    logoShadow: Color(0x1A000000),
    appBar: Color(0xFF1E1E1E),
    appBarIcon: Color(0xFFE0E0E0),
    badgeRed: Color(0xFFE53935),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? surface,
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
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      backgroundTertiary: Color.lerp(
        backgroundTertiary,
        other.backgroundTertiary,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryLightest: Color.lerp(primaryLightest, other.primaryLightest, t)!,
      darkBlueContainer: Color.lerp(
        darkBlueContainer,
        other.darkBlueContainer,
        t,
      )!,
      flashSaleBlue: Color.lerp(flashSaleBlue, other.flashSaleBlue, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textQuaternary: Color.lerp(textQuaternary, other.textQuaternary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnPrimary80: Color.lerp(textOnPrimary80, other.textOnPrimary80, t)!,
      textOnPrimary60: Color.lerp(textOnPrimary60, other.textOnPrimary60, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentOrangeLight: Color.lerp(
        accentOrangeLight,
        other.accentOrangeLight,
        t,
      )!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      discountRed: Color.lerp(discountRed, other.discountRed, t)!,
      discountOrange: Color.lerp(discountOrange, other.discountOrange, t)!,
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
        chipSelectedBackground,
        other.chipSelectedBackground,
        t,
      )!,
      chipUnselectedBackground: Color.lerp(
        chipUnselectedBackground,
        other.chipUnselectedBackground,
        t,
      )!,
      gradientTop: Color.lerp(gradientTop, other.gradientTop, t)!,
      gradientMiddle: Color.lerp(gradientMiddle, other.gradientMiddle, t)!,
      gradientBottom: Color.lerp(gradientBottom, other.gradientBottom, t)!,
      softOrangeGlow: Color.lerp(softOrangeGlow, other.softOrangeGlow, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      logoBackground: Color.lerp(logoBackground, other.logoBackground, t)!,
      logoShadow: Color.lerp(logoShadow, other.logoShadow, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      appBarIcon: Color.lerp(appBarIcon, other.appBarIcon, t)!,
      badgeRed: Color.lerp(badgeRed, other.badgeRed, t)!,
    );
  }
}
