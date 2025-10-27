import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waffir/core/errors/exceptions.dart';
import 'package:waffir/core/services/firebase_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  FirebaseAuthService._internal();
  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StreamController<AuthState>? _authStateController;
  AuthState _currentAuthState = const AuthState.initial();

  Stream<AuthState> get authStateStream => _getAuthStateStream();
  Stream<AuthState> get authStateChanges => _getAuthStateStream();
  AuthState get currentAuthState => _currentAuthState;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null && _firebaseAuth.currentUser != null;

  /// Get auth state stream
  Stream<AuthState> _getAuthStateStream() {
    _authStateController ??= StreamController<AuthState>.broadcast();

    // Listen to Firebase Auth state changes
    _firebaseAuth.authStateChanges().listen(
      (User? user) {
        _handleAuthStateChange(user);
      },
      onError: (error) {
        AppLogger.error('Auth state stream error', error: error);
        _emitState(AuthState.error(message: 'Authentication stream error', exception: error));
      },
    );

    return _authStateController!.stream;
  }

  /// Handle Firebase Auth state changes
  Future<void> _handleAuthStateChange(User? user) async {
    try {
      if (user == null) {
        _currentUser = null;
        _emitState(const AuthState.unauthenticated());
        await _clearStoredCredentials();
        return;
      }

      // Check if email verification is required
      if (!user.emailVerified && user.email != null && !user.isAnonymous) {
        final userEntity = await _mapFirebaseUserToEntity(user);
        _currentUser = userEntity;
        _emitState(
          AuthState.emailVerificationRequired(
            user: userEntity,
            message: 'Please verify your email address',
          ),
        );
        return;
      }

      // User is authenticated
      final userEntity = await _mapFirebaseUserToEntity(user);
      _currentUser = userEntity;

      final idToken = await user.getIdToken();
      final refreshToken = user.refreshToken;
      await _storeCredentials(idToken ?? '', refreshToken ?? '');

      _emitState(
        AuthState.authenticated(
          user: userEntity,
          idToken: idToken,
          refreshToken: refreshToken,
          tokenExpiry: await _getTokenExpiry(idToken ?? ''),
        ),
      );

      // Update Firebase Analytics user properties
      await FirebaseService.instance.setUserProperties(
        userId: user.uid,
        properties: {
          'email_verified': user.emailVerified.toString(),
          'provider': user.providerData.first.providerId,
          'created_at': user.metadata.creationTime?.toIso8601String() ?? '',
        },
      );

      AppLogger.logAuth(
        'User authenticated',
        metadata: {
          'uid': user.uid,
          'email': user.email,
          'provider': user.providerData.first.providerId,
        },
      );
    } catch (error, stackTrace) {
      AppLogger.error('Failed to handle auth state change', error: error, stackTrace: stackTrace);
      _emitState(AuthState.error(message: 'Authentication state error', exception: error));
    }
  }

  /// Sign in with email and password
  Future<AuthState> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _emitState(const AuthState.loading());

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Sign in failed: No user returned');
      }

      await FirebaseService.instance.logEvent(
        name: 'login',
        parameters: {'method': 'email_password'},
      );

      return _currentAuthState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Email sign in failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: _getAuthErrorMessage(e),
        code: e.code,
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected sign in error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(message: 'An unexpected error occurred during sign in');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Create user with email and password
  Future<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _emitState(const AuthState.loading());

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Sign up failed: No user returned');
      }

      // Update display name if provided
      if (displayName != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Send email verification
      await credential.user!.sendEmailVerification();

      await FirebaseService.instance.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email_password'},
      );

      return _currentAuthState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Email sign up failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: _getAuthErrorMessage(e),
        code: e.code,
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected sign up error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(message: 'An unexpected error occurred during sign up');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Sign in with Google
  Future<AuthState> signInWithGoogle() async {
    try {
      _emitState(const AuthState.loading());

      // Initialize Google Sign-In if needed
      await _googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);

      await FirebaseService.instance.logEvent(name: 'login', parameters: {'method': 'google'});

      return _currentAuthState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Google sign in failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: _getAuthErrorMessage(e),
        code: e.code,
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected Google sign in error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(
        message: 'An unexpected error occurred during Google sign in',
      );
      _emitState(errorState);
      return errorState;
    }
  }

  /// Sign in with Apple
  Future<AuthState> signInWithApple() async {
    try {
      _emitState(const AuthState.loading());

      // Generate nonce
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(rawNonce.codeUnits).toString();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      // Update display name from Apple if available
      if (userCredential.user != null && appleCredential.givenName != null) {
        final displayName = '${appleCredential.givenName} ${appleCredential.familyName}'.trim();
        await userCredential.user!.updateDisplayName(displayName);
      }

      await FirebaseService.instance.logEvent(name: 'login', parameters: {'method': 'apple'});

      return _currentAuthState;
    } on SignInWithAppleException catch (e, stackTrace) {
      AppLogger.error('Apple sign in failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: 'Apple sign in failed: ${e.toString()}',
        code: 'apple_sign_in_error',
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Apple sign in Firebase error', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: _getAuthErrorMessage(e),
        code: e.code,
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected Apple sign in error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(
        message: 'An unexpected error occurred during Apple sign in',
      );
      _emitState(errorState);
      return errorState;
    }
  }

  /// Sign in anonymously
  Future<AuthState> signInAnonymously() async {
    try {
      _emitState(const AuthState.loading());

      await _firebaseAuth.signInAnonymously();

      await FirebaseService.instance.logEvent(name: 'login', parameters: {'method': 'anonymous'});

      return _currentAuthState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Anonymous sign in failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(
        message: _getAuthErrorMessage(e),
        code: e.code,
        exception: e,
      );
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected anonymous sign in error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(
        message: 'An unexpected error occurred during anonymous sign in',
      );
      _emitState(errorState);
      return errorState;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      await FirebaseService.instance.logEvent(
        name: 'password_reset_requested',
        parameters: {'method': 'email'},
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Password reset failed', error: e, stackTrace: stackTrace);
      throw AuthException(_getAuthErrorMessage(e), code: e.code);
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected password reset error', error: error, stackTrace: stackTrace);
      throw const AuthException('Failed to send password reset email');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      await user.sendEmailVerification();

      await FirebaseService.instance.logEvent(name: 'email_verification_sent');
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Email verification failed', error: e, stackTrace: stackTrace);
      throw AuthException(_getAuthErrorMessage(e), code: e.code);
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected email verification error', error: error, stackTrace: stackTrace);
      throw const AuthException('Failed to send email verification');
    }
  }

  /// Reload user to check email verification status
  Future<void> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      await _handleAuthStateChange(_firebaseAuth.currentUser);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      await FirebaseService.instance.logEvent(name: 'logout');
    } catch (error, stackTrace) {
      AppLogger.error('Sign out error', error: error, stackTrace: stackTrace);
      // Continue with sign out even if there's an error
    }
  }

  /// Delete current user account
  Future<void> deleteAccount({required String password}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      // Reauthenticate before deleting account
      final credential = EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      await user.delete();

      await FirebaseService.instance.logEvent(name: 'account_deleted');
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Account deletion failed', error: e, stackTrace: stackTrace);
      throw AuthException(_getAuthErrorMessage(e), code: e.code);
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected account deletion error', error: error, stackTrace: stackTrace);
      throw const AuthException('Failed to delete account');
    }
  }

  /// Update user profile
  Future<AuthState> updateProfile({String? displayName, String? photoURL}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);

      // Reload user to get updated data
      await user.reload();
      await _handleAuthStateChange(_firebaseAuth.currentUser);

      await FirebaseService.instance.logEvent(name: 'profile_updated');

      return _currentAuthState;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Profile update failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(message: _getAuthErrorMessage(e), code: e.code);
      _emitState(errorState);
      return errorState;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected profile update error', error: error, stackTrace: stackTrace);
      const errorState = AuthState.error(message: 'Failed to update profile');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Update user password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      // Reauthenticate user first
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      await FirebaseService.instance.logEvent(name: 'password_updated');
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Password update failed', error: e, stackTrace: stackTrace);
      throw AuthException(_getAuthErrorMessage(e), code: e.code);
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected password update error', error: error, stackTrace: stackTrace);
      throw const AuthException('Failed to update password');
    }
  }

  /// Reauthenticate with email and password
  Future<void> reauthenticateWithEmailPassword(String email, String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error('Reauthentication failed', error: e, stackTrace: stackTrace);
      throw AuthException(_getAuthErrorMessage(e), code: e.code);
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected reauthentication error', error: error, stackTrace: stackTrace);
      throw const AuthException('Failed to reauthenticate');
    }
  }

  /// Get ID token
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      return await user.getIdToken(forceRefresh);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to get ID token', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// Verify email with code
  Future<void> verifyEmailWithCode({required String code}) async {
    try {
      await _firebaseAuth.applyActionCode(code);
    } catch (e, stackTrace) {
      AppLogger.error('Email verification failed', error: e, stackTrace: stackTrace);
      throw AuthException('Email verification failed: ${e.toString()}');
    }
  }

  /// Update user email
  Future<void> updateEmail({required String newEmail, required String password}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      // Reauthenticate user first
      final credential = EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newEmail);
    } catch (e, stackTrace) {
      AppLogger.error('Email update failed', error: e, stackTrace: stackTrace);
      throw AuthException('Email update failed: ${e.toString()}');
    }
  }

  /// Verify phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) {
          // Auto verification completed
        },
        verificationFailed: (e) {
          verificationFailed(e.message ?? 'Phone verification failed');
        },
        codeSent: (verificationId, resendToken) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          codeAutoRetrievalTimeout();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Phone verification failed', error: e, stackTrace: stackTrace);
      throw AuthException('Phone verification failed: ${e.toString()}');
    }
  }

  /// Verify phone with SMS code
  Future<AuthState> verifyPhoneWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      _emitState(const AuthState.loading());

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return _currentAuthState;
    } catch (e, stackTrace) {
      AppLogger.error('Phone code verification failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(message: 'Phone verification failed: ${e.toString()}');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Link phone number to account
  Future<AuthState> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      _emitState(const AuthState.loading());

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await user.linkWithCredential(credential);
      return _currentAuthState;
    } catch (e, stackTrace) {
      AppLogger.error('Phone linking failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(message: 'Phone linking failed: ${e.toString()}');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Sign in with phone number
  Future<AuthState> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    return verifyPhoneWithCode(verificationId: verificationId, smsCode: smsCode);
  }

  /// Reauthenticate user
  Future<void> reauthenticate({required String password}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found');
    }

    try {
      final credential = EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);
    } catch (e, stackTrace) {
      AppLogger.error('Reauthentication failed', error: e, stackTrace: stackTrace);
      throw AuthException('Reauthentication failed: ${e.toString()}');
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await user.getIdToken(true);
    } catch (e, stackTrace) {
      AppLogger.error('Token refresh failed', error: e, stackTrace: stackTrace);
      throw AuthException('Token refresh failed: ${e.toString()}');
    }
  }

  /// Check if email is available
  Future<bool> isEmailAvailable(String email) async {
    return true;
    // try {
    //   final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    //   return methods.isEmpty;
    // } catch (e) {
    //   return false;
    // }
  }

  /// Get user by ID (placeholder - would need Firestore integration)
  Future<UserModel?> getUserById(String userId) async {
    // This would typically query Firestore for user data
    // For now, return null as we don't have Firestore integration yet
    return null;
  }

  /// Update user data (placeholder - would need Firestore integration)
  Future<void> updateUserData(UserModel user) async {
    // This would typically update user data in Firestore
    // For now, just log the operation
    AppLogger.info('Update user data called for user: ${user.id}');
  }

  /// Link authentication providers
  Future<AuthState> linkWithCredential({
    required String providerId,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      _emitState(const AuthState.loading());

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found');
      }

      // This is a simplified implementation
      // You would create appropriate credentials based on providerId
      throw const AuthException('Provider linking not fully implemented');
    } catch (e, stackTrace) {
      AppLogger.error('Provider linking failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(message: 'Provider linking failed: ${e.toString()}');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Unlink authentication provider
  Future<AuthState> unlinkProvider(String providerId) async {
    try {
      _emitState(const AuthState.loading());

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found');
      }

      await user.unlink(providerId);
      return _currentAuthState;
    } catch (e, stackTrace) {
      AppLogger.error('Provider unlinking failed', error: e, stackTrace: stackTrace);
      final errorState = AuthState.error(message: 'Provider unlinking failed: ${e.toString()}');
      _emitState(errorState);
      return errorState;
    }
  }

  /// Get linked providers
  Future<List<String>> getLinkedProviders() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return [];

      return user.providerData.map((info) => info.providerId).toList();
    } catch (e) {
      return [];
    }
  }

  /// Map Firebase User to UserEntity
  Future<UserModel> _mapFirebaseUserToEntity(User user) async {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
      metadata: {
        'providers': user.providerData.map((p) => p.providerId).toList(),
        'isNewUser':
            user.metadata.creationTime?.isAfter(
              DateTime.now().subtract(const Duration(minutes: 1)),
            ) ??
            false,
      },
    );
  }

  /// Get Firebase Auth error message
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  /// Generate nonce for Apple Sign In
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Store credentials securely
  Future<void> _storeCredentials(String idToken, String? refreshToken) async {
    try {
      await _secureStorage.write(key: 'firebase_id_token', value: idToken);
      if (refreshToken != null) {
        await _secureStorage.write(key: 'firebase_refresh_token', value: refreshToken);
      }
    } catch (error, stackTrace) {
      AppLogger.error('Failed to store credentials', error: error, stackTrace: stackTrace);
    }
  }

  /// Clear stored credentials
  Future<void> _clearStoredCredentials() async {
    try {
      await _secureStorage.delete(key: 'firebase_id_token');
      await _secureStorage.delete(key: 'firebase_refresh_token');
    } catch (error, stackTrace) {
      AppLogger.error('Failed to clear credentials', error: error, stackTrace: stackTrace);
    }
  }

  /// Get token expiry time
  Future<DateTime?> _getTokenExpiry(String idToken) async {
    try {
      // JWT tokens are base64 encoded, decode to get expiry
      final parts = idToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      final exp = json['exp'] as int?;
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (error) {
      AppLogger.warning('Failed to parse token expiry: $error');
    }
    return null;
  }

  /// Emit auth state
  void _emitState(AuthState state) {
    _currentAuthState = state;
    _authStateController?.add(state);
  }

  /// Dispose resources
  void dispose() {
    _authStateController?.close();
    _authStateController = null;
    _instance = null;
  }
}
