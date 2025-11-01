import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors - Waffir Design System from Figma
  //
  // Button Color Mapping (as per Figma design):
  // - Primary Button: primaryColorDarkest (#0F352D) background, white text
  // - Secondary Button: white background, primaryColorDarkest (#0F352D) 2px border, black text
  // - Tertiary Button: white background, gray02 (#CECECE) 1px border, black text
  // - Disabled Button: gray02 (#CECECE) background, gray03 (#A3A3A3) text
  static const Color primaryColor = Color(0xFF00FF88); // Waffir-Green-02 (bright green)
  static const Color primaryColorLight = Color(0xFFDCFCE7); // Waffir-Green-01 (very light)
  static const Color primaryColorDark = Color(0xFF00C531); // Waffir-Green-03 (medium)
  static const Color primaryColorDarkest = Color(0xFF0F352D); // Waffir-Green-04 (darkest - used for primary button)
  static const Color accentColor = Color(0xFF00C531); // Using Waffir-Green-03 for accent

  // E-commerce Specific Colors (kept for functionality)
  static const Color saleRed = Color(0xFFFF3B30); // Sale/discount badges
  static const Color newBadge = Color(0xFF00C531); // "NEW" badge (using Waffir-Green-03)
  static const Color priceOriginal = Color(0xFFA3A3A3); // Strikethrough price (Gray-03)
  static const Color priceDiscounted = Color(0xFFEF4444); // Sale price
  static const Color ratingGold = Color(0xFFFBBF24); // Star rating

  // Neutral Colors
  static const Color black = Color(0xFF151515); // Figma Black
  static const Color white = Color(0xFFFFFFFF); // Figma White
  static const Color transparent = Colors.transparent;

  // Grayscale - Waffir Design System from Figma
  static const Color gray01 = Color(0xFFF2F2F2); // Lightest
  static const Color gray02 = Color(0xFFCECECE);
  static const Color gray03 = Color(0xFFA3A3A3);
  static const Color gray04 = Color(0xFF595959); // Darkest
  static const Color white40 = Color(0x66FFFFFF); // White with 40% opacity

  // Semantic Colors (kept for UX)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Background Colors - Waffir Design System
  static const Color background = gray01; // #F2F2F2
  static const Color surface = white; // #FFFFFF

  // Text Colors - Waffir Design System
  static const Color textPrimary = black; // #151515
  static const Color textSecondary = gray04; // #595959
  static const Color textTertiary = gray03; // #A3A3A3

  // Border Colors - Waffir Design System
  static const Color border = gray02; // #CECECE
  static const Color borderLight = gray01; // #F2F2F2

  // Shadow Colors
  static const Color shadow = Color(0x0D000000);

  // Gradient Colors - Waffir Design System
  static const List<Color> primaryGradient = [
    Color(0xFF00FF88), // Waffir-Green-02
    Color(0xFF00C531), // Waffir-Green-03
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFDCFCE7), // Waffir-Green-01
    Color(0xFFFFFFFF), // White
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
  static Color get accent => accentColor;
  static Color get onSurface => textPrimary;
  static Color get outline => border;

  // Material 3 Color Scheme - Light Theme Only
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary colors (Waffir Green) - Updated to match Figma button design
    primary: primaryColorDarkest, // Waffir-Green-04 #0F352D (dark green for primary button)
    onPrimary: white, // White text on dark green
    primaryContainer: primaryColorLight, // Waffir-Green-01 #DCFCE7
    onPrimaryContainer: primaryColorDarkest, // Waffir-Green-04 for text

    // Secondary colors (using bright green)
    secondary: primaryColor, // Waffir-Green-02 #00FF88 (bright green moved from primary)
    onSecondary: black,
    secondaryContainer: primaryColorLight, // Waffir-Green-01
    onSecondaryContainer: primaryColorDarkest, // Waffir-Green-04

    // Tertiary colors (accent)
    tertiary: accentColor, // Waffir-Green-03
    onTertiary: white,
    tertiaryContainer: primaryColorLight,
    onTertiaryContainer: primaryColorDarkest,

    // Error colors
    error: error,
    onError: white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410E0B),

    // Surface colors
    surface: surface, // White
    onSurface: textPrimary, // Black
    surfaceContainerHighest: gray01, // #F2F2F2
    onSurfaceVariant: textSecondary, // Gray-04

    // Outline colors
    outline: border, // Gray-02
    outlineVariant: borderLight, // Gray-01

    // Shadow and scrim
    shadow: shadow,
    scrim: Color(0x66000000),

    // Inverse colors
    inverseSurface: primaryColorDarkest, // Waffir-Green-04
    onInverseSurface: white,
    inversePrimary: primaryColor, // Waffir-Green-02

    // Surface tint
    surfaceTint: primaryColor,
  );
}
