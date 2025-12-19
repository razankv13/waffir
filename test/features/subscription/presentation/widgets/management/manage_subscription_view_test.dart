import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/features/subscription/presentation/widgets/management/manage_subscription_view.dart';

void main() {
  testWidgets('ManageSubscriptionView renders correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ManageSubscriptionView(),
          ),
        ),
      ),
    );

    // Verify "My Subscription" header exists
    expect(find.text('My Subscription'), findsOneWidget);

    // Verify "Your Savings This Year" section
    expect(find.text('Your Savings This Year'), findsOneWidget);
    
    // Verify "Current Plan" section
    expect(find.text('Current Plan'), findsOneWidget);
    expect(find.text('Family Annual Plan'), findsOneWidget);

    // Verify "Family Members" section
    expect(find.text('Family Members'), findsOneWidget);
    expect(find.text('You (Sarah)'), findsOneWidget);
    expect(find.text('Emma Miller'), findsOneWidget);
    expect(find.text('Liam Miller'), findsOneWidget);

    // Verify buttons
    expect(find.text('Change Plan'), findsOneWidget);
    expect(find.text('Add member'), findsOneWidget);
    expect(find.text('Cancel Subscription'), findsOneWidget);

     // Verify Help & Support
    expect(find.text('Help & Support'), findsOneWidget);
  });
}
