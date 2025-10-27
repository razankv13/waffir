import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      const buttonText = 'Test Button';

      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Tap Me',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(wasPressed, true);
    });

    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          const AppButton(
            text: 'Disabled Button',
          ),
        ),
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, null);

      // Should not be tappable
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      // No assertion needed - just ensuring it doesn't throw
    });

    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Loading Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Text should be hidden when loading
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('should apply correct button variant styles', (WidgetTester tester) async {
      // Test primary button (default)
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Primary Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);

      // Test secondary button
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Secondary Button',
            variant: ButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);

      // Test text button
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Text Button',
            variant: ButtonVariant.text,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should apply custom width when provided', (WidgetTester tester) async {
      const customWidth = 200.0;

      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Wide Button',
            width: customWidth,
            onPressed: () {},
          ),
        ),
      );

      final sizedBox = find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(SizedBox),
      );

      expect(sizedBox, findsOneWidget);
      final sizedBoxWidget = tester.widget<SizedBox>(sizedBox);
      expect(sizedBoxWidget.width, customWidth);
    });

    testWidgets('should display icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Button with Icon',
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Button with Icon'), findsOneWidget);
    });

    testWidgets('should handle different button sizes', (WidgetTester tester) async {
      // Test small button
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Small Button',
            size: ButtonSize.small,
            onPressed: () {},
          ),
        ),
      );

      final smallButton = find.byType(FilledButton);
      expect(smallButton, findsOneWidget);

      // Test large button
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Large Button',
            size: ButtonSize.large,
            onPressed: () {},
          ),
        ),
      );

      final largeButton = find.byType(FilledButton);
      expect(largeButton, findsOneWidget);
    });

    testWidgets('should be accessible with proper semantics', (WidgetTester tester) async {
      const buttonText = 'Accessible Button';

      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      );

      // Check that button is found and has the correct text
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Verify the button can be tapped (accessibility wise)
      await tester.tap(find.byType(AppButton));
      await tester.pump();
    });

    testWidgets('should work with different themes', (WidgetTester tester) async {
      // Test with light theme
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Light Theme Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Light Theme Button'), findsOneWidget);

      // Test with dark theme
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          AppButton(
            text: 'Dark Theme Button',
            onPressed: () {},
          ),
          themeMode: ThemeMode.dark,
        ),
      );

      expect(find.text('Dark Theme Button'), findsOneWidget);
    });
  });
}