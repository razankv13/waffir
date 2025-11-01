import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/profile/profile_header.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/mock/mock_user_data.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_premium_card.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_menu_section.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_logout_button.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_dialogs.dart';

/// Profile Screen
///
/// Pixel-perfect implementation matching Figma Profile screen (node 34:3080):
/// - Frame: 393×852px
/// - Gap between sections: 24px
/// - Horizontal padding: 16px
/// - Logout button: 361×56px
///
/// **Architecture:**
/// - Clean, modular widget composition
/// - Uses extracted sub-widgets for maintainability
/// - Follows Riverpod ConsumerWidget pattern
/// - Uses DialogService for confirmation dialogs
///
/// **Sub-widgets:**
/// - ProfileHeader: User avatar, name, email (reusable core widget)
/// - ProfilePremiumCard: Premium plan status and manage button
/// - ProfileMenuSection: Vertical list of menu items
/// - ProfileLogoutButton: Fixed bottom logout button
///
/// Displays user profile with avatar, premium status, and menu options.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ResponsiveHelper(context);
    final user = currentMockUser;

    return Scaffold(
      body: Column(
        children: [
          // Profile Header with avatar, name, email
          ProfileHeader(
            name: user.name,
            email: user.email,
            avatarUrl: user.avatarUrl,
            onEditTap: () {
              context.pushNamed(AppRouteNames.profilePersonalDetails);
            },
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              // Exact horizontal padding from Figma: 16px
              padding: responsive.scalePadding(const EdgeInsets.all(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Premium Plan Card Section
                  ProfilePremiumCard(
                    isPremium: user.isPremium,
                    subscriptionExpiryDate: user.subscriptionExpiryDate,
                    onManageTap: () {
                      if (user.isPremium) {
                        context.pushNamed(AppRouteNames.subscriptionManagement);
                      } else {
                        context.pushNamed(AppRouteNames.paywall);
                      }
                    },
                  ),

                  // Gap: 24px (exact from Figma)
                  SizedBox(height: responsive.scale(24)),

                  // Menu Items Section
                  ProfileMenuSection(
                    onPersonalDetailsTap: () {
                      context.pushNamed(AppRouteNames.profilePersonalDetails);
                    },
                    onSavedDealsTap: () {
                      context.pushNamed(AppRouteNames.profileSavedDeals);
                    },
                    onMyCityTap: () {
                      context.pushNamed(AppRouteNames.profileChangeCity);
                    },
                    onNotificationsTap: () {
                      context.pushNamed(AppRouteNames.notificationSettings);
                    },
                    onLanguageTap: () {
                      context.pushNamed(AppRouteNames.profileLanguage);
                    },
                    onHelpCenterTap: () {
                      context.pushNamed(AppRouteNames.profileHelpCenter);
                    },
                  ),

                  // Bottom spacing before logout button
                  SizedBox(height: responsive.scale(24)),
                ],
              ),
            ),
          ),

          // Logout Button (Fixed at bottom)
          ProfileLogoutButton(
            onLogoutTap: () => ProfileDialogs.showSignOutDialog(context),
          ),
        ],
      ),
    );
  }
}
