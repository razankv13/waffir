import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/navigation/page_transitions.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/navigation/screens/error_screen.dart';
import 'package:waffir/core/navigation/widgets/main_shell.dart';

import 'package:waffir/features/auth/presentation/screens/account_details_screen.dart';
import 'package:waffir/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:waffir/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:waffir/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:waffir/features/auth/presentation/screens/signup_screen.dart';
import 'package:waffir/features/credit_cards/presentation/screens/add_credit_card_screen.dart';
import 'package:waffir/features/credit_cards/presentation/screens/credit_cards_screen.dart';
import 'package:waffir/features/deals/presentation/screens/hot_deals_screen.dart';
import 'package:waffir/features/deals/presentation/screens/notifications_screen.dart';
import 'package:waffir/features/onboarding/presentation/screens/city_selection_screen.dart';
import 'package:waffir/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:waffir/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:waffir/features/products/presentation/screens/product_detail_screen.dart';
import 'package:waffir/features/profile/presentation/screens/change_city_screen.dart';
import 'package:waffir/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:waffir/features/profile/presentation/screens/favorites_screen.dart';
import 'package:waffir/features/profile/presentation/screens/help_center_screen.dart';
import 'package:waffir/features/profile/presentation/screens/language_selection_screen.dart';
import 'package:waffir/features/profile/presentation/screens/my_account.dart';
import 'package:waffir/features/profile/presentation/screens/manage_personal_details_form_screen.dart';
import 'package:waffir/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:waffir/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/profile_screen.dart';
import 'package:waffir/features/profile/presentation/screens/saved_deals_screen.dart';
import 'package:waffir/features/settings/presentation/screens/privacy_settings_screen.dart';
import 'package:waffir/features/settings/presentation/screens/settings_screen.dart';
import 'package:waffir/features/settings/presentation/screens/theme_settings_screen.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_screen.dart';
import 'package:waffir/features/stores/presentation/screens/stores_screen.dart';
import 'package:waffir/features/subscription/presentation/screens/paywall_screen.dart';
import 'package:waffir/features/subscription/presentation/screens/subscription_management_screen.dart';

