import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/gen/assets.gen.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.onChangeNumber,
  });

  final String phoneNumber;
  final String verificationId;
  final VoidCallback? onChangeNumber;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  String get _otpCode => _pinController.text;
  bool get _isOtpComplete => _otpCode.length == 6;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendCountdown = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;

    setState(() => _isLoading = true);

    try {
      //   final authController = ref.read(authControllerProvider.notifier);

      //   await authController.verifyPhoneWithCode(
      //     verificationId: widget.verificationId,
      //     smsCode: _otpCode,
      //   );

      if (mounted) {
        context.go(AppRoutes.accountDetails);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0 || _isResending) return;

    setState(() => _isResending = true);

    try {
      context.showInfoSnackBar(message: 'auth.codeSentSuccess'.tr());

      if (mounted) {
        _startResendCountdown();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _onChangeNumber() {
    if (widget.onChangeNumber != null) {
      widget.onChangeNumber!();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isRTL = context.locale.languageCode == 'ar';
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    // Pinput theme matching Figma design
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: colorScheme.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: colorScheme.primary, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: colorScheme.error, width: 2),
      ),
    );

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Stack(
            children: [
              // Background shape image (matching Figma design)
              Positioned(
                left: isRTL ? null : -40,
                right: isRTL ? -40 : null,
                top: -100,
                child: Transform(
                  alignment: Alignment.center,
                  transform: isRTL ? Matrix4.identity().scaled(-1.0, 1.0) : Matrix4.identity(),
                  child: Image.asset(
                    Assets.images.onboardingShape.path,
                    width: 467.78,
                    height: 461.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Back button (top-right for RTL, top-left for LTR)
              Positioned(
                top: 16,
                right: isRTL ? 16 : null,
                left: isRTL ? null : 16,
                child: const AppBackButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  showBackground: true,
                ),
              ),

              // Main content
              Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: isSmallScreen ? 60 : 120,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeader(textTheme, colorScheme),
                          SizedBox(height: isSmallScreen ? AppSpacing.xl : AppSpacing.xl3),
                          _buildOtpInput(
                            defaultPinTheme,
                            focusedPinTheme,
                            submittedPinTheme,
                            errorPinTheme,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _buildActionLinks(textTheme, colorScheme),
                        ],
                      ),
                    ),
                    _buildVerifyButton(colorScheme, textTheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          'auth.otpTitle'.tr(),
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
            height: 1.15,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'auth.otpSubtitle'.tr(namedArgs: {'contact': widget.phoneNumber}),
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: 0.1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpInput(
    PinTheme defaultPinTheme,
    PinTheme focusedPinTheme,
    PinTheme submittedPinTheme,
    PinTheme errorPinTheme,
  ) {
    return Center(
      child: Pinput(
        controller: _pinController,
        focusNode: _focusNode,
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        pinAnimationType: PinAnimationType.scale,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        enabled: !_isLoading,
        autofocus: true,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        closeKeyboardWhenCompleted: false,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        onCompleted: (pin) {
          HapticFeedback.mediumImpact();
          _verifyOtp();
        },
        onChanged: (pin) {
          if (pin.isNotEmpty) {
            HapticFeedback.lightImpact();
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildActionLinks(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _resendCountdown > 0 || _isResending ? null : _resendCode,
          child: _isResending
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                )
              : Text(
                  _resendCountdown > 0
                      ? 'auth.resendCodeIn'.tr(namedArgs: {'seconds': _resendCountdown.toString()})
                      : 'auth.resendCode'.tr(),
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: _resendCountdown > 0
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
        TextButton(
          onPressed: _onChangeNumber,
          child: Text(
            'auth.changeNumber'.tr(),
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(ColorScheme colorScheme, TextTheme textTheme) {
    final isEnabled = !_isLoading && _isOtpComplete;

    return AppButton.primary(
      text: 'auth.verify'.tr(),
      onPressed: isEnabled ? _verifyOtp : null,
      isLoading: _isLoading,
      enabled: isEnabled,
      width: 330,
    );
  }
}
