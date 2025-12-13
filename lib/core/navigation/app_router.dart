import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/app_router_routes.dart';
import 'package:waffir/core/navigation/route_guards.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/logger.dart';

// Global navigator key
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authGuard = ref.watch(authGuardProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) => authGuard.redirect(context, state),
    refreshListenable: authGuard,
    onException: (context, state, router) {
      AppLogger.error(
        'Navigation error',
        error: 'Failed to navigate to ${state.uri}',
        stackTrace: StackTrace.current,
      );
    },
    routes: buildAppRoutes(shellNavigatorKey: shellNavigatorKey),
  );
});

