import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/alerts/data/providers/alerts_backend_providers.dart';
import 'package:waffir/features/alerts/domain/repositories/alerts_repository.dart';
import 'package:waffir/features/deals/domain/entities/alert.dart';

/// Immutable state for user's alerts.
///
/// Holds the list of alerts created by the user, along with loading and error states.
class MyAlertsState {
  const MyAlertsState({
    required this.alerts,
    this.failure,
    this.isCreating = false,
    this.isDeleting = false,
  });

  const MyAlertsState.initial()
      : alerts = const [],
        failure = null,
        isCreating = false,
        isDeleting = false;

  final List<Alert> alerts;
  final Failure? failure;
  final bool isCreating;
  final bool isDeleting;

  bool get hasError => failure != null;
  bool get isEmpty => alerts.isEmpty;
  bool get hasAlerts => alerts.isNotEmpty;

  MyAlertsState copyWith({
    List<Alert>? alerts,
    Failure? failure,
    bool? isCreating,
    bool? isDeleting,
  }) {
    return MyAlertsState(
      alerts: alerts ?? this.alerts,
      failure: failure,
      isCreating: isCreating ?? this.isCreating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  /// Clear the error state
  MyAlertsState clearError() {
    return MyAlertsState(
      alerts: alerts,
      isCreating: isCreating,
      isDeleting: isDeleting,
    );
  }
}

/// Provider for MyAlertsController.
final myAlertsControllerProvider =
    AsyncNotifierProvider<MyAlertsController, MyAlertsState>(MyAlertsController.new);

/// Controller for managing user's keyword-based alerts.
///
/// Responsibilities:
/// - Fetch user's alerts from backend (Supabase or mock)
/// - Create new alerts with optimistic UI update
/// - Delete alerts with optimistic removal and rollback on failure
/// - Handle errors gracefully with typed Failures
class MyAlertsController extends AsyncNotifier<MyAlertsState> {
  AlertsRepository get _repository => ref.read(alertsRepositoryProvider);

  @override
  Future<MyAlertsState> build() async {
    return await _fetchAlerts();
  }

  /// Fetch alerts from backend.
  Future<MyAlertsState> _fetchAlerts() async {
    final result = await _repository.fetchMyAlerts();
    return result.when(
      success: (alerts) => MyAlertsState(alerts: alerts),
      failure: (failure) => MyAlertsState(alerts: const [], failure: failure),
    );
  }

  /// Refresh alerts from backend.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _fetchAlerts());
  }

  /// Create a new alert with optimistic UI update.
  ///
  /// The alert is immediately added to the UI, and removed if the backend call fails.
  /// Returns null on success, or Failure on error.
  Future<Failure?> createAlert(String keyword) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Normalize keyword
    final normalizedKeyword = keyword.trim().toLowerCase();
    if (normalizedKeyword.isEmpty) {
      return const Failure.validation(
        message: 'Alert keyword cannot be empty',
        field: 'keyword',
      );
    }

    // Check for duplicate
    final isDuplicate = current.alerts.any((a) => a.keyword.toLowerCase() == normalizedKeyword);
    if (isDuplicate) {
      return const Failure.conflict(message: 'You already have an alert for this keyword');
    }

    // Set creating flag
    state = AsyncValue.data(current.copyWith(isCreating: true));

    // Call backend to create alert
    final result = await _repository.createAlert(keyword: normalizedKeyword);

    return result.when(
      success: (newAlert) {
        // Add the new alert to the beginning of the list
        final updatedAlerts = <Alert>[newAlert, ...current.alerts];
        state = AsyncValue.data(MyAlertsState(
          alerts: updatedAlerts,
        ));
        AppLogger.debug('✅ Alert created successfully: ${newAlert.keyword}');
        return null;
      },
      failure: (failure) {
        // Revert creating flag and show error
        state = AsyncValue.data(current.copyWith(
          isCreating: false,
          failure: failure,
        ));
        AppLogger.warning('⚠️ Failed to create alert: $failure');
        return failure;
      },
    );
  }

  /// Delete an alert with optimistic UI update and rollback on failure.
  ///
  /// The alert is immediately removed from the UI, and restored if the backend call fails.
  /// Returns null on success, or Failure on error.
  Future<Failure?> deleteAlert(String alertId) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Find the alert to delete
    final alertToDelete = current.alerts.firstWhere(
      (a) => a.id == alertId,
      orElse: () => throw const Failure.notFound(message: 'Alert not found'),
    );

    // Optimistic delete: remove from list immediately
    final updatedAlerts = current.alerts.where((a) => a.id != alertId).toList(growable: false);
    state = AsyncValue.data(current.copyWith(
      alerts: updatedAlerts,
      isDeleting: true,
    ));

    // Call backend to delete
    final result = await _repository.deleteAlert(alertId: alertId);

    return result.when(
      success: (_) {
        // Backend confirmed deletion
        state = AsyncValue.data(MyAlertsState(
          alerts: updatedAlerts,
        ));
        AppLogger.debug('✅ Alert deleted successfully: ${alertToDelete.keyword}');
        return null;
      },
      failure: (failure) {
        // Rollback: restore the deleted alert to its original position
        final restoredAlerts = [...current.alerts];
        state = AsyncValue.data(current.copyWith(
          alerts: restoredAlerts,
          isDeleting: false,
          failure: failure,
        ));
        AppLogger.warning('⚠️ Failed to delete alert: $failure');
        return failure;
      },
    );
  }

  /// Clear the current error state.
  void clearError() {
    final current = state.asData?.value;
    if (current != null && current.hasError) {
      state = AsyncValue.data(current.clearError());
    }
  }

  /// Check if an alert already exists for the given keyword.
  bool hasAlertFor(String keyword) {
    final current = state.asData?.value;
    if (current == null) return false;
    final normalized = keyword.trim().toLowerCase();
    return current.alerts.any((a) => a.keyword.toLowerCase() == normalized);
  }
}
