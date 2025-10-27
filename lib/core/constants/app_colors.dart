import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors - Waffir Design System from Figma
  static const Color primaryColor = Color(0xFF00FF88); // Green wafir
  static const Color secondaryColor = Color(0xFF121535); // Blue wafir (dark navy)
  static const Color primaryColorDark = Color(0xFF00CC6F); // Darker green
  static const Color primaryColorLight = Color(0xFF33FFA0); // Lighter green
  static const Color accentColor = Color(0xFFF59E0B); // Amber

  // E-commerce Specific Colors
  static const Color saleRed = Color(0xFFFF3B30); // Sale/discount badges
  static const Color newBadge = Color(0xFF5856D6); // "NEW" badge
  static const Color priceOriginal = Color(0xFF9CA3AF); // Strikethrough price
  static const Color priceDiscounted = Color(0xFFEF4444); // Sale price
  static const Color ratingGold = Color(0xFFFBBF24); // Star rating

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Blue/Gray Scale - Waffir Design System from Figma
  static const Color blue05 = Color(0xFFF3F3F3); // Blue 05 - Lightest
  static const Color blue10 = Color(0xFFE4E3E7); // Blue 10
  static const Color blue20 = Color(0xFFCCCBD2); // Blue 20
  static const Color blue30 = Color(0xFF9C9AA7); // blue 30
  static const Color blue40 = Color(0xFF848292); // blue 40
  static const Color blue50 = Color(0xFF6E6B7F); // Blue 50
  static const Color blue60 = Color(0xFF58556B); // Blue 60
  static const Color blue70 = Color(0xFF434158); // Blue 70
  static const Color blue80 = Color(0xFF2F2C45); // Blue 80
  static const Color blue90 = Color(0xFF1C1A34); // Blue 90 - Darkest

  // Legacy gray scale (kept for backwards compatibility)
  static const Color gray50 = blue05;
  static const Color gray100 = blue10;
  static const Color gray200 = blue20;
  static const Color gray300 = blue30;
  static const Color gray400 = blue40;
  static const Color gray500 = blue50;
  static const Color gray600 = blue60;
  static const Color gray700 = blue70;
  static const Color gray800 = blue80;
  static const Color gray900 = blue90;

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Background Colors - Waffir Design System
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color backgroundDark = secondaryColor; // Blue wafir #121535
  static const Color surfaceLight = blue05; // #F3F3F3
  static const Color surfaceDark = blue90; // #1C1A34

  // Text Colors - Waffir Design System
  static const Color textPrimaryLight = secondaryColor; // Blue wafir for main text
  static const Color textSecondaryLight = blue50; // Blue 50 for secondary text
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = blue30; // Blue 30 for dark mode secondary

  // Border Colors - Waffir Design System
  static const Color borderLight = blue20; // #CCCBD2
  static const Color borderDark = blue70; // #434158

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x1A000000);

  // Gradient Colors - Waffir Design System
  static const List<Color> primaryGradient = [
    Color(0xFF00FF88), // Green wafir
    Color(0xFF00FFAA), // Lighter green
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF121535), // Blue wafir
    Color(0xFF1C1A34), // Blue 90
  ];

  // Waffir-specific gradients for backgrounds
  static const List<Color> waffirGreenGradient = [
    Color(0xFF00FF88), // Green wafir
    Color(0xFFFFFFFF), // White
  ];

  static const List<Color> waffirBlueGradient = [
    Color(0xFF121535), // Blue wafir
    Color(0xFF2F2C45), // Blue 80
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFEF4444),
    Color(0xFFDC2626),
  ];

  // Convenience getters for consistent naming
  static Color get primary => primaryColor;
  static Color get secondary => secondaryColor;
  static Color get accent => accentColor;
  static Color get surface => backgroundLight;
  static Color get onSurface => textPrimaryLight;
  static Color get outline => borderLight;

  // Material 3 Color Roles - Waffir Design System
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor, // Green wafir #00FF88
    onPrimary: secondaryColor, // Blue wafir for text on green
    primaryContainer: Color(0xFFCCFFEE), // Light green container
    onPrimaryContainer: secondaryColor, // Blue wafir text
    secondary: secondaryColor, // Blue wafir #121535
    onSecondary: white,
    secondaryContainer: blue05, // Blue 05 #F3F3F3
    onSecondaryContainer: secondaryColor, // Blue wafir text
    tertiary: accentColor,
    onTertiary: white,
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF1C1917),
    error: error,
    onError: white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410E0B),
    surface: backgroundLight, // White
    onSurface: textPrimaryLight, // Blue wafir
    surfaceContainerHighest: blue05, // #F3F3F3
    onSurfaceVariant: blue60, // #58556B
    outline: borderLight, // Blue 20
    outlineVariant: blue10, // Blue 10
    shadow: shadowLight,
    scrim: Color(0x66000000),
    inverseSurface: blue80, // Blue 80
    onInverseSurface: white,
    inversePrimary: primaryColor, // Green wafir
    surfaceTint: primaryColor,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor, // Green wafir (same in dark mode)
    onPrimary: secondaryColor, // Blue wafir
    primaryContainer: Color(0xFF00CC6F), // Darker green container
    onPrimaryContainer: white, // White text on container
    secondary: white, // White for secondary in dark mode
    onSecondary: secondaryColor, // Blue wafir
    secondaryContainer: blue80, // Blue 80 for containers
    onSecondaryContainer: white,
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF1C1917),
    tertiaryContainer: Color(0xFFB45309),
    onTertiaryContainer: Color(0xFFFEF3C7),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: backgroundDark, // Blue wafir #121535
    onSurface: textPrimaryDark, // White
    surfaceContainerHighest: blue80, // Blue 80
    onSurfaceVariant: blue30, // Blue 30
    outline: borderDark, // Blue 70
    outlineVariant: blue60, // Blue 60
    shadow: shadowDark,
    scrim: Color(0x66000000),
    inverseSurface: blue10, // Blue 10
    onInverseSurface: secondaryColor, // Blue wafir
    inversePrimary: primaryColor, // Green wafir
    surfaceTint: primaryColor,
  );
}