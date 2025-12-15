import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';

/// Contract for fetching stores data, allowing the backend to be swapped
/// (mock → Supabase) without touching presentation.
abstract class StoresRepository {
  /// Fetch the Stores screen feed with optional filters.
  ///
  /// - [category]: UI category label (e.g. 'All', 'Fashion').
  /// - [searchQuery]: free-text search term.
  AsyncResult<StoresFeed> fetchStoresFeed({
    String? category,
    String? searchQuery,
  });
}

/// Domain model representing the Stores screen feed sections.
class StoresFeed {
  const StoresFeed({
    required this.nearYou,
    required this.mall,
  });

  final List<Store> nearYou;
  final List<Store> mall;
}

