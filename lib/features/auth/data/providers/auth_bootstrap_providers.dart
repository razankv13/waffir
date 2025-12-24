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
  @override
  Future<AuthBootstrapData?> build() async {
    ref.listen(authStateProvider, (previous, next) {
      unawaited(_handleAuthStateChange(next));
    });

    final initialAuthState = await ref.watch(authStateProvider.future);
    if (!initialAuthState.isAuthenticated) return null;

    if (EnvironmentConfig.useMockAuth) {
      return AuthBootstrapData(
        userId: initialAuthState.user!.id,
        accountSummary: null,
        userSettings: null,
        hasHadSubscriptionBefore: null,
        fetchedAt: DateTime.now(),
      );
    }

    return ref.read(supabaseAuthBootstrapRepositoryProvider).bootstrap();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (EnvironmentConfig.useMockAuth) {
        final authStateAsync = ref.read(authStateProvider);
        final authState = authStateAsync.hasValue ? authStateAsync.value : null;
        if (authState == null || !authState.isAuthenticated || authState.user == null) return null;
        return AuthBootstrapData(
          userId: authState.user!.id,
          accountSummary: null,
          userSettings: null,
          hasHadSubscriptionBefore: null,
          fetchedAt: DateTime.now(),
        );
      }
      return ref.read(supabaseAuthBootstrapRepositoryProvider).bootstrap();
    });
  }

  Future<void> _handleAuthStateChange(AsyncValue<AuthState> next) async {
    if (next.isLoading) return;

    if (!next.hasValue) return;
    final authState = next.value;
    if (authState == null) return;

    if (!authState.isAuthenticated) {
      state = const AsyncValue.data(null);
      ref.read(pendingFamilyInviteIdProvider.notifier).clear();
      return;
    }

    final nextUserId = authState.user?.id;
    if (nextUserId == null || nextUserId.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    final current = state.hasValue ? state.value : null;
    if (current != null && current.userId == nextUserId) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (EnvironmentConfig.useMockAuth) {
        return AuthBootstrapData(
          userId: nextUserId,
          accountSummary: null,
          userSettings: null,
          hasHadSubscriptionBefore: null,
          fetchedAt: DateTime.now(),
        );
      }
      return ref.read(supabaseAuthBootstrapRepositoryProvider).bootstrap();
    });
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
