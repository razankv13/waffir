import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/search/waffir_search_bar.dart';
import 'package:waffir/gen/assets.gen.dart';

/// A shared SliverAppBar component with the Waffir app branding.
///
/// Displays:
/// - Logo with optional notification button
/// - Search bar with filter functionality
///
/// Uses responsive scaling from [ResponsiveHelper] for all dimensions.
///
/// Example usage:
/// ```dart
/// NestedScrollView(
///   headerSliverBuilder: (context, _) {
///     return [
///       WaffirSliverAppBar(
///         searchHintText: 'Search deals...',
///         onSearchChanged: controller.updateSearch,
///         onSearch: controller.updateSearch,
///         onFilterTap: () => showFilters(),
///       ),
///     ];
///   },
///   body: ...,
/// )
/// ```
class WaffirSliverAppBar extends StatelessWidget {
  const WaffirSliverAppBar({
    super.key,
    required this.searchHintText,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onFilterTap,
  });

  /// Hint text displayed in the search bar.
  final String searchHintText;

  /// Callback when the search text changes.
  final ValueChanged<String> onSearchChanged;

  /// Callback when search is submitted.
  final ValueChanged<String> onSearch;

  /// Callback when the filter button is tapped.
  final VoidCallback onFilterTap;

  /// Computes the header height for use with [NestedScrollView.headerSliverBuilder].
  ///
  /// Call this to set [SliverAppBar.collapsedHeight] and [SliverAppBar.expandedHeight].
  static double computeHeaderHeight(BuildContext context) {
    final responsive = context.rs;
    final headerVerticalPadding = responsive.s(12);
    final logoHeight = responsive.s(56);
    final notificationSize = responsive.s(44);
    const searchBarHeight = 68.0;
    final searchPadding = responsive.s(16);

    final rowHeight = logoHeight > notificationSize ? logoHeight : notificationSize;
    return (headerVerticalPadding * 2) + rowHeight + (searchPadding * 2) + searchBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.rs;

    final headerHorizontalPadding = responsive.s(16);
    final headerVerticalPadding = responsive.s(12);
    final logoHeight = responsive.s(56);
    final notificationSize = responsive.s(44);
    final notificationIconSize = responsive.s(22);
    final notificationSplashRadius = responsive.s(24);
    final searchPadding = responsive.s(16);

    final headerHeight = computeHeaderHeight(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: 0,
      collapsedHeight: headerHeight,
      expandedHeight: headerHeight,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (logo + notifications)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: headerHorizontalPadding,
              vertical: headerVerticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Assets.images.splashLogo.path,
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
                // Notifications button
                Tooltip(
                  message: 'Notifications',
                  child: Container(
                    width: notificationSize,
                    height: notificationSize,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        size: notificationIconSize,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {
                        context.pushNamed(AppRouteNames.notifications);
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: notificationSplashRadius,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.all(searchPadding),
            child: WaffirSearchBar(
              hintText: searchHintText,
              onChanged: onSearchChanged,
              onSearch: onSearch,
              onFilterTap: onFilterTap,
            ),
          ),
        ],
      ),
    );
  }
}
