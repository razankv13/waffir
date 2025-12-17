import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

/// Profile Logout Button Widget
///
/// Fixed logout button displayed at the bottom of the profile screen
/// with proper SafeArea handling.
///
/// **Figma Specs** (Node 35:2182):
/// - Width: 361px
/// - Height: 56px
/// - Border radius: 30px
/// - Background: #0F352D (primaryColorDarkest)
/// - Text: "Logout", 14px, weight 600
/// - Padding: 16px horizontal, 16px bottom, 8px top
///
/// **Usage:**
/// ```dart
/// ProfileLogoutButton(
///   onLogoutTap: () => handleLogout(),
/// )
/// ```
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    super.key,
    required this.onLogoutTap,
  });

  /// Callback when logout button is tapped
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return SafeArea(
      top: false, // Only apply safe area to bottom (notch handling)
      child: Padding(
        padding: responsive.scalePadding(
          const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 8,
          ),
        ),
        child: SizedBox(
          width: responsive.scale(361), // Exact width from Figma
          height: responsive.scale(56), // Exact height from Figma
          child: AppButton.primary(
            onPressed: onLogoutTap,
            child: Text(LocaleKeys.auth.logout.tr()),
          ),
        ),
      ),
    );
  }
}
