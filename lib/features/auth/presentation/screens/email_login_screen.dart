import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Email login screen with premium design
///
/// Features:
/// - Blurred background design
/// - Email/password authentication
/// - Toggle between Sign In and Create Account modes
/// - Forgot password functionality
/// - Social authentication (Google, Apple)
/// - Fully responsive design
/// - RTL support for Arabic
class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isSignUpMode = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = true;

  // Email regex pattern
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static const _minPasswordLength = 6;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _confirmPasswordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isEmailValid = _emailRegex.hasMatch(_emailController.text.trim());
      _isPasswordValid = _passwordController.text.length >= _minPasswordLength;

      if (_isSignUpMode) {
        _isConfirmPasswordValid = _confirmPasswordController.text == _passwordController.text &&
            _confirmPasswordController.text.isNotEmpty;
      } else {
        _isConfirmPasswordValid = true;
      }
    });
  }

  bool get _isFormValid {
    if (_isSignUpMode) {
      return _isEmailValid && _isPasswordValid && _isConfirmPasswordValid;
    }
    return _isEmailValid && _isPasswordValid;
  }

  void _toggleMode() {
    HapticFeedback.selectionClick();
    setState(() {
      _isSignUpMode = !_isSignUpMode;
      _confirmPasswordController.clear();
      _validateForm();
    });
  }

  Future<void> _submitForm() async {
    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isSignUpMode) {
        await authController.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await authController.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      final authValue = ref.read(authControllerProvider);
      authValue.when(
        data: (state) {
          if (state.isAuthenticated) {
            context.go(AppRoutes.splash);
          } else if (state.requiresEmailVerification) {
            context.showSuccessSnackBar(
              message: LocaleKeys.auth.emailVerificationSent.tr(),
            );
          } else {
            context.showErrorSnackBar(
              message: _isSignUpMode
                  ? LocaleKeys.auth.registrationSuccessful.tr()
                  : LocaleKeys.auth.loginSuccessful.tr(),
            );
          }
        },
        loading: () {},
        error: (error, _) {
          AppLogger.error('Auth failed: $error');
          context.showErrorSnackBar(message: error.toString());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Auth failed: ${e.toString()}',
        error: e,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showErrorSnackBar(message: e.toString());
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (!_isEmailValid) {
      context.showErrorSnackBar(
        message: LocaleKeys.validation.invalidEmail.tr(),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      setState(() => _isLoading = false);

      context.showSuccessSnackBar(
        message: LocaleKeys.auth.resetPasswordEmailSent.tr(),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showErrorSnackBar(message: e.toString());
    }
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
      error: (error, _) {
        AppLogger.error('Google sign in failed: ${error.toString()}');
        context.showErrorSnackBar(message: error.toString());
      },
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
      error: (error, _) {
        AppLogger.error('Apple sign in failed: ${error.toString()}');
        context.showErrorSnackBar(message: error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    double s(double value) =>
        responsive.s(value); // downscale-only
    double sf(double value, {double min = 10.0}) =>
        responsive.sConstrained(value, min: min, max: value); // downscale-only

    return Scaffold(
      body: Stack(
        children: [
          const BlurredBackground(),
          // Scrollable content
          SafeArea(
            top: false,
            bottom: false,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    // Spacer for back button area
                    SizedBox(height: responsive.topSafeArea + s(44) + s(16)),

                    // Waffir icon (node `50:3060`): 177x175.
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

                    // Bottom container
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: s(16)),
                      child: Column(
                        children: [
                          // Title/subtitle
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

                          SizedBox(height: s(24)),

                          // Mode toggle (Sign In / Create Account)
                          _buildModeToggle(s, sf),

                          SizedBox(height: s(24)),

                          // Email/Password input fields
                          SizedBox(
                            width: s(361),
                            child: _buildEmailPasswordFields(s, sf),
                          ),

                          // Forgot password link (only in sign-in mode)
                          if (!_isSignUpMode) ...[
                            SizedBox(height: s(12)),
                            SizedBox(
                              width: s(361),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: GestureDetector(
                                  onTap: _forgotPassword,
                                  child: Text(
                                    '${LocaleKeys.auth.forgotPassword.tr()}?',
                                    style: TextStyle(
                                      fontFamily: 'Parkinsans',
                                      fontSize: sf(14, min: 12),
                                      fontWeight: FontWeight.w500,
                                      color: PhoneLoginColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: s(32)),

                          // Divider
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

                          SizedBox(height: s(32)),

                          // Social buttons
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

                          // Toggle prompt
                          SizedBox(height: s(24)),
                          _buildTogglePrompt(sf),
                        ],
                      ),
                    ),

                    // Root bottom padding
                    SizedBox(height: s(60)),
                  ],
                ),
              ),
            ),
          ),
          // Fixed back button
          Positioned(
            top: responsive.topSafeArea + s(8),
            left: s(16),
            child: WaffirBackButton(
              size: s(44),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle(double Function(double) s, double Function(double, {double min}) sf) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: s(361),
      height: s(48),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(s(12)),
      ),
      padding: EdgeInsets.all(s(4)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isSignUpMode ? _toggleMode : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !_isSignUpMode ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(s(8)),
                ),
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.auth.login.tr(),
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: sf(14, min: 12),
                    fontWeight: FontWeight.w600,
                    color: !_isSignUpMode ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !_isSignUpMode ? _toggleMode : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isSignUpMode ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(s(8)),
                ),
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.auth.register.tr(),
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: sf(14, min: 12),
                    fontWeight: FontWeight.w600,
                    color: _isSignUpMode ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPasswordFields(double Function(double) s, double Function(double, {double min}) sf) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Email field
        _buildTextField(
          controller: _emailController,
          hintText: LocaleKeys.auth.email.tr(),
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          s: s,
          sf: sf,
          colorScheme: colorScheme,
        ),

        SizedBox(height: s(16)),

        // Password field
        _buildTextField(
          controller: _passwordController,
          hintText: LocaleKeys.auth.password.tr(),
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          s: s,
          sf: sf,
          colorScheme: colorScheme,
        ),

        // Confirm password field (only in sign-up mode)
        if (_isSignUpMode) ...[
          SizedBox(height: s(16)),
          _buildTextField(
            controller: _confirmPasswordController,
            hintText: LocaleKeys.auth.confirmPassword.tr(),
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            isConfirmPassword: true,
            s: s,
            sf: sf,
            colorScheme: colorScheme,
          ),
        ],

        SizedBox(height: s(24)),

        // Submit button
        _buildSubmitButton(s, sf, colorScheme),
      ],
    );
  }

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    required double Function(double) s,
    required double Function(double, {double min}) sf,
    required ColorScheme colorScheme,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    final obscure = isConfirmPassword ? _obscureConfirmPassword : _obscurePassword;

    return Container(
      height: s(56),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(s(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: s(16)),
      child: Row(
        children: [
          Icon(
            prefixIcon,
            size: s(22),
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: s(12)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword ? obscure : false,
              enabled: !_isLoading,
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
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isConfirmPassword) {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  } else {
                    _obscurePassword = !_obscurePassword;
                  }
                });
              },
              child: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: s(22),
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    double Function(double) s,
    double Function(double, {double min}) sf,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: _submitForm,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: s(56),
        decoration: BoxDecoration(
          color: _isFormValid && !_isLoading
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(s(16)),
        ),
        alignment: Alignment.center,
        child: _isLoading
            ? SizedBox(
                width: s(24),
                height: s(24),
                child: CircularProgressIndicator(
                  strokeWidth: s(2.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isFormValid ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : Text(
                _isSignUpMode
                    ? LocaleKeys.auth.register.tr()
                    : LocaleKeys.auth.login.tr(),
                style: TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: sf(16, min: 14),
                  fontWeight: FontWeight.w600,
                  color: _isFormValid ? Colors.white : colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildTogglePrompt(double Function(double, {double min}) sf) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUpMode
              ? LocaleKeys.auth.alreadyHaveAccount.tr()
              : LocaleKeys.auth.dontHaveAccount.tr(),
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: sf(14, min: 12),
            fontWeight: FontWeight.w400,
            color: PhoneLoginColors.textPrimary,
          ),
        ),
        SizedBox(width: sf(8, min: 4)),
        GestureDetector(
          onTap: _toggleMode,
          child: Text(
            _isSignUpMode
                ? LocaleKeys.auth.login.tr()
                : LocaleKeys.auth.register.tr(),
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: sf(14, min: 12),
              fontWeight: FontWeight.w600,
              color: PhoneLoginColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
