import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/themes/phone_login/app_colors.dart';
import 'package:waffir/core/themes/phone_login/app_text_styles.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
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

    final phoneNumber = '$_selectedDialCode${_phoneController.text.trim()}';
    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          unawaited(
            GoRouterHelper(context).push(
              AppRoutes.otpVerification,
              extra: {'phoneNumber': phoneNumber, 'verificationId': verificationId},
            ),
          );
        },
        verificationFailed: (error) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          context.showErrorSnackBar(message: error);
        },
        codeAutoRetrievalTimeout: () {
          if (!mounted) return;
          setState(() => _isLoading = false);
          context.showInfoSnackBar(message: LocaleKeys.errors.timeoutError.tr());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Phone verification failed: ${e.toString()}',
        error: e,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showErrorSnackBar(message: e.toString());
    }
  }

  void _onCountryChanged(CountryCode countryCode) {
    setState(() {
      _selectedDialCode = countryCode.dialCode ?? _selectedDialCode;
    });
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final authController = ref.read(authControllerProvider.notifier);
    await authController.signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);

    final authValue = ref.read(authControllerProvider);
    authValue.when(
      data: (state) {
        if (state.isAuthenticated) {
          context.go(AppRoutes.splash);
        } else {
          context.showErrorSnackBar(message: LocaleKeys.auth.googleSignInFailed.tr());
        }
      },
      loading: () {},
      error: (error, _) => context.showErrorSnackBar(message: error.toString()),
    );
  }

  Future<void> _signInWithApple() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final authController = ref.read(authControllerProvider.notifier);
    await authController.signInWithApple();
    if (!mounted) return;
    setState(() => _isLoading = false);

    final authValue = ref.read(authControllerProvider);
    authValue.when(
      data: (state) {
        if (state.isAuthenticated) {
          context.go(AppRoutes.splash);
        } else {
          context.showErrorSnackBar(message: LocaleKeys.auth.appleSignInFailed.tr());
        }
      },
      loading: () {},
      error: (error, _) => context.showErrorSnackBar(message: error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              const BlurredBackground(),
              LayoutBuilder(
                builder: (context, constraints) {
                  final responsive = context.responsive;

                  double s(double value) =>
                      responsive.scaleWithMax(value, max: value); // downscale-only
                  double sf(double value, {double min = 10.0}) =>
                      responsive.scaleWithRange(value, min: min, max: value); // downscale-only

                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          // Back button top right
                          WaffirBackButton(size: responsive.scale(44)),

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
                                              LocaleKeys.auth.welcomeToWaffir.tr(),
                                              style: PhoneLoginTextStyles.title.copyWith(
                                                fontSize: sf(20, min: 14),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: s(16)),
                                            Text(
                                              LocaleKeys.auth.loginSubtitle.tr(),
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
                                          hintText: LocaleKeys.auth.phoneHint.tr(),
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
                                          LocaleKeys.auth.or.tr(),
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
                                          label: LocaleKeys.auth.continueWithGoogle.tr(),
                                          onTap: _signInWithGoogle,
                                        ),
                                      ),
                                      SizedBox(height: s(24)),
                                      SizedBox(
                                        width: s(361),
                                        child: SocialAuthButton(
                                          provider: SocialAuthProvider.apple,
                                          label: LocaleKeys.auth.continueWithApple.tr(),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
