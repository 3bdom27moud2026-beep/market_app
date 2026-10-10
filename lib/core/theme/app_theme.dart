import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

/// Application theme configuration.
///
/// Use [AppTheme.lightTheme] and [AppTheme.darkTheme] with [MaterialApp].
abstract final class AppTheme {
  /// Light theme for the application.
  static ThemeData get lightTheme {
    const colors = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Alexandria',
      fontFamilyFallback: const ['sans-serif'],
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: Brightness.light,
        surface: colors.background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.appBarIcon),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Alexandria',
          fontFamilyFallback: const ['sans-serif'],
          color: colors.textQuaternary,
          fontSize: 12.sp,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          textStyle: TextStyle(
            fontFamily: 'Alexandria',
            fontFamilyFallback: const ['sans-serif'],
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: TextStyle(
            fontFamily: 'Alexandria',
            fontFamilyFallback: const ['sans-serif'],
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.accentOrange;
          }
          return colors.textQuaternary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.accentOrange.withValues(alpha: 0.4);
          }
          return colors.border;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.chipUnselectedBackground,
        selectedColor: colors.chipSelectedBackground,
        labelStyle: TextStyle(
          fontFamily: 'Alexandria',
          fontFamilyFallback: const ['sans-serif'],
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      extensions: const <ThemeExtension>[colors],
    );
  }

  /// Dark theme for the application.
  static ThemeData get darkTheme {
    const colors = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Alexandria',
      fontFamilyFallback: const ['sans-serif'],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: Brightness.dark,
        surface: colors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.appBarIcon),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primaryLight, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Alexandria',
          fontFamilyFallback: const ['sans-serif'],
          color: colors.textQuaternary,
          fontSize: 12.sp,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          textStyle: TextStyle(
            fontFamily: 'Alexandria',
            fontFamilyFallback: const ['sans-serif'],
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryLightest,
          textStyle: TextStyle(
            fontFamily: 'Alexandria',
            fontFamilyFallback: const ['sans-serif'],
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.accentOrange;
          }
          return colors.textQuaternary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.accentOrange.withValues(alpha: 0.4);
          }
          return colors.border;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.chipUnselectedBackground,
        selectedColor: colors.chipSelectedBackground,
        labelStyle: TextStyle(
          fontFamily: 'Alexandria',
          fontFamilyFallback: const ['sans-serif'],
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      extensions: const <ThemeExtension>[colors],
    );
  }

  /// Main [ThemeData] for backward compatibility.
  static ThemeData get theme => lightTheme;
}
