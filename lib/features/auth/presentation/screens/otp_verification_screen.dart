import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
import 'package:waffir/core/widgets/widgets.dart';

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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  String get _otpCode => _controllers.map((controller) => controller.text).join();
  bool get _isOtpComplete => _otpCode.length == 6;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
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

  void _onFieldChanged(String value, int index) {
    if (value.isNotEmpty) {
      HapticFeedback.lightImpact();

      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_isOtpComplete) {
          HapticFeedback.mediumImpact();
          _verifyOtp();
        }
      }
    }
  }

  void _onFieldSubmitted(String value, int index) {
    if (index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (_isOtpComplete) {
      _verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRTL = context.locale.languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppBackButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              showBackground: true,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primary.withValues(alpha: 0.35),
                colorScheme.primary.withValues(alpha: 0.15),
                colorScheme.surface.withValues(alpha: 0.95),
                colorScheme.surface,
              ],
              stops: const [0.0, 0.25, 0.55, 0.75],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.xl3),
                        _buildOtpInput(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildActionLinks(),
                      ],
                    ),
                  ),
                  _buildVerifyButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'auth.otpTitle'.tr(),
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'auth.otpSubtitle'.tr(namedArgs: {'contact': widget.phoneNumber}),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: 0.1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: index == 0 || index == 5 ? 0 : 6),
          child: _buildOtpField(index),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFocus = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 56,
      height: 56,
      transform: hasFocus
          ? (Matrix4.identity()..scaleByDouble(1.02, 1.02, 1.02, 1.02))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: hasValue || hasFocus
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 1.0),
          width: hasValue || hasFocus ? 2 : 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasFocus
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden TextField for input
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              enabled: !_isLoading,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onFieldChanged(value, index),
              onSubmitted: (value) => _onFieldSubmitted(value, index),
              onTapOutside: (_) => _focusNodes[index].unfocus(),
            ),
          ),
          // Visible dot indicator
          if (hasValue)
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionLinks() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _resendCountdown > 0
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        TextButton(
          onPressed: _onChangeNumber,
          child: Text(
            'auth.changeNumber'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = !_isLoading && _isOtpComplete;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
              )
            : null,
        color: isEnabled ? null : colorScheme.onSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _verifyOtp : null,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Text(
                    'auth.verify'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isEnabled
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
