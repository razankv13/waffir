import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:waffir/features/stores/domain/repositories/stores_repository.dart';

class MockStoresRepository implements StoresRepository {
  MockStoresRepository(this._remote);

  final StoresRemoteDataSource _remote;

  @override
  AsyncResult<StoresFeed> fetchStoresFeed({
    String? category,
    String? searchQuery,
  }) async {
    return Result.guard(() async {
      final results = await Future.wait([
        _remote.fetchNearYouStores(category: category, searchQuery: searchQuery),
        _remote.fetchMallStores(category: category, searchQuery: searchQuery),
      ]);

      final nearYou = results[0].map((m) => m.toDomain()).toList(growable: false);
      final mall = results[1].map((m) => m.toDomain()).toList(growable: false);

      return StoresFeed(nearYou: nearYou, mall: mall);
    });
  }
}

