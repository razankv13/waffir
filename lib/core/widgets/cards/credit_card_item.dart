import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Credit Card List Item Widget
///
/// Displays credit card information in a list format with:
/// - Card image
/// - Card name and type
/// - Bank name
/// - Cashback/rewards info
/// - Annual fee
/// - Apply button
class CreditCardItem extends StatelessWidget {
  const CreditCardItem({
    super.key,
    required this.imageUrl,
    required this.cardName,
    required this.bankName,
    required this.cardType,
    this.cashbackPercentage,
    this.rewardPoints,
    required this.annualFee,
    this.benefits = const [],
    this.isPopular = false,
    this.isFeatured = false,
    this.onTap,
    this.onApply,
  });

  final String imageUrl;
  final String cardName;
  final String bankName;
  final String cardType;
  final double? cashbackPercentage;
  final int? rewardPoints;
  final int annualFee;
  final List<String> benefits;
  final bool isPopular;
  final bool isFeatured;
  final VoidCallback? onTap;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFeatured
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.outlineVariant,
            width: isFeatured ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.credit_card,
                            size: 64,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Featured/Popular Badge
                if (isFeatured || isPopular)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isFeatured
                            ? colorScheme.primary
                            : colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isFeatured ? 'FEATURED' : 'POPULAR',
                        style: AppTypography.labelSmall.copyWith(
                          color: isFeatured
                              ? colorScheme.onPrimary
                              : colorScheme.onTertiary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Card Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bank Name
                  Text(
                    bankName,
                    style: AppTypography.labelMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Card Name and Type
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cardName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          cardType,
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Cashback/Rewards Row
                  Row(
                    children: [
                      if (cashbackPercentage != null) ...[
                        _buildInfoChip(
                          context,
                          icon: Icons.account_balance_wallet,
                          label: '$cashbackPercentage% Cashback',
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (rewardPoints != null)
                        _buildInfoChip(
                          context,
                          icon: Icons.stars,
                          label: '$rewardPoints pts/SAR',
                          color: colorScheme.tertiary,
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Annual Fee
                  Row(
                    children: [
                      Icon(
                        Icons.credit_score,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Annual Fee: ',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        annualFee == 0 ? 'FREE' : 'SAR ${annualFee.toStringAsFixed(0)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: annualFee == 0
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Benefits (show first 2)
                  if (benefits.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...benefits.take(2).map(
                          (benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if (benefits.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+${benefits.length - 2} more benefits',
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],

                  const SizedBox(height: 16),

                  // Apply Button
                  if (onApply != null)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onApply,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Apply Now'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
