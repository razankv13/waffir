import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/credit_cards/data/datasources/bank_cards_remote_data_source.dart';
import 'package:waffir/features/credit_cards/data/datasources/supabase_bank_cards_remote_data_source.dart';
import 'package:waffir/features/credit_cards/data/models/bank_model.dart';
import 'package:waffir/features/credit_cards/data/models/credit_card_model.dart';
import 'package:waffir/features/credit_cards/data/mock_data/banks_mock_data.dart';
import 'package:waffir/features/credit_cards/data/repositories/bank_cards_repository_impl.dart';
import 'package:waffir/features/credit_cards/domain/repositories/bank_cards_repository.dart';

// =============================================================================
// Supabase Backend Providers
// =============================================================================

/// Provider for BankCards remote data source (Supabase)
final bankCardsRemoteDataSourceProvider = Provider<BankCardsRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseBankCardsRemoteDataSource(client);
});

/// Provider for BankCards repository
final bankCardsRepositoryProvider = Provider<BankCardsRepository>((ref) {
  final remote = ref.watch(bankCardsRemoteDataSourceProvider);
  return BankCardsRepositoryImpl(remote);
});

// =============================================================================
// Legacy Mock Data Providers (for backwards compatibility)
// =============================================================================

/// Provider for all banks
final banksProvider = Provider<List<BankModel>>((ref) {
  return BanksMockData.banks;
});

/// Provider for bank by ID
final bankByIdProvider = Provider.family<BankModel?, String>((ref, id) {
  return BanksMockData.getBankById(id);
});

/// Provider for all bank cards (updated name, uses new mock data)
final bankCardsProvider = Provider<List<BankCardModel>>((ref) {
  return BankCardsMockData.bankCards;
});

/// Provider for bank cards by bank ID
final bankCardsByBankProvider = Provider.family<List<BankCardModel>, String>((ref, bankId) {
  return BankCardsMockData.getCardsByBankId(bankId);
});

/// Legacy alias: Provider for all credit cards
final creditCardsProvider = Provider<List<CreditCardModel>>((ref) {
  return BankCardsMockData.bankCards;
});

/// Legacy alias: Provider for credit cards by bank ID
final creditCardsByBankProvider = Provider.family<List<CreditCardModel>, String>((ref, bankId) {
  return BankCardsMockData.getCardsByBankId(bankId);
});

/// State notifier for selected banks (for add card screen)
class SelectedBanksNotifier extends StateNotifier<Set<String>> {
  SelectedBanksNotifier() : super({});

  void toggleBank(String bankId) {
    if (state.contains(bankId)) {
      state = {...state}..remove(bankId);
    } else {
      state = {...state, bankId};
    }
  }

  void clearSelection() {
    state = {};
  }

  bool isSelected(String bankId) {
    return state.contains(bankId);
  }
}

/// Provider for selected banks
final selectedBanksProvider = StateNotifierProvider<SelectedBanksNotifier, Set<String>>((ref) {
  return SelectedBanksNotifier();
});
