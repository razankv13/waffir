import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/data/repositories/supabase_auth_bootstrap_repository.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/auth_bootstrap_data.dart';

final supabaseAuthBootstrapRepositoryProvider = Provider<SupabaseAuthBootstrapRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthBootstrapRepository(client);
});

class PendingFamilyInviteIdController extends Notifier<String?> {
  @override
  String? build() => null;

  void setInviteId(String? inviteId) => state = inviteId;
  void clear() => state = null;
}

final pendingFamilyInviteIdProvider = NotifierProvider<PendingFamilyInviteIdController, String?>(
  PendingFamilyInviteIdController.new,
);

/// Tracks if user has completed initial navigation (city selection done).
/// This survives widget recreations unlike useState, preventing redirect loops.
class InitialNavigationController extends Notifier<bool> {
  @override
  bool build() => false;

  void markCompleted() => state = true;
  void reset() => state = false;
}

final initialNavigationCompletedProvider =
    NotifierProvider<InitialNavigationController, bool>(InitialNavigationController.new);

class AuthBootstrapController extends AsyncNotifier<AuthBootstrapData?> {
  /// Tracks the last bootstrapped user ID to prevent redundant fetches.
  String? _previousUserId;

  /// Prevents concurrent bootstrap fetches.
  bool _isFetching = false;

  @override
  Future<AuthBootstrapData?> build() async {
    // Only use ref.listen for auth state changes - NOT ref.watch
    // This prevents provider rebuilds and double-handling
    ref.listen(authStateProvider, (previous, next) {
      _handleAuthStateChange(next);
    });

    // Use ref.read for initial check (not watch) to avoid rebuild loops
    final authStateAsync = ref.read(authStateProvider);
    if (!authStateAsync.hasValue) {
      // Auth state not ready yet - return null, listener will handle when ready
      return null;
    }

    final initialAuthState = authStateAsync.value;
    if (initialAuthState == null || !initialAuthState.isAuthenticated) {
      return null;
    }

    final userId = initialAuthState.user?.id;
    if (userId == null || userId.isEmpty) {
      return null;
    }

    // Perform initial bootstrap
    return _performBootstrap(userId);
  }

  Future<AuthBootstrapData?> _performBootstrap(String userId) async {
    _previousUserId = userId;

    if (EnvironmentConfig.useMockAuth) {
      return AuthBootstrapData(
        userId: userId,
        accountSummary: null,
        userSettings: null,
        hasHadSubscriptionBefore: null,
        fetchedAt: DateTime.now(),
      );
    }

    return ref.read(supabaseAuthBootstrapRepositoryProvider).bootstrap();
  }

  Future<void> refresh() async {
    if (_isFetching) return;

    final authStateAsync = ref.read(authStateProvider);
    if (!authStateAsync.hasValue) return;

    final authState = authStateAsync.value;
    if (authState == null || !authState.isAuthenticated || authState.user == null) {
      state = const AsyncValue.data(null);
      return;
    }

    final userId = authState.user!.id;
    if (userId.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    _isFetching = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _performBootstrap(userId));
    _isFetching = false;
  }

  void _handleAuthStateChange(AsyncValue<AuthState> next) {
    if (next.isLoading || !next.hasValue) return;

    final authState = next.value;
    if (authState == null) return;

    // Handle logout
    if (!authState.isAuthenticated) {
      _previousUserId = null;
      _isFetching = false;
      state = const AsyncValue.data(null);
      ref.read(pendingFamilyInviteIdProvider.notifier).clear();
      return;
    }

    final nextUserId = authState.user?.id;
    if (nextUserId == null || nextUserId.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    // CRITICAL: Skip if same user AND (already have data OR currently fetching)
    // This prevents the infinite loop where loading state causes re-fetches
    if (_previousUserId == nextUserId && (state.hasValue || _isFetching)) {
      return;
    }

    // Prevent concurrent fetches
    if (_isFetching) return;

    _fetchBootstrapData(nextUserId);
  }

  Future<void> _fetchBootstrapData(String userId) async {
    _isFetching = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _performBootstrap(userId));
    _isFetching = false;
  }
}

final authBootstrapControllerProvider =
    AsyncNotifierProvider<AuthBootstrapController, AuthBootstrapData?>(AuthBootstrapController.new);

final isBootstrappedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final authenticated = authState.hasValue && (authState.value?.isAuthenticated ?? false);
  if (!authenticated) return true;

  final bootstrap = ref.watch(authBootstrapControllerProvider);
  // Bootstrapped when: has data OR has error (error handled by splash screen)
  // Only false when actively loading
  return !bootstrap.isLoading;
});
