import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/search/waffir_search_bar.dart';
import 'package:waffir/features/credit_cards/data/providers/credit_cards_providers.dart';
import 'package:waffir/features/credit_cards/presentation/widgets/bank_selection_item.dart';

/// Credit Cards Screen - Pixel-perfect Figma implementation
///
/// Figma Frame: Credit cards 01 (393×852px)
///
/// Layout Structure:
/// - Top padding: 90px
/// - Horizontal padding: 16px
/// - Bottom padding: 120px
/// - Section gap: 32px
/// - Header text gap: 16px
/// - Bank items gap: 16px
///
/// Features:
/// - Background decorative blur effect
/// - Header with title and subtitle
/// - Search bar with filter button
/// - Bank selection list with toggle switches
/// - Bottom navigation
class CreditCardsScreen extends ConsumerStatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  ConsumerState<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends ConsumerState<CreditCardsScreen> {
  String _searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final banks = ref.watch(banksProvider);
    final selectedBanks = ref.watch(selectedBanksProvider);

    // Filter banks by search query
    final filteredBanks = _searchQuery.isEmpty
        ? banks
        : banks.where((bank) {
            final nameLower = bank.name.toLowerCase();
            final nameArLower = bank.nameAr.toLowerCase();
            final cardTypesLower = bank.cardTypes?.map((t) => t.toLowerCase()).join(' ') ?? '';

            return nameLower.contains(_searchQuery) ||
                nameArLower.contains(_searchQuery) ||
                cardTypesLower.contains(_searchQuery);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.white, // Exact #FFFFFF from Figma
      body: Stack(
        children: [
          // Background decorative blur effect
          _buildBackgroundShape(responsive),

          // Main content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: responsive.scale(90)), // Exact top padding from Figma
                // Main content with horizontal padding
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.scale(16),
                    ), // Exact horizontal padding
                    child: Column(
                      children: [
                        // Header section
                        _buildHeader(responsive),

                        SizedBox(height: responsive.scale(32)), // Exact section gap from Figma
                        // Search bar
                        WaffirSearchBar(
                          hintText: 'Card, or Bank Name', // Exact text from Figma
                          onChanged: _handleSearch,
                          onSearch: _handleSearch,
                          onFilterTap: () {
                            // Filter functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Filter functionality coming soon')),
                            );
                          },
                        ),

                        SizedBox(height: responsive.scale(32)), // Exact section gap from Figma
                        // Banks list
                        Expanded(
                          child: filteredBanks.isEmpty
                              ? _buildEmptyState(responsive)
                              : ListView.separated(
                                  itemCount: filteredBanks.length,
                                  separatorBuilder: (context, index) => SizedBox(
                                    height: responsive.scale(16), // Exact gap from Figma
                                  ),
                                  itemBuilder: (context, index) {
                                    final bank = filteredBanks[index];
                                    final isSelected = selectedBanks.contains(bank.id);

                                    return BankSelectionItem(
                                      bankId: bank.id,
                                      bankName: bank.name,
                                      bankNameAr: bank.nameAr,
                                      cardTypes: bank.cardTypes, // Pass list directly
                                      logoUrl: bank.logoUrl,
                                      isSelected: isSelected,
                                      onToggle: () {
                                        ref
                                            .read(selectedBanksProvider.notifier)
                                            .toggleBank(bank.id);
                                      },
                                    );
                                  },
                                ),
                        ),

                        SizedBox(
                          height: responsive.scale(120),
                        ), // Exact bottom padding for nav clearance
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the decorative background blur effect
  ///
  /// Figma Specifications:
  /// - Position: X: -40px, Y: -100px
  /// - Size: 467.78 × 461.3px
  /// - Effect: blur(100px)
  Widget _buildBackgroundShape(ResponsiveHelper responsive) {
    return Positioned(
      left: responsive.scale(-40), // Exact X position from Figma
      top: responsive.scale(-100), // Exact Y position from Figma
      child: Container(
        width: responsive.scale(467.78), // Exact width from Figma
        height: responsive.scale(461.3), // Exact height from Figma
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.primaryColorLight.withValues(alpha: 0.4), // Light green with opacity
              AppColors.primaryColorLight.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), // Exact blur from Figma
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  /// Builds the header section with title and subtitle
  ///
  /// Figma Specifications:
  /// - Layout: Column, center-aligned
  /// - Gap between texts: 16px
  /// - Title: 18px bold, #151515, centered
  /// - Subtitle: 16px regular, #151515, centered, line-height 1.15
  Widget _buildHeader(ResponsiveHelper responsive) {
    return Column(
      children: [
        // Title - "Select Your\nCredit Card/Debit Card"
        Text(
          'Select Your\nCredit Card/Debit Card', // Exact text from Figma (2 lines)
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.w700, // Exact weight from Figma
            fontSize: responsive.scaleFontSize(18, minSize: 16),
            height: 1.0, // Exact 1em line-height from Figma
            color: AppColors.black, // #151515
          ),
        ),

        SizedBox(height: responsive.scale(16)), // Exact gap from Figma
        // Subtitle
        Text(
          'Please note: you only need to select your card type - you will not be asked to provide any other details.', // Exact text from Figma
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.w400, // Exact weight from Figma
            fontSize: responsive.scaleFontSize(16, minSize: 14),
            height: 1.15, // Exact line-height from Figma (1.149999976158142 ≈ 1.15)
            color: AppColors.black, // #151515
          ),
        ),
      ],
    );
  }

  /// Builds the empty state when no banks are found
  Widget _buildEmptyState(ResponsiveHelper responsive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: responsive.scale(80),
            color: AppColors.textTertiary.withValues(alpha: 0.5),
          ),
          SizedBox(height: responsive.scale(16)),
          Text(
            'No banks found',
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(18, minSize: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: responsive.scale(8)),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(14, minSize: 12),
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
