import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final ValueChanged<SubscriptionOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isMonthly = selection.period == SubscriptionPeriod.monthly;

    return Column(
      children: [
        SubscriptionOptionCard(
          price: isMonthly ? '4 SAR / month' : '38 SAR / month',
          userInfo: '1 User',
          isMultiUser: false,
          isSelected: selection.option == SubscriptionOption.individual,
          onTap: () => onOptionSelected(SubscriptionOption.individual),
          badges: _individualBadges(isMonthly),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
        SizedBox(height: responsive.scale(24)),
        SubscriptionOptionCard(
          price: isMonthly ? '12 SAR / month' : '100 SAR / month',
          userInfo: 'Up to 4 Family Members',
          isMultiUser: true,
          isSelected: selection.option == SubscriptionOption.family,
          onTap: () => onOptionSelected(SubscriptionOption.family),
          badges: _familyBadges(isMonthly),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
      ],
    );
  }

  List<SubscriptionBadge> _individualBadges(bool isMonthly) {
    if (isMonthly) {
      return const [SubscriptionBadge(text: '1st Month Free', position: BadgePosition.left)];
    }

    return const [
      SubscriptionBadge(text: '20% OFF', position: BadgePosition.left),
      SubscriptionBadge(text: '1st Month Free', position: BadgePosition.center),
    ];
  }

  List<SubscriptionBadge> _familyBadges(bool isMonthly) {
    if (isMonthly) {
      return const [
        SubscriptionBadge(
          text: 'Best Value - 25% OFF',
          position: BadgePosition.left,
          isSpecial: true,
        ),
        SubscriptionBadge(text: '1st Month Free', position: BadgePosition.right),
      ];
    }

    return const [
      SubscriptionBadge(
        text: 'Best Value - 30% OFF',
        position: BadgePosition.left,
        isSpecial: true,
      ),
      SubscriptionBadge(text: '1st Month Free', position: BadgePosition.right),
    ];
  }
}
