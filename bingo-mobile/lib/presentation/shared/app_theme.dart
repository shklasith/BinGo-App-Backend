import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF10B981);
  static const Color primaryHover = Color(0xFF059669);
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color bg = Color(0xFFF9FAFB);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);

  static ThemeData buildTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
    );

    return _applySharedTheme(base, isDark: false);
  }

  static ThemeData buildDarkTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
    );

    return _applySharedTheme(base, isDark: true);
  }

  static ThemeData _applySharedTheme(ThemeData base, {required bool isDark}) {
    final scaffoldColor = isDark ? const Color(0xFF0F172A) : bg;
    final cardColor = isDark ? const Color(0xFF111827) : surface;
    final borderColor = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFE5E7EB);
    final foregroundColor = isDark ? const Color(0xFFF9FAFB) : text;
    final inputFill = isDark
        ? const Color(0xFF111827)
        : const Color(0xFFF9FAFB);

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldColor,
      cardColor: cardColor,
      dividerColor: borderColor,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        foregroundColor: foregroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: foregroundColor,
        displayColor: foregroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size.fromHeight(52),
          foregroundColor: foregroundColor,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: foregroundColor,
        textColor: foregroundColor,
      ),
    );
  }
}
