import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';

const defaultStoresCategory = 'All';

/// Immutable view state for the Stores screen.
class StoresState {
  const StoresState({
    required this.nearYouStores,
    required this.mallStores,
    required this.selectedCategory,
    required this.searchQuery,
    this.failure,
  });

  const StoresState.initial()
    : nearYouStores = const [],
      mallStores = const [],
      selectedCategory = defaultStoresCategory,
      searchQuery = '',
      failure = null;

  final List<Store> nearYouStores;
  final List<Store> mallStores;
  final String selectedCategory;
  final String searchQuery;
  final Failure? failure;

  bool get hasError => failure != null;
}

/// Keep this provider alive across tab switches so the screen doesn't refetch
/// just because the widget was disposed/rebuilt by navigation.
final storesControllerProvider = AsyncNotifierProvider<StoresController, StoresState>(StoresController.new);

class StoresController extends AsyncNotifier<StoresState> {
  StoreCatalogRepository get _repository => ref.read(storeCatalogRepositoryProvider);

  List<Store> _allNearYouStores = const [];
  List<Store> _allMallStores = const [];

  @override
  Future<StoresState> build() async {
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);
    return _fetchAllAndApply(category: defaultStoresCategory, searchQuery: '');
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const StoresState.initial();
      return _fetchAllAndApply(
        category: currentState.selectedCategory,
        searchQuery: currentState.searchQuery,
      );
    });
  }

  Future<void> updateCategory(String category) async {
    final currentState = state.value ?? const StoresState.initial();
    state = AsyncValue.data(_applyFilters(category: category, searchQuery: currentState.searchQuery));
  }

  Future<void> updateSearch(String query) async {
    final currentState = state.value ?? const StoresState.initial();
    state = AsyncValue.data(_applyFilters(category: currentState.selectedCategory, searchQuery: query));
  }

  Future<StoresState> _fetchAllAndApply({required String category, required String searchQuery}) async {
    final languageCode = ref.read(localeProvider).languageCode;
    final result = await _repository.fetchStoresFeed(languageCode: languageCode);

    return result.when(
      success: (feed) {
        _allNearYouStores = feed.nearYou;
        _allMallStores = feed.mall;
        return _applyFilters(category: category, searchQuery: searchQuery);
      },
      failure: (failure) => StoresState(
        nearYouStores: const [],
        mallStores: const [],
        selectedCategory: category,
        searchQuery: searchQuery,
        failure: failure,
      ),
    );
  }

  StoresState _applyFilters({required String category, required String searchQuery}) {
    final normalizedCategory = category.trim();
    final normalizedSearch = searchQuery.trim().toLowerCase();

    bool matchesCategory(Store store) {
      if (normalizedCategory.isEmpty || normalizedCategory == 'All' || normalizedCategory == 'الكل') {
        return true;
      }
      return store.category == normalizedCategory;
    }

    bool matchesSearch(Store store) {
      if (normalizedSearch.isEmpty) return true;
      final nameLower = store.name.toLowerCase();
      final categoryLower = store.category.toLowerCase();
      final addressLower = store.address?.toLowerCase() ?? '';
      final locationLower = store.location?.toLowerCase() ?? '';
      return nameLower.contains(normalizedSearch) ||
          categoryLower.contains(normalizedSearch) ||
          addressLower.contains(normalizedSearch) ||
          locationLower.contains(normalizedSearch);
    }

    final nearYou = _allNearYouStores.where((s) => matchesCategory(s) && matchesSearch(s)).toList(growable: false);
    final mall = _allMallStores.where((s) => matchesCategory(s) && matchesSearch(s)).toList(growable: false);

    return StoresState(
      nearYouStores: nearYou,
      mallStores: mall,
      selectedCategory: category,
      searchQuery: searchQuery,
    );
  }
}
