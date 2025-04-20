import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme light() => ColorScheme.light(
    primary: Color(0xFF2176ff),
    primaryContainer: Color(0xFF33a1fd),
    secondary: Color(0xFFf79824),
    secondaryContainer: Color(0xFFfdca40),
    onPrimary: Colors.white,
    onPrimaryContainer: Colors.white,
    surface: Color(0xFFF2F2F2),
    surfaceContainer: Colors.white,
    shadow: const Color(0xFFC3C3C3),
    tertiary: Colors.grey.shade700,
  );
}
