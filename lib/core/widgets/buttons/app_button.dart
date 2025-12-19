import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/loading/loading_indicators.dart';

enum ButtonSize { small, medium, large }

enum ButtonVariant { primary, secondary, tertiary, outlined, text, ghost, destructive }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  // Factory constructor for primary button
  const AppButton.primary({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : variant = ButtonVariant.primary,
       assert(text != null || child != null, 'Either text or child must be provided');

  // Factory constructor for secondary button
  const AppButton.secondary({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : variant = ButtonVariant.secondary,
       assert(text != null || child != null, 'Either text or child must be provided');

  // Factory constructor for tertiary button
  const AppButton.tertiary({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : variant = ButtonVariant.tertiary,
       assert(text != null || child != null, 'Either text or child must be provided');

  // Factory constructor for outlined button
  const AppButton.outlined({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : variant = ButtonVariant.outlined,
       assert(text != null || child != null, 'Either text or child must be provided');

  // Factory constructor for text button
  const AppButton.text({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.animateOnTap = true,
    this.tooltip,
  }) : variant = ButtonVariant.text,
       assert(text != null || child != null, 'Either text or child must be provided');
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool animateOnTap;
  final String? tooltip;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isButtonEnabled = widget.enabled && !widget.isLoading;

    Widget baseButton = _buildButton(context, colorScheme, isButtonEnabled);

    Widget finalButton;

    if (widget.animateOnTap && isButtonEnabled) {
      finalButton = GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: baseButton,
        ),
      );
    } else {
      finalButton = baseButton;
    }

    if (widget.tooltip != null) {
      finalButton = Tooltip(message: widget.tooltip!, child: finalButton);
    }

    return finalButton;
  }

  Widget _buildButton(BuildContext context, ColorScheme colorScheme, bool isEnabled) {
    final buttonStyle = _getButtonStyle(colorScheme, isEnabled);
    final textStyle = _getTextStyle(colorScheme);

    final isFullWidth = widget.width == double.infinity;

    Widget label;
    if (widget.isLoading) {
      label = Text('Loading...', style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
    } else if (widget.child != null) {
      label = DefaultTextStyle(style: textStyle, child: widget.child!);
    } else {
      label = Text(widget.text ?? '', style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: LoadingIndicator(
              size: _getIconSize(),
              strokeWidth: 2,
              color: _getLoadingColor(colorScheme),
            ),
          ),
          const SizedBox(width: AppSpacing.xs2),
        ] else if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(size: _getIconSize(), color: _getForegroundColor(colorScheme)),
            child: widget.icon!,
          ),
          const SizedBox(width: AppSpacing.xs2),
        ],
        Flexible(child: label),
      ],
    );

    Widget button;

    switch (widget.variant) {
      case ButtonVariant.primary:
        button = FilledButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
      case ButtonVariant.secondary:
        // Updated to match Figma: White bg with 2px dark green border
        button = OutlinedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(colorScheme.surface),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.12), width: 2);
              }
              return BorderSide(color: colorScheme.primary, width: 2);
            }),
          ),
          child: content,
        );
        break;
      case ButtonVariant.tertiary:
        // Figma design: White bg with 1px gray border, 60px radius
        button = OutlinedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(colorScheme.surface),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.12), width: 1);
              }
              return BorderSide(color: colorScheme.outline, width: 1);
            }),
          ),
          child: content,
        );
        break;
      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
      case ButtonVariant.ghost:
        button = TextButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle.copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
          child: content,
        );
        break;
      case ButtonVariant.destructive:
        button = FilledButton(
          onPressed: isEnabled ? widget.onPressed : null,
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.onSurface.withValues(alpha: 0.12);
              }
              return widget.backgroundColor ?? colorScheme.error;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.onSurface.withValues(alpha: 0.38);
              }
              return widget.foregroundColor ?? colorScheme.onError;
            }),
          ),
          child: content,
        );
        break;
    }

    if (widget.width != null) {
      button = SizedBox(width: widget.width, child: button);
    }

    return button;
  }

  ButtonStyle _getButtonStyle(ColorScheme colorScheme, bool isEnabled) {
    final width = widget.width;
    final effectiveMinWidth = (width != null && width.isFinite) ? width : 0.0;
    return ButtonStyle(
      padding: WidgetStateProperty.all(widget.padding ?? _getPadding()),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: widget.borderRadius ?? _getBorderRadius()),
      ),
      // Explicit disabled state colors per Figma design
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) && widget.backgroundColor == null) {
          // Figma disabled state: #CECECE background
          return const Color(0xFFCECECE);
        }
        return widget.backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) && widget.foregroundColor == null) {
          // Figma disabled state: #A3A3A3 text
          return const Color(0xFFA3A3A3);
        }
        return widget.foregroundColor ?? _getForegroundColor(colorScheme);
      }),
      textStyle: WidgetStateProperty.all(_getTextStyle(colorScheme)),
      elevation: _getElevation(),
      shadowColor: WidgetStateProperty.all(colorScheme.shadow.withValues(alpha: 0.06)),
      // Fixed height (48px for medium size) via minimum size
      minimumSize: WidgetStateProperty.all(Size(effectiveMinWidth == 0 ? 330 : effectiveMinWidth, 48)),
    );
  }

  WidgetStateProperty<double> _getElevation() {
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.destructive:
        return WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppSpacing.elevation2;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppSpacing.elevation3;
          }
          return AppSpacing.elevation1;
        });
      case ButtonVariant.secondary:
      case ButtonVariant.tertiary:
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return WidgetStateProperty.all(AppSpacing.elevation0);
    }
  }

  TextStyle _getTextStyle(ColorScheme colorScheme) {
    TextStyle baseStyle;

    switch (widget.size) {
      case ButtonSize.small:
        baseStyle = AppTypography.labelSmall;
        break;
      case ButtonSize.medium:
        baseStyle = AppTypography.labelLarge;
        break;
      case ButtonSize.large:
        baseStyle = AppTypography.titleSmall;
        break;
    }

    // Font weights per Figma design
    FontWeight fontWeight;
    switch (widget.variant) {
      case ButtonVariant.primary:
        fontWeight = FontWeight.w600; // SemiBold
        break;
      case ButtonVariant.secondary:
        fontWeight = FontWeight.w600; // SemiBold (Figma: Node 35:2197, weight 600)
        break;
      case ButtonVariant.tertiary:
        fontWeight = FontWeight.w500; // Medium
        break;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        fontWeight = FontWeight.w600; // SemiBold (default)
        break;
      case ButtonVariant.destructive:
        fontWeight = FontWeight.w700; // Bold
        break;
    }

    return baseStyle.copyWith(
      color: widget.foregroundColor ?? _getForegroundColor(colorScheme),
      fontWeight: fontWeight,
      fontSize: 14, // Figma specifies 14px for all buttons
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xs3, vertical: AppSpacing.xs2);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPadding,
          vertical: AppSpacing.xs3,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.sm3, vertical: AppSpacing.sm);
    }
  }

  BorderRadius _getBorderRadius() {
    // Tertiary button uses 60px radius per Figma (double the standard 30px)
    if (widget.variant == ButtonVariant.tertiary) {
      return BorderRadius.circular(60);
    }

    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.borderRadiusSm;
      case ButtonSize.medium:
        return AppSpacing.buttonBorderRadius; // 30px for most buttons
      case ButtonSize.large:
        return AppSpacing.borderRadiusLg;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.iconXs;
      case ButtonSize.medium:
        return AppSpacing.iconSm;
      case ButtonSize.large:
        return AppSpacing.iconMd;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    if (widget.foregroundColor != null) return widget.foregroundColor!;

    switch (widget.variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary; // White text
      case ButtonVariant.destructive:
        return colorScheme.onError;
      case ButtonVariant.secondary:
        return colorScheme.onSurface; // Black text on white bg
      case ButtonVariant.tertiary:
        return colorScheme.onSurface; // Black text on white bg
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return colorScheme.primary;
    }
  }

  Color _getLoadingColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary; // White loading indicator
      case ButtonVariant.destructive:
        return colorScheme.onError;
      case ButtonVariant.secondary:
        return colorScheme.onSurface; // Black loading indicator
      case ButtonVariant.tertiary:
        return colorScheme.onSurface; // Black loading indicator
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return colorScheme.primary;
    }
  }
}

