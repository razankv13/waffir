import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';
import 'package:waffir/features/stores/presentation/controllers/offset_paginated_list_controller.dart';

/// Arguments for the StoreCatalogController family provider.
///
/// Supports both navigation with pre-loaded data (from StoresScreen) and
/// deep links that require fetching from the backend.
class StoreCatalogArgs {
  const StoreCatalogArgs({
    required this.storeId,
    this.initialStore,
    this.initialOffers,
  });

  final String storeId;
  final Store? initialStore;
  final List<StoreOffer>? initialOffers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreCatalogArgs &&
          runtimeType == other.runtimeType &&
          storeId == other.storeId;

  @override
  int get hashCode => storeId.hashCode;
}

class StoreCatalogState {
  const StoreCatalogState({
    required this.store,
    required this.offers,
    required this.searchQuery,
    required this.selectedCategoryId,
    required this.isLoadingOffers,
    required this.hasMore,
    required this.isLoadingMore,
    this.offersFailure,
    this.lastActionFailure,
  });

  final StoreModel store;
  final List<StoreOffer> offers;
  final String searchQuery;
  final String? selectedCategoryId;
  final bool isLoadingOffers;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? offersFailure;
  final Failure? lastActionFailure;

  StoreCatalogState copyWith({
    StoreModel? store,
    List<StoreOffer>? offers,
    String? searchQuery,
    String? selectedCategoryId,
    bool? isLoadingOffers,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? offersFailure,
    Failure? lastActionFailure,
  }) {
    return StoreCatalogState(
      store: store ?? this.store,
      offers: offers ?? this.offers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoadingOffers: isLoadingOffers ?? this.isLoadingOffers,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      offersFailure: offersFailure,
      lastActionFailure: lastActionFailure,
    );
  }
}

final storeCatalogControllerProvider = AsyncNotifierProvider.autoDispose
    .family<StoreCatalogController, StoreCatalogState, StoreCatalogArgs>(
      StoreCatalogController.new,
    );

class StoreCatalogController extends AsyncNotifier<StoreCatalogState> {
  StoreCatalogController(this._args);

  final StoreCatalogArgs _args;

  String get storeId => _args.storeId;
  Store? get _initialStore => _args.initialStore;
  List<StoreOffer>? get _initialOffers => _args.initialOffers;

  StoreCatalogRepository get _repository =>
      ref.read(storeCatalogRepositoryProvider);

  static const int _pageSize = 20;
  OffsetPaginatedListController<StoreOffer> get _offersController =>
      OffsetPaginatedListController<StoreOffer>(
        pageSize: _pageSize,
        fetchPage: ({
          required int limit,
          required int offset,
          String? searchQuery,
          String? categoryId,
        }) {
          return _repository.fetchStoreOffers(
            storeId: storeId,
            languageCode: ref.read(localeProvider).languageCode,
            searchQuery: searchQuery,
            categoryId: categoryId,
            limit: limit,
            offset: offset,
          );
        },
      );

  @override
  Future<StoreCatalogState> build() async {
    final languageCode = ref.watch(localeProvider).languageCode;

    // Use initial data if available (from StoresScreen navigation)
    if (_initialStore != null) {
      final storeModel = StoreModel.fromDomain(_initialStore!);
      final offers = _initialOffers ?? const <StoreOffer>[];
      final hasInitialOffers = offers.isNotEmpty;

      final initial = StoreCatalogState(
        store: storeModel,
        offers: offers,
        searchQuery: '',
        selectedCategoryId: null,
        isLoadingOffers: !hasInitialOffers,
        hasMore: !hasInitialOffers, // If we have initial offers, assume no more to load
        isLoadingMore: false,
      );

      // Only load offers if none were provided
      if (!hasInitialOffers) {
        unawaited(
          Future<void>.delayed(
            Duration.zero,
            _loadOffersWithController,
          ),
        );
      }
      return initial;
    }

    // Fallback: Fetch from backend (for deep links)
    final storeResult = await _repository.fetchStoreById(
      storeId: storeId,
      languageCode: languageCode,
    );
    return storeResult.when(
      success: (store) async {
        final initial = StoreCatalogState(
          store: store,
          offers: const [],
          searchQuery: '',
          selectedCategoryId: null,
          isLoadingOffers: true,
          hasMore: true,
          isLoadingMore: false,
        );
        // Defer until after `build` completes so `state.value` is available.
        unawaited(
          Future<void>.delayed(
            Duration.zero,
            _loadOffersWithController,
          ),
        );
        return initial;
      },
      failure: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }

  Future<void> updateSearch(String query) async {
    final current = state.value;
    if (current == null) return;

    final next = await _offersController.applySearch(
      _offersStateFrom(current),
      searchQuery: query,
    );
    if (!ref.mounted) return;
    state = AsyncValue.data(_mergeOffers(current, next).copyWith(lastActionFailure: null));
  }

  Future<void> updateSelectedCategory(String? categoryId) async {
    final current = state.value;
    if (current == null) return;
    final next = await _offersController.applyCategoryFilter(
      _offersStateFrom(current),
      categoryId: categoryId,
    );
    if (!ref.mounted) return;
    state = AsyncValue.data(_mergeOffers(current, next).copyWith(lastActionFailure: null));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null) return;
    final next = await _offersController.loadMore(_offersStateFrom(current));
    if (!ref.mounted) return;
    state = AsyncValue.data(_mergeOffers(current, next));
  }

  Future<bool> toggleFavorite() async {
    final current = state.value;
    if (current == null) return false;

    final result = await _repository.toggleFavoriteStore(storeId: storeId);
    return result.when(
      success: (_) {
        final latest = state.value;
        if (latest == null) return true;
        state = AsyncValue.data(latest.copyWith(lastActionFailure: null));
        return true;
      },
      failure: (failure) {
        final latest = state.value;
        if (latest == null) return false;
        state = AsyncValue.data(latest.copyWith(lastActionFailure: failure));
        return false;
      },
    );
  }

  OffsetPaginatedListState<StoreOffer> _offersStateFrom(StoreCatalogState state) {
    return OffsetPaginatedListState<StoreOffer>(
      items: state.offers,
      searchQuery: state.searchQuery,
      selectedCategoryId: state.selectedCategoryId,
      isLoadingInitial: state.isLoadingOffers,
      isLoadingMore: state.isLoadingMore,
      hasMore: state.hasMore,
      failure: state.offersFailure,
    );
  }

  StoreCatalogState _mergeOffers(
    StoreCatalogState base,
    OffsetPaginatedListState<StoreOffer> offers,
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

  Future<void> _loadOffersWithController() async {
    final current = state.value;
    if (current == null) return;
    final offers = await _offersController.loadInitial(_offersStateFrom(current));
    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncValue.data(_mergeOffers(latest, offers));
  }
}
