import 'package:waffir/features/profile/data/datasources/mock_profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/repositories/profile_repository_impl.dart';

/// Mock repository for profile (wraps mock data source).
///
/// This is a convenience class that provides a pre-configured repository
/// with the mock data source. Useful for testing and development.
class MockProfileRepository extends ProfileRepositoryImpl {
  MockProfileRepository() : super(MockProfileRemoteDataSource());
}
