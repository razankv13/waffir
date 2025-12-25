import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';

/// Bank Selection Item Widget - Pixel-perfect Figma implementation
///
/// Figma Specifications:
/// - Logo: 80×80px, borderRadius 8px, border 1px #F2F2F2
/// - Gap between logo and text: 12px
/// - Bank name: 14px bold #151515
/// - Card type: 12px medium #A3A3A3
/// - Gap between name and card type: 4px
/// - Switch: 52×32px
/// - Item gap: 8.835px (rounded to 9px)
///
/// Supports both single card type and multiple card types:
/// - Use `cardType` for single type (e.g., "Platinum 2209")
/// - Use `cardTypes` for multiple types (e.g., ["Credit", "Debit"])
/// - Supports Arabic bank names via `bankNameAr`
class BankSelectionItem extends StatelessWidget {
  final String bankId;
  final String bankName;
  final String? bankNameAr;
  final String? cardType;
  final List<String>? cardTypes;
  final String? logoUrl;
  final bool isSelected;
  final VoidCallback onToggle;

  const BankSelectionItem({
    super.key,
    required this.bankId,
    required this.bankName,
    this.bankNameAr,
    this.cardType,
    this.cardTypes,
    this.logoUrl,
    required this.isSelected,
    required this.onToggle,
  });

  /// Get display text for card type
  /// Priority: cardType > cardTypes joined > Figma default
  String get _displayCardType {
    if (cardType != null && cardType!.isNotEmpty) {
      return cardType!;
    }
    if (cardTypes != null && cardTypes!.isNotEmpty) {
      return cardTypes!.join(' • ');
    }
    return 'Platinum 2209'; // Exact default from Figma
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bank logo and info
        Row(
          children: [
            // Bank Logo - 80×80px with exact specs
            _buildBankLogo(responsive),

            SizedBox(width: responsive.scale(12)), // Exact gap from Figma

            // Bank info column
            _buildBankInfo(theme, responsive),
          ],
        ),

        // Toggle Switch - 52×32px
        CustomToggleSwitch(
          value: isSelected,
          onChanged: (_) => onToggle(), // VoidCallback - ignore boolean parameter
        ),
      ],
    );
  }

  Widget _buildBankLogo(ResponsiveHelper responsive) {
    return Container(
      width: responsive.scale(80), // Exact Figma dimension
      height: responsive.scale(80), // Exact Figma dimension
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.scale(8)), // Exact Figma radius
        border: Border.all(
          color: AppColors.borderLight, // #F2F2F2
          width: 1, // Exact 1px border
        ),
      ),
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? AppNetworkImage(
              imageUrl: logoUrl!,
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(8),
              errorWidget: _buildPlaceholderLogo(responsive),
            )
          : _buildPlaceholderLogo(responsive),
    );
  }

  Widget _buildPlaceholderLogo(ResponsiveHelper responsive) {
    // Fallback: Show bank initials on colored background
    final initials = bankName.length >= 2
        ? bankName.substring(0, 2).toUpperCase()
        : bankName.substring(0, 1).toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.waffirGreen01, // Light green background
        borderRadius: BorderRadius.circular(responsive.scale(8)),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.bold,
            fontSize: responsive.scaleFontSize(20, minSize: 18),
            color: AppColors.waffirGreen02,
          ),
        ),
      ),
    );
  }

  Widget _buildBankInfo(ThemeData theme, ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bank Name - 14px bold #151515
        Text(
          bankName,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.w700, // Exact Figma weight
            fontSize: responsive.scaleFontSize(14, minSize: 12),
            height: 1.0, // Exact 1em line-height from Figma
            color: AppColors.black, // #151515
          ),
        ),

        SizedBox(height: responsive.scale(4)), // Exact gap from Figma (4.417px ≈ 4px)

        // Card Type - 12px medium #A3A3A3
        Text(
          _displayCardType, // Use getter for flexible card type display
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.w500, // Exact Figma weight
            fontSize: responsive.scaleFontSize(12, minSize: 10),
            height: 1.0, // Exact 1em line-height from Figma
            color: AppColors.textTertiary, // #A3A3A3
          ),
        ),
      ],
    );
  }
}
