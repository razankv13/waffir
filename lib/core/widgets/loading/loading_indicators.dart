import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

enum LoadingIndicatorType {
  circular,
  linear,
  dots,
  pulse,
  wave,
  spinner,
}

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({
    super.key,
    this.type = LoadingIndicatorType.circular,
    this.size,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
    this.padding,
  });
  final LoadingIndicatorType type;
  final double? size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = color ?? colorScheme.primary;

    Widget indicator;

    switch (type) {
      case LoadingIndicatorType.circular:
        indicator = _buildCircularIndicator(indicatorColor);
        break;
      case LoadingIndicatorType.linear:
        indicator = _buildLinearIndicator(indicatorColor, colorScheme);
        break;
      case LoadingIndicatorType.dots:
        indicator = _buildDotsIndicator(indicatorColor);
        break;
      case LoadingIndicatorType.pulse:
        indicator = _buildPulseIndicator(indicatorColor);
        break;
      case LoadingIndicatorType.wave:
        indicator = _buildWaveIndicator(indicatorColor);
        break;
      case LoadingIndicatorType.spinner:
        indicator = _buildSpinnerIndicator(indicatorColor);
        break;
    }

    Widget content = indicator;

    if (message != null) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: AppSpacing.sm),
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildCircularIndicator(Color color) {
    return SizedBox(
      width: size ?? 48,
      height: size ?? 48,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }

  Widget _buildLinearIndicator(Color color, ColorScheme colorScheme) {
    return SizedBox(
      width: size ?? 200,
      height: 6,
      child: LinearProgressIndicator(
        color: color,
        backgroundColor: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }

  Widget _buildDotsIndicator(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: size ?? 8,
          height: size ?? 8,
          margin: EdgeInsets.symmetric(horizontal: (size ?? 8) * 0.25),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              delay: Duration(milliseconds: index * 200),
              duration: 800.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
            )
            .then()
            .scale(
              duration: 800.ms,
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.5, 0.5),
            );
      }),
    );
  }

  Widget _buildPulseIndicator(Color color) {
    return Container(
      width: size ?? 48,
      height: size ?? 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 1000.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
        )
        .then()
        .scale(
          duration: 1000.ms,
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.8, 0.8),
        );
  }

  Widget _buildWaveIndicator(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          width: (size ?? 32) * 0.15,
          height: size ?? 32,
          margin: EdgeInsets.symmetric(horizontal: (size ?? 32) * 0.05),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scaleY(
              delay: Duration(milliseconds: index * 100),
              duration: 600.ms,
              begin: 0.4,
              end: 1.0,
            )
            .then()
            .scaleY(
              duration: 600.ms,
              begin: 1.0,
              end: 0.4,
            );
      }),
    );
  }

  Widget _buildSpinnerIndicator(Color color) {
    return SizedBox(
      width: size ?? 48,
      height: size ?? 48,
      child: CustomPaint(
        painter: _SpinnerPainter(color: color, strokeWidth: strokeWidth),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 1000.ms);
  }
}

class _SpinnerPainter extends CustomPainter {

  _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw partial circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start at top (-90 degrees)
      4.7124, // 270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Loading overlay widget
class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.indicatorType = LoadingIndicatorType.circular,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.opacity = 0.3,
  });
  final bool isLoading;
  final Widget child;
  final LoadingIndicatorType indicatorType;
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: (backgroundColor ?? Colors.black).withValues(alpha: opacity),
              child: Center(
                child: LoadingIndicator(
                  type: indicatorType,
                  color: indicatorColor,
                  message: message,
                  padding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Loading button widget
class LoadingButton extends StatelessWidget {

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.loadingText,
    this.indicatorType = LoadingIndicatorType.circular,
    this.icon,
    this.style,
    this.enabled = true,
  });
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final String? loadingText;
  final LoadingIndicatorType indicatorType;
  final Widget? icon;
  final ButtonStyle? style;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = enabled && !isLoading;

    if (icon != null && !isLoading) {
      return FilledButton.icon(
        onPressed: isButtonEnabled ? onPressed : null,
        style: style,
        icon: icon!,
        label: Text(text),
      );
    }

    return FilledButton(
      onPressed: isButtonEnabled ? onPressed : null,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: LoadingIndicator(
                type: indicatorType,
                size: 20,
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs2),
          ] else if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.xs2),
          ],
          Text(isLoading ? (loadingText ?? 'Loading...') : text),
        ],
      ),
    );
  }
}

// Shimmer loading effect
class ShimmerLoading extends StatelessWidget {

  const ShimmerLoading({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });
  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final colorScheme = Theme.of(context).colorScheme;
    final shimmerBaseColor = baseColor ?? colorScheme.surfaceContainer;
    final shimmerHighlightColor = highlightColor ?? colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            shimmerBaseColor,
            shimmerHighlightColor,
            shimmerBaseColor,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: period,
          colors: [
            shimmerBaseColor,
            shimmerHighlightColor,
            shimmerBaseColor,
          ],
        );
  }
}