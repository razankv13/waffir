import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';
import 'package:waffir/core/services/auth/firebase_auth_service.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/result/exception_to_failure.dart';
import 'package:waffir/core/errors/failures.dart';

class FirebaseAuthRepository implements AuthRepository {

  FirebaseAuthRepository(this._authService);
  final FirebaseAuthService _authService;

  @override
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  @override
  AuthState get currentAuthState => _authService.currentAuthState;

  @override
  UserModel? get currentUser => _authService.currentUser;

  @override
  AsyncResult<AuthState> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authState = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final authState = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInWithGoogle() async {
    try {
      final authState = await _authService.signInWithGoogle();
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInWithApple() async {
    try {
      final authState = await _authService.signInWithApple();
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInAnonymously() async {
    try {
      final authState = await _authService.signInAnonymously();
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> verifyEmailWithCode({
    required String code,
  }) async {
    try {
      await _authService.verifyEmailWithCode(code: code);
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final authState = await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      await _authService.updateEmail(
        newEmail: newEmail,
        password: password,
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: codeSent,
        verificationFailed: verificationFailed,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> verifyPhoneWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final authState = await _authService.verifyPhoneWithCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final authState = await _authService.linkPhoneNumber(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final authState = await _authService.signInWithPhoneNumber(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> reauthenticate({
    required String password,
  }) async {
    try {
      await _authService.reauthenticate(password: password);
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> deleteAccount({
    required String password,
  }) async {
    try {
      await _authService.deleteAccount(password: password);
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> signOut() async {
    try {
      await _authService.signOut();
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> refreshToken() async {
    try {
      await _authService.refreshToken();
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<bool> isEmailAvailable(String email) async {
    try {
      final isAvailable = await _authService.isEmailAvailable(email);
      return Result.success(isAvailable);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<UserModel> getUserById(String userId) async {
    try {
      final user = await _authService.getUserById(userId);
      if (user == null) {
        return const Result.failure(
          Failure.notFound(message: 'User not found'),
        );
      }
      return Result.success(user);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<void> updateUserData(UserModel user) async {
    try {
      await _authService.updateUserData(user);
      return const Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> linkWithCredential({
    required String providerId,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final authState = await _authService.linkWithCredential(
        providerId: providerId,
        parameters: parameters,
      );
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<AuthState> unlinkProvider(String providerId) async {
    try {
      final authState = await _authService.unlinkProvider(providerId);
      return Result.success(authState);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  @override
  AsyncResult<List<String>> getLinkedProviders() async {
    try {
      final providers = await _authService.getLinkedProviders();
      return Result.success(providers);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }
}