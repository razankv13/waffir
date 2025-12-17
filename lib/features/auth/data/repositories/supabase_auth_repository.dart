import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/exception_to_failure.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final sb.SupabaseClient _client;

  @override
  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      return _toDomainAuthState(event: data.event, session: data.session);
    });
  }

  @override
  AuthState get currentAuthState {
    final session = _client.auth.currentSession;
    return _toDomainAuthState(event: sb.AuthChangeEvent.initialSession, session: session);
  }

  @override
  UserModel? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _toDomainUser(user);
  }

  @override
  AsyncResult<AuthState> signInWithEmailAndPassword({required String email, required String password}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email/password auth is disabled. Use Phone (OTP) or Social login.'),
    );
  }

  @override
  AsyncResult<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email/password sign up is disabled. Use Phone (OTP) or Social login.'),
    );
  }

  @override
  AsyncResult<AuthState> signInWithGoogle() async {
    try {
      final signIn = GoogleSignInPlatform.instance;
      await signIn.init(
        InitParameters(
          clientId: EnvironmentConfig.googleClientIdIOS,
          serverClientId: EnvironmentConfig.googleClientIdWeb,
        ),
      );

      final result = await signIn.authenticate(const AuthenticateParameters(scopeHint: <String>['email']));
      final idToken = result.authenticationTokens.idToken;
      if (idToken == null || idToken.isEmpty) {
        return const Result.failure(Failure.validation(message: 'Missing Google ID token.'));
      }

      final tokenData = await signIn.clientAuthorizationTokensForScopes(
        ClientAuthorizationTokensForScopesParameters(
          request: AuthorizationRequestDetails(
            scopes: const <String>['email'],
            userId: result.user.id,
            email: result.user.email,
            promptIfUnauthorized: true,
          ),
        ),
      );
      final accessToken = tokenData?.accessToken;

      final response = await _client.auth.signInWithIdToken(
        provider: sb.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final session = response.session ?? _client.auth.currentSession;
      return Result.success(_toDomainAuthState(event: sb.AuthChangeEvent.signedIn, session: session));
    } on GoogleSignInException catch (e, stackTrace) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Result.failure(Failure.validation(message: 'Google sign-in cancelled.'));
      }
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInWithApple() async {
    try {
      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        return const Result.failure(Failure.validation(message: 'Missing Apple identity token.'));
      }

      final response = await _client.auth.signInWithIdToken(
        provider: sb.OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      final session = response.session ?? _client.auth.currentSession;
      return Result.success(_toDomainAuthState(event: sb.AuthChangeEvent.signedIn, session: session));
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInAnonymously() async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Anonymous auth is not supported for Supabase in this app.'),
    );
  }

  @override
  AsyncResult<void> sendPasswordResetEmail({required String email}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email/password auth is disabled. Password reset is not available.'),
    );
  }

  @override
  AsyncResult<void> sendEmailVerification() async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email verification is not used. Use Phone (OTP) or Social login.'),
    );
  }

  @override
  AsyncResult<void> verifyEmailWithCode({required String code}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email verification is not used. Use Phone (OTP) or Social login.'),
    );
  }

  @override
  AsyncResult<AuthState> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final current = _client.auth.currentUser;
      if (current == null) {
        return const Result.failure(Failure.unauthorized(message: 'Not signed in.'));
      }

      final data = <String, dynamic>{};
      if (displayName != null && displayName.trim().isNotEmpty) {
        data['full_name'] = displayName.trim();
      }
      if (photoURL != null && photoURL.trim().isNotEmpty) {
        data['avatar_url'] = photoURL.trim();
      }

      if (data.isNotEmpty) {
        await _client.auth.updateUser(sb.UserAttributes(data: data));
      }

      final session = _client.auth.currentSession;
      return Result.success(_toDomainAuthState(event: sb.AuthChangeEvent.userUpdated, session: session));
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> updatePassword({required String currentPassword, required String newPassword}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email/password auth is disabled. Password updates are not available.'),
    );
  }

  @override
  AsyncResult<void> updateEmail({required String newEmail, required String password}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email/password auth is disabled. Email updates are not available.'),
    );
  }

  @override
  AsyncResult<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    try {
      await _client.auth.signInWithOtp(phone: phoneNumber);
      // Supabase verify step requires the phone number again; we use it as our "verificationId".
      codeSent(phoneNumber);
      return const Result.success(null);
    } catch (e, stackTrace) {
      verificationFailed(e.toString());
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> verifyPhoneWithCode({required String verificationId, required String smsCode}) async {
    try {
      final response = await _client.auth.verifyOTP(
        phone: verificationId,
        token: smsCode,
        type: sb.OtpType.sms,
      );

      final session = response.session ?? _client.auth.currentSession;
      return Result.success(_toDomainAuthState(event: sb.AuthChangeEvent.signedIn, session: session));
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> linkPhoneNumber({required String verificationId, required String smsCode}) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Phone linking is not implemented yet.'));
  }

  @override
  AsyncResult<AuthState> signInWithPhoneNumber({required String verificationId, required String smsCode}) async {
    // In Supabase OTP, "sign in" is completing verifyOTP.
    return verifyPhoneWithCode(verificationId: verificationId, smsCode: smsCode);
  }

  @override
  AsyncResult<void> reauthenticate({required String password}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Reauthentication is not implemented for Supabase in this app.'),
    );
  }

  @override
  AsyncResult<void> deleteAccount({required String password}) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Delete account is not implemented yet.'));
  }

  @override
  AsyncResult<void> signOut() async {
    try {
      await _client.auth.signOut();
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> refreshToken() async {
    try {
      await _client.auth.refreshSession();
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<bool> isEmailAvailable(String email) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Email/password auth is disabled.'));
  }

  @override
  AsyncResult<UserModel> getUserById(String userId) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'User lookup is not implemented yet.'));
  }

  @override
  AsyncResult<void> updateUserData(UserModel user) async {
    try {
      final current = _client.auth.currentUser;
      if (current == null) {
        return const Result.failure(Failure.unauthorized(message: 'Not signed in.'));
      }
      if (current.id != user.id) {
        return const Result.failure(Failure.unauthorized(message: 'Cannot update a different user.'));
      }

      final data = <String, dynamic>{
        if (user.displayName != null && user.displayName!.trim().isNotEmpty) 'full_name': user.displayName!.trim(),
        if (user.firstName != null && user.firstName!.trim().isNotEmpty) 'first_name': user.firstName!.trim(),
        if (user.lastName != null && user.lastName!.trim().isNotEmpty) 'last_name': user.lastName!.trim(),
        if (user.gender != null && user.gender!.trim().isNotEmpty) 'gender': user.gender!.trim(),
        if (user.photoURL != null && user.photoURL!.trim().isNotEmpty) 'avatar_url': user.photoURL!.trim(),
        if (user.preferences.containsKey('acceptedTerms')) 'accepted_terms': user.preferences['acceptedTerms'] == true,
      };

      await _client.auth.updateUser(sb.UserAttributes(data: data));
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> linkWithCredential({required String providerId, Map<String, dynamic>? parameters}) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Provider linking is not implemented yet.'));
  }

  @override
  AsyncResult<AuthState> unlinkProvider(String providerId) async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Provider unlinking is not implemented yet.'));
  }

  @override
  AsyncResult<List<String>> getLinkedProviders() async {
    return const Result.failure(Failure.featureNotAvailable(message: 'Provider listing is not implemented yet.'));
  }

  AuthState _toDomainAuthState({required sb.AuthChangeEvent event, required sb.Session? session}) {
    final user = session?.user ?? _client.auth.currentUser;
    if (session == null || user == null) {
      return const AuthState.unauthenticated();
    }

    DateTime? tokenExpiry;
    final expiresAt = session.expiresAt;
    if (expiresAt != null) {
      tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000, isUtc: true).toLocal();
    }

    return AuthState.authenticated(
      user: _toDomainUser(user),
      idToken: session.accessToken,
      refreshToken: session.refreshToken,
      tokenExpiry: tokenExpiry,
    );
  }

  UserModel _toDomainUser(sb.User user) {
    final metadata = <String, dynamic>{
      ...user.userMetadata ?? const <String, dynamic>{},
      'app_metadata': user.appMetadata,
    };

    final acceptedTerms = user.userMetadata?['accepted_terms'] ?? user.userMetadata?['acceptedTerms'];
    final preferences = <String, dynamic>{
      if (acceptedTerms is bool) 'acceptedTerms': acceptedTerms,
    };

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: (user.userMetadata?['full_name'] as String?) ?? (user.userMetadata?['name'] as String?),
      photoURL: user.userMetadata?['avatar_url'] as String?,
      phoneNumber: user.phone,
      emailVerified: user.emailConfirmedAt != null,
      isAnonymous: user.isAnonymous,
      createdAt: DateTime.tryParse(user.createdAt),
      lastSignInAt: DateTime.tryParse(user.lastSignInAt ?? ''),
      metadata: metadata,
      firstName: user.userMetadata?['first_name'] as String?,
      lastName: user.userMetadata?['last_name'] as String?,
      gender: user.userMetadata?['gender'] as String?,
      country: user.userMetadata?['country'] as String?,
      language: user.userMetadata?['language'] as String?,
      timezone: user.userMetadata?['timezone'] as String?,
      roles: (user.appMetadata['roles'] is List)
          ? List<String>.from(user.appMetadata['roles'] as List)
          : const <String>[],
      preferences: preferences,
    );
  }
}
