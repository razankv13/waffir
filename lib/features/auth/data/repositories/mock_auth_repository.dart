import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/auth/data/datasources/mock_auth_session_storage.dart';
import 'package:waffir/features/auth/data/datasources/mock_auth_store.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._store, this._sessionStorage);

  final MockAuthStore _store;
  final MockAuthSessionStorage _sessionStorage;

  @override
  Stream<AuthState> get authStateChanges => _store.authStateChanges;

  @override
  AuthState get currentAuthState => _store.currentAuthState;

  @override
  UserModel? get currentUser => _store.currentUser;

  @override
  AsyncResult<AuthState> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      if (email.trim().isEmpty) {
        throw const Failure.validation(message: 'Email is required', field: 'email');
      }
      if (password.isEmpty) {
        throw const Failure.validation(message: 'Password is required', field: 'password');
      }

      final user = UserModel(
        id: 'mock_user_${email.trim().toLowerCase()}',
        email: email.trim().toLowerCase(),
        displayName: email.split('@').first,
        emailVerified: true,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );

      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      if (email.trim().isEmpty) {
        throw const Failure.validation(message: 'Email is required', field: 'email');
      }
      if (password.length < 8) {
        throw const Failure.validation(
          message: 'Password must be at least 8 characters',
          field: 'password',
        );
      }

      final normalizedEmail = email.trim().toLowerCase();
      final user = UserModel(
        id: 'mock_user_$normalizedEmail',
        email: normalizedEmail,
        displayName: displayName ?? normalizedEmail.split('@').first,
        emailVerified: true,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );

      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> signInWithGoogle() async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final user = UserModel(
        id: 'mock_google_user',
        email: 'google.user@mock.waffir',
        displayName: 'Google User',
        emailVerified: true,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );
      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> signInWithApple() async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final user = UserModel(
        id: 'mock_apple_user',
        email: 'apple.user@mock.waffir',
        displayName: 'Apple User',
        emailVerified: true,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );
      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> signInAnonymously() async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final now = DateTime.now();
      final user = UserModel(
        id: 'mock_anon_${now.microsecondsSinceEpoch}',
        email: 'anonymous@mock.waffir',
        displayName: 'Guest',
        emailVerified: true,
        isAnonymous: true,
        createdAt: now,
        lastSignInAt: now,
      );
      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<void> sendPasswordResetEmail({required String email}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      if (email.trim().isEmpty) {
        throw const Failure.validation(message: 'Email is required', field: 'email');
      }
    });
  }

  @override
  AsyncResult<void> sendEmailVerification() async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email verification is disabled in production'),
    );
  }

  @override
  AsyncResult<void> verifyEmailWithCode({required String code}) async {
    return const Result.failure(
      Failure.featureNotAvailable(message: 'Email verification is disabled in production'),
    );
  }

  @override
  AsyncResult<AuthState> updateProfile({String? displayName, String? photoURL}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final updated = _store.updateUser(
        (current) => current.copyWith(displayName: displayName ?? current.displayName, photoURL: photoURL),
      );
      final authState = _store.signInUser(updated);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<void> updatePassword({required String currentPassword, required String newPassword}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      _store.requireUser();
      if (newPassword.length < 8) {
        throw const Failure.validation(
          message: 'Password must be at least 8 characters',
          field: 'newPassword',
        );
      }
    });
  }

  @override
  AsyncResult<void> updateEmail({required String newEmail, required String password}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final updated = _store.updateUser((current) => current.copyWith(email: newEmail.trim().toLowerCase()));
      final authState = _store.signInUser(updated);
      await _sessionStorage.save(authState);
    });
  }

  @override
  AsyncResult<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    return Result.guard(() async {
      await _store.simulateNetwork();

      final normalized = phoneNumber.trim();
      if (normalized.isEmpty) {
        throw const Failure.validation(message: 'Phone number is required', field: 'phoneNumber');
      }

      final verificationId = _store.createVerificationId();
      _store.savePhoneVerification(verificationId: verificationId, phoneNumber: normalized);

      codeSent(verificationId);
    });
  }

  @override
  AsyncResult<AuthState> verifyPhoneWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final phoneNumber = _store.phoneNumberForVerificationId(verificationId);
      if (phoneNumber == null) {
        throw const Failure.validation(message: 'Invalid verificationId', field: 'verificationId');
      }
      if (smsCode.trim().length < 5) {
        throw const Failure.validation(message: 'Invalid OTP code', field: 'smsCode');
      }

      final now = DateTime.now();
      final user = UserModel(
        id: 'mock_phone_${phoneNumber.replaceAll('+', '')}',
        email: 'phone.user@mock.waffir',
        phoneNumber: phoneNumber,
        displayName: 'Phone User',
        emailVerified: true,
        createdAt: now,
        lastSignInAt: now,
      );

      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final phoneNumber = _store.phoneNumberForVerificationId(verificationId);
      if (phoneNumber == null) {
        throw const Failure.validation(message: 'Invalid verificationId', field: 'verificationId');
      }
      if (smsCode.trim().length < 5) {
        throw const Failure.validation(message: 'Invalid OTP code', field: 'smsCode');
      }

      final updated = _store.updateUser((current) => current.copyWith(phoneNumber: phoneNumber));
      final authState = _store.signInUser(updated);
      await _sessionStorage.save(authState);
      return authState;
    });
  }

  @override
  AsyncResult<AuthState> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) {
    return verifyPhoneWithCode(verificationId: verificationId, smsCode: smsCode);
  }

  @override
  AsyncResult<void> reauthenticate({required String password}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      _store.requireUser();
    });
  }

  @override
  AsyncResult<void> deleteAccount({required String password}) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      _store.requireUser();
      _store.signOut();
      await _sessionStorage.clear();
    });
  }

  @override
  AsyncResult<void> signOut() async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      _store.signOut();
      await _sessionStorage.clear();
    });
  }

  @override
  AsyncResult<void> refreshToken() async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final user = _store.requireUser();
      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
    });
  }

  @override
  AsyncResult<bool> isEmailAvailable(String email) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final normalized = email.trim().toLowerCase();
      if (normalized.isEmpty) {
        throw const Failure.validation(message: 'Email is required', field: 'email');
      }
      return normalized != 'taken@mock.waffir';
    });
  }

  @override
  AsyncResult<UserModel> getUserById(String userId) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      final current = _store.currentUser;
      if (current != null && current.id == userId) {
        return current;
      }
      throw const Failure.notFound(message: 'User not found');
    });
  }

  @override
  AsyncResult<void> updateUserData(UserModel user) async {
    return Result.guard(() async {
      await _store.simulateNetwork();
      _store.updateUser((_) => user);
      final authState = _store.signInUser(user);
      await _sessionStorage.save(authState);
    });
  }

  @override
  AsyncResult<AuthState> linkWithCredential({
    required String providerId,
    Map<String, dynamic>? parameters,
  }) async {
    return Result.failure(
      Failure.featureNotAvailable(message: 'Provider linking not supported in mock auth', code: providerId),
    );
  }

  @override
  AsyncResult<AuthState> unlinkProvider(String providerId) async {
    return Result.failure(
      Failure.featureNotAvailable(message: 'Provider unlinking not supported in mock auth', code: providerId),
    );
  }

  @override
  AsyncResult<List<String>> getLinkedProviders() async {
    return const Result.success(<String>['phone', 'email']);
  }
}
