import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

/// Dialog for managing ad consent and privacy settings
class AdConsentDialog extends ConsumerStatefulWidget {
  const AdConsentDialog({
    super.key,
    this.canDismiss = false,
    this.showPersonalizationOption = true,
  });

  final bool canDismiss;
  final bool showPersonalizationOption;

  /// Show the consent dialog
  static Future<bool?> show(
    BuildContext context, {
    bool canDismiss = false,
    bool showPersonalizationOption = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: canDismiss,
      builder: (context) => AdConsentDialog(
        canDismiss: canDismiss,
        showPersonalizationOption: showPersonalizationOption,
      ),
    );
  }

  @override
  ConsumerState<AdConsentDialog> createState() => _AdConsentDialogState();
}

class _AdConsentDialogState extends ConsumerState<AdConsentDialog> {
  bool _acceptPersonalized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _acceptPersonalized = EnvironmentConfig.enableAdPersonalization;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: widget.canDismiss,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: colorScheme.primary,
                    size: AppSpacing.iconLg,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Privacy & Ads',
                      style: AppTypography.headlineSmall.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Main content
              Text(
                'We use ads to keep our app free. Please review your privacy choices:',
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Consent information
              _buildConsentInfo(colorScheme),

              if (widget.showPersonalizationOption) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildPersonalizationOption(colorScheme),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Privacy links
              _buildPrivacyLinks(colorScheme),

              const SizedBox(height: AppSpacing.xl),

              // Action buttons
              _buildActionButtons(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentInfo(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: AppSpacing.iconSm, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.xs3),
              Text(
                'How we use ads',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '• We show ads to support our free app\n'
            '• Ads help us improve our services\n'
            '• You can choose personalized or non-personalized ads\n'
            '• Your privacy choices are always respected',
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationOption(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _acceptPersonalized
            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
            : colorScheme.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: _acceptPersonalized
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ad personalization',
                  style: AppTypography.titleSmall.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _acceptPersonalized,
                onChanged: _isProcessing
                    ? null
                    : (value) {
                        setState(() {
                          _acceptPersonalized = value;
                        });
                      },
                activeTrackColor: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs3),
          Text(
            _acceptPersonalized
                ? 'Personalized ads are based on your interests and activity'
                : 'Non-personalized ads are not based on your personal data',
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyLinks(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () => _openPrivacyPolicy(context),
          icon: Icon(
            Icons.description_outlined,
            size: AppSpacing.iconXs,
            color: colorScheme.primary,
          ),
          label: Text(
            'Privacy Policy',
            style: AppTypography.labelSmall.copyWith(color: colorScheme.primary),
          ),
        ),
        Container(width: 1, height: 16, color: colorScheme.outline.withValues(alpha: 0.3)),
        TextButton.icon(
          onPressed: () => _openAdChoices(context),
          icon: Icon(Icons.settings_outlined, size: AppSpacing.iconXs, color: colorScheme.primary),
          label: Text(
            'Ad Choices',
            style: AppTypography.labelSmall.copyWith(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        if (widget.canDismiss) ...[
          Expanded(
            child: AppButton.outlined(
              text: 'Later',
              onPressed: _isProcessing ? null : () => Navigator.of(context).pop(false),
              size: ButtonSize.medium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          flex: widget.canDismiss ? 1 : 2,
          child: AppButton.primary(
            text: _isProcessing ? null : 'Accept & Continue',
            isLoading: _isProcessing,
            onPressed: _isProcessing ? null : _handleAccept,
            size: ButtonSize.medium,
          ),
        ),
      ],
    );
  }

  Future<void> _handleAccept() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
     // final adStateNotifier = ref.read(adStateNotifierProvider.notifier);

      // Here you would typically save the user's consent preferences
      // For now, we'll just refresh the ad state
   //   await adStateNotifier.refreshState();

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _openPrivacyPolicy(BuildContext context) {
    // Open privacy policy URL
    // You can use url_launcher or implement an in-app web view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening Privacy Policy: ${EnvironmentConfig.privacyPolicyUrl}')),
    );
  }

  void _openAdChoices(BuildContext context) {
    // Open ad choices/settings
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening Ad Choices settings')));
  }
}

/// A simplified consent banner for minimal UX impact
class AdConsentBanner extends ConsumerWidget {
  const AdConsentBanner({super.key, this.onAccept, this.onDecline, this.onSettings});

  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.xs3),
                Expanded(
                  child: Text(
                    'We use ads to keep our app free',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton.text(
                    text: 'Settings',
                    size: ButtonSize.small,
                    onPressed: onSettings ?? () => AdConsentDialog.show(context, canDismiss: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs3),
                Expanded(
                  child: AppButton.primary(
                    text: 'Accept',
                    size: ButtonSize.small,
                    onPressed: onAccept,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
