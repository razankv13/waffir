import 'dart:async';

import 'package:waffir/features/deals/data/mock_data/deals_mock_data.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';

/// Abstraction for remote deals source (mock for now, Supabase later).
abstract class DealsRemoteDataSource {
  Future<List<DealModel>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode,
    int limit,
    int offset,
  });

  Future<void> trackDealView({
    required String dealId,
    String dealType,
  });

  Future<bool> toggleDealLike({
    required String dealId,
    String dealType,
  });
}

/// Temporary mock implementation that simulates latency and filtering.
class MockDealsRemoteDataSource implements DealsRemoteDataSource {
  @override
  Future<List<DealModel>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode = 'en',
    int limit = 20,
    int offset = 0,
  }) async {
    // Simulate network roundtrip
    await Future<void>.delayed(const Duration(milliseconds: 350));

    // Base hot deals list
    var data = DealsMockData.hotDeals;
    final normalizedCategory = category?.trim();

    // Map UI-friendly categories to mock filtering rules
    if (normalizedCategory != null && normalizedCategory.isNotEmpty) {
      switch (normalizedCategory) {
        case 'For You':
        case 'الكل':
        case 'All':
          data = DealsMockData.hotDeals;
          break;
        case 'Front Page':
          data = DealsMockData.featuredDeals;
          break;
        case 'Popular':
          data = DealsMockData.hotDeals
              .where((deal) => (deal.rating ?? 0) >= 4.7)
              .toList();
          break;
        default:
          data = DealsMockData.getDealsByCategory(normalizedCategory);
          break;
      }
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      data = data.where((deal) {
        final titleLower = deal.title.toLowerCase();
        final descLower = deal.description.toLowerCase();
        final brandLower = deal.brand?.toLowerCase() ?? '';
        final categoryLower = deal.category?.toLowerCase() ?? '';
        return titleLower.contains(query) ||
            descLower.contains(query) ||
            brandLower.contains(query) ||
            categoryLower.contains(query);
      }).toList();
    }

    if (offset <= 0 && limit >= data.length) return data;
    final start = offset.clamp(0, data.length);
    final end = (offset + limit).clamp(start, data.length);
    return data.sublist(start, end);
  }

  @override
  Future<void> trackDealView({required String dealId, String dealType = 'product'}) async {
    // No-op for mock backend.
  }

  @override
  Future<bool> toggleDealLike({required String dealId, String dealType = 'product'}) async {
    // Mock backend doesn’t persist likes; return true so UI can behave consistently.
    return true;
  }
}
