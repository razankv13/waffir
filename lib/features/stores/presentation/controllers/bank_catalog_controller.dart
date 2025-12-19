import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';
import 'package:waffir/features/stores/domain/repositories/bank_catalog_repository.dart';
import 'package:waffir/features/stores/presentation/controllers/offset_paginated_list_controller.dart';

class BankCatalogState {
  const BankCatalogState({
    required this.banks,
    required this.bankCards,
    required this.myBankCards,
    required this.selectedBankId,
    required this.selectedCategoryId,
    required this.selectedBankCardIds,
    required this.offers,
    required this.searchQuery,
    required this.isLoadingOffers,
    required this.hasMore,
    required this.isLoadingMore,
    required this.isSavingCards,
    this.offersFailure,
    this.lastActionFailure,
  });

  final List<CatalogBank> banks;
  final List<CatalogBankCard> bankCards;
  final List<MyBankCard> myBankCards;
  final String? selectedBankId;
  final String? selectedCategoryId;
  final Set<String> selectedBankCardIds;
  final List<BankOffer> offers;
  final String searchQuery;
  final bool isLoadingOffers;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSavingCards;
  final Failure? offersFailure;
  final Failure? lastActionFailure;

  BankCatalogState copyWith({
    List<CatalogBank>? banks,
    List<CatalogBankCard>? bankCards,
    List<MyBankCard>? myBankCards,
    String? selectedBankId,
    String? selectedCategoryId,
    Set<String>? selectedBankCardIds,
    List<BankOffer>? offers,
    String? searchQuery,
    bool? isLoadingOffers,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSavingCards,
    Failure? offersFailure,
    Failure? lastActionFailure,
  }) {
    return BankCatalogState(
      banks: banks ?? this.banks,
      bankCards: bankCards ?? this.bankCards,
      myBankCards: myBankCards ?? this.myBankCards,
      selectedBankId: selectedBankId ?? this.selectedBankId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedBankCardIds: selectedBankCardIds ?? this.selectedBankCardIds,
      offers: offers ?? this.offers,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingOffers: isLoadingOffers ?? this.isLoadingOffers,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSavingCards: isSavingCards ?? this.isSavingCards,
      offersFailure: offersFailure,
      lastActionFailure: lastActionFailure,
    );
  }

  Map<String, CatalogBank> get bankById =>
      UnmodifiableMapView({for (final bank in banks) bank.id: bank});

  List<CatalogBankCard> cardsForBank(String bankId) =>
      bankCards.where((c) => c.bankId == bankId).toList(growable: false);
}

final bankCatalogControllerProvider =
    AsyncNotifierProvider.autoDispose<BankCatalogController, BankCatalogState>(
      BankCatalogController.new,
    );

class BankCatalogController extends AsyncNotifier<BankCatalogState> {
  BankCatalogRepository get _repository =>
      ref.read(bankCatalogRepositoryProvider);

  static const int _pageSize = 20;

  OffsetPaginatedListController<BankOffer> _offersControllerFor({
    required String? bankId,
  }) {
    return OffsetPaginatedListController<BankOffer>(
      fetchPage:
          ({
            required int limit,
            required int offset,
            String? searchQuery,
            String? categoryId,
          }) {
            return _repository.fetchBankOffers(
              bankId: bankId,
              languageCode: ref.read(localeProvider).languageCode,
              searchQuery: searchQuery,
              categoryId: categoryId,
              limit: limit,
              offset: offset,
            );
          },
    );
  }

