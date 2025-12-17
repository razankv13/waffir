import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/gen/assets.gen.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';
import 'package:waffir/core/widgets/profile/profile_menu_item.dart';

/// Profile Menu Section Widget
///
/// Displays a vertical list of menu items for profile-related actions.
///
/// **Figma Specs** (Node 34:3097):
/// - Card background: #FFFFFF (white)
/// - Border radius: 8px
/// - No card padding (menu items have internal padding)
/// - Menu item height: 44px
/// - Gap between items: 8px (via dividers)
/// - Icon size: 24×24px
/// - Chevron size: 24×24px
///
/// **Usage:**
/// ```dart
/// ProfileMenuSection(
///   onPersonalDetailsTap: () => navigate(Routes.personalDetails),
///   onSavedDealsTap: () => navigate(Routes.savedDeals),
///   // ... other callbacks
/// )
/// ```
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.onPersonalDetailsTap,
    required this.onSavedDealsTap,
    required this.onMyCityTap,
    required this.onNotificationsTap,
    required this.onLanguageTap,
    required this.onHelpCenterTap,
  });

  /// Callback when Personal Details menu item is tapped
  final VoidCallback onPersonalDetailsTap;

  /// Callback when Saved Deals menu item is tapped
  final VoidCallback onSavedDealsTap;

  /// Callback when My City menu item is tapped
  final VoidCallback onMyCityTap;

  /// Callback when Notifications menu item is tapped
  final VoidCallback onNotificationsTap;

  /// Callback when Language menu item is tapped
  final VoidCallback onLanguageTap;

  /// Callback when Help Center menu item is tapped
  final VoidCallback onHelpCenterTap;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      padding: EdgeInsets.zero, // No card padding (items have internal padding)
      backgroundColor: Theme.of(context).colorScheme.surface, // White background (#FFFFFF)
      child: Column(
        children: [
          // Personal Details
          ProfileMenuItem(
            icon: Assets.icons.profile.iconPersonalDetails.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
            ),
            label: LocaleKeys.profile.menu.myAccount.tr(),
            onTap: onPersonalDetailsTap,
          ),

          // Saved Deals
          ProfileMenuItem(
            icon: Assets.icons.profile.iconSavedDeals.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
            ),
            label: LocaleKeys.profile.menu.favourites.tr(),
            onTap: onSavedDealsTap,
          ),

          // My City
          ProfileMenuItem(
            icon: Assets.icons.profile.iconMyCity.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
            ),
            label: LocaleKeys.profile.menu.changeCity.tr(),
            onTap: onMyCityTap,
          ),

          // Notifications
          ProfileMenuItem(
            icon: Assets.icons.profile.iconNotifications.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
            ),
            label: LocaleKeys.settings.notifications.tr(),
            onTap: onNotificationsTap,
          ),

          // Language
          ProfileMenuItem(
            icon: Assets.icons.profile.iconLanguage.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
            ),
            label: LocaleKeys.settings.language.tr(),
            onTap: onLanguageTap,
          ),

          // Help Center (no divider on last item)
          ProfileMenuItem(
            icon: Icon(Icons.help_center, size: 24, color: context.colorScheme.primary),
            label: LocaleKeys.profile.menu.helpCenter.tr(),
            onTap: onHelpCenterTap,
            showDivider: false, // Last item has no divider
          ),
        ],
      ),
    );
  }
}
