import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/locale_keys.dart';
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
          SubscriptionBenefitItem(text: LocaleKeys.subscription.management.benefits.cancelAnytime.tr()),
          SizedBox(height: responsive.scale(8)),
          SubscriptionBenefitItem(text: LocaleKeys.subscription.management.benefits.dailyVerified.tr()),
          SizedBox(height: responsive.scale(8)),
          SubscriptionBenefitItem(text: LocaleKeys.subscription.management.benefits.oneApp.tr()),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, duration: 400.ms);
  }
}
