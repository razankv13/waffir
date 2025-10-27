import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/core/result/result.dart';

abstract class AuthRepository {
  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges;

  /// Get current authentication state
  AuthState get currentAuthState;

  /// Get current user if authenticated
  UserModel? get currentUser;

  /// Sign in with email and password
  AsyncResult<AuthState> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create account with email and password
  AsyncResult<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with Google
  AsyncResult<AuthState> signInWithGoogle();

  /// Sign in with Apple
  AsyncResult<AuthState> signInWithApple();

  /// Sign in anonymously
  AsyncResult<AuthState> signInAnonymously();

  /// Send password reset email
  AsyncResult<void> sendPasswordResetEmail({
    required String email,
  });

  /// Send email verification
  AsyncResult<void> sendEmailVerification();

  /// Verify email with code
  AsyncResult<void> verifyEmailWithCode({
    required String code,
  });

  /// Update user profile
  AsyncResult<AuthState> updateProfile({
    String? displayName,
    String? photoURL,
  });

  /// Update user password
  AsyncResult<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user email
  AsyncResult<void> updateEmail({
    required String newEmail,
    required String password,
  });

  /// Verify phone number
  AsyncResult<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  });

  /// Verify phone with SMS code
  AsyncResult<AuthState> verifyPhoneWithCode({
    required String verificationId,
    required String smsCode,
  });

  /// Link phone number to account
  AsyncResult<AuthState> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  /// Sign in with phone number
  AsyncResult<AuthState> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  /// Reauthenticate user
  AsyncResult<void> reauthenticate({
    required String password,
  });

  /// Delete user account
  AsyncResult<void> deleteAccount({
    required String password,
  });

  /// Sign out
  AsyncResult<void> signOut();

  /// Refresh authentication token
  AsyncResult<void> refreshToken();

  /// Check if email is available
  AsyncResult<bool> isEmailAvailable(String email);

  /// Get user by ID
  AsyncResult<UserModel> getUserById(String userId);

  /// Update user data in Firestore
  AsyncResult<void> updateUserData(UserModel user);

  /// Link authentication providers
  AsyncResult<AuthState> linkWithCredential({
    required String providerId,
    Map<String, dynamic>? parameters,
  });

  /// Unlink authentication provider
  AsyncResult<AuthState> unlinkProvider(String providerId);

  /// Get linked providers
  AsyncResult<List<String>> getLinkedProviders();
}