// Floating Action Button with enhanced features
class AppFAB extends StatefulWidget {
  const AppFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.mini = false,
    this.extended = false,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.animateOnTap = true,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final String? label;
  final bool mini;
  final bool extended;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool animateOnTap;

  @override
  State<AppFAB> createState() => _AppFABState();
}

class _AppFABState extends State<AppFAB> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget baseFab;

    if (widget.extended && widget.label != null) {
      baseFab = FloatingActionButton.extended(
        onPressed: widget.isLoading ? null : widget.onPressed,
        backgroundColor: widget.backgroundColor ?? colorScheme.primaryContainer,
        foregroundColor: widget.foregroundColor ?? colorScheme.onPrimaryContainer,
        tooltip: widget.tooltip,
        elevation: AppSpacing.elevation3,
        focusElevation: AppSpacing.elevation4,
        hoverElevation: AppSpacing.elevation4,
        highlightElevation: AppSpacing.elevation2,
        icon: widget.isLoading
            ? SizedBox(
                width: AppSpacing.iconSm,
                height: AppSpacing.iconSm,
                child: LoadingIndicator(
                  size: AppSpacing.iconSm,
                  strokeWidth: 2,
                  color: widget.foregroundColor ?? colorScheme.onPrimaryContainer,
                ),
              )
            : widget.icon,
        label: Text(
          widget.label!,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      );
    } else {
      baseFab = FloatingActionButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        backgroundColor: widget.backgroundColor ?? colorScheme.primaryContainer,
        foregroundColor: widget.foregroundColor ?? colorScheme.onPrimaryContainer,
        tooltip: widget.tooltip,
        mini: widget.mini,
        elevation: AppSpacing.elevation3,
        focusElevation: AppSpacing.elevation4,
        hoverElevation: AppSpacing.elevation4,
        highlightElevation: AppSpacing.elevation2,
        child: widget.isLoading
            ? LoadingIndicator(
                size: AppSpacing.iconMd,
                strokeWidth: 2,
                color: widget.foregroundColor ?? colorScheme.onPrimaryContainer,
              )
            : widget.icon,
      );
    }

    if (widget.animateOnTap && !widget.isLoading) {
      return GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: baseFab,
        ),
      );
    }

    return baseFab;
  }
}

