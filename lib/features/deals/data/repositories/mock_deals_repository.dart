import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

/// Mock repository that can be swapped with a Supabase-backed implementation.
class MockDealsRepository implements DealsRepository {
  MockDealsRepository(this._remoteDataSource);

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
      final deals = models.map((model) => model.toDomain()).toList();
      return Result.success(deals);
    } on Failure catch (failure) {
      return Result.failure(failure);
    } catch (error, stackTrace) {
      return Result.failure(
        Failure.unknown(
          message: 'Unable to load hot deals',
          originalError: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}
