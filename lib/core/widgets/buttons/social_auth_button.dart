import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/app_colors.dart';
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.gray01,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon from Figma assets - 23.64x23.64px
              SvgPicture.asset(_iconPath, width: 23.64, height: 23.64),
              const SizedBox(width: 11),
              // Label - Parkinsans 14px weight 600
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
