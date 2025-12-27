import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_selection_provider.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_option_card.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

class SubscriptionOptionsSection extends StatelessWidget {
  const SubscriptionOptionsSection({
    super.key,
    required this.selection,
    required this.onOptionSelected,
  });

  final SubscriptionSelectionState selection;
  final ValueChanged<AppSubscriptionOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final isMonthly = selection.period == SubscriptionPeriod.monthly;

    final individualPrices = LocaleKeys.subscription.management.options.individual;
    final familyPrices = LocaleKeys.subscription.management.options.family;

    return Column(
      children: [
        SubscriptionOptionCard(
          price: isMonthly
              ? individualPrices.priceMonthly.tr()
              : individualPrices.priceYearly.tr(),
          userInfo: individualPrices.users.tr(),
          isMultiUser: false,
          isSelected: selection.option == AppSubscriptionOption.individual,
          onTap: () => onOptionSelected(AppSubscriptionOption.individual),
          badges: _individualBadges(isMonthly),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
        SizedBox(height: responsive.s(24)),
        SubscriptionOptionCard(
          price: isMonthly
              ? familyPrices.priceMonthly.tr()
              : familyPrices.priceYearly.tr(),
          userInfo: familyPrices.users.tr(),
          isMultiUser: true,
          isSelected: selection.option == AppSubscriptionOption.family,
          onTap: () => onOptionSelected(AppSubscriptionOption.family),
          badges: _familyBadges(isMonthly),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
      ],
    );
  }

  List<SubscriptionBadge> _individualBadges(bool isMonthly) {
    if (isMonthly) {
      return [
        SubscriptionBadge(
          text: LocaleKeys.subscription.management.badges.firstMonthFree.tr(),
          position: BadgePosition.left,
        ),
      ];
    }

    return [
      SubscriptionBadge(
        text: LocaleKeys.subscription.management.badges.discount20.tr(),
        position: BadgePosition.left,
      ),
      SubscriptionBadge(
        text: LocaleKeys.subscription.management.badges.firstMonthFree.tr(),
        position: BadgePosition.center,
      ),
    ];
  }

  List<SubscriptionBadge> _familyBadges(bool isMonthly) {
    if (isMonthly) {
      return [
        SubscriptionBadge(
          text: LocaleKeys.subscription.management.badges.bestValue25.tr(),
          position: BadgePosition.left,
          isSpecial: true,
        ),
        SubscriptionBadge(
          text: LocaleKeys.subscription.management.badges.firstMonthFree.tr(),
          position: BadgePosition.right,
        ),
      ];
    }

    return [
      SubscriptionBadge(
        text: LocaleKeys.subscription.management.badges.bestValue30.tr(),
        position: BadgePosition.left,
        isSpecial: true,
      ),
      SubscriptionBadge(
        text: LocaleKeys.subscription.management.badges.firstMonthFree.tr(),
        position: BadgePosition.right,
      ),
    ];
  }
}
