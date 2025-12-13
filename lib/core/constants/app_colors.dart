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
  // Figma Color-Palettes (node `34:5062`) - canonical token names
  static const Color waffirGreen01 = Color(0xFFDCFCE7); // Very light
  static const Color waffirGreen02 = Color(0xFF00FF88); // Bright green
  static const Color waffirGreen03 = Color(0xFF00C531); // Medium green
  static const Color waffirGreen04 = Color(0xFF0F352D); // Darkest green

  static const Color indigo = Color(0xFF3A2D98);
  static const Color red = Color(0xFFFF0000);
  static const List<Color> goldGradient = [Color(0xFFFFD900), Color(0xFFFF9A03)];

  // Backwards-compatible aliases (deprecated)
  @Deprecated('Use waffirGreen02')
  static const Color primaryColor = waffirGreen02; // Waffir-Green-02 (bright green)

  @Deprecated('Use waffirGreen01')
  static const Color primaryColorLight = waffirGreen01; // Waffir-Green-01 (very light)

  @Deprecated('Use waffirGreen03')
  static const Color primaryColorDark = waffirGreen03; // Waffir-Green-03 (medium)

  @Deprecated('Use waffirGreen04')
  static const Color primaryColorDarkest = waffirGreen04; // Waffir-Green-04 (darkest - used for primary button)

  @Deprecated('Use indigo')
  static const Color accentColor = indigo;

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
  static const Color error = red;
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
    waffirGreen02,
    waffirGreen03,
  ];

  static const List<Color> backgroundGradient = [
    waffirGreen01,
    white,
  ];

  static const List<Color> successGradient = [Color(0xFF10B981), Color(0xFF059669)];

  static const List<Color> warningGradient = [Color(0xFFF59E0B), Color(0xFFD97706)];

  static const List<Color> errorGradient = [Color(0xFFEF4444), Color(0xFFDC2626)];

  // Convenience getters for consistent naming
  static Color get primary => waffirGreen02;
  static Color get accent => indigo;
  static Color get onSurface => textPrimary;
  static Color get outline => border;

  // Material 3 Color Scheme - Light Theme Only
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary colors (Waffir Green) - Updated to match Figma button design
    primary: waffirGreen04, // Waffir-Green-04 #0F352D (dark green for primary button)
    onPrimary: white, // White text on dark green
    primaryContainer: waffirGreen01, // Waffir-Green-01 #DCFCE7
    onPrimaryContainer: waffirGreen04, // Waffir-Green-04 for text
    // Secondary colors (using bright green)
    secondary: waffirGreen02, // Waffir-Green-02 #00FF88
    onSecondary: black,
    secondaryContainer: waffirGreen01, // Waffir-Green-01
    onSecondaryContainer: waffirGreen04, // Waffir-Green-04
    // Tertiary colors (accent)
    tertiary: indigo,
    onTertiary: white,
    tertiaryContainer: waffirGreen01,
    onTertiaryContainer: waffirGreen04,

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
    inverseSurface: waffirGreen04, // Waffir-Green-04
    onInverseSurface: white,
    inversePrimary: waffirGreen02, // Waffir-Green-02
    // Surface tint
    surfaceTint: waffirGreen02,
  );
}
