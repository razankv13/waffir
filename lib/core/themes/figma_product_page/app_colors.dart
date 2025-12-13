import 'package:flutter/material.dart';

/// Exact color + effect tokens extracted from Figma node `34:4022` (Product Page).
///
/// IMPORTANT: Do not import this file from widgets.
/// Widgets must access these values via `Theme.of(context)` using `ProductPageTheme`.
class ProductPageFigmaColors {
  ProductPageFigmaColors._();

  // Core colors
  static const Color background = Color(0xFFFFFFFF); // #FFFFFF
  static const Color textPrimary = Color(0xFF151515); // #151515
  static const Color textSecondary = Color(0xFFA3A3A3); // #A3A3A3
  static const Color textMid = Color(0xFF595959); // #595959

  static const Color surfaceContainer = Color(0xFFF2F2F2); // #F2F2F2
  static const Color brandDarkGreen = Color(0xFF0F352D); // #0F352D
  static const Color brandBrightGreen = Color(0xFF00FF88); // #00FF88
  static const Color badgeMint = Color(0xFFDCFCE7); // #DCFCE7

  // Lines/borders
  static const Color divider = Color(0xFFF2F2F2); // #F2F2F2
  static const Color heroBorder = Color(0x0D000000); // rgba(0,0,0,0.05)

  // Effects
  static const Color backShadowColor = Color(0xFFF2F2F2); // rgba(242,242,242,1)

  // Gradients
  static const LinearGradient topOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: <double>[0.71, 1.0],
    colors: <Color>[
      Color(0xFFFFFFFF), // rgba(255,255,255,1)
      Color(0x00FFFFFF), // rgba(255,255,255,0)
    ],
  );

  static const LinearGradient bottomCtaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: <double>[0.0, 0.49],
    colors: <Color>[
      Color(0x00FFFFFF), // rgba(255,255,255,0)
      Color(0xFFFFFFFF), // rgba(255,255,255,1)
    ],
  );
}
