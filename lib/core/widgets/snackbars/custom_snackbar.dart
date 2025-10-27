import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

class CustomSnackBar extends StatelessWidget {

  const CustomSnackBar({
    super.key,
    required this.type,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.duration = const Duration(seconds: 4),
    this.showCloseButton = false,
    this.leading,
    this.margin,
    this.padding,
  });
  final SnackBarType type;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback? onDismissed;
  final Duration duration;
  final bool showCloseButton;
  final Widget? leading;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: margin ?? const EdgeInsets.all(AppSpacing.sm),
      child: Material(
        color: _getBackgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        elevation: 4,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs3,
          ),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(colorScheme),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _getIcon(),
                  color: _getIconColor(colorScheme),
                  size: AppSpacing.iconSm,
                ),
              )
                  .animate()
                  .scale(delay: 100.ms, duration: 300.ms)
                  .then()
                  .shake(hz: 1, curve: Curves.easeInOut),
              
              const SizedBox(width: AppSpacing.xs3),
              
              // Message
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: _getTextColor(colorScheme),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Action button
              if (actionLabel != null) ...[
                const SizedBox(width: AppSpacing.xs2),
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: _getActionColor(colorScheme),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs3),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    actionLabel!,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              
              // Close button
              if (showCloseButton) ...[
                const SizedBox(width: AppSpacing.xs2),
                IconButton(
                  onPressed: onDismissed,
                  icon: Icon(
                    Icons.close_rounded,
                    color: _getTextColor(colorScheme).withValues(alpha: 0.7),
                  ),
                  iconSize: AppSpacing.iconXs,
                  padding: const EdgeInsets.all(AppSpacing.xs2),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .slideY(
          duration: 400.ms,
          begin: 1.0,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 300.ms);
  }

  IconData _getIcon() {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.error_rounded;
      case SnackBarType.warning:
        return Icons.warning_rounded;
      case SnackBarType.info:
        return Icons.info_rounded;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (type) {
      case SnackBarType.success:
        return colorScheme.primaryContainer;
      case SnackBarType.error:
        return colorScheme.errorContainer;
      case SnackBarType.warning:
        return colorScheme.secondaryContainer;
      case SnackBarType.info:
        return colorScheme.tertiaryContainer;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    switch (type) {
      case SnackBarType.success:
        return colorScheme.onPrimaryContainer;
      case SnackBarType.error:
        return colorScheme.onErrorContainer;
      case SnackBarType.warning:
        return colorScheme.onSecondaryContainer;
      case SnackBarType.info:
        return colorScheme.onTertiaryContainer;
    }
  }

  Color _getIconBackgroundColor(ColorScheme colorScheme) {
    switch (type) {
      case SnackBarType.success:
        return colorScheme.primary.withValues(alpha: 0.2);
      case SnackBarType.error:
        return colorScheme.error.withValues(alpha: 0.2);
      case SnackBarType.warning:
        return colorScheme.secondary.withValues(alpha: 0.2);
      case SnackBarType.info:
        return colorScheme.tertiary.withValues(alpha: 0.2);
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    switch (type) {
      case SnackBarType.success:
        return colorScheme.onPrimaryContainer;
      case SnackBarType.error:
        return colorScheme.onErrorContainer;
      case SnackBarType.warning:
        return colorScheme.onSecondaryContainer;
      case SnackBarType.info:
        return colorScheme.onTertiaryContainer;
    }
  }

  Color _getActionColor(ColorScheme colorScheme) {
    switch (type) {
      case SnackBarType.success:
        return colorScheme.primary;
      case SnackBarType.error:
        return colorScheme.error;
      case SnackBarType.warning:
        return colorScheme.secondary;
      case SnackBarType.info:
        return colorScheme.tertiary;
    }
  }
}

class SnackBarItem {

  SnackBarItem({
    required this.id,
    required this.snackBar,
    required this.duration,
  }) : createdAt = DateTime.now();
  final String id;
  final CustomSnackBar snackBar;
  final Duration duration;
  final DateTime createdAt;

  bool get isExpired => DateTime.now().difference(createdAt) > duration;
}