import 'dart:math';
import 'package:dio/dio.dart';

import 'package:waffir/core/utils/logger.dart';

/// Interceptor for handling request retries with exponential backoff
class RetryInterceptor extends Interceptor {

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 1000),
    this.maxDelay = const Duration(seconds: 30),
    this.exponentialBase = 2.0,
    this.retryStatusCodes = const [
      502, // Bad Gateway
      503, // Service Unavailable
      504, // Gateway Timeout
      429, // Too Many Requests
      408, // Request Timeout
    ],
  });
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final double exponentialBase;
  final List<int> retryStatusCodes;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    
    // Check if this request should be retried
    if (!_shouldRetry(err, request)) {
      handler.next(err);
      return;
    }

    final retryCount = _getRetryCount(request);
    
    if (retryCount >= maxRetries) {
      AppLogger.warning(
        'Max retries ($maxRetries) reached for ${request.path}',
      );
      handler.next(err);
      return;
    }

    final nextRetryCount = retryCount + 1;
    _setRetryCount(request, nextRetryCount);

    final delay = _calculateDelay(nextRetryCount);
    
    AppLogger.info(
      'Retrying request ${request.path} (attempt $nextRetryCount/$maxRetries) after ${delay.inMilliseconds}ms delay. Status: ${err.response?.statusCode}',
    );

    try {
      await Future.delayed(delay);
      
      // Create a new Dio instance to avoid interceptor loops
      final dio = Dio();
      dio.options = request.copyWith() as BaseOptions;
      
      // Copy interceptors except retry interceptor to avoid infinite loops
      final originalInterceptors = request.extra['_original_interceptors'] as List<Interceptor>?;
      if (originalInterceptors != null) {
        for (final interceptor in originalInterceptors) {
          if (interceptor is! RetryInterceptor) {
            dio.interceptors.add(interceptor);
          }
        }
      }

      final response = await dio.fetch(request);
      handler.resolve(response);
    } catch (e) {
      AppLogger.error(
        'Retry attempt $nextRetryCount failed for ${request.path}',
        error: e,
      );
      
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(
          DioException(
            requestOptions: request,
            error: e,
          ),
        );
      }
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Store original interceptors for retry attempts
    if (!options.extra.containsKey('_original_interceptors')) {
      // We can't access the original interceptors easily, so we'll skip this
      // In a production app, you might want to pass the interceptors differently
    }
    
    handler.next(options);
  }

  /// Check if the request should be retried based on error type and status code
  bool _shouldRetry(DioException err, RequestOptions request) {
    // Don't retry if it's a client error (4xx except 408, 429)
    if (err.response != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 400 && statusCode < 500 && !retryStatusCodes.contains(statusCode)) {
        return false;
      }
      return retryStatusCodes.contains(statusCode);
    }

    // Retry on connection timeout, receive timeout, and connection errors
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        return err.response != null && 
               retryStatusCodes.contains(err.response!.statusCode);
      default:
        return false;
    }
  }

  /// Get current retry count for the request
  int _getRetryCount(RequestOptions request) {
    return request.extra['retry_count'] as int? ?? 0;
  }

  /// Set retry count for the request
  void _setRetryCount(RequestOptions request, int count) {
    request.extra['retry_count'] = count;
  }

  /// Calculate delay with exponential backoff and jitter
  Duration _calculateDelay(int retryCount) {
    final exponentialDelay = baseDelay.inMilliseconds * 
                           pow(exponentialBase, retryCount - 1);
    
    // Add jitter to avoid thundering herd
    final jitter = Random().nextDouble() * 0.1; // 10% jitter
    final delayWithJitter = exponentialDelay * (1 + jitter);
    
    final finalDelay = Duration(
      milliseconds: min(delayWithJitter.round(), maxDelay.inMilliseconds),
    );
    
    return finalDelay;
  }

  /// Create a copy of RequestOptions for retry
  RequestOptions _copyRequestOptions(RequestOptions original) {
    return RequestOptions(
      method: original.method,
      sendTimeout: original.sendTimeout,
      receiveTimeout: original.receiveTimeout,
      extra: Map.from(original.extra),
      headers: Map.from(original.headers),
      responseType: original.responseType,
      contentType: original.contentType,
      validateStatus: original.validateStatus,
      receiveDataWhenStatusError: original.receiveDataWhenStatusError,
      followRedirects: original.followRedirects,
      maxRedirects: original.maxRedirects,
      requestEncoder: original.requestEncoder,
      responseDecoder: original.responseDecoder,
      path: original.path,
      queryParameters: Map.from(original.queryParameters),
      data: original.data,
    );
  }
}