import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => getTheme(1.0, false);

  static ThemeData getTheme(double fontSizeFactor, bool isHighContrast) {
    final colorScheme = isHighContrast
        ? const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF000000), 
            onPrimary: Color(0xFFFFFFFF), 
            primaryContainer: Color(0xFFFFF209),
            onPrimaryContainer: Color(0xFF000000),
            
            secondary: Color(0xFF0000FF), 
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer: Color(0xFF82B2FE),
            onSecondaryContainer: Color(0xFF0000FF),
            
            tertiary: Color(0xFF004400), 
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFCCFFCC),
            onTertiaryContainer: Color(0xFF004400),
            
            error: Color(0xFFBA1A1A),
            onError: Color(0xFFFFFFFF),
            errorContainer: Color(0xFFFFDAD6),
            onErrorContainer: Color(0xFF93000A),
            
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFF000000),
            surfaceContainerHighest: Color(0xFFCCCCCC),
            onSurfaceVariant: Color(0xFF000000),
            outline: Color(0xFF000000),
            outlineVariant: Color(0xFF000000),
          )
        : const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF666000), 
            onPrimary: Color(0xFFFFFFFF), 
            primaryContainer: Color(0xFFFFF209),
            onPrimaryContainer: Color(0xFF736D00),
            
            secondary: Color(0xFF285EA5), 
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer: Color(0xFF82B2FE),
            onSecondaryContainer: Color(0xFF004384),
            
            tertiary: Color(0xFF355F97), 
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFE5EDFF),
            onTertiaryContainer: Color(0xFF436CA5),
            
            error: Color(0xFFBA1A1A),
            onError: Color(0xFFFFFFFF),
            errorContainer: Color(0xFFFFDAD6),
            onErrorContainer: Color(0xFF93000A),
            
            surface: Color(0xFFFAF9F6),
            onSurface: Color(0xFF1A1C1A),
            surfaceContainerHighest: Color(0xFFE3E3DF),
            onSurfaceVariant: Color(0xFF4A4731),
            outline: Color(0xFF7B785F),
            outlineVariant: Color(0xFFCCC7AA),
          );

    return ThemeData(
      fontFamily: 'Public Sans',
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 57 * fontSizeFactor, fontWeight: FontWeight.w600, height: 1.12, letterSpacing: -0.25),
        headlineLarge: TextStyle(fontSize: 32 * fontSizeFactor, fontWeight: FontWeight.w600, height: 1.25, letterSpacing: 0),
        headlineMedium: TextStyle(fontSize: 28 * fontSizeFactor, fontWeight: FontWeight.w500, height: 1.28, letterSpacing: 0),
        titleLarge: TextStyle(fontSize: 22 * fontSizeFactor, fontWeight: FontWeight.w500, height: 1.27, letterSpacing: 0),
        bodyLarge: TextStyle(fontSize: 16 * fontSizeFactor, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.5),
        bodyMedium: TextStyle(fontSize: 14 * fontSizeFactor, fontWeight: FontWeight.w400, height: 1.42, letterSpacing: 0.25),
        labelLarge: TextStyle(fontSize: 14 * fontSizeFactor, fontWeight: FontWeight.w500, height: 1.42, letterSpacing: 0.1),
        labelSmall: TextStyle(fontSize: 11 * fontSizeFactor, fontWeight: FontWeight.w500, height: 1.45, letterSpacing: 0.5),
      ),
    );
  }
}
