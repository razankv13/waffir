import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/utils/logger.dart';

void main() {
  group('AppLogger', () {
    setUp(() {
      // Reset logger state before each test if needed
    });

    test('should log info messages', () {
      // Test that info logging doesn't throw errors
      expect(() => AppLogger.info('Test info message'), returnsNormally);
    });

    test('should log debug messages', () {
      // Test that debug logging doesn't throw errors
      expect(() => AppLogger.debug('Test debug message'), returnsNormally);
    });

    test('should log warning messages', () {
      // Test that warning logging doesn't throw errors
      expect(() => AppLogger.warning('Test warning message'), returnsNormally);
    });

    test('should log error messages', () {
      // Test that error logging doesn't throw errors
      expect(() => AppLogger.error('Test error message'), returnsNormally);
    });

    test('should log error with exception and stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;

      expect(
        () => AppLogger.error(
          'Test error with exception',
          error: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('should log navigation events', () {
      expect(
        () => AppLogger.logNavigation(
          from: '/home',
          to: '/profile',
        ),
        returnsNormally,
      );
    });

    test('should log authentication events', () {
      expect(
        () => AppLogger.logAuth(
          'login',
          metadata: {'method': 'email'},
        ),
        returnsNormally,
      );
    });

    test('should log performance metrics', () {
      expect(
        () => AppLogger.logPerformance(
          operation: 'test_operation',
          duration: const Duration(milliseconds: 100),
        ),
        returnsNormally,
      );
    });

    test('should log user actions', () {
      expect(
        () => AppLogger.logUserAction(
          action: 'button_tap',
          data: {'screen': 'home', 'button': 'login'},
        ),
        returnsNormally,
      );
    });

    test('should log analytics events', () {
      expect(
        () => AppLogger.logAnalytics(
          event: 'screen_view',
          parameters: {'screen_name': 'home'},
        ),
        returnsNormally,
      );
    });

    test('should log HTTP requests', () {
      expect(
        () => AppLogger.logRequest(
          method: 'GET',
          url: 'https://api.example.com/users',
          headers: {'Authorization': 'Bearer token'},
          body: {'id': '123'},
        ),
        returnsNormally,
      );
    });

    test('should log HTTP responses', () {
      expect(
        () => AppLogger.logResponse(
          method: 'GET',
          url: 'https://api.example.com/users',
          statusCode: 200,
          headers: {'Content-Type': 'application/json'},
          body: {'data': 'test'},
          duration: const Duration(milliseconds: 150),
        ),
        returnsNormally,
      );
    });

    test('should log database operations', () {
      expect(
        () => AppLogger.logDatabase(
          operation: 'SELECT',
          table: 'users',
          duration: const Duration(milliseconds: 50),
        ),
        returnsNormally,
      );
    });

    test('should log cache operations', () {
      expect(
        () => AppLogger.logCache(
          operation: 'GET',
          key: 'user_123',
          hit: true,
        ),
        returnsNormally,
      );
    });

    test('should log feature flags', () {
      expect(
        () => AppLogger.logFeatureFlag(
          flag: 'new_ui',
          enabled: true,
          metadata: {'userId': 'user_123'},
        ),
        returnsNormally,
      );
    });

    test('should log lifecycle events', () {
      expect(
        () => AppLogger.logLifecycle(
          'resumed',
          screen: 'home',
        ),
        returnsNormally,
      );
    });

    test('should log memory usage', () {
      expect(() => AppLogger.logMemoryUsage(), returnsNormally);
    });

    test('should handle null and empty messages gracefully', () {
      expect(() => AppLogger.info(''), returnsNormally);
      expect(() => AppLogger.debug(''), returnsNormally);
      expect(() => AppLogger.warning(''), returnsNormally);
      expect(() => AppLogger.error(''), returnsNormally);
    });

    test('should handle very long messages', () {
      final longMessage = 'A' * 10000;
      expect(() => AppLogger.info(longMessage), returnsNormally);
    });

    test('should handle special characters in messages', () {
      const specialMessage = 'Test with émojis 🚀 and spëcial çharacters!';
      expect(() => AppLogger.info(specialMessage), returnsNormally);
    });

    test('should handle concurrent logging calls', () async {
      // Test that multiple concurrent log calls don't cause issues
      final futures = List.generate(10, (index) async {
        AppLogger.info('Concurrent log message $index');
        AppLogger.debug('Debug message $index');
        AppLogger.warning('Warning message $index');
      });

      expect(() async => await Future.wait(futures), returnsNormally);
    });

    test('should handle error logging with context', () {
      expect(
        () => AppLogger.logErrorWithContext(
          message: 'Test error occurred',
          error: Exception('Test error'),
          context: {'userId': '123', 'action': 'test'},
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      // Clean up any resources if needed
    });
  });
}