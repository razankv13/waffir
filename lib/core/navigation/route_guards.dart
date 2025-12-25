import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/auth/data/providers/auth_bootstrap_providers.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';

/// Base class for route guards
abstract class RouteGuard extends ChangeNotifier {
  /// Check if the route should be redirected
  String? redirect(BuildContext context, GoRouterState state);

  /// Check if the guard should be active for this route
  bool shouldGuard(String route);
}

/// Authentication route guard
class AuthGuard extends RouteGuard {
  AuthGuard(this._ref);
  final Ref _ref;

  bool _isAuthenticated = false;
  bool _isInitialized = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;
  bool get isBootstrapped => _ref.read(isBootstrappedProvider);

  /// Update authentication status
  void updateAuthStatus(bool isAuthenticated) {
    final didChange = _isAuthenticated != isAuthenticated || !_isInitialized;
    _isAuthenticated = isAuthenticated;
    _isInitialized = true;

    if (didChange) {
      _isInitialized = true;
      notifyListeners();

      AppLogger.logAuth(
        isAuthenticated ? 'User authenticated' : 'User logged out',
        metadata: {'timestamp': DateTime.now().toIso8601String()},
      );
    }
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final isGoingToAuth = AppRoutes.authRoutes.contains(state.matchedLocation);
    final isGoingToPublic = AppRoutes.publicRoutes.contains(state.matchedLocation);

    // Onboarding routes that should be accessible during bootstrap
    final isGoingToOnboarding = [
      AppRoutes.splash,
      AppRoutes.citySelection,
      AppRoutes.onboarding,
      AppRoutes.welcome,
      AppRoutes.accountDetails,
    ].contains(state.matchedLocation);

    // Don't redirect if not initialized yet
    if (!_isInitialized) {
      AppLogger.debug('AuthGuard not initialized, allowing navigation');
      return null;
    }

    // Read bootstrap status directly from provider to avoid race conditions
    final isBootstrapped = _ref.read(isBootstrappedProvider);

    // Check if user has already passed the initial navigation flow (city selection done)
    final hasPassedInitialFlow = _ref.read(initialNavigationCompletedProvider);

    // If authenticated but bootstrapping is not finished, allow onboarding routes
    // Also allow if user has already passed initial flow (prevents redirect loop)
    if (_isAuthenticated && !isBootstrapped && !isGoingToOnboarding && !hasPassedInitialFlow) {
      return AppRoutes.splash;
    }

    // If user is not authenticated and trying to access protected route
    if (!_isAuthenticated && !isGoingToAuth && !isGoingToPublic) {
      AppLogger.logNavigation(
        from: state.matchedLocation,
        to: AppRoutes.login,
        arguments: {'reason': 'not_authenticated'},
      );
      return '${AppRoutes.login}?${AppQueryParams.returnTo}=${Uri.encodeComponent(state.uri.toString())}';
    }

    // If user is authenticated and trying to access auth pages (except accountDetails)
    // accountDetails is part of auth flow but requires authenticated access for profile completion
    if (_isAuthenticated && isGoingToAuth && state.matchedLocation != AppRoutes.accountDetails) {
      AppLogger.logNavigation(
        from: state.matchedLocation,
        to: AppRoutes.home,
        arguments: {'reason': 'already_authenticated'},
      );
      return AppRoutes.home;
    }

    return null;
  }

  @override
  bool shouldGuard(String route) {
    return AppRoutes.protectedRoutes.contains(route) || AppRoutes.authRoutes.contains(route);
  }

  /// Sign out user
  void signOut() {
    updateAuthStatus(false);
  }

  /// Sign in user
  void signIn() {
    updateAuthStatus(true);
  }

  /// Force GoRouter to re-evaluate routes
  void refreshRouter() {
    notifyListeners();
  }
}

/// Admin route guard
class AdminGuard extends RouteGuard {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void updateAdminStatus(bool isAdmin) {
    if (_isAdmin != isAdmin) {
      _isAdmin = isAdmin;
      notifyListeners();
    }
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    // Check if trying to access admin routes
    final isAdminRoute = state.matchedLocation.startsWith('/admin');

    if (isAdminRoute && !_isAdmin) {
      AppLogger.logNavigation(
        from: state.matchedLocation,
        to: AppRoutes.error,
        arguments: {'reason': 'insufficient_permissions'},
      );
      return '${AppRoutes.error}?error=Access denied: Admin privileges required';
    }

    return null;
  }

  @override
  bool shouldGuard(String route) {
    return route.startsWith('/admin');
  }
}

