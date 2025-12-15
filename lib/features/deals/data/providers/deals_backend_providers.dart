import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/data/datasources/supabase_deals_remote_data_source.dart';
import 'package:waffir/features/deals/data/repositories/mock_deals_repository.dart';
import 'package:waffir/features/deals/data/repositories/supabase_deals_repository.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';

final dealsRemoteDataSourceProvider = Provider<DealsRemoteDataSource>((ref) {
  if (EnvironmentConfig.useMockDeals) {
    return MockDealsRemoteDataSource();
  }
  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseDealsRemoteDataSource(client);
  } catch (e) {
    throw Failure.configuration(
      message: 'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});

final dealsRepositoryProvider = Provider<DealsRepository>((ref) {
  final remoteDataSource = ref.watch(dealsRemoteDataSourceProvider);
  if (EnvironmentConfig.useMockDeals) {
    return MockDealsRepository(remoteDataSource);
  }
  return SupabaseDealsRepository(remoteDataSource);
});
