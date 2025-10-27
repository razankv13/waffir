import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/network/interceptors/auth_interceptor.dart';
import 'package:waffir/core/network/interceptors/logging_interceptor.dart';
import 'package:waffir/core/network/interceptors/retry_interceptor.dart';
import 'package:waffir/core/network/interceptors/connectivity_interceptor.dart';

/// Base API client using Dio for network requests
class ApiClient {

  ApiClient._internal() {
    _dio = Dio();
    _setupInterceptors();
    _configureClient();
  }
  static ApiClient? _instance;
  late final Dio _dio;

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _configureClient() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: true,
      maxRedirects: 3,
      validateStatus: (status) {
        // Accept status codes from 200-299 and specific error codes for custom handling
        return status != null && status >= 200 && status < 300;
      },
    );
  }

  void _setupInterceptors() {
    // Add interceptors in order of priority
    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      AuthInterceptor(),
      RetryInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
    ]);
  }

  /// Update base URL (useful for environment switching)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    AppLogger.info('API base URL updated to: $baseUrl');
  }

  /// Update auth token
  void updateAuthToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      AppLogger.info('Auth token updated');
    } else {
      _dio.options.headers.remove('Authorization');
      AppLogger.info('Auth token removed');
    }
  }

  /// Clear all headers and reset client
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    AppLogger.info('API headers cleared');
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      AppLogger.error('GET request failed for path: $path', error: e);
      rethrow;
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      AppLogger.error('POST request failed for path: $path', error: e);
      rethrow;
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      AppLogger.error('PUT request failed for path: $path', error: e);
      rethrow;
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      AppLogger.error('PATCH request failed for path: $path', error: e);
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('DELETE request failed for path: $path', error: e);
      rethrow;
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        options: options,
      );
    } catch (e) {
      AppLogger.error('Download failed for URL: $urlPath', error: e);
      rethrow;
    }
  }

  /// Upload files using FormData
  Future<Response<T>> uploadFiles<T>(
    String path,
    Map<String, dynamic> files, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData();

      // Add regular data fields
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      // Add file fields
      for (final entry in files.entries) {
        if (entry.value is File) {
          final file = entry.value as File;
          formData.files.add(MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ));
        } else if (entry.value is List<File>) {
          final fileList = entry.value as List<File>;
          for (final file in fileList) {
            formData.files.add(MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ));
          }
        }
      }

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('File upload failed for path: $path', error: e);
      rethrow;
    }
  }

  /// Close the client and clean up resources
  void close() {
    _dio.close();
    AppLogger.info('API client closed');
  }
}