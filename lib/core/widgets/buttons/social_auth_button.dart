import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Social authentication provider types
enum SocialAuthProvider {
  google,
  apple,
}

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

class _SocialAuthButtonState extends State<SocialAuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
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

  IconData get _icon {
    switch (widget.provider) {
      case SocialAuthProvider.google:
        return Icons.g_mobiledata; // Using Material icon as placeholder
      case SocialAuthProvider.apple:
        return Icons.apple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                _icon,
                size: 24,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 11),
              // Label
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
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
