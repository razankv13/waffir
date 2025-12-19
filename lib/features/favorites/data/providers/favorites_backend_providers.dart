import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:waffir/features/favorites/data/datasources/mock_favorites_remote_data_source.dart';
import 'package:waffir/features/favorites/data/datasources/supabase_favorites_remote_data_source.dart';
import 'package:waffir/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:waffir/features/favorites/data/repositories/mock_favorites_repository.dart';
import 'package:waffir/features/favorites/domain/repositories/favorites_repository.dart';

/// Provider for favorites remote data source.
///
/// Returns mock data source if [EnvironmentConfig.useMockFavorites] is true,
/// otherwise returns Supabase-backed implementation.
final favoritesRemoteDataSourceProvider = Provider<FavoritesRemoteDataSource>((ref) {
  if (EnvironmentConfig.useMockFavorites) {
    return MockFavoritesRemoteDataSource();
  }
  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseFavoritesRemoteDataSource(client);
  } catch (e) {
    throw Failure.configuration(
      message: 'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});

/// Provider for favorites repository.
///
/// Returns mock repository if [EnvironmentConfig.useMockFavorites] is true,
/// otherwise returns Supabase-backed repository implementation.
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final remoteDataSource = ref.watch(favoritesRemoteDataSourceProvider);
  if (EnvironmentConfig.useMockFavorites) {
    return MockFavoritesRepository();
  }
  return FavoritesRepositoryImpl(remoteDataSource);
});
