import 'package:flutter/material.dart';

import 'package:waffir/core/navigation/widgets/bottom_navigation.dart';

/// Main shell widget with bottom navigation.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
