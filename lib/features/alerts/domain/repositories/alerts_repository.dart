import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/domain/entities/alert.dart';

/// Abstract repository for alerts functionality
///
/// Defines contracts for managing user alerts with typed error handling.
/// Implementations handle both Supabase-backed and mock data sources.
abstract class AlertsRepository {
  /// Fetch all alerts for the authenticated user
  ///
  /// Returns:
  /// - Success with list of user's alerts (may be empty)
  /// - Failure if unauthorized or server error
  AsyncResult<List<Alert>> fetchMyAlerts();

  /// Create a new alert with the given keyword
  ///
  /// Parameters:
  /// - [keyword]: The keyword to alert on (case-insensitive, trimmed)
  ///
  /// Returns:
  /// - Success with the created alert
  /// - Failure.conflict if alert already exists
  /// - Failure.unauthorized if user not authenticated
  /// - Failure.server if backend error
  AsyncResult<Alert> createAlert({required String keyword});

  /// Delete an alert by its ID
  ///
  /// Parameters:
  /// - [alertId]: The unique identifier of the alert to delete
  ///
  /// Returns:
  /// - Success (void) if deleted successfully
  /// - Failure.unauthorized if user not authenticated
  /// - Failure.server if backend error
  AsyncResult<void> deleteAlert({required String alertId});

  /// Fetch list of popular/trending keywords
  ///
  /// Returns:
  /// - Success with list of popular keywords (may be empty)
  /// - Failure.server if backend error
  AsyncResult<List<String>> fetchPopularKeywords();
}