/// Builds the full GoRouter route table.
///
/// This is extracted to keep `app_router.dart` focused on wiring providers/guards.
List<RouteBase> buildAppRoutes({required GlobalKey<NavigatorState> shellNavigatorKey}) {
  return [
    // Splash Screen
    GoRoute(
      path: AppRoutes.splash,
      name: AppRouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // City Selection
    GoRoute(
      path: AppRoutes.citySelection,
      name: AppRouteNames.citySelection,
      builder: (context, state) => const CitySelectionScreen(),
    ),

    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Authentication Routes (No shell)
    GoRoute(
      path: AppRoutes.login,
      name: AppRouteNames.login,
      builder: (context, state) => const PhoneLoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.signup,
      name: AppRouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: AppRoutes.otpVerification,
      name: AppRouteNames.otpVerification,
      builder: (context, state) {
        final phoneNumber = state.extra as Map<String, dynamic>?;
        return OtpVerificationScreen(
          phoneNumber: phoneNumber?['phoneNumber'] ?? '',
          verificationId: phoneNumber?['verificationId'] ?? '',
        );
      },
    ),

    GoRoute(
      path: AppRoutes.accountDetails,
      name: AppRouteNames.accountDetails,
      builder: (context, state) => const AccountDetailsScreen(),
    ),

    // Main App Shell
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        // Deals (Hot Deals)
        GoRoute(
          path: AppRoutes.deals,
          name: AppRouteNames.deals,
          pageBuilder: (context, state) => AppPageTransitions.fadeScale<void>(
            state: state,
            child: const HotDealsScreen(),
          ),
        ),

        // Stores
        GoRoute(
          path: AppRoutes.stores,
          name: AppRouteNames.stores,
          pageBuilder: (context, state) => AppPageTransitions.fadeScale<void>(
            state: state,
            child: const StoresScreen(),
          ),
        ),

        // Credit Cards
        GoRoute(
          path: AppRoutes.creditCards,
          name: AppRouteNames.creditCards,
          pageBuilder: (context, state) => AppPageTransitions.fadeScale<void>(
            state: state,
            child: const CreditCardsScreen(),
          ),
          routes: [
            // Add Credit Card sub-route
            GoRoute(
              path: '/add',
              name: AppRouteNames.addCreditCard,
              builder: (context, state) => const AddCreditCardScreen(),
            ),
          ],
        ),

        // Profile
        GoRoute(
          path: AppRoutes.profile,
          name: AppRouteNames.profile,
          pageBuilder: (context, state) => AppPageTransitions.fadeScale<void>(
            state: state,
            child: const ProfileScreen(),
          ),
          routes: [
            // Profile sub-routes
            GoRoute(
              path: '/edit',
              name: AppRouteNames.profileEdit,
              builder: (context, state) => const ProfileEditScreen(),
            ),
            GoRoute(
              path: '/my-account',
              name: AppRouteNames.profileMyAccount,
              builder: (context, state) => const MyAccount(),
            ),
            GoRoute(
              path: '/personal-details',
              name: AppRouteNames.profilePersonalDetails,
              builder: (context, state) => const ManagePersonalDetailsFormScreen(),
            ),
            GoRoute(
              path: '/saved-deals',
              name: AppRouteNames.profileSavedDeals,
              builder: (context, state) => const SavedDealsScreen(),
            ),
            GoRoute(
              path: '/favorites',
              name: AppRouteNames.profileFavorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: '/change-city',
              name: AppRouteNames.profileChangeCity,
              builder: (context, state) {
                final showBackButton = state.extra is bool ? state.extra as bool : true;
                return ChangeCityScreen(showBackButton: showBackButton);
              },
            ),
            GoRoute(
              path: '/language',
              name: AppRouteNames.profileLanguage,
              builder: (context, state) => const LanguageSelectionScreen(),
            ),
            GoRoute(
              path: '/help-center',
              name: AppRouteNames.profileHelpCenter,
              builder: (context, state) => const HelpCenterScreen(),
            ),
            GoRoute(
              path: '/delete-account',
              name: AppRouteNames.profileDeleteAccount,
              builder: (context, state) => const DeleteAccountScreen(),
            ),
            GoRoute(
              path: '/selected-credit-cards',
              name: AppRouteNames.profileSelectedCreditCards,
              builder: (context, state) => const CreditCardsScreen(showBackButton: true),
            ),
          ],
        ),
      ],
    ),

    // Settings (Outside shell - accessible from Profile or AppBar)
    GoRoute(
      path: AppRoutes.settings,
      name: AppRouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        // Settings sub-routes
        GoRoute(
          path: '/notifications',
          name: AppRouteNames.notificationSettings,
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/theme',
          name: AppRouteNames.themeSettings,
          builder: (context, state) => const ThemeSettingsScreen(),
        ),
        GoRoute(
          path: '/privacy',
          name: AppRouteNames.privacySettings,
          builder: (context, state) => const PrivacySettingsScreen(),
        ),
      ],
    ),

    // Root redirect to Deals (default home)
    GoRoute(path: '/', redirect: (context, state) => AppRoutes.deals),

    // Notifications (Outside shell - full screen experience)
    GoRoute(
      path: AppRoutes.notifications,
      name: AppRouteNames.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Subscription Routes (Outside shell for fullscreen experience)
    GoRoute(
      path: AppRoutes.paywall,
      name: AppRouteNames.paywall,
      builder: (context, state) => const PaywallScreen(),
    ),

    GoRoute(
      path: AppRoutes.subscriptionManagement,
      name: AppRouteNames.subscriptionManagement,
      builder: (context, state) => const SubscriptionManagementScreen(),
    ),

    // Product Routes
    GoRoute(
      path: '/product/:id',
      name: AppRouteNames.productDetail,
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),

    GoRoute(
      path: '/store/:id',
      name: AppRouteNames.storeDetail,
      builder: (context, state) {
        final storeId = state.pathParameters['id']!;
        return StoreDetailScreen(storeId: storeId);
      },
    ),

    // Error/Not Found Route
    GoRoute(
      path: '/error',
      name: AppRouteNames.error,
      builder: (context, state) {
        final error = state.extra as String?;
        return ErrorScreen(error: error ?? 'Unknown error occurred');
      },
    ),
  ];
}
