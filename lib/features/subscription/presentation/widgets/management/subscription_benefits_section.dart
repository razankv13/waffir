import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_benefit_item.dart';

class SubscriptionBenefitsSection extends StatelessWidget {
  const SubscriptionBenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 32)),
      child: Column(
        children: [
          const SubscriptionBenefitItem(text: 'Cancel anytime'),
          SizedBox(height: responsive.scale(8)),
          const SubscriptionBenefitItem(text: 'Daily verified discounts'),
          SizedBox(height: responsive.scale(8)),
          const SubscriptionBenefitItem(text: 'One app for all offers'),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, duration: 400.ms);
  }
}
