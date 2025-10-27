import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:waffir/core/utils/logger.dart';

/// Interceptor for logging HTTP requests and responses in debug mode
class LoggingInterceptor extends Interceptor {

  LoggingInterceptor({
    this.logHeaders = true,
    this.logRequestData = true,
    this.logResponseData = true,
    this.maxBodyLength = 1000,
    this.sensitiveHeaders = const [
      'authorization',
      'cookie',
      'x-api-key',
      'x-auth-token',
    ],
  });
  final bool logHeaders;
  final bool logRequestData;
  final bool logResponseData;
  final int maxBodyLength;
  final List<String> sensitiveHeaders;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }

    _logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }

    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(err);
      return;
    }

    _logError(err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    
    buffer.writeln('╭─────── Request ────────');
    buffer.writeln('│ ${options.method.toUpperCase()} ${options.uri}');
    
    if (logHeaders && options.headers.isNotEmpty) {
      buffer.writeln('│');
      buffer.writeln('│ Headers:');
      _logHeaders(buffer, options.headers);
    }

    if (logRequestData && options.data != null) {
      buffer.writeln('│');
      buffer.writeln('│ Body:');
      _logBody(buffer, options.data);
    }

    buffer.writeln('╰──────────────────────────');
    
    AppLogger.debug(buffer.toString());
  }

  void _logResponse(Response response) {
    final buffer = StringBuffer();
    
    buffer.writeln('╭─────── Response ───────');
    buffer.writeln('│ ${response.statusCode} ${response.statusMessage}');
    buffer.writeln('│ ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
    
    if (logHeaders && response.headers.map.isNotEmpty) {
      buffer.writeln('│');
      buffer.writeln('│ Headers:');
      _logHeaders(buffer, response.headers.map);
    }

    if (logResponseData && response.data != null) {
      buffer.writeln('│');
      buffer.writeln('│ Body:');
      _logBody(buffer, response.data);
    }

    buffer.writeln('╰──────────────────────────');
    
    AppLogger.debug(buffer.toString());
  }

  void _logError(DioException error) {
    final buffer = StringBuffer();
    
    buffer.writeln('╭─────── Error ──────────');
    buffer.writeln('│ ${error.type.name}');
    buffer.writeln('│ ${error.requestOptions.method.toUpperCase()} ${error.requestOptions.uri}');
    
    if (error.response != null) {
      buffer.writeln('│ Status: ${error.response!.statusCode} ${error.response!.statusMessage}');
      
      if (logResponseData && error.response!.data != null) {
        buffer.writeln('│');
        buffer.writeln('│ Error Body:');
        _logBody(buffer, error.response!.data);
      }
    }

    if (error.message != null) {
      buffer.writeln('│');
      buffer.writeln('│ Message: ${error.message}');
    }

    buffer.writeln('╰──────────────────────────');
    
    AppLogger.error(buffer.toString());
  }

  void _logHeaders(StringBuffer buffer, Map<String, dynamic> headers) {
    headers.forEach((key, value) {
      final headerKey = key.toLowerCase();
      final headerValue = _shouldMaskHeader(headerKey) 
          ? _maskSensitiveValue(value.toString())
          : value.toString();
      
      buffer.writeln('│   $key: $headerValue');
    });
  }

  void _logBody(StringBuffer buffer, dynamic data) {
    String bodyString;
    
    try {
      if (data is Map || data is List) {
        bodyString = const JsonEncoder.withIndent('  ').convert(data);
      } else if (data is String) {
        bodyString = data;
      } else {
        bodyString = data.toString();
      }
    } catch (e) {
      bodyString = 'Unable to parse body: ${data.runtimeType}';
    }

    if (bodyString.length > maxBodyLength) {
      bodyString = '${bodyString.substring(0, maxBodyLength)}... (truncated)';
    }

    // Add indentation to each line
    final lines = bodyString.split('\n');
    for (final line in lines) {
      buffer.writeln('│   $line');
    }
  }

  bool _shouldMaskHeader(String headerKey) {
    return sensitiveHeaders.any(
      (sensitiveHeader) => headerKey.contains(sensitiveHeader.toLowerCase()),
    );
  }

  String _maskSensitiveValue(String value) {
    if (value.length <= 8) {
      return '*' * value.length;
    }
    return '${value.substring(0, 4)}${'*' * (value.length - 8)}${value.substring(value.length - 4)}';
  }
}