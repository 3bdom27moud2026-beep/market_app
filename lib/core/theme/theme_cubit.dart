import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/utils/cache_helper.dart';

/// Cubit managing the application's ThemeMode (Light, Dark, System).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_loadInitialTheme());

  static ThemeMode _loadInitialTheme() {
    try {
      final saved = CacheHelper.themeMode;
      if (saved == 'dark') return ThemeMode.dark;
      if (saved == 'light') return ThemeMode.light;
    } catch (_) {}
    return ThemeMode.light;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
    try {
      final String val = mode == ThemeMode.dark
          ? 'dark'
          : (mode == ThemeMode.light ? 'light' : 'system');
      CacheHelper.setThemeMode(val);
    } catch (_) {}
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
