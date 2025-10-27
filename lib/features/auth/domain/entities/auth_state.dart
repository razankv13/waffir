import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.authenticated({
    required UserModel user,
    String? idToken,
    String? refreshToken,
    DateTime? tokenExpiry,
  }) = _Authenticated;

  const factory AuthState.unauthenticated({String? message}) = _Unauthenticated;

  const factory AuthState.error({required String message, String? code, dynamic exception}) =
      _Error;

  const factory AuthState.emailVerificationRequired({required UserModel user, String? message}) =
      _EmailVerificationRequired;

  const factory AuthState.phoneVerificationRequired({
    required String verificationId,
    required String phoneNumber,
    String? message,
  }) = _PhoneVerificationRequired;

  const factory AuthState.mfaRequired({
    required String multiFactorSession,
    required List<String> availableFactors,
    String? message,
  }) = _MfaRequired;
}

extension AuthStateX on AuthState {
  /// Check if user is authenticated
  bool get isAuthenticated =>
      maybeWhen(authenticated: (_, __, ___, ____) => true, orElse: () => false);

  /// Check if auth state is loading
  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  /// Check if there's an error
  bool get hasError => maybeWhen(error: (_, __, ___) => true, orElse: () => false);

  /// Get current user if authenticated
  UserModel? get user => maybeWhen(
    authenticated: (user, _, __, ___) => user,
    emailVerificationRequired: (user, _) => user,
    orElse: () => null,
  );

  /// Get error message
  String? get errorMessage => maybeWhen(
    error: (message, _, __) => message,
    unauthenticated: (message) => message,
    orElse: () => null,
  );

  /// Check if email verification is required
  bool get requiresEmailVerification =>
      maybeWhen(emailVerificationRequired: (_, __) => true, orElse: () => false);

  /// Check if phone verification is required
  bool get requiresPhoneVerification =>
      maybeWhen(phoneVerificationRequired: (_, __, ___) => true, orElse: () => false);

  /// Check if MFA is required
  bool get requiresMfa => maybeWhen(mfaRequired: (_, __, ___) => true, orElse: () => false);

  /// Check if token is expired or will expire soon
  bool get isTokenExpired {
    return maybeWhen(
      authenticated: (_, __, ___, tokenExpiry) {
        if (tokenExpiry == null) return false;
        return DateTime.now().add(const Duration(minutes: 5)).isAfter(tokenExpiry);
      },
      orElse: () => true,
    );
  }
}
