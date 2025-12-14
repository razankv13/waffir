import 'package:flutter/material.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

/// Gradient overlay CTA used on scrolling screens to prompt unauthenticated users to log in.
///
/// Based on Figma node `34:7097` (393×215, bottom-aligned button with 30px radius).
/// Dimensions, padding, and radius are scaled via [ResponsiveHelper] to stay responsive.
class BottomLoginOverlay extends StatelessWidget {
  const BottomLoginOverlay({
    super.key,
    this.buttonText = 'Login to view full deal details',
    this.onPressed,
    this.buttonVariant = ButtonVariant.primary,
    this.buttonSize = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.height,
    this.bottomOffset,
    this.gradient,
    this.borderRadius,
    this.buttonPadding,
  });

  /// Button label. Defaults to the Figma text.
  final String buttonText;

  /// Callback when CTA is pressed. Defaults to navigating to the login route.
  final VoidCallback? onPressed;

  /// Visual style of the CTA button (primary/secondary/etc).
  final ButtonVariant buttonVariant;

  /// Size of the CTA button (matches AppButton sizes).
  final ButtonSize buttonSize;

  /// Optional leading icon for the CTA button.
  final Widget? icon;

  /// Whether to show a loading indicator on the CTA button.
  final bool isLoading;

  /// Enables/disables the CTA button and tap handling.
  final bool enabled;

  /// Override for the overlay height (scaled if provided).
  final double? height;

  /// Override for the distance from the bottom of the stack (scaled if provided).
  final double? bottomOffset;

  /// Custom gradient override. Defaults to a transparent→surface gradient.
  final LinearGradient? gradient;

  /// Custom border radius override for the button (scaled if provided).
  final BorderRadius? borderRadius;

  /// Custom padding override for the button (scaled if provided).
  final EdgeInsets? buttonPadding;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    final overlayHeight = height != null ? responsive.scale(height!) : responsive.scale(215);
    final contentPadding = responsive.scalePadding(const EdgeInsets.all(16));
    final effectiveButtonPadding = buttonPadding != null
        ? responsive.scalePadding(buttonPadding!)
        : responsive.scalePadding(const EdgeInsets.symmetric(vertical: 14));
    final effectiveBorderRadius = responsive.scaleBorderRadius(
      borderRadius ?? BorderRadius.circular(30),
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: overlayHeight,
        decoration: BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colorScheme.surface.withValues(alpha: 0.0), colorScheme.surface],
                stops: const [0.0, 1.0],
              ),
        ),
        child: Padding(
          padding: contentPadding,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AppButton(
              text: buttonText,
              onPressed: enabled ? onPressed ?? () => context.pushNamed(AppRoutes.login) : null,
              variant: buttonVariant,
              size: buttonSize,
              icon: icon,
              isLoading: isLoading,
              enabled: enabled,
              width: double.infinity,
              padding: effectiveButtonPadding,
              borderRadius: effectiveBorderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