// Icon button with enhanced features
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.ghost,
    this.isLoading = false,
    this.tooltip,
    this.animateOnTap = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isLoading;
  final String? tooltip;
  final bool animateOnTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = !widget.isLoading && widget.onPressed != null;

    Widget baseIconButton = IconButton(
      onPressed: isEnabled ? widget.onPressed : null,
      icon: widget.isLoading
          ? LoadingIndicator(
              size: _getIconSize(),
              strokeWidth: 2,
              color: widget.foregroundColor ?? colorScheme.primary,
            )
          : widget.icon,
      iconSize: _getIconSize(),
      padding: widget.padding ?? _getPadding(),
      tooltip: widget.tooltip,
      style: IconButton.styleFrom(
        backgroundColor: _getBackgroundColor(colorScheme),
        foregroundColor: widget.foregroundColor ?? _getForegroundColor(colorScheme),
        shape: RoundedRectangleBorder(borderRadius: _getBorderRadius()),
        side: _getBorderSide(colorScheme),
      ),
    );

    if (widget.animateOnTap && isEnabled) {
      return GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: baseIconButton,
        ),
      );
    }

    return baseIconButton;
  }

  Color? _getBackgroundColor(ColorScheme colorScheme) {
    if (widget.backgroundColor != null) return widget.backgroundColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        return colorScheme.primary;
      case ButtonVariant.secondary:
        return colorScheme.secondaryContainer;
      case ButtonVariant.tertiary:
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return null;
      case ButtonVariant.destructive:
        return colorScheme.errorContainer;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary;
      case ButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case ButtonVariant.tertiary:
      case ButtonVariant.destructive:
        return colorScheme.onErrorContainer;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return colorScheme.onSurfaceVariant;
    }
  }

  BorderSide? _getBorderSide(ColorScheme colorScheme) {
    if (widget.variant == ButtonVariant.outlined) {
      return BorderSide(color: colorScheme.outline.withValues(alpha: 0.5));
    }
    return null;
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.iconXs;
      case ButtonSize.medium:
        return AppSpacing.iconSm;
      case ButtonSize.large:
        return AppSpacing.iconMd;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.all(AppSpacing.xs2);
      case ButtonSize.medium:
        return const EdgeInsets.all(AppSpacing.xs3);
      case ButtonSize.large:
        return const EdgeInsets.all(AppSpacing.sm);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSpacing.borderRadiusXs;
      case ButtonSize.medium:
        return AppSpacing.borderRadiusSm;
      case ButtonSize.large:
        return AppSpacing.borderRadiusMd;
    }
  }
}
