import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Social authentication provider types
enum SocialAuthProvider { google, apple }

/// Social authentication button
///
/// Features:
/// - Google and Apple sign-in buttons
/// - Icon + text layout
/// - Consistent styling with Figma design
/// - 56px height, 30px border radius
/// - Scale animation on press
/// - Haptic feedback
///
/// Example usage:
/// ```dart
/// SocialAuthButton(
///   provider: SocialAuthProvider.google,
///   label: 'تابع باستخدام Google',
///   onTap: () => _signInWithGoogle(),
/// )
/// ```
class SocialAuthButton extends StatefulWidget {
  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.label,
    required this.onTap,
  });

  final SocialAuthProvider provider;
  final String label;
  final VoidCallback onTap;

  @override
  State<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends State<SocialAuthButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    widget.onTap();
  }

  String get _iconPath {
    switch (widget.provider) {
      case SocialAuthProvider.google:
        return Assets.icons.googleIcon.path;
      case SocialAuthProvider.apple:
        return Assets.icons.appleIcon.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    double s(double value) => responsive.scaleWithMax(value, max: value); // downscale-only
    double sf(double value, {double min = 10.0}) => responsive.scaleWithRange(value, min: min, max: value); // downscale-only

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: s(48),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest, // #F2F2F2 (Figma)
            borderRadius: BorderRadius.circular(s(30)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: isRtl
                ? [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: sf(14, min: 12),
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: colorScheme.onSurface,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(width: s(11)),
                    SvgPicture.asset(_iconPath, width: s(23.64), height: s(23.64)),
                  ]
                : [
                    SvgPicture.asset(_iconPath, width: s(23.64), height: s(23.64)),
                    SizedBox(width: s(11)),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: sf(14, min: 12),
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: colorScheme.onSurface,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
