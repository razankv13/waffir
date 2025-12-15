import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';
import 'package:waffir/features/auth/data/datasources/mock_auth_session_storage.dart';
import 'package:waffir/features/auth/data/datasources/mock_auth_store.dart';
import 'package:waffir/features/auth/data/repositories/cloud_functions_auth_repository.dart';
import 'package:waffir/features/auth/data/repositories/mock_auth_repository.dart';

// Re-export the auth controller provider
export '../../presentation/controllers/auth_controller.dart' show authControllerProvider;

final mockAuthStoreProvider = Provider<MockAuthStore>((ref) {
  final store = MockAuthStore();
  final sessionStorage = MockAuthSessionStorage(HiveService.instance);
  final persisted = sessionStorage.load();
  if (persisted != null) {
    store.restoreAuthenticated(persisted);
  }
  ref.onDispose(() => unawaited(store.dispose()));
  return store;
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (EnvironmentConfig.useMockAuth) {
    final store = ref.watch(mockAuthStoreProvider);
    final sessionStorage = MockAuthSessionStorage(HiveService.instance);
    return MockAuthRepository(store, sessionStorage);
  }

  return const CloudFunctionsAuthRepository();
});

// Auth State Stream Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(data: (state) => state.user, loading: () => null, error: (_, __) => null);
});

/// Active user provider.
///
/// When mock auth is enabled, this reads directly from the mock store so screens
/// can access the "mocked user" even if the auth state stream wiring changes.
final activeUserProvider = Provider<UserModel?>((ref) {
  if (EnvironmentConfig.useMockAuth) {
    return ref.watch(mockAuthStoreProvider).currentUser;
  }
  return ref.watch(currentUserProvider);
});

// Authentication Status Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.isAuthenticated,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Auth Loading State Provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.isLoading,
    loading: () => true,
    error: (_, __) => false,
  );
});

// Auth Error Provider
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.errorMessage,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
});

// Email Verification Required Provider
final emailVerificationRequiredProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.requiresEmailVerification,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Phone Verification Required Provider
final phoneVerificationRequiredProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.requiresPhoneVerification,
    loading: () => false,
    error: (_, __) => false,
  );
});

// MFA Required Provider
final mfaRequiredProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.requiresMfa,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Token Expiry Provider
final tokenExpiredProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.isTokenExpired,
    loading: () => false,
    error: (_, __) => true,
  );
});
