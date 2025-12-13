import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/widgets/navigation/custom_bottom_nav.dart';

/// Bottom navigation component.
class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return CustomBottomNav(
      selectedIndex: _getSelectedIndex(location),
      onTap: (index) => _onTap(context, index),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.deals)) return 0;
    if (location.startsWith(AppRoutes.stores)) return 1;
    if (location.startsWith(AppRoutes.creditCards)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0; // Default to Deals
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.deals);
        break;
      case 1:
        context.go(AppRoutes.stores);
        break;
      case 2:
        context.go(AppRoutes.creditCards);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }

    AppLogger.logNavigation(from: GoRouterState.of(context).uri.path, to: _getRouteForIndex(index));
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.deals;
      case 1:
        return AppRoutes.stores;
      case 2:
        return AppRoutes.creditCards;
      case 3:
        return AppRoutes.profile;
      default:
        return AppRoutes.deals;
    }
  }
}
