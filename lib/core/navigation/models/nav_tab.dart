import 'package:flutter/material.dart';

/// Model representing a navigation tab in the bottom navigation bar.
///
/// Used to build dynamic tab lists that can change based on app state
/// (e.g., hiding the Credit Cards tab after user confirms their selection).
@immutable
class NavTab {
  const NavTab({
    required this.route,
    required this.label,
    required this.iconPath,
  });

  /// The route path for navigation (e.g., '/stores').
  final String route;

  /// The display label for the tab.
  final String label;

  /// The asset path for the tab icon SVG.
  final String iconPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavTab &&
          runtimeType == other.runtimeType &&
          route == other.route &&
          label == other.label &&
          iconPath == other.iconPath;

  @override
  int get hashCode => Object.hash(route, label, iconPath);
}
