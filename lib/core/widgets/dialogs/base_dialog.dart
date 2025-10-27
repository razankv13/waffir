import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

enum DialogType {
  success,
  error,
  warning,
  info,
  confirmation,
}

class BaseDialog extends StatelessWidget {

  const BaseDialog({
    super.key,
    required this.type,
    required this.title,
    required this.content,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.customContent,
    this.dismissible = true,
    this.showCloseButton = false,
    this.contentPadding,
  });
  final DialogType type;
  final String title;
  final String content;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Widget? customContent;
  final bool dismissible;
  final bool showCloseButton;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return PopScope(
      canPop: dismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and close button
              _buildHeader(context),
              
              // Content
              _buildContent(context),
              
              // Actions
              if (_hasActions) _buildActions(context),
            ],
          ),
        )
            .animate()
            .scale(
              duration: 300.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0.8, 0.8),
            )
            .fadeIn(duration: 200.ms),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(colorScheme),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Icon(
              _getIcon(),
              color: _getIconColor(colorScheme),
              size: AppSpacing.iconMd,
            ),
          )
              .animate()
              .scale(delay: 100.ms, duration: 400.ms)
              .then()
              .shake(hz: 2, curve: Curves.easeInOut),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Title
          Expanded(
            child: Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Close button
          if (showCloseButton)
            IconButton(
              onPressed: dismissible ? () => Navigator.of(context).pop() : null,
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              iconSize: AppSpacing.iconSm,
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: contentPadding ?? const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customContent != null)
            customContent!
          else
            Text(
              content,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (secondaryButtonText != null) ...[
            TextButton(
              onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
              child: Text(secondaryButtonText!),
            ),
            const SizedBox(width: AppSpacing.xs3),
          ],
          
          if (primaryButtonText != null)
            FilledButton(
              onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: _getPrimaryButtonColor(Theme.of(context).colorScheme),
              ),
              child: Text(primaryButtonText!),
            ),
        ],
      ),
    )
        .animate()
        .slideY(
          delay: 300.ms,
          duration: 300.ms,
          begin: 0.3,
          curve: Curves.easeOut,
        )
        .fadeIn(delay: 300.ms, duration: 200.ms);
  }

  bool get _hasActions => primaryButtonText != null || secondaryButtonText != null;

  IconData _getIcon() {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle_rounded;
      case DialogType.error:
        return Icons.error_rounded;
      case DialogType.warning:
        return Icons.warning_rounded;
      case DialogType.info:
        return Icons.info_rounded;
      case DialogType.confirmation:
        return Icons.help_rounded;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    switch (type) {
      case DialogType.success:
        return colorScheme.onPrimaryContainer;
      case DialogType.error:
        return colorScheme.onErrorContainer;
      case DialogType.warning:
        return colorScheme.onSecondaryContainer;
      case DialogType.info:
        return colorScheme.onTertiaryContainer;
      case DialogType.confirmation:
        return colorScheme.onSurfaceVariant;
    }
  }

  Color _getIconBackgroundColor(ColorScheme colorScheme) {
    switch (type) {
      case DialogType.success:
        return colorScheme.primaryContainer;
      case DialogType.error:
        return colorScheme.errorContainer;
      case DialogType.warning:
        return colorScheme.secondaryContainer;
      case DialogType.info:
        return colorScheme.tertiaryContainer;
      case DialogType.confirmation:
        return colorScheme.surfaceContainer;
    }
  }

  Color _getPrimaryButtonColor(ColorScheme colorScheme) {
    switch (type) {
      case DialogType.success:
        return colorScheme.primary;
      case DialogType.error:
        return colorScheme.error;
      case DialogType.warning:
        return colorScheme.secondary;
      case DialogType.info:
        return colorScheme.tertiary;
      case DialogType.confirmation:
        return colorScheme.primary;
    }
  }
}