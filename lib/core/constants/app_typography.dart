import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // Font families - Waffir Design System
  static const String primaryFontFamily = 'Parkinsans'; // Arabic & English
  static const String secondaryFontFamily = 'Inter'; // Fallback
  static const String monospaceFontFamily = 'RobotoMono';

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Line heights
  static const double tightLineHeight = 1.2;
  static const double normalLineHeight = 1.4;
  static const double relaxedLineHeight = 1.6;
  static const double looseLineHeight = 1.8;

  // Letter spacing
  static const double tightLetterSpacing = -0.5;
  static const double normalLetterSpacing = 0.0;
  static const double wideLetterSpacing = 0.5;
  static const double extraWideLetterSpacing = 1.0;

  // Display text styles - Using local Parkinsans font
  static TextStyle displayLarge = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 57,
    fontWeight: bold,
    letterSpacing: tightLetterSpacing,
    height: tightLineHeight,
  );

  static TextStyle displayMedium = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 45,
    fontWeight: bold,
    letterSpacing: tightLetterSpacing,
    height: tightLineHeight,
  );

  static TextStyle displaySmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 36,
    fontWeight: bold,
    letterSpacing: normalLetterSpacing,
    height: tightLineHeight,
  );

  // Headline text styles - Using local Parkinsans font
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: bold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: semiBold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  // Title text styles - Using local Parkinsans font
  static TextStyle titleLarge = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22,
    fontWeight: semiBold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: wideLetterSpacing,
    height: relaxedLineHeight,
  );

  static TextStyle titleSmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: wideLetterSpacing,
    height: relaxedLineHeight,
  );

  // Body text styles - Using local Parkinsans font
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: relaxedLineHeight,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: relaxedLineHeight,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  // Label text styles - Using local Parkinsans font
  static TextStyle labelLarge = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: wideLetterSpacing,
    height: relaxedLineHeight,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: wideLetterSpacing,
    height: relaxedLineHeight,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: wideLetterSpacing,
    height: relaxedLineHeight,
  );

  // Custom text styles - Using local Parkinsans font
  static TextStyle button = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    letterSpacing: wideLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10,
    fontWeight: medium,
    letterSpacing: extraWideLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle code = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: relaxedLineHeight,
  );

  // E-commerce specific text styles - Using local Parkinsans font
  static TextStyle priceText = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: bold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle priceSmall = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle salePriceText = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: bold,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle originalPriceText = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle badgeText = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10,
    fontWeight: bold,
    letterSpacing: extraWideLetterSpacing,
    height: tightLineHeight,
  );

  static TextStyle productTitle = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  static TextStyle productBrand = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: normalLineHeight,
  );

  // Waffir-specific text styles matching Figma designs - Using local Parkinsans font
  static TextStyle waffirLogo = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 59.4, // From Figma splash screen
    fontWeight: extraBold, // ExtraBold in Figma
    letterSpacing: normalLetterSpacing,
    height: 36 / 59.4, // 36px line height
  );

  static TextStyle waffirHeading = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 25.4, // From Figma login "مرحباً بكم في"
    fontWeight: extraBold,
    letterSpacing: normalLetterSpacing,
    height: 36 / 25.4, // 36px line height
  );

  static TextStyle waffirSubtitle = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16, // From Figma subtitle text
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: 24 / 16, // 24px line height
  );

  static TextStyle waffirInput = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16, // From Figma input fields
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: 20 / 16, // 20px line height
  );

  static TextStyle waffirButton = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16, // From Figma buttons
    fontWeight: semiBold,
    letterSpacing: normalLetterSpacing,
    height: 24 / 16, // 24px line height
  );

  static TextStyle waffirSmallText = const TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14, // From Figma small text
    fontWeight: regular,
    letterSpacing: normalLetterSpacing,
    height: 20 / 14, // 20px line height
  );

  // Store section header style (exact from Figma Stores screen)
  static const TextStyle storeSectionHeader = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Exact: 700 from Figma
    height: 1.0, // Line-height 16px / font-size 16px = 1.0
    letterSpacing: normalLetterSpacing,
  );

  // Profile screen text styles (exact from Figma Profile screen - node 34:3080)
  static const TextStyle profileName = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: semiBold, // 600
    height: 1.0, // Line-height 20px / font-size 20px = 1.0
    letterSpacing: normalLetterSpacing,
  );

  static const TextStyle profileEmail = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium, // 500
    height: 1.0, // Line-height 14px / font-size 14px = 1.0
    letterSpacing: normalLetterSpacing,
  );

  static const TextStyle premiumTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: bold, // 700
    height: 1.0, // Line-height 16px / font-size 16px = 1.0
    letterSpacing: normalLetterSpacing,
  );

  static const TextStyle premiumSubtitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular, // 400
    height: 1.0, // Line-height 12px / font-size 12px = 1.0
    letterSpacing: normalLetterSpacing,
  );

  static const TextStyle menuItemText = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium, // 500
    height: 1.25, // Line-height 17.5px / font-size 14px = 1.25
    letterSpacing: normalLetterSpacing,
  );

  // Create a complete TextTheme for Material 3
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  // Utility methods for creating themed text styles
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  static TextStyle withSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }

  // Responsive text scaling
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return baseSize * 0.9;
    } else if (screenWidth < 900) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  // Text scale factor limits
  static const double minScaleFactor = 0.8;
  static const double maxScaleFactor = 1.3;

  static double getConstrainedTextScaleFactor(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    return textScaler.scale(1.0).clamp(minScaleFactor, maxScaleFactor);
  }
}