import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

const defaultCategory = 'For You';

/// Immutable view state for the Hot Deals screen.
class HotDealsState {
  const HotDealsState({
    required this.deals,
    required this.selectedCategory,
    required this.searchQuery,
    this.failure,
  });

  const HotDealsState.initial()
    : deals = const [],
      selectedCategory = defaultCategory,
      searchQuery = '',
      failure = null;

  final List<Deal> deals;
  final String selectedCategory;
  final String searchQuery;
  final Failure? failure;

  bool get hasError => failure != null;
}

final hotDealsControllerProvider =
    AsyncNotifierProvider<HotDealsController, HotDealsState>(HotDealsController.new);

class HotDealsController extends AsyncNotifier<HotDealsState> {
  DealsRepository get _repository => ref.read(dealsRepositoryProvider);

  List<Deal> _allDeals = const [];

  @override
  Future<HotDealsState> build() async {
    return _fetchAllAndApply(category: defaultCategory, searchQuery: '');
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const HotDealsState.initial();
      return _fetchAllAndApply(
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

  Future<HotDealsState> _fetchAllAndApply({
    required String category,
    required String searchQuery,
  }) async {
    // Fetch the base dataset once, then apply UI filters locally.
    final result = await _repository.fetchHotDeals();

    return result.when(
      success: (deals) {
        _allDeals = deals;
        return _applyFilters(category: category, searchQuery: searchQuery);
      },
      failure: (failure) => HotDealsState(
        deals: const [],
        selectedCategory: category,
        searchQuery: searchQuery,
        failure: failure,
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
          data = data.where((d) => (d.rating ?? 0) >= 4.7).toList(growable: false);
          data = [...data]
            ..sort((a, b) {
              final ratingCompare = (b.rating ?? 0).compareTo(a.rating ?? 0);
              if (ratingCompare != 0) return ratingCompare;
              final reviewsCompare = (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0);
              if (reviewsCompare != 0) return reviewsCompare;
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
    );
  }
}
