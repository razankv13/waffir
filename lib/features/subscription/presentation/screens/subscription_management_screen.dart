import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_benefit_item.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_option_card.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

/// Subscription management screen with pixel-perfect Figma design
///
/// Allows users to select and purchase subscription plans (Monthly or Yearly)
/// with Individual or Family options.
class SubscriptionManagementScreen extends ConsumerStatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  ConsumerState<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends ConsumerState<SubscriptionManagementScreen> {
  SubscriptionPeriod _selectedPeriod = SubscriptionPeriod.monthly;
  SubscriptionOption _selectedOption = SubscriptionOption.individual;
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Blurred gradient background shape (matches Figma)
            Positioned(
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
            ),
            // Main scrollable content
            SingleChildScrollView(
              padding: responsive.scalePadding(const EdgeInsets.only(top: 108, bottom: 120)),
              child: Padding(
                padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
                child: Column(
                  children: [
                    // Header section
                    _buildHeader(context, responsive, theme),
                    SizedBox(height: responsive.scale(32)),

                    // Tab switcher
                    SubscriptionTabSwitcher(
                      selectedTab: _selectedPeriod,
                      onTabChanged: (period) {
                        setState(() => _selectedPeriod = period);
                      },
                    ),
                    SizedBox(height: responsive.scale(32)),

                    // Subscription options
                    _buildSubscriptionOptions(context, responsive),
                    SizedBox(height: responsive.scale(13)),

                    // Benefits list
                    _buildBenefitsList(context, responsive),
                    SizedBox(height: responsive.scale(32)),

                    // Divider
                    Container(
                      width: responsive.scale(338),
                      height: 1,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    SizedBox(height: responsive.scale(32)),

                    // Promo code section
                    _buildPromoSection(context, responsive, theme),
                  ],
                ),
              ),
            ),

            // Back button (top left)
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: responsive.scalePadding(const EdgeInsets.only(top: 64, left: 16)),
                child: WaffirBackButton(onTap: () => context.pop(), size: responsive.scale(44)),
              ),
            ),

            // Proceed button (bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: theme.colorScheme.surface,
                padding: responsive.scalePadding(const EdgeInsets.all(16)),
                child: Center(
                  child: Container(
                    width: responsive.scale(330),
                    height: responsive.scale(48),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F352D).withOpacity(0.15),
                          offset: const Offset(0, 8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: AppButton.primary(
                      onPressed: _handleProceed,
                      child: Text(
                        'Proceed',
                        style: AppTypography.labelLarge.copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveHelper responsive, ThemeData theme) {
    return Column(
      children: [
        // Title
        Text(
          'You just got "One" month free',
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            fontSize: responsive.scaleFontSize(18, minSize: 16),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        SizedBox(height: responsive.scale(16)),
        // Subtitle
        SizedBox(
          width: _selectedPeriod == SubscriptionPeriod.monthly
              ? responsive.scale(243)
              : responsive.scale(323),
          child: Text(
            'Continue to start your free month and confirm your plan.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: responsive.scaleFontSize(16, minSize: 14),
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, duration: 400.ms);
  }

  Widget _buildSubscriptionOptions(BuildContext context, ResponsiveHelper responsive) {
    return Column(
      children: [
        // Individual option
        SubscriptionOptionCard(
          price: _selectedPeriod == SubscriptionPeriod.monthly ? '4 SAR / month' : '38 SAR / month',
          userInfo: '1 User',
          isMultiUser: false,
          isSelected: _selectedOption == SubscriptionOption.individual,
          onTap: () {
            setState(() => _selectedOption = SubscriptionOption.individual);
          },
          badges: _getIndividualBadges(),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
        SizedBox(height: responsive.scale(24)),
        // Family option
        SubscriptionOptionCard(
          price: _selectedPeriod == SubscriptionPeriod.monthly
              ? '12 SAR / month'
              : '100 SAR / month',
          userInfo: 'Up to 4 Family Members',
          isMultiUser: true,
          isSelected: _selectedOption == SubscriptionOption.family,
          onTap: () {
            setState(() => _selectedOption = SubscriptionOption.family);
          },
          badges: _getFamilyBadges(),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.2, duration: 400.ms),
      ],
    );
  }

  List<SubscriptionBadge> _getIndividualBadges() {
    if (_selectedPeriod == SubscriptionPeriod.monthly) {
      return const [SubscriptionBadge(text: '1st Month Free', position: BadgePosition.left)];
    } else {
      // Yearly
      return const [
        SubscriptionBadge(text: '20% OFF', position: BadgePosition.left),
        SubscriptionBadge(text: '1st Month Free', position: BadgePosition.center),
      ];
    }
  }

  List<SubscriptionBadge> _getFamilyBadges() {
    if (_selectedPeriod == SubscriptionPeriod.monthly) {
      return const [
        SubscriptionBadge(
          text: 'Best Value - 25% OFF',
          position: BadgePosition.left,
          isSpecial: true,
        ),
        SubscriptionBadge(text: '1st Month Free', position: BadgePosition.right),
      ];
    } else {
      // Yearly
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

  Widget _buildBenefitsList(BuildContext context, ResponsiveHelper responsive) {
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

  Widget _buildPromoSection(BuildContext context, ResponsiveHelper responsive, ThemeData theme) {
    return Column(
      children: [
        // Promo question
        SizedBox(
          width: responsive.scale(243),
          child: Text(
            'Do you have a promo code?',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: responsive.scaleFontSize(16, minSize: 14),
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: responsive.scale(16)),
        // Promo input with button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field
            Container(
              width: responsive.scale(232),
              height: responsive.scale(56),
              padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(16)),
              ),
              child: Center(
                child: TextField(
                  controller: _promoController,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: responsive.scaleFontSize(16, minSize: 14),
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Apply Promo Code',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      fontSize: responsive.scaleFontSize(16, minSize: 14),
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.scale(11)),
            // Arrow button
            GestureDetector(
              onTap: _applyPromoCode,
              child: Container(
                width: responsive.scale(44),
                height: responsive.scale(44),
                decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_forward,
                  size: responsive.scale(20),
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2, duration: 400.ms);
  }

  void _handleProceed() {
    // Get subscription notifier
    final subscriptionNotifier = ref.read(subscriptionNotifierProvider.notifier);

    // TODO: Implement actual subscription purchase logic
    // This would involve:
    // 1. Determining the package ID based on selected period and option
    // 2. Calling subscriptionNotifier.purchasePackage(package)
    // 3. Handling success/error states
    // 4. Navigating to success screen or showing error

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${_selectedPeriod == SubscriptionPeriod.monthly ? 'Monthly' : 'Yearly'} - '
          '${_selectedOption == SubscriptionOption.individual ? 'Individual' : 'Family'}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _applyPromoCode() {
    final promoCode = _promoController.text.trim();
    if (promoCode.isEmpty) return;

    // TODO: Implement promo code validation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo code "$promoCode" applied!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Subscription option enum
enum SubscriptionOption { individual, family }
