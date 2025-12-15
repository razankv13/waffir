import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Supabase-backed stores data source.
///
/// This implementation is wired behind `USE_MOCK_STORES`. Keep that flag `true`
/// until the Supabase schema/RLS and data are deployed.
class SupabaseStoresRemoteDataSource implements StoresRemoteDataSource {
  SupabaseStoresRemoteDataSource(this._client);

  final SupabaseClient _client;


  @override
  Future<List<StoreModel>> fetchNearYouStores({
    String? category,
    String? searchQuery,
  }) async {
    throw const Failure.featureNotAvailable(
      message: 'Stores backend not deployed yet',
      code: 'STORES_BACKEND_NOT_DEPLOYED',
    );
  }

  @override
  Future<List<StoreModel>> fetchMallStores({
    String? category,
    String? searchQuery,
  }) async {
    throw const Failure.featureNotAvailable(
      message: 'Stores backend not deployed yet',
      code: 'STORES_BACKEND_NOT_DEPLOYED',
    );
  }
}

