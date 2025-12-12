import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/features/credit_cards/data/providers/credit_cards_providers.dart';
import 'package:waffir/features/credit_cards/presentation/widgets/bank_selection_item.dart';

/// Add Credit Card Screen - allows users to select banks for credit card tracking
///
/// Features:
/// - List of all banks with toggle switches
/// - Multiple bank selection
/// - Popular banks section
/// - Continue button to add selected banks
class AddCreditCardScreen extends ConsumerWidget {
  const AddCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final allBanks = ref.watch(banksProvider);
    final popularBanks = ref.watch(popularBanksProvider);
    final selectedBanks = ref.watch(selectedBanksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Credit Cards',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select Your Banks',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the banks where you have credit cards. We\'ll track offers and benefits for your selected cards.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Banks List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Popular Banks Section
                if (popularBanks.isNotEmpty) ...[
                  _buildSectionHeader(
                    context,
                    'Popular Banks',
                    popularBanks.length,
                  ),
                  const SizedBox(height: 12),
                  ...popularBanks.map(
                    (bank) => BankSelectionItem(
                      bankId: bank.id,
                      bankName: bank.name,
                      bankNameAr: bank.nameAr,
                      logoUrl: bank.logoUrl,
                      cardTypes: bank.cardTypes ?? [],
                      isSelected: selectedBanks.contains(bank.id),
                      onToggle: () {
                        ref
                            .read(selectedBanksProvider.notifier)
                            .toggleBank(bank.id);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // All Banks Section
                _buildSectionHeader(
                  context,
                  'All Banks',
                  allBanks.length,
                ),
                const SizedBox(height: 12),
                ...allBanks.map(
                  (bank) => BankSelectionItem(
                    bankId: bank.id,
                    bankName: bank.name,
                    bankNameAr: bank.nameAr,
                    logoUrl: bank.logoUrl,
                    cardTypes: bank.cardTypes ?? [],
                    isSelected: selectedBanks.contains(bank.id),
                    onToggle: () {
                      ref
                          .read(selectedBanksProvider.notifier)
                          .toggleBank(bank.id);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selection Summary
                  if (selectedBanks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedBanks.length} ${selectedBanks.length == 1 ? 'bank' : 'banks'} selected',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(selectedBanksProvider.notifier)
                                  .clearSelection();
                            },
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    ),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: selectedBanks.isEmpty
                          ? null
                          : () {
                              // TODO: Handle adding cards
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added ${selectedBanks.length} ${selectedBanks.length == 1 ? 'bank' : 'banks'} for tracking',
                                  ),
                                ),
                              );
                              // Clear selection and go back
                              ref
                                  .read(selectedBanksProvider.notifier)
                                  .clearSelection();
                              context.pop();
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: selectedBanks.isEmpty
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.primary,
                        foregroundColor: selectedBanks.isEmpty
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        selectedBanks.isEmpty
                            ? 'Select at least one bank'
                            : 'Continue',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          '$count ${count == 1 ? 'bank' : 'banks'}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
