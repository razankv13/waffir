import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/features/stores/data/mock_data/stores_mock_data.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Provider for all stores
final storesProvider = Provider<List<StoreModel>>((ref) {
  return StoresMockData.stores;
});

/// Provider for stores near you (not in mall)
final nearYouStoresProvider = Provider<List<StoreModel>>((ref) {
  return StoresMockData.nearYouStores;
});

/// Provider for mall stores
final mallStoresProvider = Provider<List<StoreModel>>((ref) {
  return StoresMockData.mallStores;
});

/// Provider for stores by category
final storesByCategoryProvider = Provider.family<List<StoreModel>, String>((ref, category) {
  return StoresMockData.getStoresByCategory(category);
});

/// Provider for stores by mall name
final storesByMallProvider = Provider.family<List<StoreModel>, String>((ref, mallName) {
  return StoresMockData.getStoresByMall(mallName);
});

/// State notifier for selected store category filter
class SelectedStoreCategoryNotifier extends StateNotifier<String> {
  SelectedStoreCategoryNotifier() : super('All');

  void selectCategory(String category) {
    state = category;
  }
}

/// Provider for selected store category
final selectedStoreCategoryProvider = StateNotifierProvider<SelectedStoreCategoryNotifier, String>((ref) {
  return SelectedStoreCategoryNotifier();
});

/// Provider for filtered stores based on selected category
final filteredStoresProvider = Provider<List<StoreModel>>((ref) {
  final selectedCategory = ref.watch(selectedStoreCategoryProvider);
  return StoresMockData.getStoresByCategory(selectedCategory);
});

/// Provider for filtered near you stores
final filteredNearYouStoresProvider = Provider<List<StoreModel>>((ref) {
  final selectedCategory = ref.watch(selectedStoreCategoryProvider);
  final allNearYou = StoresMockData.nearYouStores;

  if (selectedCategory == 'All' || selectedCategory == 'الكل') {
    return allNearYou;
  }

  return allNearYou.where((store) => store.category == selectedCategory).toList();
});

/// Provider for filtered mall stores
final filteredMallStoresProvider = Provider<List<StoreModel>>((ref) {
  final selectedCategory = ref.watch(selectedStoreCategoryProvider);
  final allMall = StoresMockData.mallStores;

  if (selectedCategory == 'All' || selectedCategory == 'الكل') {
    return allMall;
  }

  return allMall.where((store) => store.category == selectedCategory).toList();
});

/// Provider for a single store by id
final storeByIdProvider = Provider.family<StoreModel?, String>((ref, storeId) {
  try {
    return StoresMockData.stores.firstWhere((store) => store.id == storeId);
  } catch (_) {
    return null;
  }
});
