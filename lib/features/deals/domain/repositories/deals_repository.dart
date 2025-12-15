import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';

/// Contract for fetching deals data, allowing the data source to be swapped
/// (mock → Supabase) without touching presentation.
abstract class DealsRepository {
  /// Fetch hot deals with optional filters.
  ///
  /// - [category]: server-friendly category value (e.g. 'Fashion', 'Popular').
  /// - [searchQuery]: free-text search term.
  AsyncResult<List<Deal>> fetchHotDeals({
    String? category,
    String? searchQuery,
  });
}