  @override
  Future<BankCatalogState> build() async {
    final languageCode = ref.watch(localeProvider).languageCode;

    final banksResult = await _repository.fetchActiveBanks(
      languageCode: languageCode,
    );
    final cardsResult = await _repository.fetchActiveBankCards(
      languageCode: languageCode,
    );
    final myCardsResult = await _repository.fetchMyBankCards(
      languageCode: languageCode,
    );

    final banks = banksResult.when(
      success: (d) => d,
      failure: (_) => const <CatalogBank>[],
    );
    final bankCards = cardsResult.when(
      success: (d) => d,
      failure: (_) => const <CatalogBankCard>[],
    );
    final myCards = myCardsResult.when(
      success: (d) => d,
      failure: (_) => const <MyBankCard>[],
    );

    final selectedCardIds = myCards.map((c) => c.bankCardId).toSet();

    final offers = await _offersControllerFor(
      bankId: null,
    ).loadInitial(const OffsetPaginatedListState<BankOffer>.initial());

    return BankCatalogState(
      banks: banks,
      bankCards: bankCards,
      myBankCards: myCards,
      selectedBankId: null,
      selectedCategoryId: null,
      selectedBankCardIds: selectedCardIds,
      offers: offers.items,
      searchQuery: offers.searchQuery,
      isLoadingOffers: offers.isLoadingInitial,
      hasMore: offers.hasMore,
      isLoadingMore: false,
      isSavingCards: false,
      offersFailure: offers.failure,
      lastActionFailure: myCardsResult.when(
        success: (_) => null,
        failure: (f) => f,
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }

  Future<void> updateSelectedBank(String? bankId) async {
    final current = state.value;
    if (current == null) return;
    if (bankId == current.selectedBankId) return;

    final controller = _offersControllerFor(bankId: bankId);
    final reset = controller.resetForQuery(
      current: _offersStateFrom(current),
      searchQuery: current.searchQuery,
      categoryId: current.selectedCategoryId,
    );

    state = AsyncValue.data(
      _mergeOffers(
        current,
        reset,
      ).copyWith(selectedBankId: bankId, lastActionFailure: null),
    );

    final loaded = await controller.loadInitial(reset);
    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncValue.data(_mergeOffers(latest, loaded));
  }

  Future<void> updateSearch(String query) async {
    final current = state.value;
    if (current == null) return;

    final normalized = query.trim();
    if (normalized == current.searchQuery) return;

    final controller = _offersControllerFor(bankId: current.selectedBankId);
    final reset = controller.resetForQuery(
      current: _offersStateFrom(current),
      searchQuery: normalized,
      categoryId: current.selectedCategoryId,
    );

    state = AsyncValue.data(
      _mergeOffers(current, reset).copyWith(lastActionFailure: null),
    );

    final loaded = await controller.loadInitial(reset);
    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncValue.data(_mergeOffers(latest, loaded));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null) return;
    final offersState = _offersStateFrom(current);
    if (offersState.isLoadingInitial ||
        offersState.isLoadingMore ||
        !offersState.hasMore)
      return;

    final controller = _offersControllerFor(bankId: current.selectedBankId);
    final loading = offersState.copyWith(isLoadingMore: true, failure: null);
    state = AsyncValue.data(
      _mergeOffers(current, loading).copyWith(lastActionFailure: null),
    );

    final result = await controller.fetchPage(
      limit: _pageSize,
      offset: offersState.items.length,
      searchQuery: offersState.searchQuery.isEmpty
          ? null
          : offersState.searchQuery,
      categoryId: offersState.selectedCategoryId,
    );

    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;

    final updated = result.when(
      success: (items) => loading.copyWith(
        items: [...loading.items, ...items],
        isLoadingMore: false,
        hasMore: items.length == _pageSize,
        failure: null,
      ),
      failure: (failure) => loading.copyWith(
        isLoadingMore: false,
        hasMore: false,
        failure: failure,
      ),
    );

    state = AsyncValue.data(_mergeOffers(latest, updated));
  }

  void toggleCardSelection(String bankCardId) {
    final current = state.value;
    if (current == null) return;

    final updated = {...current.selectedBankCardIds};
    if (updated.contains(bankCardId)) {
      updated.remove(bankCardId);
    } else {
      updated.add(bankCardId);
    }

    state = AsyncValue.data(
      current.copyWith(selectedBankCardIds: updated, lastActionFailure: null),
    );
  }

  Future<void> updateSelectedCategory(String? categoryId) async {
    final current = state.value;
    if (current == null) return;

    final normalized = (categoryId == null || categoryId.trim().isEmpty)
        ? null
        : categoryId.trim();
    if (normalized == current.selectedCategoryId) return;

    final controller = _offersControllerFor(bankId: current.selectedBankId);
    final reset = controller.resetForQuery(
      current: _offersStateFrom(current),
      searchQuery: current.searchQuery,
      categoryId: normalized,
    );

    state = AsyncValue.data(
      _mergeOffers(current, reset).copyWith(lastActionFailure: null),
    );

    final loaded = await controller.loadInitial(reset);
    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncValue.data(_mergeOffers(latest, loaded));
  }

  Future<void> saveSelectedCards() async {
    final current = state.value;
    if (current == null) return;
    if (current.isSavingCards) return;

    state = AsyncValue.data(current.copyWith(isSavingCards: true));

    final ids = current.selectedBankCardIds.toList(growable: false);
    final result = await _repository.setMyBankCards(bankCardIds: ids);

    await result.when(
      success: (_) async {
        final languageCode = ref.read(localeProvider).languageCode;
        final myCardsResult = await _repository.fetchMyBankCards(
          languageCode: languageCode,
        );
        final next = state.value;
        if (next == null) return;
        state = AsyncValue.data(
          next.copyWith(
            myBankCards: myCardsResult.when(
              success: (d) => d,
              failure: (_) => next.myBankCards,
            ),
            isSavingCards: false,
            lastActionFailure: myCardsResult.when(
              success: (_) => null,
              failure: (f) => f,
            ),
          ),
        );
      },
      failure: (failure) async {
        final next = state.value;
        if (next == null) return;
        state = AsyncValue.data(
          next.copyWith(isSavingCards: false, lastActionFailure: failure),
        );
      },
    );
  }

  OffsetPaginatedListState<BankOffer> _offersStateFrom(BankCatalogState data) {
    return OffsetPaginatedListState<BankOffer>(
      items: data.offers,
      searchQuery: data.searchQuery,
      selectedCategoryId: data.selectedCategoryId,
      isLoadingInitial: data.isLoadingOffers,
      isLoadingMore: data.isLoadingMore,
      hasMore: data.hasMore,
      failure: data.offersFailure,
    );
  }

  BankCatalogState _mergeOffers(
    BankCatalogState base,
    OffsetPaginatedListState<BankOffer> offers,
  ) {
    return base.copyWith(
      offers: offers.items,
      searchQuery: offers.searchQuery,
      selectedCategoryId: offers.selectedCategoryId,
      isLoadingOffers: offers.isLoadingInitial,
      isLoadingMore: offers.isLoadingMore,
      hasMore: offers.hasMore,
      offersFailure: offers.failure,
    );
  }
}
