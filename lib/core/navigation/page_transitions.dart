import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standard page transitions used by the app.
class AppPageTransitions {
  AppPageTransitions._();

  /// Smooth fade + slight scale transition (good for bottom-tab switching).
  static CustomTransitionPage<T> fadeScale<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
