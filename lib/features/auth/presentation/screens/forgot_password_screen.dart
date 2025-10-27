import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/validators.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.sendPasswordResetEmail(email: _emailController.text.trim());
      
      setState(() => _emailSent = true);
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

  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.sendPasswordResetEmail(email: _emailController.text.trim());
      
      if (mounted) {
        context.showSuccessSnackBar(message: 'Reset email sent again');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl),
                if (_emailSent) ...[
                  _buildSuccessContent(),
                ] else ...[
                  _buildFormContent(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _emailSent ? Icons.mark_email_read : Icons.lock_reset,
            size: 32,
            color: AppColors.primary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _emailSent ? 'Check your email' : 'Forgot Password',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _emailSent
              ? "We've sent a password reset link to ${_emailController.text}"
              : 'Enter your email address and we\'ll send you a link to reset your password',
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.grey[600],
            height: 1.4,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
      ],
    );
  }

  Widget _buildFormContent() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: Validators.email,
          onFieldSubmitted: (_) => _handleSendResetEmail(),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideX(begin: 0.3, duration: 600.ms),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            onPressed: _isLoading ? null : _handleSendResetEmail,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Send Reset Link'),
          ),
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Email Sent Successfully',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please check your email and click on the password reset link to continue.',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.green[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .scale(begin: const Offset(0.9, 0.9), duration: 600.ms),
        const SizedBox(height: AppSpacing.xl),
        Column(
          children: [
            Text(
              'Didn\'t receive the email?',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _isLoading ? null : _handleResendEmail,
              child: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Resend Email',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Remember your password?',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Sign In',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
      ],
    );
  }
}