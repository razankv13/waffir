import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/credit_cards/data/providers/credit_cards_providers.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';
import 'package:waffir/features/credit_cards/domain/repositories/bank_cards_repository.dart';

/// State for bank cards selection screen
class BankCardsState {
  const BankCardsState({
    required this.bankCards,
    required this.selectedCardIds,
    required this.searchQuery,
    required this.isSaving,
    this.saveFailure,
  });

  final List<BankCard> bankCards;
  final Set<String> selectedCardIds;
  final String searchQuery;
  final bool isSaving;
  final Failure? saveFailure;

  BankCardsState copyWith({
    List<BankCard>? bankCards,
    Set<String>? selectedCardIds,
    String? searchQuery,
    bool? isSaving,
    Failure? saveFailure,
  }) {
    return BankCardsState(
      bankCards: bankCards ?? this.bankCards,
      selectedCardIds: selectedCardIds ?? this.selectedCardIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
      saveFailure: saveFailure,
    );
  }

  /// Get bank cards filtered by search query
  List<BankCard> get filteredBankCards {
    if (searchQuery.isEmpty) return bankCards;

    final query = searchQuery.toLowerCase();
    return bankCards
        .where((card) {
          final nameEn = card.nameEn.toLowerCase();
          final nameAr = card.nameAr?.toLowerCase() ?? '';
          final bankName = card.bankName?.toLowerCase() ?? '';
          final bankNameAr = card.bankNameAr?.toLowerCase() ?? '';

          return nameEn.contains(query) ||
              nameAr.contains(query) ||
              bankName.contains(query) ||
              bankNameAr.contains(query);
        })
        .toList(growable: false);
  }

  /// Check if a card is selected
  bool isSelected(String cardId) => selectedCardIds.contains(cardId);

  /// Get count of selected cards
  int get selectedCount => selectedCardIds.length;

  /// Check if there are changes (dirty state)
  bool hasChanges(Set<String> originalIds) => selectedCardIds != originalIds;
}

/// Provider for bank cards controller
final bankCardsControllerProvider =
    AsyncNotifierProvider<BankCardsController, BankCardsState>(BankCardsController.new);

/// Controller for managing bank cards selection
class BankCardsController extends AsyncNotifier<BankCardsState> {
  BankCardsRepository get _repository => ref.read(bankCardsRepositoryProvider);

  Set<String> _originalSelectedIds = {};

  @override
  Future<BankCardsState> build() async {
    final languageCode = ref.watch(localeProvider).languageCode;

    // Fetch all bank cards
    final cardsResult = await _repository.fetchAllBankCards();

    // Fetch user's selected card IDs
    final selectedResult = await _repository.fetchUserSelectedCardIds();

    final bankCards = cardsResult.when(
      success: (cards) => cards,
      failure: (_) => const <BankCard>[],
    );

    final selectedIds = selectedResult.when(
      success: (ids) => ids,
      failure: (_) => const <String>{},
    );

    // Store original for dirty checking
    _originalSelectedIds = selectedIds;

    // Sort cards: selected first, then by name
    final sortedCards = _sortCards(bankCards, selectedIds, languageCode);

    return BankCardsState(
      bankCards: sortedCards,
      selectedCardIds: selectedIds,
      searchQuery: '',
      isSaving: false,
    );
  }

  /// Sort cards with selected first, then alphabetically
  List<BankCard> _sortCards(List<BankCard> cards, Set<String> selectedIds, String languageCode) {
    final sorted = [...cards];
    sorted.sort((a, b) {
      final aSelected = selectedIds.contains(a.id);
      final bSelected = selectedIds.contains(b.id);

      // Selected cards first
      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;

      // Then alphabetically by localized name
      return a.localizedName(languageCode).compareTo(b.localizedName(languageCode));
    });
    return sorted;
  }

  /// Refresh data from server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }

  /// Toggle card selection
  void toggleCard(String cardId) {
    final current = state.value;
    if (current == null) return;

    final updated = {...current.selectedCardIds};
    if (updated.contains(cardId)) {
      updated.remove(cardId);
    } else {
      updated.add(cardId);
    }

    state = AsyncValue.data(current.copyWith(selectedCardIds: updated));
  }

  /// Update search query
  void updateSearch(String query) {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(searchQuery: query.trim()));
  }

  /// Clear search query
  void clearSearch() {
    updateSearch('');
  }

  /// Select all cards
  void selectAll() {
    final current = state.value;
    if (current == null) return;

    final allIds = current.bankCards.map((c) => c.id).toSet();
    state = AsyncValue.data(current.copyWith(selectedCardIds: allIds));
  }

  /// Clear all selections
  void clearAll() {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(selectedCardIds: {}));
  }

  /// Save current selection to Supabase
  Future<bool> saveSelection() async {
    final current = state.value;
    if (current == null) return false;
    if (current.isSaving) return false;

    state = AsyncValue.data(current.copyWith(isSaving: true));

    final result = await _repository.setUserBankCards(current.selectedCardIds);

    return result.when(
      success: (_) {
        _originalSelectedIds = current.selectedCardIds;
        final next = state.value;
        if (next != null) {
          state = AsyncValue.data(next.copyWith(isSaving: false));
        }
        return true;
      },
      failure: (failure) {
        final next = state.value;
        if (next != null) {
          state = AsyncValue.data(next.copyWith(isSaving: false, saveFailure: failure));
        }
        return false;
      },
    );
  }

  /// Check if there are unsaved changes
  bool get hasUnsavedChanges {
    final current = state.value;
    if (current == null) return false;
    return current.selectedCardIds != _originalSelectedIds;
  }

  /// True if user has never saved card selections before.
  /// Used to show first-time confirmation flow.
  bool get isFirstTimeSelection => _originalSelectedIds.isEmpty;

  /// Revert to original selection
  void revertChanges() {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(
      current.copyWith(selectedCardIds: _originalSelectedIds),
    );
  }
}
