import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    appBarTheme: _appBarTheme(colorScheme),
    dividerTheme: DividerThemeData(color: colorScheme.shadow, indent: 32, endIndent: 32),
    tabBarTheme: TabBarThemeData(dividerColor: Colors.transparent),
  );

  static _appBarTheme(ColorScheme colorScheme) => AppBarTheme(
    backgroundColor: colorScheme.surfaceContainer,
    shadowColor: colorScheme.shadow,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    shape: Border(bottom: BorderSide(color: colorScheme.shadow, width: 1)),
    actionsPadding: const EdgeInsets.only(right: 16),
  );
}
