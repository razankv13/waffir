import 'package:waffir/features/stores/data/models/store_model.dart';

/// Abstraction for remote stores source (mock for now, Supabase later).
///
/// @deprecated Use [StoreCatalogRemoteDataSource] instead which consolidates
/// all store-related data operations and supports Supabase integration.
@Deprecated('Use StoreCatalogRemoteDataSource instead')
abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> fetchNearYouStores({
    String? category,
    String? searchQuery,
  });

  Future<List<StoreModel>> fetchMallStores({
    String? category,
    String? searchQuery,
  });
}

