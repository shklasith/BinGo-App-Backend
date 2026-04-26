import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF16A34A);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
