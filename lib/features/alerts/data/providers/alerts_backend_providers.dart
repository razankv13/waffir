import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/data/datasources/mock_alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/data/datasources/supabase_alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/data/repositories/alerts_repository_impl.dart';
import 'package:waffir/features/alerts/domain/repositories/alerts_repository.dart';

/// Provider for alerts remote data source
///
/// Returns mock implementation if USE_MOCK_ALERTS=true in environment,
/// otherwise returns Supabase implementation.
final alertsRemoteDataSourceProvider = Provider<AlertsRemoteDataSource>((ref) {
  if (EnvironmentConfig.useMockAlerts) {
    return MockAlertsRemoteDataSource();
  }

  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseAlertsRemoteDataSource(client);
  } catch (e) {
    throw Failure.configuration(
      message: 'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set in .env',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});

/// Provider for alerts repository
///
/// Depends on alertsRemoteDataSourceProvider for data source selection.
final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final remoteDataSource = ref.watch(alertsRemoteDataSourceProvider);
  return AlertsRepositoryImpl(remoteDataSource);
});
