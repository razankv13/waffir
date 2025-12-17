import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_selection_provider.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_benefits_section.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/subscription_management_header.dart';
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
    final monthlyLabel = LocaleKeys.subscription.management.tabs.monthly.tr();
    final yearlyLabel = LocaleKeys.subscription.management.tabs.yearlySaveMore.tr();
    final yearlyLabelInline = yearlyLabel.replaceAll('\n', ' ');

    void handleProceed(SubscriptionSelectionState currentSelection) {
      ref.read(subscriptionNotifierProvider.notifier);

      // TODO: Implement actual subscription purchase logic
      // 1. Determine package based on selection
      // 2. Call subscriptionNotifier.purchasePackage(package)
      // 3. Handle loading/success/error UI

      final periodLabel =
          currentSelection.period == SubscriptionPeriod.monthly ? monthlyLabel : yearlyLabelInline;
      final optionLabel = currentSelection.option == SubscriptionOption.individual
          ? LocaleKeys.subscription.management.options.individual.name.tr()
          : LocaleKeys.subscription.management.options.family.name.tr();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.subscription.management.selection.tr(
              namedArgs: {'period': periodLabel, 'option': optionLabel},
            ),
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
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
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            _SubscriptionBackground(responsive: responsive),
            SingleChildScrollView(
              padding: responsive.scalePadding(const EdgeInsets.only(top: 108, bottom: 120)),
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
            SubscriptionProceedButton(onPressed: () => handleProceed(selection)),
          ],
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
              const Color(0xFF00FF88).withOpacity(0.15),
              const Color(0xFF00D9A3).withOpacity(0.10),
              const Color(0xFF00C531).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(responsive.scale(200)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.0))),
        ),
      ),
    );
  }
}
