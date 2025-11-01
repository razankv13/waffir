import 'package:flutter/material.dart';

/// Discount tag pill widget - pill-shaped discount badge
///
/// Displays discount percentage in a rounded pill shape matching Figma design.
/// Background: #DCFCE7 (light green), Text: #0F352D (dark green)
///
/// Example usage:
/// ```dart
/// DiscountTagPill(
///   discountText: '20% off',
/// )
/// ```
class DiscountTagPill extends StatelessWidget {
  const DiscountTagPill({
    super.key,
    required this.discountText,
    this.showIcon = true,
  });

  final String discountText;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7), // Light green from Figma
        borderRadius: BorderRadius.circular(100), // Fully rounded pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            // Tag icon (16×16px)
            const Icon(
              Icons.local_offer,
              size: 16,
              color: Color(0xFF0F352D),
            ),
            const SizedBox(width: 4), // Gap between icon and text
          ],
          Text(
            discountText,
            style: const TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: 12,
              fontWeight: FontWeight.w500, // Medium
              height: 1.15, // Line height from Figma
              color: Color(0xFF0F352D), // Dark green from Figma
            ),
          ),
        ],
      ),
    );
  }
}
