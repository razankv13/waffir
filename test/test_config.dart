import 'mocks/mock_services.dart';

/// Global test configuration
class TestConfig {
  /// Set up global test configuration
  static void setUp() {
    // Set up mock fallback values
    MockSetup.setUpMockFallbacks();

    // Configure test timeouts - Note: this would be set in test runner configuration
    // testWidgets.timeout is not directly settable in this way

    // Set up any global test fixtures
  }

  /// Clean up after all tests
  static void tearDown() {
    // Clean up any global resources
  }
}

/// Test groups for organizing tests
abstract class TestGroups {
  static const unit = 'Unit Tests';
  static const widget = 'Widget Tests';
  static const integration = 'Integration Tests';
  static const e2e = 'End-to-End Tests';
}

/// Test tags for categorizing tests
abstract class TestTags {
  static const fast = 'fast';
  static const slow = 'slow';
  static const network = 'network';
  static const database = 'database';
  static const auth = 'auth';
  static const payment = 'payment';
  static const ui = 'ui';
  static const performance = 'performance';
}

/// Test environment configuration
class TestEnvironment {
  static bool get isCIEnvironment =>
      const bool.fromEnvironment('CI');

  static bool get isDebugMode =>
      const bool.fromEnvironment('DEBUG');

  static String get testEnvironment =>
      const String.fromEnvironment('TEST_ENV', defaultValue: 'local');
}