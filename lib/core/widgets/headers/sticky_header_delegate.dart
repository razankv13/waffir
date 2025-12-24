import 'package:flutter/material.dart';

/// A reusable sticky header delegate for [SliverPersistentHeader] that maintains
/// a fixed height with configurable top spacing and background color.
///
/// Commonly used for sticky category chip filters that remain pinned while scrolling.
///
/// Example usage:
/// ```dart
/// SliverPersistentHeader(
///   pinned: true,
///   delegate: StickyHeaderDelegate(
///     height: 80,
///     topSpacing: 6,
///     backgroundColor: Theme.of(context).colorScheme.surface,
///     child: CategoryChips(...),
///   ),
/// )
/// ```
class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const StickyHeaderDelegate({
    required this.height,
    required this.topSpacing,
    required this.backgroundColor,
    required this.child,
  });

  /// The total height of the header.
  final double height;

  /// Top spacing/padding applied above the child widget.
  final double topSpacing;

  /// Background color of the header container.
  final Color backgroundColor;

  /// The widget to display inside the header.
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    return height != oldDelegate.height ||
        topSpacing != oldDelegate.topSpacing ||
        backgroundColor != oldDelegate.backgroundColor ||
        child != oldDelegate.child;
  }
}
