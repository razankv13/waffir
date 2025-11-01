import 'package:flutter/material.dart';
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
            icon: const Icon(Icons.person_outline, size: 24),
            label: 'Personal Details',
            onTap: onPersonalDetailsTap,
          ),

          // Saved Deals
          ProfileMenuItem(
            icon: const Icon(Icons.favorite_outline, size: 24),
            label: 'Saved Deals',
            onTap: onSavedDealsTap,
          ),

          // My City
          ProfileMenuItem(
            icon: const Icon(Icons.location_on_outlined, size: 24),
            label: 'My City',
            onTap: onMyCityTap,
          ),

          // Notifications
          ProfileMenuItem(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            label: 'Notifications',
            onTap: onNotificationsTap,
          ),

          // Language
          ProfileMenuItem(
            icon: const Icon(Icons.language, size: 24),
            label: 'Language',
            onTap: onLanguageTap,
          ),

          // Help Center (no divider on last item)
          ProfileMenuItem(
            icon: const Icon(Icons.help_outline, size: 24),
            label: 'Help Center',
            onTap: onHelpCenterTap,
            showDivider: false, // Last item has no divider
          ),
        ],
      ),
    );
  }
}
