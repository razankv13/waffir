import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

const defaultCategory = 'For You';

/// Immutable view state for the Hot Deals screen.
class HotDealsState {
  static const Object _unset = Object();

  const HotDealsState({
    required this.deals,
    required this.selectedCategory,
    required this.searchQuery,
    this.failure,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  const HotDealsState.initial()
    : deals = const [],
      selectedCategory = defaultCategory,
      searchQuery = '',
      failure = null,
      hasMore = true,
      isLoadingMore = false,
      loadMoreFailure = null;

  final List<Deal> deals;
  final String selectedCategory;
  final String searchQuery;
  final Failure? failure;

  bool get hasError => failure != null;

  final bool hasMore;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;

  HotDealsState copyWith({
    List<Deal>? deals,
    String? selectedCategory,
    String? searchQuery,
    Failure? failure,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreFailure = _unset,
  }) {
    return HotDealsState(
      deals: deals ?? this.deals,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      failure: failure ?? this.failure,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure: loadMoreFailure == _unset ? this.loadMoreFailure : loadMoreFailure as Failure?,
    );
  }
}

final hotDealsControllerProvider =
    AsyncNotifierProvider<HotDealsController, HotDealsState>(HotDealsController.new);

class HotDealsController extends AsyncNotifier<HotDealsState> {
  DealsRepository get _repository => ref.read(dealsRepositoryProvider);

  static const int _pageSize = 20;

  List<Deal> _allDeals = const [];
  int _offset = 0;
  bool _hasMore = true;

  @override
  Future<HotDealsState> build() async {
    return _fetchFirstPageAndApply(category: defaultCategory, searchQuery: '');
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const HotDealsState.initial();
      return _fetchFirstPageAndApply(
        category: currentState.selectedCategory,
        searchQuery: currentState.searchQuery,
      );
    });
  }

  Future<void> updateCategory(String category) async {
    final currentState = state.value ?? const HotDealsState.initial();
    state = AsyncValue.data(_applyFilters(category: category, searchQuery: currentState.searchQuery));
  }

  Future<void> updateSearch(String query) async {
    final currentState = state.value ?? const HotDealsState.initial();
    state = AsyncValue.data(_applyFilters(category: currentState.selectedCategory, searchQuery: query));
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null) return;
    if (state.isLoading) return;
    if (current.isLoadingMore) return;
    if (!_hasMore) return;

    state = AsyncValue.data(
      current.copyWith(
        isLoadingMore: true,
        loadMoreFailure: null,
      ),
    );

    final languageCode = ref.read(localeProvider).languageCode;
    final result = await _repository.fetchHotDeals(
      category: current.selectedCategory,
      searchQuery: current.searchQuery,
      languageCode: languageCode,
      limit: _pageSize,
      offset: _offset,
    );

    final nextState = result.when(
      success: (deals) {
        _offset += deals.length;
        _hasMore = deals.length == _pageSize;

        final seen = _allDeals.map((d) => d.id).toSet();
        final unique = deals.where((d) => !seen.contains(d.id)).toList(growable: false);
        _allDeals = [..._allDeals, ...unique];

        AppLogger.debug('🐛 Deals feed loadMore success (count=${deals.length}, hasMore=$_hasMore).');

        return _applyFilters(category: current.selectedCategory, searchQuery: current.searchQuery).copyWith(
          hasMore: _hasMore,
          isLoadingMore: false,
          loadMoreFailure: null,
        );
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Deals feed loadMore failed: ${failure.message}');
        return current.copyWith(
          hasMore: _hasMore,
          isLoadingMore: false,
          loadMoreFailure: failure,
        );
      },
    );

