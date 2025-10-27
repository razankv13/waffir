import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/result/result.dart';

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Watch the auth state stream
    ref.listen(authStateProvider, (previous, next) {
      next.when(
        data: (authState) {
          state = AsyncValue.data(authState);
        },
        loading: () {
          state = const AsyncValue.loading();
        },
        error: (error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
        },
      );
    });

    // Return initial state
    return const AuthState.initial();
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithEmailAndPassword(email: email, password: password);

    result.when(
      success: (authState) {
        AppLogger.info('✅ Email sign in successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Email sign in failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Create account with email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.when(
      success: (authState) {
        AppLogger.info('✅ Account creation successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Account creation failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithGoogle();

    result.when(
      success: (authState) {
        AppLogger.info('✅ Google sign in successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Google sign in failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithApple();

    result.when(
      success: (authState) {
        AppLogger.info('✅ Apple sign in successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Apple sign in failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Sign in anonymously
  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInAnonymously();

    result.when(
      success: (authState) {
        AppLogger.info('✅ Anonymous sign in successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Anonymous sign in failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.sendPasswordResetEmail(email: email);

    result.when(
      success: (_) {
        AppLogger.info('✅ Password reset email sent');
      },
      failure: (failure) {
        AppLogger.error('❌ Failed to send password reset email: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.sendEmailVerification();

    result.when(
      success: (_) {
        AppLogger.info('✅ Email verification sent');
      },
      failure: (failure) {
        AppLogger.error('❌ Failed to send email verification: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Verify email with code
  Future<void> verifyEmailWithCode({required String code}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyEmailWithCode(code: code);

    result.when(
      success: (_) {
        AppLogger.info('✅ Email verified successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ Email verification failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updateProfile(displayName: displayName, photoURL: photoURL);

    result.when(
      success: (authState) {
        AppLogger.info('✅ Profile updated successfully');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Profile update failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Update user password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.when(
      success: (_) {
        AppLogger.info('✅ Password updated successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ Password update failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Update user email
  Future<void> updateEmail({required String newEmail, required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updateEmail(newEmail: newEmail, password: password);

    result.when(
      success: (_) {
        AppLogger.info('✅ Email updated successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ Email update failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Verify phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );

    result.when(
      success: (_) {
        AppLogger.info('✅ Phone verification initiated');
      },
      failure: (failure) {
        AppLogger.error('❌ Phone verification failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Verify phone with SMS code
  Future<void> verifyPhoneWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyPhoneWithCode(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    result.when(
      success: (authState) {
        AppLogger.info('✅ Phone verified successfully');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Phone verification failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Sign in with phone number
  Future<void> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    result.when(
      success: (authState) {
        AppLogger.info('✅ Phone sign in successful');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Phone sign in failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Reauthenticate user
  Future<void> reauthenticate({required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.reauthenticate(password: password);

    result.when(
      success: (_) {
        AppLogger.info('✅ Reauthentication successful');
      },
      failure: (failure) {
        AppLogger.error('❌ Reauthentication failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Delete user account
  Future<void> deleteAccount({required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.deleteAccount(password: password);

    result.when(
      success: (_) {
        AppLogger.info('✅ Account deleted successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ Account deletion failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signOut();

    result.when(
      success: (_) {
        AppLogger.info('✅ Sign out successful');
      },
      failure: (failure) {
        AppLogger.error('❌ Sign out failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.refreshToken();

    result.when(
      success: (_) {
        AppLogger.info('✅ Token refreshed successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ Token refresh failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Check if email is available
  Future<bool> isEmailAvailable(String email) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.isEmailAvailable(email);

    return result.when(
      success: (isAvailable) {
        return isAvailable;
      },
      failure: (failure) {
        AppLogger.error('❌ Email availability check failed: ${failure.message}');
        return false;
      },
    );
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getUserById(userId);

    return result.when(
      success: (user) => user,
      failure: (failure) {
        AppLogger.error('❌ Get user by ID failed: ${failure.message}');
        return null;
      },
    );
  }

  /// Update user data in Firestore
  Future<void> updateUserData(UserModel user) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updateUserData(user);

    result.when(
      success: (_) {
        AppLogger.info('✅ User data updated successfully');
      },
      failure: (failure) {
        AppLogger.error('❌ User data update failed: ${failure.message}');
        throw failure;
      },
    );
  }

  /// Link authentication providers
  Future<void> linkWithCredential({
    required String providerId,
    Map<String, dynamic>? parameters,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.linkWithCredential(
      providerId: providerId,
      parameters: parameters,
    );

    result.when(
      success: (authState) {
        AppLogger.info('✅ Provider linked successfully');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Provider linking failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Unlink authentication provider
  Future<void> unlinkProvider(String providerId) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.unlinkProvider(providerId);

    result.when(
      success: (authState) {
        AppLogger.info('✅ Provider unlinked successfully');
        state = AsyncValue.data(authState);
      },
      failure: (failure) {
        AppLogger.error('❌ Provider unlinking failed: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Get linked providers
  Future<List<String>> getLinkedProviders() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getLinkedProviders();

    return result.when(
      success: (providers) => providers,
      failure: (failure) {
        AppLogger.error('❌ Get linked providers failed: ${failure.message}');
        return [];
      },
    );
  }
}

/// Auth Controller Provider
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});
