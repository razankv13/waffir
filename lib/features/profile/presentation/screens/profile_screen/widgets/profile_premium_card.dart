import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';

/// Premium Plan Card Widget
///
/// Displays user's subscription status with premium icon, plan details,
/// and manage subscription button.
///
/// **Figma Specs** (Node 34:3087):
/// - Card padding: 16px
/// - Icon size: 32×32px circular
/// - Gap icon-to-text: 12px
/// - Gap title-to-subtitle: 8px
/// - Gap content-to-button: 16px
/// - Background: #F2F2F2 (gray01)
///
/// **Usage:**
/// ```dart
/// ProfilePremiumCard(
///   isPremium: true,
///   subscriptionExpiryDate: DateTime(2023, 12, 31),
///   onManageTap: () => navigateToSubscriptionManagement(),
/// )
/// ```
class ProfilePremiumCard extends StatelessWidget {
  const ProfilePremiumCard({
    super.key,
    required this.isPremium,
    this.subscriptionExpiryDate,
    required this.onManageTap,
  });

  /// Whether the user has an active premium subscription
  final bool isPremium;

  /// Optional subscription expiry date (only shown for premium users)
  final DateTime? subscriptionExpiryDate;

  /// Callback when manage subscription button is tapped
  final VoidCallback onManageTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);

    return ProfileCard(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Row: Icon LEFT, Text RIGHT (exact from Figma)
          Row(
            children: [
              // Premium Icon: 32×32px circular, #0F352D background (exact from Figma)
              Container(
                width: responsive.scale(32),
                height: responsive.scale(32),
                decoration: BoxDecoration(
                  color: colorScheme.primary, // #0F352D
                  borderRadius: responsive.scaleBorderRadius(
                    BorderRadius.circular(727), // Circular from Figma
                  ),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: colorScheme.surface, // White
                  size: responsive.scale(18),
                ),
              ),

              // Gap between icon and text: 12px (exact from Figma)
              SizedBox(width: responsive.scale(12)),

              // Title and subtitle column (text on RIGHT per Figma)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // LEFT aligned per Figma
                  children: [
                    // Title: "Premium Plan" / "Free Plan" - 16px weight 700, line-height 1em
                    Text(
                      isPremium ? 'Premium Plan' : 'Free Plan',
                      style: AppTypography.premiumTitle.copyWith(
                        color: colorScheme.onSurface, // #151515
                        fontSize: responsive.scaleFontSize(16, minSize: 14),
                      ),
                    ),

                    // Gap: 8px (exact from Figma) - Only show if premium with expiry date
                    if (isPremium && subscriptionExpiryDate != null)
                      SizedBox(height: responsive.scale(8)),

                    // Subtitle: "Valid until Dec 2023" - 12px weight 400, line-height 1em
                    if (isPremium && subscriptionExpiryDate != null)
                      Text(
                        _formatExpiryDate(subscriptionExpiryDate!),
                        style: AppTypography.premiumSubtitle.copyWith(
                          color: colorScheme.onSurface, // #151515
                          fontSize: responsive.scaleFontSize(12, minSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Gap: 16px (exact from Figma)
          SizedBox(height: responsive.scale(16)),

          // Manage Subscription Button (Secondary style, full width)
          AppButton.secondary(
            onPressed: onManageTap,
            child: Text(isPremium ? 'Manage Subscription' : 'Upgrade to Premium'),
          ),
        ],
      ),
    );
  }

  /// Formats expiry date to "Valid until MMM YYYY" format
  ///
  /// Example: DateTime(2023, 12, 15) → "Valid until Dec 2023"
  String _formatExpiryDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = months[date.month - 1];
    return 'Valid until $monthName ${date.year}';
  }
}
