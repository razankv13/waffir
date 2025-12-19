import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

/// Supabase-backed deals repository.
class SupabaseDealsRepository implements DealsRepository {
  SupabaseDealsRepository(this._remoteDataSource);

  final DealsRemoteDataSource _remoteDataSource;

  @override
  AsyncResult<List<Deal>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode = 'en',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.fetchHotDeals(
        category: category,
        searchQuery: searchQuery,
        languageCode: languageCode,
        limit: limit,
        offset: offset,
      );
      return Result.success(models.map((model) => model.toDomain()).toList());
    } on Failure catch (failure) {
      return Result.failure(failure);
    }
  }

  @override
  AsyncResult<void> trackDealView({required String dealId, String dealType = 'product'}) async {
    try {
      await _remoteDataSource.trackDealView(dealId: dealId, dealType: dealType);
      return const Result.success(null);
    } on Failure catch (failure) {
      return Result.failure(failure);
    }
  }

  @override
  AsyncResult<bool> toggleDealLike({required String dealId, String dealType = 'product'}) async {
    try {
      final liked = await _remoteDataSource.toggleDealLike(dealId: dealId, dealType: dealType);
      return Result.success(liked);
    } on Failure catch (failure) {
      return Result.failure(failure);
    }
  }
}
