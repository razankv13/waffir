import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
import 'package:waffir/core/widgets/buttons/social_auth_button.dart';
import 'package:waffir/core/widgets/inputs/phone_input_widget.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
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

    // Responsive sizing


    return Scaffold(
      body: Stack(
        children: [
          // Blurred background matching Figma design
          const Positioned.fill(child: BlurredBackground()),

          // Back button (top right per Figma) with white circular background
          Positioned(
            top: 64,
            right: 16,
            child: AppBackButton(onPressed: () => GoRouterHelper(context).pop()),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 500.0 : double.infinity),
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 80 : 60),

                      // Hero section: Waffir icon - 177x175px per Figma
                      Image.asset(
                        Assets.images.waffirIconLogin.path,
                        width: 177,
                        height: 175,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: isTablet ? 42 : 40),

                      // Title - Parkinsans 20px bold (all bold, no mixed weights)
                      const Text(
                        'مرحباً بكم في وفــــر',
                        style: TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Subtitle - Parkinsans 16px regular
                      const Text(
                        'سجّل الدخول أو أنشئ حساباً للمتابعة',
                        style: TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Phone input with validation - 361px width per Figma
                      SizedBox(
                        width: 361,
                        child: PhoneInputWidget(
                          controller: _phoneController,
                          hintText: 'Phone Number', // Match Figma placeholder
                          isLoading: _isLoading,
                          isValid: _isPhoneValid,
                          onSubmit: _submitPhone,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // "or" divider - Parkinsans 14px weight 500
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: colorScheme.surface)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'أو',
                              style: TextStyle(
                                fontFamily: 'Parkinsans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ),
                          Expanded(child: Container(height: 1, color: colorScheme.surface)),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Social auth buttons - 361px width per Figma
                      SizedBox(
                        width: 361,
                        child: SocialAuthButton(
                          provider: SocialAuthProvider.google,
                          label: 'تابع باستخدام Google',
                          onTap: _signInWithGoogle,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: 361,
                        child: SocialAuthButton(
                          provider: SocialAuthProvider.apple,
                          label: 'تابع باستخدام Apple',
                          onTap: _signInWithApple,
                        ),
                      ),

                      SizedBox(height: isTablet ? 120 : 120),
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
