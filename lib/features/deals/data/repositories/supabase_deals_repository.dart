import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

/// Stub repository until the Supabase backend is deployed.
///
/// Keep the domain contract stable; only update the data layer when ready.
class SupabaseDealsRepository implements DealsRepository {
  SupabaseDealsRepository(this._remoteDataSource);

  final DealsRemoteDataSource _remoteDataSource;

  @override
  AsyncResult<List<Deal>> fetchHotDeals({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final models = await _remoteDataSource.fetchHotDeals(
        category: category,
        searchQuery: searchQuery,
      );
      return Result.success(models.map((model) => model.toDomain()).toList());
    } on Failure catch (failure) {
      return Result.failure(failure);
    }
  }
}
