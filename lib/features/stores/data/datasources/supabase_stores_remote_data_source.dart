import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Supabase-backed stores data source.
///
/// @deprecated Use [SupabaseStoreCatalogRemoteDataSource] instead which has
/// working Supabase integration with fetchStores(), fetchStoreById(), etc.
// ignore: deprecated_member_use_from_same_package
@Deprecated('Use SupabaseStoreCatalogRemoteDataSource instead')
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