/// Onboarding route guard
class OnboardingGuard extends RouteGuard {
  bool _hasCompletedOnboarding = false;

  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  void updateOnboardingStatus(bool completed) {
    if (_hasCompletedOnboarding != completed) {
      _hasCompletedOnboarding = completed;
      notifyListeners();
    }
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
    final isGoingToAuth = AppRoutes.authRoutes.contains(state.matchedLocation);

    // If user hasn't completed onboarding and is not going to onboarding or auth
    if (!_hasCompletedOnboarding && !isGoingToOnboarding && !isGoingToAuth) {
      AppLogger.logNavigation(
        from: state.matchedLocation,
        to: AppRoutes.onboarding,
        arguments: {'reason': 'onboarding_required'},
      );
      return AppRoutes.onboarding;
    }

    // If user has completed onboarding and is trying to access onboarding
    if (_hasCompletedOnboarding && isGoingToOnboarding) {
      return AppRoutes.home;
    }

    return null;
  }

  @override
  bool shouldGuard(String route) {
    return !AppRoutes.authRoutes.contains(route) && route != AppRoutes.onboarding;
  }
}

/// Combined route guard that manages multiple guards
class CombinedRouteGuard extends RouteGuard {
  CombinedRouteGuard(this._guards) {
    // Listen to changes in all guards
    for (final guard in _guards) {
      guard.addListener(notifyListeners);
    }
  }
  final List<RouteGuard> _guards;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    // Execute guards in order and return first non-null redirect
    for (final guard in _guards) {
      if (guard.shouldGuard(state.matchedLocation)) {
        final redirect = guard.redirect(context, state);
        if (redirect != null) {
          return redirect;
        }
      }
    }
    return null;
  }

  @override
  bool shouldGuard(String route) {
    return _guards.any((guard) => guard.shouldGuard(route));
  }

  @override
  void dispose() {
    for (final guard in _guards) {
      guard.removeListener(notifyListeners);
      guard.dispose();
    }
    super.dispose();
  }
}

// Global instances
final _adminGuard = AdminGuard();
final _onboardingGuard = OnboardingGuard();

// Providers
final authGuardProvider = Provider<AuthGuard>((ref) {
  final guard = AuthGuard(ref);

  ref.listen(authStateProvider, (previous, next) {
    next.when(
      data: (state) {
        guard.updateAuthStatus(state.isAuthenticated);
        // Reset initial navigation state when user logs out
        if (!state.isAuthenticated) {
          ref.read(initialNavigationCompletedProvider.notifier).reset();
        }
      },
      loading: () {},
      error: (_, _) => guard.updateAuthStatus(false),
    );
  });

  // Trigger GoRouter re-evaluation when bootstrap status changes
  // This ensures stale provider values are refreshed after bootstrap completes
  ref.listen(isBootstrappedProvider, (previous, next) {
    if (previous != next) {
      guard.refreshRouter();
    }
  });

  // Initialize with current auth value if already available
  final initialAuth = ref.read(isAuthenticatedProvider);
  guard.updateAuthStatus(initialAuth);

  ref.onDispose(guard.dispose);
  return guard;
});

final adminGuardProvider = Provider<AdminGuard>((ref) {
  return _adminGuard;
});

final onboardingGuardProvider = Provider<OnboardingGuard>((ref) {
  return _onboardingGuard;
});

final combinedGuardProvider = Provider<CombinedRouteGuard>((ref) {
  return CombinedRouteGuard([
    ref.watch(authGuardProvider),
    ref.watch(adminGuardProvider),
    ref.watch(onboardingGuardProvider),
  ]);
});

// Extensions for easier usage
extension GoRouterExtension on GoRouter {
  /// Check if current route requires authentication
  bool get requiresAuth {
    final location = routerDelegate.currentConfiguration.uri.path;
    return AppRoutes.protectedRoutes.contains(location);
  }

  /// Get current route name
  String? get currentRouteName {
    final matches = routerDelegate.currentConfiguration.matches;
    if (matches.isNotEmpty) {
      final match = matches.last;
      return match.matchedLocation;
    }
    return null;
  }
}

extension BuildContextRouteExtension on BuildContext {
  /// Navigate with authentication check
  void goWithAuth(String route, {Object? extra}) {
    final router = GoRouter.of(this);
    if (AppRoutes.protectedRoutes.contains(route)) {
      // Add auth check logic here if needed
    }
    router.go(route, extra: extra);
  }

  /// Push with authentication check
  void pushWithAuth(String route, {Object? extra}) {
    final router = GoRouter.of(this);
    if (AppRoutes.protectedRoutes.contains(route)) {
      // Add auth check logic here if needed
    }
    router.push(route, extra: extra);
  }
}
