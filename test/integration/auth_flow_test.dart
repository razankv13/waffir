import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:waffir/main.dart' as app;
import '../helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    setUpAll(() async {
      // Set up any global test configuration
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      // Reset app state before each test
    });

    testWidgets('complete auth flow - signup, login, logout', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test signup flow
      await _testSignupFlow(tester);

      // Test logout
      await _testLogout(tester);

      // Test login flow
      await _testLoginFlow(tester);
    });

    testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Simulate network error by disabling network
      // This would require mock network conditions

      // Try to login with network disabled
      // Verify error message is shown

      // Re-enable network and verify login works
    });

    testWidgets('should persist login state across app restarts', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await _testLoginFlow(tester);

      // Simulate app restart
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/platform',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('SystemNavigator.pop'),
        ),
        (data) {},
      );

      // Start app again
      app.main();
      await tester.pumpAndSettle();

      // Should still be logged in
      expect(find.text('Home'), findsOneWidget);
    });
  });
}

Future<void> _testSignupFlow(WidgetTester tester) async {
  // Navigate to signup
  if (find.text('Sign Up').evaluate().isNotEmpty) {
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
  }

  // Fill signup form
  await tester.enterText(
    find.byKey(const Key('email_field')),
    TestConstants.validEmail,
  );
  await tester.enterText(
    find.byKey(const Key('password_field')),
    TestConstants.validPassword,
  );
  await tester.enterText(
    find.byKey(const Key('confirm_password_field')),
    TestConstants.validPassword,
  );

  // Submit form
  await tester.tap(find.byKey(const Key('signup_button')));
  await tester.pumpAndSettle();

  // Should navigate to home or email verification
  final welcomeText = find.byWidgetPredicate((widget) =>
      widget is Text && widget.data != null && widget.data!.contains('Welcome'));
  final verifyEmailText = find.text('Verify Email');

  expect(
    welcomeText.evaluate().isNotEmpty || verifyEmailText.evaluate().isNotEmpty,
    true,
  );
}

Future<void> _testLoginFlow(WidgetTester tester) async {
  // Navigate to login if not already there
  if (find.text('Login').evaluate().isNotEmpty) {
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
  }

  // Fill login form
  await tester.enterText(
    find.byKey(const Key('email_field')),
    TestConstants.validEmail,
  );
  await tester.enterText(
    find.byKey(const Key('password_field')),
    TestConstants.validPassword,
  );

  // Submit form
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();

  // Should navigate to home
  expect(find.text('Home'), findsOneWidget);
}

Future<void> _testLogout(WidgetTester tester) async {
  // Open drawer or navigate to settings
  if (find.byKey(const Key('drawer_button')).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(const Key('drawer_button')));
    await tester.pumpAndSettle();
  }

  // Tap logout
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();

  // Should navigate back to auth screen
  final loginText = find.text('Login');
  final welcomeText = find.text('Welcome');

  expect(
    loginText.evaluate().isNotEmpty || welcomeText.evaluate().isNotEmpty,
    true,
  );
}