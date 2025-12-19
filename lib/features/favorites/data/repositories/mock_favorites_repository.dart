import 'package:waffir/features/favorites/data/datasources/mock_favorites_remote_data_source.dart';
import 'package:waffir/features/favorites/data/repositories/favorites_repository_impl.dart';

/// Mock repository for favorites (wraps mock data source).
///
/// This is a convenience class that provides a pre-configured repository
/// with the mock data source. Useful for testing and development.
class MockFavoritesRepository extends FavoritesRepositoryImpl {
  MockFavoritesRepository() : super(MockFavoritesRemoteDataSource());
}
