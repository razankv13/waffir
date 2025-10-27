import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';

/// Interceptor for handling authentication tokens in API requests
class AuthInterceptor extends Interceptor {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Skip auth for certain endpoints
      if (_shouldSkipAuth(options.path)) {
        handler.next(options);
        return;
      }

      // Get stored auth token
      final token = await _getStoredToken();
      
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        AppLogger.debug('Auth token added to request: ${options.path}');
      } else {
        AppLogger.debug('No auth token found for request: ${options.path}');
      }
      
      handler.next(options);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in auth interceptor for ${options.path}',
        error: e,
        stackTrace: stackTrace,
      );
      handler.next(options);
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      // Check for new token in response headers
      final newToken = response.headers.value('x-auth-token') ??
                      response.headers.value('authorization');
      
      if (newToken != null) {
        await _storeToken(newToken);
        AppLogger.info('New auth token stored from response');
      }
      
      handler.next(response);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error processing auth response',
        error: e,
        stackTrace: stackTrace,
      );
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      AppLogger.warning('Received 401 Unauthorized - clearing stored token');
      await _clearStoredToken();
      
      // You might want to emit an event here to trigger re-authentication
      // or redirect to login screen
    }
    
    handler.next(err);
  }

  /// Check if authentication should be skipped for this endpoint
  bool _shouldSkipAuth(String path) {
    final skipPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/public',
    ];
    
    return skipPaths.any((skipPath) => path.contains(skipPath));
  }

  /// Get stored authentication token
  Future<String?> _getStoredToken() async {
    try {
      return await _storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read auth token from storage', error: e);
      return null;
    }
  }

  /// Store authentication token securely
  Future<void> _storeToken(String token) async {
    try {
      // Remove 'Bearer ' prefix if present
      final cleanToken = token.startsWith('Bearer ') 
          ? token.substring(7)
          : token;
      
      await _storage.write(key: AppConstants.accessTokenKey, value: cleanToken);
    } catch (e) {
      AppLogger.error('Failed to store auth token', error: e);
    }
  }

  /// Clear stored authentication token
  Future<void> _clearStoredToken() async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to clear auth token', error: e);
    }
  }

  /// Manually store token (for use after login)
  static Future<void> storeAuthToken(String token) async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      
      await storage.write(key: AppConstants.accessTokenKey, value: token);
      AppLogger.info('Auth token stored manually');
    } catch (e) {
      AppLogger.error('Failed to manually store auth token', error: e);
    }
  }

  /// Manually clear token (for use during logout)
  static Future<void> clearAuthToken() async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      
      await storage.delete(key: AppConstants.accessTokenKey);
      AppLogger.info('Auth token cleared manually');
    } catch (e) {
      AppLogger.error('Failed to manually clear auth token', error: e);
    }
  }

  /// Get current stored token (for external use)
  static Future<String?> getCurrentToken() async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      
      return await storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to get current auth token', error: e);
      return null;
    }
  }
}