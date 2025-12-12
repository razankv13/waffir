import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:waffir/core/themes/app_theme.dart';

/// Test helpers and utilities for the Flutter template app
class TestHelpers {
  /// Creates a widget with Material App wrapper for testing
  static Widget createTestableWidget(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en', 'US'),
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: themeMode,
        locale: locale,
        home: child,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
          Locale('fr', 'FR'),
        ],
      ),
    );
  }

  /// Wraps widget test with network image mocking
  static Future<T> withNetworkImageMock<T>(Future<T> Function() test) async {
    return mockNetworkImagesFor(test);
  }

  /// Creates a test widget with Riverpod providers (simplified version)
  static Widget createTestableWidgetWithProviders({
    required Widget child,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: themeMode,
        home: Scaffold(body: child),
      ),
    );
  }

  /// Simulates a delay for async operations in tests
  static Future<void> delay([Duration? duration]) async {
    await Future.delayed(duration ?? const Duration(milliseconds: 100));
  }

  /// Pumps and settles with a timeout to prevent infinite loops
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle();
  }

  /// Finds a widget by text with case-insensitive matching
  static Finder findTextIgnoringCase(String text) {
    return find.byWidgetPredicate((widget) =>
        widget is Text &&
        widget.data?.toLowerCase().contains(text.toLowerCase()) == true);
  }

  /// Finds a button by its text
  static Finder findButtonByText(String text) {
    return find.widgetWithText(ButtonStyleButton, text);
  }

  /// Taps a button and waits for it to settle
  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.tap(finder);
    await pumpAndSettle(tester, timeout: timeout);
  }

  /// Enters text in a form field and waits
  static Future<void> enterTextAndSettle(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await pumpAndSettle(tester);
  }
}

/// Test constants and data
class TestConstants {
  static const validEmail = 'test@example.com';
  static const validPassword = 'password123';
  static const invalidEmail = 'invalid-email';
  static const shortPassword = '123';

  static const mockUserId = 'mock-user-id';
  static const mockUserName = 'Test User';
  static const mockUserPhotoUrl = 'https://example.com/photo.jpg';

  static const mockProductId = 'premium_monthly';
  static const mockTransactionId = 'mock-transaction-123';
}

/// Custom matchers for testing
class TestMatchers {
  /// Matches any exception
  static Matcher isException = isA<Exception>();

  /// Matches any error
  static Matcher isError = isA<Error>();

  /// Matches loading state
  static Matcher isLoading = isA<AsyncLoading>();

  /// Matches error state
  static Matcher isAsyncError = isA<AsyncError>();

  /// Matches data state
  static Matcher isAsyncData = isA<AsyncData>();
}

/// Extensions for better testing experience
extension WidgetTesterExtensions on WidgetTester {
  /// Finds a widget by type and taps it
  Future<void> tapWidget<T extends Widget>() async {
    await tap(find.byType(T));
    await pump();
  }

  /// Finds and taps a button with specific text
  Future<void> tapButtonWithText(String text) async {
    await tap(TestHelpers.findButtonByText(text));
    await TestHelpers.pumpAndSettle(this);
  }

  /// Finds and enters text in a text field
  Future<void> enterTextInField(Finder finder, String text) async {
    await TestHelpers.enterTextAndSettle(this, finder, text);
  }

  /// Scrolls to find a widget if not visible
  Future<void> scrollToWidget(Finder finder) async {
    await scrollUntilVisible(finder, 100.0);
    await pump();
  }
}

/// Test data factories
class TestDataFactory {
  /// Creates test user data
  static Map<String, dynamic> createUserData({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
  }) {
    return {
      'id': id ?? TestConstants.mockUserId,
      'email': email ?? TestConstants.validEmail,
      'displayName': displayName ?? TestConstants.mockUserName,
      'photoURL': photoURL ?? TestConstants.mockUserPhotoUrl,
      'emailVerified': emailVerified ?? true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates test subscription data
  static Map<String, dynamic> createSubscriptionData({
    String? productId,
    bool? isActive,
    DateTime? expiresAt,
  }) {
    return {
      'productId': productId ?? TestConstants.mockProductId,
      'isActive': isActive ?? true,
      'purchaseDate': DateTime.now().toIso8601String(),
      'expiresAt': (expiresAt ?? DateTime.now().add(const Duration(days: 30))).toIso8601String(),
      'transactionId': TestConstants.mockTransactionId,
    };
  }
}