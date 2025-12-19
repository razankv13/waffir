import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/profile/data/datasources/mock_profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/datasources/supabase_profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:waffir/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:waffir/features/profile/domain/repositories/profile_repository.dart';

/// Provider for profile remote data source.
///
/// Returns mock data source if [EnvironmentConfig.useMockProfile] is true,
/// otherwise returns Supabase-backed implementation.
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  if (EnvironmentConfig.useMockProfile) {
    return MockProfileRemoteDataSource();
  }
  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseProfileRemoteDataSource(client);
  } catch (e) {
    throw const Failure.configuration(
      message: 'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});

/// Provider for profile repository.
///
/// Returns mock repository if [EnvironmentConfig.useMockProfile] is true,
/// otherwise returns Supabase-backed repository implementation.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  if (EnvironmentConfig.useMockProfile) {
    return MockProfileRepository();
  }
  return ProfileRepositoryImpl(remoteDataSource);
});
