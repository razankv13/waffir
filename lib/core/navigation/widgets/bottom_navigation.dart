import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/navigation/models/nav_tab.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/widgets/navigation/custom_bottom_nav.dart';
import 'package:waffir/features/credit_cards/data/providers/credit_cards_providers.dart';

/// Bottom navigation component with dynamic tab visibility.
///
/// Hides the Credit Cards tab after user has confirmed their card selection.
class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    // Watch card confirmation state - null while loading, true if confirmed
    final hasConfirmedCards = ref.watch(cardSelectionConfirmedProvider) ?? false;

    // Build dynamic tab list based on card confirmation state
    final tabs = _buildVisibleTabs(hasConfirmedCards);
    final selectedIndex = _getSelectedIndex(location, tabs);

    return CustomBottomNav(
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTap: (index) => _onTap(context, index, tabs),
    );
  }

  /// Builds the list of visible tabs based on card confirmation state.
  ///
  /// When [hasConfirmedCards] is true, the Credit Cards tab is hidden.
  List<NavTab> _buildVisibleTabs(bool hasConfirmedCards) {
    return [
      const NavTab(
        route: AppRoutes.deals,
        label: 'Hot Deals',
        iconPath: 'assets/icons/nav/hot_deals_icon.svg',
      ),
      const NavTab(
        route: AppRoutes.stores,
        label: 'Stores',
        iconPath: 'assets/icons/nav/store_icon.svg',
      ),
      if (!hasConfirmedCards)
        const NavTab(
          route: AppRoutes.creditCards,
          label: 'Credit Cards',
          iconPath: 'assets/icons/nav/credit_cards_icon.svg',
        ),
      const NavTab(
        route: AppRoutes.profile,
        label: 'Profile',
        iconPath: 'assets/icons/nav/profile_icon.svg',
      ),
    ];
  }

  /// Gets the selected index based on current location and visible tabs.
  int _getSelectedIndex(String location, List<NavTab> tabs) {
    for (var i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i].route)) return i;
    }
    return 0; // Default to first tab (Deals)
  }

  /// Handles tab tap and navigates to the corresponding route.
  void _onTap(BuildContext context, int index, List<NavTab> tabs) {
    if (index < 0 || index >= tabs.length) return;

    final targetRoute = tabs[index].route;
    final currentRoute = GoRouterState.of(context).uri.path;

    context.go(targetRoute);
    AppLogger.logNavigation(from: currentRoute, to: targetRoute);
  }
}
