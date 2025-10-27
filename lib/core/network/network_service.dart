import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/network/api_client.dart';
import 'package:waffir/core/network/interceptors/connectivity_interceptor.dart';

/// Network service providing high-level API operations
class NetworkService {

  NetworkService._internal() {
    _apiClient = ApiClient.instance;
    _initializeBaseUrl();
  }
  static NetworkService? _instance;
  late final ApiClient _apiClient;

  static NetworkService get instance {
    _instance ??= NetworkService._internal();
    return _instance!;
  }

  void _initializeBaseUrl() {
    _apiClient.updateBaseUrl('${AppConstants.baseUrl}${AppConstants.apiPrefix}');
  }

  /// Update authentication token
  void setAuthToken(String? token) {
    _apiClient.updateAuthToken(token);
  }

  /// Clear authentication token
  void clearAuthToken() {
    _apiClient.updateAuthToken(null);
  }

  /// Generic GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Making GET request to: $endpoint');
      
      final response = await _apiClient.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'GET', endpoint);
    }
  }

  /// Generic POST request
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Making POST request to: $endpoint');
      
      final response = await _apiClient.post<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'POST', endpoint);
    }
  }

  /// Generic PUT request
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Making PUT request to: $endpoint');
      
      final response = await _apiClient.put<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'PUT', endpoint);
    }
  }

  /// Generic PATCH request
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Making PATCH request to: $endpoint');
      
      final response = await _apiClient.patch<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'PATCH', endpoint);
    }
  }

  /// Generic DELETE request
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Making DELETE request to: $endpoint');
      
      final response = await _apiClient.delete<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'DELETE', endpoint);
    }
  }

  /// Upload file
  Future<T> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      AppLogger.debug('Uploading file to: $endpoint');
      
      final response = await _apiClient.uploadFiles<dynamic>(
        endpoint,
        {fieldName: filePath},
        data: additionalData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e, 'UPLOAD', endpoint);
    }
  }

  /// Download file
  Future<void> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      AppLogger.debug('Downloading file from: $endpoint');
      
      await _apiClient.download(
        endpoint,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e, 'DOWNLOAD', endpoint);
    }
  }

  /// Process response and handle deserialization
  T _processResponse<T>(Response response, T Function(dynamic)? fromJson) {
    if (T == dynamic) {
      return response.data as T;
    }

    if (fromJson != null) {
      return fromJson(response.data);
    }

    // If no fromJson function provided, return raw data
    return response.data as T;
  }

  /// Handle and transform errors
  Exception _handleError(dynamic error, String method, String endpoint) {
    if (error is DioException) {
      return _transformDioError(error, method, endpoint);
    } else {
      AppLogger.error(
        'Unexpected error in $method $endpoint',
        error: error,
      );
      return Exception('Unexpected error: ${error.toString()}');
    }
  }

  /// Transform DioException to more specific exceptions
  Exception _transformDioError(DioException error, String method, String endpoint) {
    AppLogger.error(
      '$method $endpoint failed: ${error.type.name}',
      error: error,
    );

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException.connectionTimeout(endpoint);
      case DioExceptionType.sendTimeout:
        return NetworkException.sendTimeout(endpoint);
      case DioExceptionType.receiveTimeout:
        return NetworkException.receiveTimeout(endpoint);
      case DioExceptionType.badResponse:
        return _handleBadResponse(error, endpoint);
      case DioExceptionType.cancel:
        return NetworkException.requestCancelled(endpoint);
      case DioExceptionType.connectionError:
        return NetworkException.connectionError(endpoint);
      case DioExceptionType.badCertificate:
        return NetworkException.badCertificate(endpoint);
      case DioExceptionType.unknown:
        if (error is NoInternetException) {
          return NetworkException.noInternet(endpoint);
        }
        return NetworkException.unknown(endpoint, error.message);
    }
  }

  /// Handle bad response errors (4xx, 5xx)
  Exception _handleBadResponse(DioException error, String endpoint) {
    final statusCode = error.response?.statusCode ?? 0;
    final message = error.response?.data?['message'] as String? ?? 
                   error.response?.statusMessage ?? 
                   'Request failed';

    switch (statusCode) {
      case 400:
        return NetworkException.badRequest(endpoint, message);
      case 401:
        return NetworkException.unauthorized(endpoint, message);
      case 403:
        return NetworkException.forbidden(endpoint, message);
      case 404:
        return NetworkException.notFound(endpoint, message);
      case 422:
        return NetworkException.validationError(endpoint, message);
      case 429:
        return NetworkException.tooManyRequests(endpoint, message);
      case 500:
        return NetworkException.serverError(endpoint, message);
      case 502:
        return NetworkException.badGateway(endpoint, message);
      case 503:
        return NetworkException.serviceUnavailable(endpoint, message);
      case 504:
        return NetworkException.gatewayTimeout(endpoint, message);
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return NetworkException.clientError(endpoint, statusCode, message);
        } else if (statusCode >= 500) {
          return NetworkException.serverError(endpoint, message);
        } else {
          return NetworkException.unknown(endpoint, message);
        }
    }
  }

  /// Check internet connectivity
  static Future<bool> isConnected() => ConnectivityInterceptor.isConnected();

  /// Get connectivity status
  static Future<String> getConnectivityStatus() => 
      ConnectivityInterceptor.getConnectivityStatus();

  /// Stream of connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream => 
      ConnectivityInterceptor.connectivityStream;
}

