import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/mock/mock_user_data.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/profile/profile_header.dart';
import 'package:waffir/core/widgets/scrollable/blurry_edge_list_view.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_dialogs.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_logout_button.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_menu_section.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_premium_card.dart';

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
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final logoutOverlayHeight = responsive.scale(56 + 8 + 16) + bottomInset;
    final headerHeight = responsive.scale(150) + MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            top: false, // ProfileHeader already handles top safe area
            bottom: false,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 0,
                    collapsedHeight: headerHeight,
                    expandedHeight: headerHeight,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: ProfileHeader(
                      name: user.name,
                      email: user.email,
                      avatarUrl: user.avatarUrl,
                      onEditTap: () {
                        context.pushNamed(AppRouteNames.profilePersonalDetails);
                      },
                    ),
                  ),
                ];
              },
              body: BlurryEdgeListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: responsive.scalePadding(
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16 + logoutOverlayHeight),
                ),
                topBlurEnabled: false,
                itemCount: 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return ProfilePremiumCard(
                        isPremium: user.isPremium,
                        subscriptionExpiryDate: user.subscriptionExpiryDate,
                        onManageTap: () {
                          if (user.isPremium) {
                            context.pushNamed(AppRouteNames.subscriptionManagement);
                          } else {
                            context.pushNamed(AppRouteNames.paywall);
                          }
                        },
                      );
                    case 1:
                      return SizedBox(height: responsive.scale(24));
                    case 2:
                      return ProfileMenuSection(
                        onPersonalDetailsTap: () {
                          context.pushNamed(AppRouteNames.profileMyAccount);
                        },
                        onSavedDealsTap: () {
                          context.pushNamed(AppRouteNames.profileFavorites);
                        },
                        onMyCityTap: () {
                          context.pushNamed(
                            AppRouteNames.citySelection,
                            queryParameters: {'showBackButton': 'true'},
                          );
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
                      );
                    case 3:
                      return SizedBox(height: responsive.scale(24));
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),

          // Logout Button (Fixed at bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProfileLogoutButton(
              onLogoutTap: () => ProfileDialogs.showSignOutDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}
