import 'package:waffir/features/alerts/data/models/alert_model.dart';

/// Abstract data source for alerts operations
///
/// Defines the contract for interacting with the alerts backend (Supabase or mock).
/// Implementations should throw Failure on errors, not return Result.
abstract class AlertsRemoteDataSource {
  /// Fetch all alerts for the authenticated user
  ///
  /// Throws:
  /// - [Failure.unauthorized] if user is not authenticated
  /// - [Failure.server] if backend request fails
  Future<List<AlertModel>> fetchMyAlerts();

  /// Create a new alert with the given keyword
  ///
  /// Parameters:
  /// - [keyword]: The keyword to alert on (will be normalized to lowercase)
  ///
  /// Returns the created alert model
  ///
  /// Throws:
  /// - [Failure.unauthorized] if user is not authenticated
  /// - [Failure.conflict] if alert with this keyword already exists
  /// - [Failure.server] if backend request fails
  Future<AlertModel> createAlert({required String keyword});

  /// Delete an alert by its ID
  ///
  /// Parameters:
  /// - [alertId]: The unique identifier of the alert to delete
  ///
  /// Throws:
  /// - [Failure.unauthorized] if user is not authenticated
  /// - [Failure.server] if backend request fails
  Future<void> deleteAlert({required String alertId});

  /// Fetch list of popular/trending keywords
  ///
  /// Returns a list of keyword strings that are popular among users.
  /// Used for alert suggestions.
  ///
  /// Throws:
  /// - [Failure.server] if backend request fails
  Future<List<String>> fetchPopularKeywords();
}
