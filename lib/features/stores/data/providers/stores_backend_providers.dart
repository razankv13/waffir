import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/stores/data/datasources/mock_stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/supabase_stores_remote_data_source.dart';
import 'package:waffir/features/stores/data/repositories/mock_stores_repository.dart';
import 'package:waffir/features/stores/data/repositories/supabase_stores_repository.dart';
import 'package:waffir/features/stores/domain/repositories/stores_repository.dart';

final storesRemoteDataSourceProvider = Provider<StoresRemoteDataSource>((ref) {
  if (EnvironmentConfig.useMockStores) {
    final forceError = EnvironmentConfig.getBool('FORCE_STORES_ERROR', defaultValue: false);
    return MockStoresRemoteDataSource(forceError: forceError);
  }

  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseStoresRemoteDataSource(client);
  } catch (e) {
    throw const Failure.configuration(
      message: 'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.',
      configKey: 'SUPABASE_URL/SUPABASE_ANON_KEY',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});

final storesRepositoryProvider = Provider<StoresRepository>((ref) {
  final remoteDataSource = ref.watch(storesRemoteDataSourceProvider);
  if (EnvironmentConfig.useMockStores) {
    return MockStoresRepository(remoteDataSource);
  }
  return SupabaseStoresRepository(remoteDataSource);
});

