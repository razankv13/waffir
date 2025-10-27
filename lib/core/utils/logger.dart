import 'dart:async';
import 'dart:developer' as developer;
import 'package:logger/logger.dart';
import 'package:waffir/core/constants/app_constants.dart';

/// Custom logger utility for the application
class AppLogger {

  // Private constructor
  AppLogger._();
  static final Logger _logger = Logger(
    printer: _getLoggerPrinter(),
    level: _getLogLevel(),
    output: _getLogOutput(),
  );

  // Public methods
  static void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void wtf(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Network logging
  static void logRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('📤 HTTP REQUEST');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    
    if (body != null) {
      buffer.writeln('Body: $body');
    }
    
    info(buffer.toString());
  }

  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    Duration? duration,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('📥 HTTP RESPONSE');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');
    buffer.writeln('Status Code: $statusCode');
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    
    if (body != null) {
      // Truncate large responses
      final bodyStr = body.toString();
      if (bodyStr.length > 1000) {
        buffer.writeln('Body: ${bodyStr.substring(0, 1000)}... [TRUNCATED]');
      } else {
        buffer.writeln('Body: $bodyStr');
      }
    }
    
    if (statusCode >= 200 && statusCode < 300) {
      info(buffer.toString());
    } else if (statusCode >= 400) {
      error(buffer.toString());
    } else {
      warning(buffer.toString());
    }
  }

  // Navigation logging
  static void logNavigation({
    required String from,
    required String to,
    Map<String, dynamic>? arguments,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('🧭 NAVIGATION');
    buffer.writeln('From: $from');
    buffer.writeln('To: $to');
    
    if (arguments != null && arguments.isNotEmpty) {
      buffer.writeln('Arguments: $arguments');
    }
    
    debug(buffer.toString());
  }

  // Authentication logging
  static void logAuth(String event, {Map<String, dynamic>? metadata}) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('🔐 AUTH EVENT: $event');
    
    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln('Metadata: $metadata');
    }
    
    info(buffer.toString());
  }

  // Performance logging
  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('⚡ PERFORMANCE');
    buffer.writeln('Operation: $operation');
    buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    
    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln('Metadata: $metadata');
    }
    
    if (duration.inMilliseconds > 1000) {
      warning(buffer.toString());
    } else {
      debug(buffer.toString());
    }
  }

  // Database logging
  static void logDatabase({
    required String operation,
    String? table,
    Map<String, dynamic>? data,
    Duration? duration,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('🗄️ DATABASE');
    buffer.writeln('Operation: $operation');
    
    if (table != null) {
      buffer.writeln('Table: $table');
    }
    
    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    debug(buffer.toString());
  }

  // Cache logging
  static void logCache({
    required String operation,
    required String key,
    bool? hit,
    Duration? duration,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('💾 CACHE');
    buffer.writeln('Operation: $operation');
    buffer.writeln('Key: $key');
    
    if (hit != null) {
      buffer.writeln('Hit: $hit');
    }
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    debug(buffer.toString());
  }

  // Analytics logging
  static void logAnalytics({
    required String event,
    Map<String, dynamic>? parameters,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('📊 ANALYTICS');
    buffer.writeln('Event: $event');
    
    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('Parameters: $parameters');
    }
    
    debug(buffer.toString());
  }

  // Error with context
  static void logErrorWithContext({
    required String message,
    required dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('❌ ERROR WITH CONTEXT');
    buffer.writeln('Message: $message');
    
    if (context != null && context.isNotEmpty) {
      buffer.writeln('Context: $context');
    }
    
    AppLogger.error(buffer.toString(), error: error, stackTrace: stackTrace);
  }

  // Feature flag logging
  static void logFeatureFlag({
    required String flag,
    required bool enabled,
    Map<String, dynamic>? metadata,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('🚩 FEATURE FLAG');
    buffer.writeln('Flag: $flag');
    buffer.writeln('Enabled: $enabled');
    
    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln('Metadata: $metadata');
    }
    
    debug(buffer.toString());
  }

  // User action logging
  static void logUserAction({
    required String action,
    Map<String, dynamic>? data,
  }) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('👤 USER ACTION');
    buffer.writeln('Action: $action');
    
    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }
    
    info(buffer.toString());
  }

  // Lifecycle logging
  static void logLifecycle(String event, {String? screen}) {
    if (!AppConstants.enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('🔄 LIFECYCLE');
    buffer.writeln('Event: $event');
    
    if (screen != null) {
      buffer.writeln('Screen: $screen');
    }
    
    debug(buffer.toString());
  }

  // Memory usage logging
  static void logMemoryUsage() {
    if (!AppConstants.enableLogging) return;
    
    // Note: This is a basic implementation. For more detailed memory profiling,
    // you might want to use vm_service or other profiling tools
    developer.log('📊 Memory usage logging requested', name: 'AppLogger');
  }

  // Custom log level check
  static bool isLoggingEnabled(Level level) {
    return Logger.level.index <= level.index;
  }

  // Close logger resources
  static void close() {
    _logger.close();
  }

  // Private helper methods
  static LogPrinter _getLoggerPrinter() {
    if (AppConstants.isDebugMode) {
      return PrettyPrinter(
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      );
    } else {
      return SimplePrinter(
        colors: false,
      );
    }
  }

  static Level _getLogLevel() {
    if (AppConstants.isDebugMode) {
      return Level.debug;
    } else {
      return Level.info;
    }
  }

  static LogOutput _getLogOutput() {
    return ConsoleOutput();
  }
}

/// Extension methods for easier logging
extension LoggerExtension on Object {
  void logDebug([dynamic error, StackTrace? stackTrace]) {
    AppLogger.debug(toString(), error: error, stackTrace: stackTrace);
  }

  void logInfo([dynamic error, StackTrace? stackTrace]) {
    AppLogger.info(toString(), error: error, stackTrace: stackTrace);
  }

  void logWarning([dynamic error, StackTrace? stackTrace]) {
    AppLogger.warning(toString(), error: error, stackTrace: stackTrace);
  }

  void logError([dynamic error, StackTrace? stackTrace]) {
    AppLogger.error(toString(), error: error, stackTrace: stackTrace);
  }
}

/// Utility class for measuring execution time
class LoggingTimer {

  LoggingTimer(this.operation, {this.metadata}) {
    _stopwatch.start();
  }
  final String operation;
  final Stopwatch _stopwatch = Stopwatch();
  final Map<String, dynamic>? metadata;

  void stop() {
    _stopwatch.stop();
    AppLogger.logPerformance(
      operation: operation,
      duration: _stopwatch.elapsed,
      metadata: metadata,
    );
  }
}

/// Annotation for automatic logging (can be used with code generation)
class LogExecution {
  
  const LogExecution({
    this.name,
    this.logParameters = false,
    this.logResult = false,
  });
  final String? name;
  final bool logParameters;
  final bool logResult;
}

/// Zone-based error logging
class LoggingZone {
  static T runGuarded<T>(T Function() callback, {String? operation}) {
    return runZonedGuarded(() {
      final timer = operation != null ? LoggingTimer(operation) : null;
      try {
        final result = callback();
        timer?.stop();
        return result;
      } catch (error, stackTrace) {
        timer?.stop();
        AppLogger.logErrorWithContext(
          message: 'Error in ${operation ?? 'guarded zone'}',
          error: error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }, (error, stackTrace) {
      AppLogger.logErrorWithContext(
        message: 'Uncaught error in ${operation ?? 'guarded zone'}',
        error: error,
        stackTrace: stackTrace,
      );
    })!;
  }
}

