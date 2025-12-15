import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';

/// Placeholder repository for the future "real" backend implementation.
///
/// The backend will be exposed via cloud function endpoints. For now this repo
/// returns `featureNotAvailable` so the app can run end-to-end with mock auth.
class CloudFunctionsAuthRepository implements AuthRepository {
  const CloudFunctionsAuthRepository();

  Failure _notReady([String? method]) {
    return Failure.featureNotAvailable(
      message: 'Auth backend not deployed yet${method == null ? '' : ' ($method)'}',
    );
  }

  @override
  Stream<AuthState> get authStateChanges => const Stream<AuthState>.empty();

  @override
  AuthState get currentAuthState => const AuthState.unauthenticated(message: 'Backend not deployed');

  @override
  UserModel? get currentUser => null;

  @override
  AsyncResult<AuthState> signInWithEmailAndPassword({required String email, required String password}) async {
    return Result.failure(_notReady('signInWithEmailAndPassword'));
  }

  @override
  AsyncResult<AuthState> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return Result.failure(_notReady('createUserWithEmailAndPassword'));
  }

  @override
  AsyncResult<AuthState> signInWithGoogle() async {
    return Result.failure(_notReady('signInWithGoogle'));
  }

  @override
  AsyncResult<AuthState> signInWithApple() async {
    return Result.failure(_notReady('signInWithApple'));
  }

  @override
  AsyncResult<AuthState> signInAnonymously() async {
    return Result.failure(_notReady('signInAnonymously'));
  }

  @override
  AsyncResult<void> sendPasswordResetEmail({required String email}) async {
    return Result.failure(_notReady('sendPasswordResetEmail'));
  }

  @override
  AsyncResult<void> sendEmailVerification() async {
    return Result.failure(_notReady('sendEmailVerification'));
  }

  @override
  AsyncResult<void> verifyEmailWithCode({required String code}) async {
    return Result.failure(_notReady('verifyEmailWithCode'));
  }

  @override
  AsyncResult<AuthState> updateProfile({String? displayName, String? photoURL}) async {
    return Result.failure(_notReady('updateProfile'));
  }

  @override
  AsyncResult<void> updatePassword({required String currentPassword, required String newPassword}) async {
    return Result.failure(_notReady('updatePassword'));
  }

  @override
  AsyncResult<void> updateEmail({required String newEmail, required String password}) async {
    return Result.failure(_notReady('updateEmail'));
  }

  @override
  AsyncResult<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    required Function() codeAutoRetrievalTimeout,
  }) async {
    return Result.failure(_notReady('verifyPhoneNumber'));
  }

  @override
  AsyncResult<AuthState> verifyPhoneWithCode({required String verificationId, required String smsCode}) async {
    return Result.failure(_notReady('verifyPhoneWithCode'));
  }

  @override
  AsyncResult<AuthState> linkPhoneNumber({required String verificationId, required String smsCode}) async {
    return Result.failure(_notReady('linkPhoneNumber'));
  }

  @override
  AsyncResult<AuthState> signInWithPhoneNumber({required String verificationId, required String smsCode}) async {
    return Result.failure(_notReady('signInWithPhoneNumber'));
  }

  @override
  AsyncResult<void> reauthenticate({required String password}) async {
    return Result.failure(_notReady('reauthenticate'));
  }

  @override
  AsyncResult<void> deleteAccount({required String password}) async {
    return Result.failure(_notReady('deleteAccount'));
  }

  @override
  AsyncResult<void> signOut() async {
    return Result.failure(_notReady('signOut'));
  }

  @override
  AsyncResult<void> refreshToken() async {
    return Result.failure(_notReady('refreshToken'));
  }

  @override
  AsyncResult<bool> isEmailAvailable(String email) async {
    return Result.failure(_notReady('isEmailAvailable'));
  }

  @override
  AsyncResult<UserModel> getUserById(String userId) async {
    return Result.failure(_notReady('getUserById'));
  }

  @override
  AsyncResult<void> updateUserData(UserModel user) async {
    return Result.failure(_notReady('updateUserData'));
  }

  @override
  AsyncResult<AuthState> linkWithCredential({required String providerId, Map<String, dynamic>? parameters}) async {
    return Result.failure(_notReady('linkWithCredential'));
  }

  @override
  AsyncResult<AuthState> unlinkProvider(String providerId) async {
    return Result.failure(_notReady('unlinkProvider'));
  }

  @override
  AsyncResult<List<String>> getLinkedProviders() async {
    return Result.failure(_notReady('getLinkedProviders'));
  }
}

