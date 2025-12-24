import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_selection_provider.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_benefits_section.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_management_header.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:waffir/features/subscription/presentation/widgets/management/manage_subscription_view.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_options_section.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_proceed_button.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_promo_section.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

/// Subscription management screen with pixel-perfect Figma design
/// and Riverpod-managed UI state.
class SubscriptionManagementScreen extends HookConsumerWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(subscriptionSelectionProvider);
    final selectionNotifier = ref.read(subscriptionSelectionProvider.notifier);
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);
    final promoController = useTextEditingController();

    // Watch subscription status from provider
    final isSubscribed = ref.watch(isPremiumUserProvider);
    final isRevenueCatAvailable = ref.watch(isRevenueCatAvailableProvider);

    // Local state for purchase loading
    final isPurchasing = useState(false);

    // Debug mode override for testing UI states
    final debugOverrideSubscribed = useState<bool?>(null);
    final effectiveIsSubscribed = debugOverrideSubscribed.value ?? isSubscribed;

    Future<void> handleProceed(SubscriptionSelectionState currentSelection) async {
      // Check if RevenueCat is available
      if (!isRevenueCatAvailable) {
        _showErrorDialog(
          context,
          title: LocaleKeys.subscription.purchase.unavailable.tr(),
          message: LocaleKeys.subscription.purchase.serviceUnavailable.tr(),
        );
        return;
      }

      isPurchasing.value = true;

      try {
        final notifier = ref.read(subscriptionNotifierProvider.notifier);
        final result = await notifier.purchaseFromSelection(
          period: currentSelection.period,
          option: currentSelection.option,
        );

        if (!context.mounted) return;

        switch (result.type) {
          case PurchaseResultType.success:
            // Show success briefly and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.subscription.purchase.success.tr()),
                backgroundColor: theme.colorScheme.primary,
                duration: const Duration(seconds: 2),
              ),
            );
            // Wait a moment for user to see success message
            await Future.delayed(const Duration(milliseconds: 500));
            if (context.mounted) {
              context.pop();
            }

          case PurchaseResultType.cancelled:
            // User cancelled - do nothing, just dismiss loading
            AppLogger.info('Purchase cancelled by user');

          case PurchaseResultType.alreadySubscribed:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.subscription.purchase.alreadySubscribed.tr()),
                backgroundColor: theme.colorScheme.secondary,
              ),
            );

          case PurchaseResultType.noPackageAvailable:
            _showErrorDialog(
              context,
              title: LocaleKeys.subscription.purchase.unavailable.tr(),
              message: LocaleKeys.subscription.purchase.planNotAvailable.tr(),
            );

          case PurchaseResultType.notInitialized:
            _showErrorDialog(
              context,
              title: LocaleKeys.subscription.purchase.unavailable.tr(),
              message: LocaleKeys.subscription.purchase.serviceUnavailable.tr(),
            );

          case PurchaseResultType.networkError:
            _showRetryDialog(
              context,
              message: LocaleKeys.errors.networkError.tr(),
              onRetry: () => handleProceed(currentSelection),
            );

          case PurchaseResultType.error:
            _showErrorDialog(
              context,
              title: LocaleKeys.subscription.purchase.failed.tr(),
              message: result.message ?? LocaleKeys.errors.unknown.tr(),
            );
        }
      } catch (e) {
        AppLogger.error('Unexpected error in handleProceed', error: e);
        if (context.mounted) {
          _showErrorDialog(
            context,
            title: LocaleKeys.subscription.purchase.failed.tr(),
            message: LocaleKeys.errors.unknown.tr(),
          );
        }
      } finally {
        if (context.mounted) {
          isPurchasing.value = false;
        }
      }
    }

    Future<void> handleRestorePurchases() async {
      if (!isRevenueCatAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.subscription.purchase.serviceUnavailable.tr()),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        return;
      }

      isPurchasing.value = true;

      try {
        final notifier = ref.read(subscriptionNotifierProvider.notifier);
        final result = await notifier.restorePurchasesWithResult();

        if (!context.mounted) return;

        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.subscription.restore.success.tr()),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
          // If restoration found active subscription, navigate back after a delay
          await Future.delayed(const Duration(milliseconds: 500));
          if (context.mounted) {
            context.pop();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.subscription.restore.noPurchases.tr()),
              backgroundColor: theme.colorScheme.secondary,
            ),
          );
        }
      } catch (e) {
        AppLogger.error('Unexpected error in handleRestorePurchases', error: e);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.subscription.restore.failed.tr()),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      } finally {
        if (context.mounted) {
          isPurchasing.value = false;
        }
      }
    }

    void applyPromoCode(String promoCode) {
      final trimmedCode = promoCode.trim();
      if (trimmedCode.isEmpty) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.subscription.management.promo.applied.tr(namedArgs: {'code': trimmedCode}),
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // Temporary debug button to toggle subscription view (only in debug mode)
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                if (debugOverrideSubscribed.value == null) {
                  debugOverrideSubscribed.value = !isSubscribed;
                } else {
                  debugOverrideSubscribed.value = !debugOverrideSubscribed.value!;
                }
              },
              child: Icon(effectiveIsSubscribed ? Icons.check : Icons.close),
            )
          : null,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            _SubscriptionBackground(responsive: responsive),
            if (effectiveIsSubscribed)
              SingleChildScrollView(
                padding: responsive.scalePadding(const EdgeInsets.only(top: 108, bottom: 40)),
                child: const Center(child: ManageSubscriptionView()),
              )
            else
              SingleChildScrollView(
                padding: responsive.scalePadding(const EdgeInsets.only(top: 108, bottom: 160)),
                child: Padding(
                  padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
                  child: Column(
                    children: [
                      SubscriptionManagementHeader(selectedPeriod: selection.period),
                      SizedBox(height: responsive.scale(32)),
                      SubscriptionTabSwitcher(
                        selectedTab: selection.period,
                        onTabChanged: selectionNotifier.selectPeriod,
                      ),
                      SizedBox(height: responsive.scale(32)),
                      SubscriptionOptionsSection(
                        selection: selection,
                        onOptionSelected: selectionNotifier.selectOption,
                      ),
                      SizedBox(height: responsive.scale(13)),
                      const SubscriptionBenefitsSection(),
                      SizedBox(height: responsive.scale(32)),
                      Container(
                        width: responsive.scale(338),
                        height: 1,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      SizedBox(height: responsive.scale(32)),
                      SubscriptionPromoSection(
                        promoController: promoController,
                        onPromoChanged: selectionNotifier.updatePromoCode,
                        onApplyPromo: () => applyPromoCode(promoController.text),
                      ),
                    ],
                  ),
                ),
              ),
            WaffirBackButton(onTap: () => context.pop(), size: responsive.scale(44)),
            if (!effectiveIsSubscribed)
              SubscriptionProceedButton(
                onPressed: () => handleProceed(selection),
                isLoading: isPurchasing.value,
                onRestorePressed: handleRestorePurchases,
              ),
            // Loading overlay during purchase
            if (isPurchasing.value) _PurchaseLoadingOverlay(responsive: responsive),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.common.ok.tr()),
          ),
        ],
      ),
    );
  }

  void _showRetryDialog(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.errors.networkError.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.common.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: Text(LocaleKeys.common.retry.tr()),
          ),
        ],
      ),
    );
  }
}

/// Loading overlay shown during purchase operations
class _PurchaseLoadingOverlay extends StatelessWidget {
  const _PurchaseLoadingOverlay({required this.responsive});

  final ResponsiveHelper responsive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(
            child: Container(
              padding: responsive.scalePadding(const EdgeInsets.all(24)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: responsive.scale(40),
                    height: responsive.scale(40),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                  SizedBox(height: responsive.scale(16)),
                  Text(
                    LocaleKeys.subscription.purchase.processing.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: responsive.scaleFontSize(14, minSize: 12),
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionBackground extends StatelessWidget {
  const _SubscriptionBackground({required this.responsive});

  final ResponsiveHelper responsive;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: responsive.scale(-103.46),
      left: responsive.scale(-40),
      child: Container(
        width: responsive.scale(467.78),
        height: responsive.scale(477.28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00FF88).withValues(alpha: 0.15),
              const Color(0xFF00D9A3).withValues(alpha: 0.10),
              const Color(0xFF00C531).withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(responsive.scale(200)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.0))),
        ),
      ),
    );
  }
}
