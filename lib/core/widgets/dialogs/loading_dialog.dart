import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

class LoadingDialog extends StatelessWidget {

  const LoadingDialog({
    super.key,
    this.message,
    this.showProgress = false,
    this.progress,
    this.dismissible = false,
    this.backgroundColor,
    this.progressColor,
  });
  final String? message;
  final bool showProgress;
  final double? progress;
  final bool dismissible;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return PopScope(
      canPop: dismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surface,
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
              // Loading indicator
              if (showProgress && progress != null)
                _buildProgressIndicator(context)
              else
                _buildCircularIndicator(context),
              
              if (message != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  message!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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

  Widget _buildCircularIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: progressColor ?? colorScheme.primary,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 1000.ms);
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: progressColor ?? colorScheme.primary,
            minHeight: 6,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        
        if (progress != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${(progress! * 100).toInt()}%',
            style: AppTypography.labelLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class LoadingDialogService {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show({
    required BuildContext context,
    String? message,
    bool showProgress = false,
    double? progress,
    bool dismissible = false,
    bool useBlur = true,
    Color? backgroundColor,
    Color? progressColor,
  }) {
    if (_isShowing) return;
    
    _isShowing = true;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Backdrop
            Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
            
            // Blur effect
            if (useBlur)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            
            // Loading dialog
            Center(
              child: LoadingDialog(
                message: message,
                showProgress: showProgress,
                progress: progress,
                dismissible: dismissible,
                backgroundColor: backgroundColor,
                progressColor: progressColor,
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void updateProgress({
    required double progress,
    String? message,
  }) {
    if (!_isShowing || _overlayEntry == null) return;
    
    _overlayEntry!.markNeedsBuild();
  }

  static void hide() {
    if (!_isShowing || _overlayEntry == null) return;
    
    _overlayEntry!.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  static bool get isShowing => _isShowing;
}

// Extension for easier usage
extension LoadingDialogExtension on BuildContext {
  void showLoadingDialog({
    String? message,
    bool showProgress = false,
    double? progress,
    bool dismissible = false,
    bool useBlur = true,
    Color? backgroundColor,
    Color? progressColor,
  }) {
    LoadingDialogService.show(
      context: this,
      message: message,
      showProgress: showProgress,
      progress: progress,
      dismissible: dismissible,
      useBlur: useBlur,
      backgroundColor: backgroundColor,
      progressColor: progressColor,
    );
  }

  void hideLoadingDialog() {
    LoadingDialogService.hide();
  }

  bool get isLoadingDialogShowing => LoadingDialogService.isShowing;
}