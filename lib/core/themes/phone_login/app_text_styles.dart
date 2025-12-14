import 'package:flutter/material.dart';
import 'package:waffir/core/themes/phone_login/app_colors.dart';

/// Figma-exact typography tokens for Phone Login screen (node `50:3051`).
class PhoneLoginTextStyles {
  PhoneLoginTextStyles._();

  // Title (node `50:5571`): Parkinsans 20/700, line-height 1.0em, #0F352D.
  static const TextStyle title = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: PhoneLoginColors.primary,
  );

  // Subtitle (node `50:3066`): Parkinsans 16/400, line-height 1.25em, #0F352D.
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: PhoneLoginColors.primary,
  );

  // Divider text (node `50:3070`): Parkinsans 14/500, line-height 1.25em, #151515.
  static const TextStyle divider = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: PhoneLoginColors.textPrimary,
  );

  // Phone input (node `50:3067`): Parkinsans 14/600, line-height 1.0em, #151515.
  static const TextStyle phoneValue = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: PhoneLoginColors.textPrimary,
  );

  // Phone placeholder (node `50:3067`): Parkinsans 14/500, line-height 1.0em, #A3A3A3.
  static const TextStyle phonePlaceholder = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: PhoneLoginColors.textPlaceholder,
  );

  // Social buttons (node `50:3073`): Parkinsans 14/600, line-height 1.0em, #151515.
  static const TextStyle socialLabel = TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: PhoneLoginColors.textPrimary,
  );
}

