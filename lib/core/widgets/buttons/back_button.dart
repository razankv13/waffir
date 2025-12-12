import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A customizable back button widget based on Figma design (node 442:548)
///
/// Features:
/// - Smart navigation using GoRouter's context.pop()
/// - Tap animation with scale effect
/// - Theme-aware colors (light/dark mode support)
/// - Customizable size, colors, and behavior
///
/// Example usage:
/// ```dart
/// // Default back navigation
/// AppBackButton()
///
/// // Custom callback
/// AppBackButton(
///   onPressed: () => context.go('/home'),
/// )
///
/// // Custom styling
/// AppBackButton(
///   size: 44,
///   backgroundColor: Colors.white,
///   foregroundColor: Colors.black,
/// )
/// ```
class AppBackButton extends StatefulWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 38,
    this.tooltip = 'Go back',
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.isLoading = false,
    this.borderRadius,
    this.showBackground = false,
  });

  /// Custom callback to override default back navigation
  /// If null, will use context.pop() from GoRouter
  final VoidCallback? onPressed;

  /// Size of the button (width and height)
  /// Default: 38 (from Figma design)
  final double size;

  /// Tooltip text shown on long press
  final String? tooltip;

  /// Background color override
  /// If null, uses transparent or subtle surface color if showBackground is true
  final Color? backgroundColor;

  /// Icon color override
  /// If null, uses theme's onSurface color
  final Color? foregroundColor;

  /// Whether to animate the button on tap
  final bool animateOnTap;

  /// Whether to show loading indicator instead of icon
  final bool isLoading;

  /// Border radius override
  /// If null, uses circular shape (size / 2)
  final BorderRadius? borderRadius;

  /// Whether to show a background color
  /// If false, button is transparent (icon only)
  final bool showBackground;

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.animateOnTap) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }

    // Use custom callback or default to GoRouter's pop
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on theme and overrides
    final iconColor = widget.foregroundColor ?? colorScheme.onSurface;
    final bgColor =
        widget.backgroundColor ??
        (widget.showBackground
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.transparent);

    final buttonContent = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.size / 2), // Circular by default
      ),
      child: widget.isLoading
          ? Center(
              child: SizedBox(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              ),
            )
          : Icon(
              Icons.chevron_left,
              size: widget.size * 0.6, // Icon is 60% of button size
              color: iconColor,
            ),
    );

    final button = widget.animateOnTap
        ? ScaleTransition(scale: _scaleAnimation, child: buttonContent)
        : buttonContent;

    final inkWell = InkWell(
      onTap: widget.isLoading ? null : _handleTap,
      borderRadius:
          widget.borderRadius ?? BorderRadius.circular(widget.size / 2), // Circular by default
      child: button,
    );

    // Wrap with tooltip if provided
    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      return Tooltip(message: widget.tooltip!, child: inkWell);
    }

    return inkWell;
  }
}
