import 'dart:async';
import 'dart:math';

import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';

class MockAuthStore {
  MockAuthStore({
    DateTime Function()? now,
    Duration simulatedNetworkDelay = const Duration(milliseconds: 800),
  })  : _now = now ?? DateTime.now,
        _simulatedNetworkDelay = simulatedNetworkDelay {
    _emit(const AuthState.unauthenticated());
  }

  final DateTime Function() _now;
  final Duration _simulatedNetworkDelay;

  final StreamController<AuthState> _controller = StreamController<AuthState>.broadcast();
  final Map<String, String> _verificationIdToPhoneNumber = <String, String>{};

  AuthState _current = const AuthState.unauthenticated();
  UserModel? _currentUser;

  Stream<AuthState> get authStateChanges => _controller.stream;
  AuthState get currentAuthState => _current;
  UserModel? get currentUser => _currentUser;

  void restoreAuthenticated(AuthState state) {
    final user = state.user;
    if (user == null) return;
    _currentUser = user;
    _emit(state);
  }

  Future<void> dispose() async {
    await _controller.close();
  }

  Future<void> simulateNetwork() async {
    await Future<void>.delayed(_simulatedNetworkDelay);
  }

  String createVerificationId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return 'mock_ver_$hex';
  }

  void savePhoneVerification({
    required String verificationId,
    required String phoneNumber,
  }) {
    _verificationIdToPhoneNumber[verificationId] = phoneNumber;
  }

  String? phoneNumberForVerificationId(String verificationId) {
    return _verificationIdToPhoneNumber[verificationId];
  }

  AuthState signInUser(UserModel user) {
    _currentUser = user;
    final now = _now();
    final authState = AuthState.authenticated(
      user: user,
      idToken: 'mock_access_${user.id}',
      refreshToken: 'mock_refresh_${user.id}',
      tokenExpiry: now.add(const Duration(hours: 1)),
    );
    _emit(authState);
    return authState;
  }

  void signOut() {
    _currentUser = null;
    _emit(const AuthState.unauthenticated());
  }

  UserModel requireUser() {
    final user = _currentUser;
    if (user == null) {
      throw const Failure.unauthorized(message: 'Not signed in');
    }
    return user;
  }

  UserModel updateUser(UserModel Function(UserModel current) updater) {
    final updated = updater(requireUser());
    _currentUser = updated;
    _emit(_current.maybeWhen(
      authenticated: (_, _, _, _) => AuthState.authenticated(
        user: updated,
        idToken: _current.maybeWhen(authenticated: (_, idToken, __, ___) => idToken, orElse: () => null),
        refreshToken:
            _current.maybeWhen(authenticated: (_, __, refreshToken, ___) => refreshToken, orElse: () => null),
        tokenExpiry:
            _current.maybeWhen(authenticated: (_, __, ___, tokenExpiry) => tokenExpiry, orElse: () => null),
      ),
      orElse: () => AuthState.authenticated(user: updated),
    ));
    return updated;
  }

  void _emit(AuthState state) {
    _current = state;
    if (!_controller.isClosed) {
      _controller.add(state);
    }
  }
}
