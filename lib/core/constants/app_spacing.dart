import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing unit (4.0)
  static const double _baseUnit = 4.0;

  // Extra small spacing
  static const double xs = _baseUnit; // 4.0
  static const double xs2 = _baseUnit * 2; // 8.0
  static const double xs3 = _baseUnit * 3; // 12.0

  // Small spacing
  static const double sm = _baseUnit * 4; // 16.0
  static const double sm2 = _baseUnit * 5; // 20.0
  static const double sm3 = _baseUnit * 6; // 24.0

  // Medium spacing
  static const double md = _baseUnit * 8; // 32.0
  static const double md2 = _baseUnit * 10; // 40.0
  static const double md3 = _baseUnit * 12; // 48.0

  // Large spacing
  static const double lg = _baseUnit * 16; // 64.0
  static const double lg2 = _baseUnit * 20; // 80.0
  static const double lg3 = _baseUnit * 24; // 96.0

  // Extra large spacing
  static const double xl = _baseUnit * 32; // 128.0
  static const double xl2 = _baseUnit * 40; // 160.0
  static const double xl3 = _baseUnit * 48; // 192.0

  // Component-specific spacing
  static const double buttonPadding = sm; // 16.0
  static const double cardPadding = md; // 32.0
  static const double screenPadding = sm3; // 24.0
  static const double sectionSpacing = md2; // 40.0
  static const double itemSpacing = xs2; // 8.0

  // Border radius
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 999.0;

  // Waffir-specific border radius (from Figma)
  static const double radiusWaffir = 30.0; // 30px from Figma designs

  // Component-specific border radius
  static const double buttonRadius = radiusWaffir; // Updated to Waffir radius
  static const double cardRadius = radiusLg;
  static const double inputRadius = radiusWaffir; // Updated to Waffir radius
  static const double avatarRadius = radiusFull;
  static const double chipRadius = radiusFull;

  // Elevation levels
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 4.0;
  static const double elevation4 = 6.0;
  static const double elevation5 = 8.0;
  static const double elevation6 = 12.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double icon2xl = 64.0;

  // Avatar sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;
  static const double avatar2xl = 96.0;

  // Common EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);

  // Common BorderRadius
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // Component-specific BorderRadius
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(buttonRadius));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(inputRadius));
}