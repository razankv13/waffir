import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/features/credit_cards/data/models/bank_model.dart';
import 'package:waffir/features/credit_cards/data/models/credit_card_model.dart';
import 'package:waffir/features/credit_cards/data/mock_data/banks_mock_data.dart';

/// Provider for all banks
final banksProvider = Provider<List<BankModel>>((ref) {
  return BanksMockData.banks;
});

/// Provider for popular banks
final popularBanksProvider = Provider<List<BankModel>>((ref) {
  return BanksMockData.popularBanks;
});

/// Provider for bank by ID
final bankByIdProvider = Provider.family<BankModel?, String>((ref, id) {
  return BanksMockData.getBankById(id);
});

/// Provider for all credit cards
final creditCardsProvider = Provider<List<CreditCardModel>>((ref) {
  return CreditCardsMockData.creditCards;
});

/// Provider for featured credit cards
final featuredCreditCardsProvider = Provider<List<CreditCardModel>>((ref) {
  return CreditCardsMockData.featuredCards;
});

/// Provider for popular credit cards
final popularCreditCardsProvider = Provider<List<CreditCardModel>>((ref) {
  return CreditCardsMockData.popularCards;
});

/// Provider for credit cards by bank ID
final creditCardsByBankProvider = Provider.family<List<CreditCardModel>, String>((ref, bankId) {
  return CreditCardsMockData.getCardsByBankId(bankId);
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
