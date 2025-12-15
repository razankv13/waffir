import 'package:waffir/features/stores/data/models/store_model.dart';

/// Abstraction for remote stores source (mock for now, Supabase later).
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

