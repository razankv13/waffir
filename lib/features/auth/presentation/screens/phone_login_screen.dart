import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/themes/phone_login/app_colors.dart';
import 'package:waffir/core/themes/phone_login/app_text_styles.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/social_auth_button.dart';
import 'package:waffir/core/widgets/inputs/phone_input_widget.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
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
  String _selectedDialCode = '+966';

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
      final phoneNumber = '$_selectedDialCode${_phoneController.text.trim()}';
      unawaited(
        GoRouterHelper(
          context,
        ).push(AppRoutes.otpVerification, extra: {'phoneNumber': phoneNumber}),
      );
    }
  }

  void _onCountryChanged(CountryCode countryCode) {
    setState(() {
      _selectedDialCode = countryCode.dialCode ?? _selectedDialCode;
    });
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
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const Positioned.fill(child: BlurredBackground()),
            LayoutBuilder(
              builder: (context, constraints) {
                final responsive = context.responsive;

                double s(double value) =>
                    responsive.scaleWithMax(value, max: value); // downscale-only
                double sf(double value, {double min = 10.0}) =>
                    responsive.scaleWithRange(value, min: min, max: value); // downscale-only

                final contentWidth = s(ResponsiveHelper.figmaWidth);

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          children: [
                            // Back container (node `50:5556`): 393×108 with padding top=64 right=16.
                            Align(
                              alignment: Alignment.topLeft,
                              child: WaffirBackButton(size: responsive.scale(44)),
                            ),
                            // Waffir icon (node `50:3060`): 177×175.
                            SizedBox(
                              height: s(175),
                              child: Center(
                                child: Image.asset(
                                  Assets.images.waffirIconLogin.path,
                                  width: s(177),
                                  height: s(175),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Bottom container (node `50:3061`): height=449, padding horizontal=16, gap=40.
                            SizedBox(
                              height: s(449),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: s(16)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Top group (node `50:3062`): gap=32.
                                    Column(
                                      children: [
                                        // Title/subtitle group (node `50:3063`): gap=16.
                                        SizedBox(
                                          width: s(361),
                                          child: Column(
                                            children: [
                                              Text(
                                                'مرحباً بكم في وفــــر',
                                                style: PhoneLoginTextStyles.title.copyWith(
                                                  fontSize: sf(20, min: 14),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: s(16)),
                                              Text(
                                                'سجّل الدخول أو أنشئ حساباً للمتابعة',
                                                style: PhoneLoginTextStyles.subtitle.copyWith(
                                                  fontSize: sf(16, min: 12),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: s(32)),

                                        // Phone input (node `50:3067`): width=361.
                                        SizedBox(
                                          width: s(361),
                                          child: PhoneInputWidget(
                                            controller: _phoneController,
                                            countryCode: _selectedDialCode,
                                            hintText: 'Phone Number',
                                            isLoading: _isLoading,
                                            isValid: _isPhoneValid,
                                            onSubmit: _submitPhone,
                                            onCountryChanged: _onCountryChanged,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: s(40)),

                                    // Divider (node `50:3068`): gap=16, line color #F2F2F2.
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: s(1),
                                            color: PhoneLoginColors.surface,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: s(16)),
                                          child: Text(
                                            'أو',
                                            style: PhoneLoginTextStyles.divider.copyWith(
                                              fontSize: sf(14, min: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: s(1),
                                            color: PhoneLoginColors.surface,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: s(40)),

                                    // Social buttons (node `50:3072`): gap=24; each button 361×48.
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: s(361),
                                          child: SocialAuthButton(
                                            provider: SocialAuthProvider.google,
                                            label: 'تابع باستخدام Google',
                                            onTap: _signInWithGoogle,
                                          ),
                                        ),
                                        SizedBox(height: s(24)),
                                        SizedBox(
                                          width: s(361),
                                          child: SocialAuthButton(
                                            provider: SocialAuthProvider.apple,
                                            label: 'تابع باستخدام Apple',
                                            onTap: _signInWithApple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Root bottom padding (node `50:3051`): 120.
                            SizedBox(height: s(120)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
