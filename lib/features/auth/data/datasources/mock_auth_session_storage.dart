import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';

class MockAuthSessionStorage {
  MockAuthSessionStorage(this._hiveService);

  static const String _sessionKey = 'mock_auth_session_v1';

  final HiveService _hiveService;

  AuthState? load() {
    try {
      final data = _hiveService.getUser<Map>(_sessionKey);
      if (data == null) return null;

      final UserModel? user = data['user'];

      if (user == null) return null;

      final idToken = data['idToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final tokenExpiryRaw = data['tokenExpiry'] as String?;
      final tokenExpiry = tokenExpiryRaw != null ? DateTime.tryParse(tokenExpiryRaw) : null;

      return AuthState.authenticated(
        user: user,
        idToken: idToken,
        refreshToken: refreshToken,
        tokenExpiry: tokenExpiry,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AuthState state) async {
    final user = state.user;
    if (user == null) return;

    final data = <String, Object?>{
      'user': user,
      'idToken': state.maybeWhen(authenticated: (_, idToken, _, _) => idToken, orElse: () => null),
      'refreshToken': state.maybeWhen(
        authenticated: (_, _, refreshToken, ___) => refreshToken,
        orElse: () => null,
      ),
      'tokenExpiry': state.maybeWhen(
        authenticated: (_, _, _, tokenExpiry) => tokenExpiry?.toIso8601String(),
        orElse: () => null,
      ),
    };

    await _hiveService.storeUser(_sessionKey, data);
  }

  Future<void> clear() async {
    await _hiveService.deleteUser(_sessionKey);
  }

  Object? _normalizeJson(Object? value) {
    if (value is Map) {
      return value.map((key, nestedValue) => MapEntry(key.toString(), _normalizeJson(nestedValue)));
    }
    if (value is List) {
      return value.map(_normalizeJson).toList();
    }
    return value;
  }
}