/// Custom network exceptions
class NetworkException implements Exception {

  const NetworkException(this.endpoint, this.message, [this.statusCode]);

  // Timeout exceptions
  const NetworkException.connectionTimeout(String endpoint)
      : this(endpoint, 'Connection timeout');
  
  const NetworkException.sendTimeout(String endpoint)
      : this(endpoint, 'Send timeout');
  
  const NetworkException.receiveTimeout(String endpoint)
      : this(endpoint, 'Receive timeout');

  // Client errors (4xx)
  const NetworkException.badRequest(String endpoint, String message)
      : this(endpoint, message, 400);
  
  const NetworkException.unauthorized(String endpoint, String message)
      : this(endpoint, message, 401);
  
  const NetworkException.forbidden(String endpoint, String message)
      : this(endpoint, message, 403);
  
  const NetworkException.notFound(String endpoint, String message)
      : this(endpoint, message, 404);
  
  const NetworkException.validationError(String endpoint, String message)
      : this(endpoint, message, 422);
  
  const NetworkException.tooManyRequests(String endpoint, String message)
      : this(endpoint, message, 429);
  
  const NetworkException.clientError(String endpoint, int statusCode, String message)
      : this(endpoint, message, statusCode);

  // Server errors (5xx)
  const NetworkException.serverError(String endpoint, String message)
      : this(endpoint, message, 500);
  
  const NetworkException.badGateway(String endpoint, String message)
      : this(endpoint, message, 502);
  
  const NetworkException.serviceUnavailable(String endpoint, String message)
      : this(endpoint, message, 503);
  
  const NetworkException.gatewayTimeout(String endpoint, String message)
      : this(endpoint, message, 504);

  // Connection errors
  const NetworkException.connectionError(String endpoint)
      : this(endpoint, 'Connection error');
  
  const NetworkException.noInternet(String endpoint)
      : this(endpoint, 'No internet connection');
  
  const NetworkException.badCertificate(String endpoint)
      : this(endpoint, 'Bad certificate');
  
  const NetworkException.requestCancelled(String endpoint)
      : this(endpoint, 'Request cancelled');

  // Unknown errors
  const NetworkException.unknown(String endpoint, String? message)
      : this(endpoint, message ?? 'Unknown network error');
  final String endpoint;
  final String message;
  final int? statusCode;

  @override
  String toString() {
    final codeText = statusCode != null ? ' ($statusCode)' : '';
    return 'NetworkException$codeText: $message (Endpoint: $endpoint)';
  }
}

/// Riverpod provider for NetworkService
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService.instance;
});

/// Connectivity status provider
final connectivityStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return NetworkService.connectivityStream;
});

/// Helper provider to check if device is connected
final isConnectedProvider = FutureProvider<bool>((ref) {
  return NetworkService.isConnected();
});