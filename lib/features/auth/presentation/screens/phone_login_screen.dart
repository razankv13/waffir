import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/social_auth_button.dart';
import 'package:waffir/core/widgets/inputs/phone_input_widget.dart';
import 'package:waffir/features/auth/presentation/widgets/radial_starburst_background.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Phone login screen with premium design
///
/// Features:
/// - Animated radial starburst background
/// - Custom key and sun/star icon graphics
/// - Phone number input with validation
/// - Enhanced button interactions (haptic, animations)
/// - Social authentication (Google, Apple)
/// - Fully responsive design
/// - RTL support for Arabic
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhone);
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    setState(() {
      // Simple validation: Must be at least 9 digits (Saudi phone numbers)
      _isPhoneValid = _phoneController.text.trim().length >= 9;
    });
  }

  Future<void> _submitPhone() async {
    if (!_isPhoneValid || _isLoading) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to OTP screen
      unawaited(
        GoRouterHelper(
          context,
        ).push(AppRoutes.otpVerification, extra: {'phoneNumber': _phoneController.text}),
      );
    }
  }

  void _signInWithGoogle() {
    // Mock Google sign-in
    // Navigate to account details after successful auth
    context.go(AppRoutes.accountDetails);
  }

  void _signInWithApple() {
    // Mock Apple sign-in
    // Navigate to account details after successful auth
    context.go(AppRoutes.accountDetails);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 900;

    // Responsive sizing
    final horizontalPadding = isDesktop ? 48.0 : (isTablet ? 40.0 : 24.0);
    final maxContentWidth = isTablet ? 500.0 : double.infinity;

    return Scaffold(
      body: Stack(
        children: [
          // Animated radial starburst background
          const Positioned.fill(child: RadialStarburstBackground()),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 80 : 60),

                      // Hero section: Key icon with sun/star
                      Image.asset(
                        Assets.icons.appIconNoBg.path,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        color: context.colorScheme.onPrimaryContainer,
                      ),

                      SizedBox(height: isTablet ? 50 : 40),

                      // Title
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'مرحباً بكم في ',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: isTablet ? 28 : 25.4,
                                fontWeight: FontWeight.normal,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'وفــــر',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: isTablet ? 28 : 25.4,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isTablet ? 42 : 38),

                      // Subtitle
                      Text(
                        'سجّل الدخول أو أنشئ حساباً للمتابعة',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          fontSize: isTablet ? 16 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isTablet ? 52 : 47),

                      // Phone input with validation
                      PhoneInputWidget(
                        controller: _phoneController,
                        isLoading: _isLoading,
                        isValid: _isPhoneValid,
                        onSubmit: _submitPhone,
                      ),

                      SizedBox(height: isTablet ? 40 : 36),

                      // "or" divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'أو',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 40 : 36),

                      // Social auth buttons
                      SocialAuthButton(
                        provider: SocialAuthProvider.google,
                        label: 'تابع باستخدام Google',
                        onTap: _signInWithGoogle,
                      ),

                      const SizedBox(height: 25),

                      SocialAuthButton(
                        provider: SocialAuthProvider.apple,
                        label: 'تابع باستخدام Apple',
                        onTap: _signInWithApple,
                      ),

                      SizedBox(height: isTablet ? 60 : 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
