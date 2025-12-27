import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Email and password input widget with submit button
///
/// Features:
/// - Email input field with validation
/// - Password input field with visibility toggle
/// - Optional confirm password field for sign-up mode
/// - Submit button (circular arrow) with animations
/// - Loading state with spinner
/// - Disabled state when input invalid
/// - Haptic feedback on interactions
/// - Scale animation on button press
/// - RTL support
///
/// Example usage:
/// ```dart
/// EmailInputWidget(
///   emailController: _emailController,
///   passwordController: _passwordController,
///   isLoading: false,
///   isValid: true,
///   onSubmit: () => _handleSubmit(),
///   emailHint: 'Enter your email',
///   passwordHint: 'Enter your password',
/// )
/// ```
class EmailInputWidget extends StatefulWidget {
  const EmailInputWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
    this.emailHint = 'Email',
    this.passwordHint = 'Password',
    this.confirmPasswordHint = 'Confirm password',
    this.isLoading = false,
    this.isValid = true,
    this.showConfirmPassword = false,
    this.onSubmit,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onConfirmPasswordChanged,
    this.submitButtonLabel,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final String emailHint;
  final String passwordHint;
  final String confirmPasswordHint;
  final bool isLoading;
  final bool isValid;
  final bool showConfirmPassword;
  final VoidCallback? onSubmit;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<String>? onConfirmPasswordChanged;
  final String? submitButtonLabel;

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleSubmitTap() {
    if (!widget.isValid || widget.isLoading) return;

    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    widget.onSubmit?.call();
  }

  void _togglePasswordVisibility() {
    HapticFeedback.selectionClick();
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    HapticFeedback.selectionClick();
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.rs;

    double s(double value) => responsive.s(value); // downscale-only
    double sf(double value, {double min = 10.0}) =>
        responsive.sConstrained(value, min: min, max: value); // downscale-only

    return Column(
      children: [
        // Email input field
        _buildInputField(
          controller: widget.emailController,
          hintText: widget.emailHint,
          keyboardType: TextInputType.emailAddress,
          onChanged: widget.onEmailChanged,
          prefixIcon: Icons.email_outlined,
          s: s,
          sf: sf,
          colorScheme: colorScheme,
        ),

        SizedBox(height: s(16)),

        // Password input field
        _buildInputField(
          controller: widget.passwordController,
          hintText: widget.passwordHint,
          keyboardType: TextInputType.visiblePassword,
          onChanged: widget.onPasswordChanged,
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          onToggleVisibility: _togglePasswordVisibility,
          s: s,
          sf: sf,
          colorScheme: colorScheme,
        ),

        // Confirm password field (only shown in sign-up mode)
        if (widget.showConfirmPassword && widget.confirmPasswordController != null) ...[
          SizedBox(height: s(16)),
          _buildInputField(
            controller: widget.confirmPasswordController!,
            hintText: widget.confirmPasswordHint,
            keyboardType: TextInputType.visiblePassword,
            onChanged: widget.onConfirmPasswordChanged,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: _toggleConfirmPasswordVisibility,
            s: s,
            sf: sf,
            colorScheme: colorScheme,
          ),
        ],

        SizedBox(height: s(24)),

        // Submit button
        ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: _handleSubmitTap,
            child: Container(
              width: double.infinity,
              height: s(56),
              decoration: BoxDecoration(
                color: widget.isValid && !widget.isLoading
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(s(16)),
              ),
              alignment: Alignment.center,
              child: widget.isLoading
                  ? SizedBox(
                      width: s(24),
                      height: s(24),
                      child: CircularProgressIndicator(
                        strokeWidth: s(2.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isValid ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.submitButtonLabel != null)
                          Text(
                            widget.submitButtonLabel!,
                            style: TextStyle(
                              fontFamily: 'Parkinsans',
                              fontSize: sf(16, min: 14),
                              fontWeight: FontWeight.w600,
                              color: widget.isValid ? Colors.white : colorScheme.onSurfaceVariant,
                            ),
                          )
                        else
                          SvgPicture.asset(
                            Assets.icons.arrowIcon.path,
                            width: s(24),
                            height: s(24),
                            colorFilter: ColorFilter.mode(
                              widget.isValid ? Colors.white : colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    required double Function(double) s,
    required double Function(double, {double min}) sf,
    required ColorScheme colorScheme,
    ValueChanged<String>? onChanged,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      height: s(56),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(s(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: s(16)),
      child: Row(
        children: [
          Icon(prefixIcon, size: s(22), color: colorScheme.onSurfaceVariant),
          SizedBox(width: s(12)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              enabled: !widget.isLoading,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: sf(14, min: 12),
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: sf(14, min: 12),
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: const Color(0xFFA3A3A3),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          // Visibility toggle for password fields
          if (onToggleVisibility != null)
            GestureDetector(
              onTap: onToggleVisibility,
              child: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: s(22),
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
