import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';
import 'package:waffir/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:waffir/core/services/auth/firebase_auth_service.dart';

// Re-export the auth controller provider
export '../../presentation/controllers/auth_controller.dart' show authControllerProvider;

// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService.instance;
});

// Firebase Auth Instance Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return FirebaseAuthRepository(authService);
});

// Auth State Stream Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
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