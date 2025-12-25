import 'dart:async';

import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/mock_data/stores_mock_data.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Temporary mock implementation that simulates latency and filtering.
///
/// @deprecated Use [MockStoreCatalogRemoteDataSource] instead which implements
/// the consolidated [StoreCatalogRemoteDataSource] interface.
// ignore: deprecated_member_use_from_same_package
@Deprecated('Use MockStoreCatalogRemoteDataSource instead')
class MockStoresRemoteDataSource implements StoresRemoteDataSource {
  MockStoresRemoteDataSource({this.forceError = false});

  final bool forceError;

  @override
  Future<List<StoreModel>> fetchNearYouStores({
    String? category,
    String? searchQuery,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (forceError) {
      throw const Failure.network(message: 'Forced mock error');
    }
    return _filter(
      StoresMockData.nearYouStores,
      category: category,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<List<StoreModel>> fetchMallStores({
    String? category,
    String? searchQuery,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (forceError) {
      throw const Failure.network(message: 'Forced mock error');
    }
    return _filter(
      StoresMockData.mallStores,
      category: category,
      searchQuery: searchQuery,
    );
  }

  static List<StoreModel> _filter(
    List<StoreModel> input, {
    String? category,
    String? searchQuery,
  }) {
    var data = input;

    final normalizedCategory = category?.trim();
    if (normalizedCategory != null &&
        normalizedCategory.isNotEmpty &&
        normalizedCategory != 'All' &&
        normalizedCategory != 'الكل') {
      data = data.where((store) => store.category == normalizedCategory).toList();
    }

    final normalizedSearch = searchQuery?.trim();
    if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
      final query = normalizedSearch.toLowerCase();
      data = data.where((store) {
        final nameLower = store.name.toLowerCase();
        final categoryLower = store.category.toLowerCase();
        final addressLower = store.address?.toLowerCase() ?? '';
        final locationLower = store.location?.toLowerCase() ?? '';
        return nameLower.contains(query) ||
            categoryLower.contains(query) ||
            addressLower.contains(query) ||
            locationLower.contains(query);
      }).toList();
    }

    return data;
  }
}

