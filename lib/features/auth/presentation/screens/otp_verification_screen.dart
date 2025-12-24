import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';

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
  static const int _otpLength = 6;
  static const int _resendCountdownSeconds = 180;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  String get _otpCode => _pinController.text;
  bool get _isOtpComplete => _otpCode.length == _otpLength;

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
    _resendCountdown = _resendCountdownSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  String _formatCountdown(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;
    if (widget.verificationId.trim().isEmpty) {
      context.showErrorSnackBar(message: LocaleKeys.auth.verificationIdMissing.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.verifyPhoneWithCode(
        verificationId: widget.verificationId,
        smsCode: _otpCode,
      );

      if (!mounted) return;

      final authValue = ref.read(authControllerProvider);
      authValue.when(
        data: (state) {
          if (state.isAuthenticated) {
            context.go(AppRoutes.home);
          } else {
            context.showErrorSnackBar(message: LocaleKeys.auth.otpVerificationFailed.tr());
          }
        },
        loading: () {},
        error: (error, _) => context.showErrorSnackBar(message: error.toString()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0 || _isResending) return;

    setState(() => _isResending = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        codeSent: (_) {
          if (mounted) context.showInfoSnackBar(message: LocaleKeys.auth.codeSentSuccess.tr());
        },
        verificationFailed: (error) {
          if (mounted) context.showErrorSnackBar(message: error);
        },
        codeAutoRetrievalTimeout: () {
          if (mounted) context.showInfoSnackBar(message: LocaleKeys.auth.codeTimeout.tr());
        },
      );

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
    final responsive = context.responsive;
    final isSmallScreen = responsive.screenHeight < 700;

    final horizontalPadding = responsive.scaleWithRange(16, min: 16, max: 32);
    final bottomPadding = responsive.scaleWithRange(isSmallScreen ? 60 : 120, min: 40, max: 160);
    final contentWidth = responsive.scaleWithMax(309, max: 420);
    final buttonWidth = responsive.scaleWithMax(330, max: 420);
    final pinBoxSize = responsive.scaleWithRange(50, min: 44, max: 60);
    final pinRadius = responsive.scaleWithRange(16, min: 12, max: 20);

    // Pinput theme matching Figma design
    final defaultPinTheme = PinTheme(
      width: pinBoxSize,
      height: pinBoxSize,
      textStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(pinRadius),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: colorScheme.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: responsive.scale(12),
            offset: Offset(0, responsive.scale(4)),
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
        body: Stack(
          children: [
            // Background shape image (matching Figma design)
            const BlurredBackground(),
            // Back button (RTL-aware)
            WaffirBackButton(size: responsive.scale(44)),
            // Main content
            Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: bottomPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: contentWidth),
                          child: _buildHeader(textTheme, colorScheme, responsive),
                        ),
                        SizedBox(
                          height: responsive.scaleWithRange(
                            isSmallScreen ? 24 : 32,
                            min: 16,
                            max: 40,
                          ),
                        ),
                        _buildOtpInput(
                          defaultPinTheme,
                          focusedPinTheme,
                          submittedPinTheme,
                          errorPinTheme,
                        ),
                        SizedBox(height: responsive.scaleWithRange(32, min: 20, max: 40)),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: contentWidth),
                          child: _buildActionLinks(textTheme, colorScheme, responsive),
                        ),
                      ],
                    ),
                  ),
                  _buildVerifyButton(buttonWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme, ResponsiveHelper responsive) {
    return Column(
      children: [
        Text(
          LocaleKeys.auth.otpTitle.tr(),
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: responsive.scaleFontSize(20, minSize: 18),
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
            height: 1.15,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.scaleWithRange(16, min: 12, max: 20)),
        Text(
          LocaleKeys.auth.otpSubtitle.tr(namedArgs: {'contact': widget.phoneNumber}),
          style: textTheme.bodyLarge?.copyWith(
            fontSize: responsive.scaleFontSize(16, minSize: 14),
            color: colorScheme.onSurfaceVariant,
            height: 1.2,
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
        length: _otpLength,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        enabled: !_isLoading,
        autofocus: true,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
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

  Widget _buildActionLinks(
    TextTheme textTheme,
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
  ) {
    final isResendEnabled = _resendCountdown <= 0 && !_isResending;
    final resendTextStyle = textTheme.bodyMedium?.copyWith(
      fontSize: responsive.scaleFontSize(14, minSize: 12),
      color: isResendEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w400,
    );

    final changeNumberTextStyle = textTheme.bodyMedium?.copyWith(
      fontSize: responsive.scaleFontSize(14, minSize: 12),
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w700,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _onChangeNumber,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(LocaleKeys.auth.changeNumber.tr(), style: changeNumberTextStyle),
        ),
        TextButton(
          onPressed: isResendEnabled ? _resendCode : null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: _isResending
              ? SizedBox(
                  height: responsive.scaleWithRange(16, min: 14, max: 20),
                  width: responsive.scaleWithRange(16, min: 14, max: 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                )
              : Text(
                  _resendCountdown > 0
                      ? LocaleKeys.auth.resendCodeIn.tr(
                          namedArgs: {'time': _formatCountdown(_resendCountdown)},
                        )
                      : LocaleKeys.auth.resendCode.tr(),
                  style: resendTextStyle,
                ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(double width) {
    final isEnabled = !_isLoading && _isOtpComplete;

    return AppButton.primary(
      text: LocaleKeys.auth.verify.tr(),
      onPressed: isEnabled ? _verifyOtp : null,
      isLoading: _isLoading,
      enabled: isEnabled,
      width: width,
    );
  }
}
