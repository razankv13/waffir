import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/profile/profile_header.dart';
import 'package:waffir/core/widgets/scrollable/blurry_edge_list_view.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_dialogs.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_logout_button.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_menu_section.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_premium_card.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';

/// Profile Screen
///
/// Pixel-perfect implementation matching Figma Profile screen (node 34:3080):
/// - Frame: 393x852px
/// - Gap between sections: 24px
/// - Horizontal padding: 16px
/// - Logout button: 361x56px
///
/// **Architecture:**
/// - Clean, modular widget composition
/// - Uses extracted sub-widgets for maintainability
/// - Follows HookConsumerWidget pattern with Riverpod
/// - Uses ProfileController for profile state management
/// - Uses DialogService for confirmation dialogs
///
/// **Sub-widgets:**
/// - ProfileHeader: User avatar, name, email (reusable core widget)
/// - ProfilePremiumCard: Premium plan status and manage button
/// - ProfileMenuSection: Vertical list of menu items
/// - ProfileLogoutButton: Fixed bottom logout button
///
/// Displays user profile with avatar, premium status, and menu options.
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ResponsiveHelper.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final logoutOverlayHeight = responsive.s(56 + 8 + 16) + bottomInset;
    final headerHeight = responsive.s(150) + MediaQuery.paddingOf(context).top;

    // Watch profile state
    final profileAsync = ref.watch(profileControllerProvider);

    // Watch auth state for email
    final authStateAsync = ref.watch(authStateProvider);
    final authState = authStateAsync.asData?.value;
    final userEmail = authState?.user?.email ?? '';

    // Watch subscription status for premium
    final isPremium = ref.watch(isPremiumUserProvider);

    // Get subscription expiry date if available
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final subscriptionExpiryDate = useMemoized(() {
      final customerInfo = subscriptionState.asData?.value.customerInfo;
      if (customerInfo == null) return null;
      final entitlements = customerInfo.entitlements.active;
      if (entitlements.isEmpty) return null;
      final expirationDateStr = entitlements.values.first.expirationDate;
      if (expirationDateStr == null) return null;
      return DateTime.tryParse(expirationDateStr);
    }, [subscriptionState]);

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: responsive.sPadding(const EdgeInsets.all(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: responsive.s(48),
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: responsive.s(16)),
                Text(
                  'Failed to load profile',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.s(8)),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.s(24)),
                ElevatedButton(
                  onPressed: () => ref.read(profileControllerProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profileState) {
          final profile = profileState.profile;

          return Stack(
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
                          name: profile.displayName,
                          email: userEmail,
                          avatarUrl: profile.avatarUrl,
                          onEditTap: () {
                            context.pushNamed(AppRouteNames.profilePersonalDetails);
                          },
                        ),
                      ),
                    ];
                  },
                  body: BlurryEdgeListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: responsive.sPadding(
                      EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 16 + logoutOverlayHeight,
                      ),
                    ),
                    topBlurEnabled: false,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return ProfilePremiumCard(
                            isPremium: isPremium,
                            subscriptionExpiryDate: subscriptionExpiryDate,
                            onManageTap: () {
                              context.pushNamed(AppRouteNames.subscriptionManagement);
                            },
                          );
                        case 1:
                          return SizedBox(height: responsive.s(24));
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
                          return SizedBox(height: responsive.s(24));
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
                  onLogoutTap: () => ProfileDialogs.showSignOutDialog(context, ref),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
