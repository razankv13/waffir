import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/data/models/alert_model.dart';

/// Mock implementation of AlertsRemoteDataSource for testing
///
/// Provides in-memory storage and simulated network delays.
/// Useful for development and testing without backend dependency.
class MockAlertsRemoteDataSource implements AlertsRemoteDataSource {
  final List<AlertModel> _myAlerts = [
    AlertModel(
      id: 'alert_001',
      keyword: 'iphone',
      isSubscribed: true,
      subscriberCount: 1250,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    AlertModel(
      id: 'alert_002',
      keyword: 'macbook',
      isSubscribed: true,
      subscriberCount: 890,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  final List<String> _popularKeywords = [
    'iphone',
    'samsung',
    'macbook',
    'airpods',
    'playstation',
    'xbox',
    'ipad',
    'nike',
    'adidas',
    'laptop',
  ];

  @override
  Future<List<AlertModel>> fetchMyAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_myAlerts);
  }

  @override
  Future<AlertModel> createAlert({required String keyword}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final normalized = keyword.trim().toLowerCase();

    // Check for duplicates
    if (_myAlerts.any((a) => a.keyword == normalized)) {
      throw const Failure.conflict(message: 'Alert already exists');
    }

    final newAlert = AlertModel(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      keyword: normalized,
      isSubscribed: true,
      subscriberCount: 1,
      createdAt: DateTime.now(),
    );

    _myAlerts.insert(0, newAlert);
    return newAlert;
  }

  @override
  Future<void> deleteAlert({required String alertId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _myAlerts.removeWhere((a) => a.id == alertId);
  }

  @override
  Future<List<String>> fetchPopularKeywords() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_popularKeywords);
  }

  // Test helpers

  /// Reset alerts to default state
  void reset() {
    _myAlerts.clear();
    _myAlerts.addAll([
      AlertModel(
        id: 'alert_001',
        keyword: 'iphone',
        isSubscribed: true,
        subscriberCount: 1250,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      AlertModel(
        id: 'alert_002',
        keyword: 'macbook',
        isSubscribed: true,
        subscriberCount: 890,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
  }

  /// Get current alerts (for testing)
  List<AlertModel> get alerts => List.from(_myAlerts);
}