    state = AsyncValue.data(nextState);
  }

  Future<Failure?> toggleLike(Deal deal) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    final optimisticLiked = !deal.isLiked;
    final nextCount = (deal.likesCount + (optimisticLiked ? 1 : -1)).clamp(0, 1 << 30);
    final updatedDeal = deal.copyWith(isLiked: optimisticLiked, likesCount: nextCount);

    _allDeals = _allDeals.map((d) => d.id == deal.id ? updatedDeal : d).toList(growable: false);
    state = AsyncValue.data(_applyFilters(category: current.selectedCategory, searchQuery: current.searchQuery));

    final result = await _repository.toggleDealLike(dealId: deal.id, dealType: 'product');
    return result.when(
      success: (liked) {
        final fixedDeal = updatedDeal.copyWith(isLiked: liked);
        _allDeals = _allDeals.map((d) => d.id == deal.id ? fixedDeal : d).toList(growable: false);
        state = AsyncValue.data(_applyFilters(category: current.selectedCategory, searchQuery: current.searchQuery));
        return null;
      },
      failure: (failure) {
        _allDeals = _allDeals.map((d) => d.id == deal.id ? deal : d).toList(growable: false);
        state = AsyncValue.data(_applyFilters(category: current.selectedCategory, searchQuery: current.searchQuery));
        return failure;
      },
    );
  }

  Future<void> trackView(Deal deal) async {
    final result = await _repository.trackDealView(dealId: deal.id, dealType: 'product');
    result.when(
      success: (_) {},
      failure: (failure) => AppLogger.warning('⚠️ trackDealView failed: ${failure.message}'),
    );
  }

  Future<HotDealsState> _fetchFirstPageAndApply({
    required String category,
    required String searchQuery,
  }) async {
    _allDeals = const [];
    _offset = 0;
    _hasMore = true;

    final languageCode = ref.read(localeProvider).languageCode;
    final result = await _repository.fetchHotDeals(
      category: category,
      searchQuery: searchQuery,
      languageCode: languageCode,
      limit: _pageSize,
      offset: 0,
    );

    return result.when(
      success: (deals) {
        _allDeals = deals;
        _offset = deals.length;
        _hasMore = deals.length == _pageSize;
        AppLogger.debug('🐛 Deals feed initial load success (count=${deals.length}).');
        return _applyFilters(category: category, searchQuery: searchQuery).copyWith(
          hasMore: _hasMore,
          isLoadingMore: false,
          loadMoreFailure: null,
        );
      },
      failure: (failure) => HotDealsState(
        deals: const [],
        selectedCategory: category,
        searchQuery: searchQuery,
        failure: failure,
        hasMore: false,
      ),
    );
  }

  HotDealsState _applyFilters({
    required String category,
    required String searchQuery,
  }) {
    final normalizedCategory = category.trim();
    final normalizedSearch = searchQuery.trim().toLowerCase();

    var data = _allDeals;

    if (normalizedCategory.isNotEmpty) {
      switch (normalizedCategory) {
        case 'For You':
        case 'All':
        case 'الكل':
          break;
        case 'Front Page':
          data = data.where((d) => d.isFeatured == true).toList(growable: false);
          break;
        case 'Popular':
          final hasRatings = data.any((d) => d.rating != null);
          data = [...data]
            ..sort((a, b) {
              if (hasRatings) {
                final ratingCompare = (b.rating ?? 0).compareTo(a.rating ?? 0);
                if (ratingCompare != 0) return ratingCompare;
                final reviewsCompare = (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0);
                if (reviewsCompare != 0) return reviewsCompare;
              } else {
                final likesCompare = b.likesCount.compareTo(a.likesCount);
                if (likesCompare != 0) return likesCompare;
                final viewsCompare = b.viewsCount.compareTo(a.viewsCount);
                if (viewsCompare != 0) return viewsCompare;
              }
              return (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                  .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
            });
          break;
        default:
          data = data.where((d) => d.category == normalizedCategory).toList(growable: false);
          break;
      }
    }

    if (normalizedSearch.isNotEmpty) {
      data = data.where((deal) {
        final titleLower = deal.title.toLowerCase();
        final descLower = deal.description.toLowerCase();
        final brandLower = deal.brand?.toLowerCase() ?? '';
        final categoryLower = deal.category?.toLowerCase() ?? '';
        return titleLower.contains(normalizedSearch) ||
            descLower.contains(normalizedSearch) ||
            brandLower.contains(normalizedSearch) ||
            categoryLower.contains(normalizedSearch);
      }).toList(growable: false);
    }

    return HotDealsState(
      deals: data,
      selectedCategory: category,
      searchQuery: searchQuery,
      hasMore: _hasMore,
    );
  }
}
