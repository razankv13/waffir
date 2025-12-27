import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Production-grade responsive design helper with:
/// - Cached instance via InheritedWidget (performance)
/// - Bounded/diminishing scaling (prevents extreme sizes)
/// - Text accessibility support
/// - Orientation awareness
/// - Density-aware scaling
///
/// Setup: Wrap your MaterialApp with ResponsiveScope
/// ```dart
/// ResponsiveScope(
///   config: ResponsiveConfig(
///     figmaWidth: 393,
///     figmaHeight: 852,
///   ),
///   child: MaterialApp(...),
/// )
/// ```
class ResponsiveConfig {
  const ResponsiveConfig({
    this.figmaWidth = 393.0,
    this.figmaHeight = 852.0,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 900.0,
    this.desktopBreakpoint = 1200.0,
    this.minScaleFactor = 0.8,
    this.maxScaleFactor = 1.4,
    this.useTextScaling = true,
    this.scalingCurve = ScalingCurve.bounded,
  });

  final double figmaWidth;
  final double figmaHeight;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double desktopBreakpoint;
  
  /// Minimum scale factor (prevents UI from becoming too small)
  final double minScaleFactor;
  
  /// Maximum scale factor (prevents UI from becoming too large)
  final double maxScaleFactor;
  
  /// Whether to respect system text scaling for accessibility
  final bool useTextScaling;
  
  /// How scaling should be applied
  final ScalingCurve scalingCurve;
}

enum ScalingCurve {
  /// Pure linear: size * scaleFactor (can be extreme)
  linear,
  
  /// Bounded: clamped between min/max scale factors
  bounded,
  
  /// Diminishing: scales less aggressively as screen size increases
  /// Good for tablets/desktops - prevents comically large elements
  diminishing,
}

enum DeviceType { mobile, tablet, desktop }

enum Orientation { portrait, landscape }

/// InheritedWidget for efficient ResponsiveHelper access
class ResponsiveScope extends StatelessWidget {
  const ResponsiveScope({
    super.key,
    required this.child,
    this.config = const ResponsiveConfig(),
  });

  final Widget child;
  final ResponsiveConfig config;

  static ResponsiveConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResponsiveScopeInherited>();
    return scope?.config ?? const ResponsiveConfig();
  }

  @override
  Widget build(BuildContext context) {
    return _ResponsiveScopeInherited(
      config: config,
      child: child,
    );
  }
}

class _ResponsiveScopeInherited extends InheritedWidget {
  const _ResponsiveScopeInherited({
    required this.config,
    required super.child,
  });

  final ResponsiveConfig config;

  @override
  bool updateShouldNotify(_ResponsiveScopeInherited oldWidget) {
    return config != oldWidget.config;
  }
}

/// Main responsive helper - use via context.rs extension
class ResponsiveHelper {
  ResponsiveHelper._(this.context, this.config);

  factory ResponsiveHelper.of(BuildContext context) {
    final config = ResponsiveScope.of(context);
    return ResponsiveHelper._(context, config);
  }

  final BuildContext context;
  final ResponsiveConfig config;

  // Cached MediaQuery data
  MediaQueryData? _mediaQuery;
  MediaQueryData get _mq => _mediaQuery ??= MediaQuery.of(context);

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN METRICS
  // ═══════════════════════════════════════════════════════════════════════════

  Size get screenSize => _mq.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get pixelRatio => _mq.devicePixelRatio;
  double get textScaleFactor => _mq.textScaleFactor;
  
  /// Logical pixels (accounting for device pixel ratio)
  double get logicalWidth => screenWidth;
  double get logicalHeight => screenHeight;

  // ═══════════════════════════════════════════════════════════════════════════
  // DEVICE TYPE & ORIENTATION
  // ═══════════════════════════════════════════════════════════════════════════

  DeviceType get deviceType {
    if (screenWidth >= config.desktopBreakpoint) return DeviceType.desktop;
    if (screenWidth >= config.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  Orientation get orientation =>
      screenWidth > screenHeight ? Orientation.landscape : Orientation.portrait;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE FACTORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Raw width scale factor (no bounds)
  double get _rawScaleWidth => screenWidth / config.figmaWidth;

  /// Raw height scale factor (no bounds)
  double get _rawScaleHeight => screenHeight / config.figmaHeight;

  /// Effective scale factor based on configured scaling curve
  double get scaleFactor {
    final raw = _rawScaleWidth;
    
    switch (config.scalingCurve) {
      case ScalingCurve.linear:
        return raw;
        
      case ScalingCurve.bounded:
        return raw.clamp(config.minScaleFactor, config.maxScaleFactor);
        
      case ScalingCurve.diminishing:
        // Logarithmic scaling: scales less aggressively as screen grows
        // At 1x: returns 1x
        // At 2x: returns ~1.3x instead of 2x
        // At 0.5x: returns ~0.7x instead of 0.5x
        if (raw <= 1.0) {
          // Below reference: use sqrt for gentler reduction
          return math.sqrt(raw).clamp(config.minScaleFactor, 1.0);
        } else {
          // Above reference: use log for diminishing returns
          final scaled = 1.0 + (math.log(raw) / math.ln2) * 0.5;
          return scaled.clamp(1.0, config.maxScaleFactor);
        }
    }
  }

  /// Height-based scale factor (useful for vertical spacing)
  double get scaleFactorHeight {
    final raw = _rawScaleHeight;
    return raw.clamp(config.minScaleFactor, config.maxScaleFactor);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCALING METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Scale a value using the current scaling curve
  /// This is your primary scaling method
  double s(double value) => value * scaleFactor;

  /// Scale with explicit min/max constraints
  double sConstrained(double value, {double? min, double? max}) {
    final scaled = s(value);
    if (min != null && max != null) return scaled.clamp(min, max);
    if (min != null) return math.max(scaled, min);
    if (max != null) return math.min(scaled, max);
    return scaled;
  }

  /// Scale height-based values (vertical spacing, heights)
  double sHeight(double value) => value * scaleFactorHeight;

  /// Scale font size with accessibility support
  /// Respects system text scaling settings
  double sFont(double fontSize, {double minSize = 10.0, bool respectAccessibility = true}) {
    var scaled = s(fontSize);
    
    // Apply system text scaling if enabled
    if (config.useTextScaling && respectAccessibility) {
      scaled *= textScaleFactor;
    }
    
    return math.max(scaled, minSize);
  }

  /// Scale icon size (typically same as font scaling)
  double sIcon(double iconSize, {double minSize = 16.0}) {
    return sConstrained(iconSize, min: minSize);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPOUND SCALING (EdgeInsets, Size, etc.)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Scale EdgeInsets
  EdgeInsets sPadding(EdgeInsets padding) {
    return EdgeInsets.only(
      left: s(padding.left),
      top: sHeight(padding.top),
      right: s(padding.right),
      bottom: sHeight(padding.bottom),
    );
  }

  /// Scale symmetric padding
  EdgeInsets sPaddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: s(horizontal),
      vertical: sHeight(vertical),
    );
  }

  /// Scale all-sides padding
  EdgeInsets sPaddingAll(double value) {
    return EdgeInsets.all(s(value));
  }

  /// Scale Size
  Size sSize(Size size) => Size(s(size.width), sHeight(size.height));

  /// Scale Offset
  Offset sOffset(Offset offset) => Offset(s(offset.dx), sHeight(offset.dy));

  /// Scale BorderRadius
  BorderRadius sBorderRadius(BorderRadius radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(s(radius.topLeft.x)),
      topRight: Radius.circular(s(radius.topRight.x)),
      bottomLeft: Radius.circular(s(radius.bottomLeft.x)),
      bottomRight: Radius.circular(s(radius.bottomRight.x)),
    );
  }

  /// Scale circular border radius
  BorderRadius sBorderRadiusCircular(double radius) {
    return BorderRadius.circular(s(radius));
  }

  /// Scale BoxConstraints
  BoxConstraints sConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: s(constraints.minWidth),
      maxWidth: constraints.maxWidth.isFinite ? s(constraints.maxWidth) : double.infinity,
      minHeight: sHeight(constraints.minHeight),
      maxHeight: constraints.maxHeight.isFinite ? sHeight(constraints.maxHeight) : double.infinity,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get value based on device type
  T byDevice<T>({required T mobile, T? tablet, T? desktop}) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Get value based on orientation
  T byOrientation<T>({required T portrait, required T landscape}) {
    return isPortrait ? portrait : landscape;
  }

  /// Responsive grid columns
  int gridColumns({int mobile = 2, int tablet = 3, int desktop = 4}) {
    return byDevice(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Responsive horizontal padding
  double horizontalPadding({double mobile = 16, double tablet = 24, double desktop = 32}) {
    return s(byDevice(mobile: mobile, tablet: tablet, desktop: desktop));
  }

  /// Responsive vertical padding
  double verticalPadding({double mobile = 16, double tablet = 20, double desktop = 24}) {
    return sHeight(byDevice(mobile: mobile, tablet: tablet, desktop: desktop));
  }

  /// Max content width (for centering on large screens)
  double contentMaxWidth({double mobile = double.infinity, double tablet = 720, double desktop = 1200}) {
    return byDevice(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SAFE AREAS
  // ═══════════════════════════════════════════════════════════════════════════

  EdgeInsets get safeArea => _mq.padding;
  double get topSafeArea => safeArea.top;
  double get bottomSafeArea => safeArea.bottom;
  double get leftSafeArea => safeArea.left;
  double get rightSafeArea => safeArea.right;

  bool get hasBottomNotch => bottomSafeArea > 0;
  bool get hasTopNotch => topSafeArea > 20; // Status bar is ~20-24px

  /// Total safe area adjusted height (screen minus notches)
  double get safeHeight => screenHeight - topSafeArea - bottomSafeArea;

  /// Total safe area adjusted width
  double get safeWidth => screenWidth - leftSafeArea - rightSafeArea;

  // ═══════════════════════════════════════════════════════════════════════════
  // KEYBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  double get keyboardHeight => _mq.viewInsets.bottom;
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Available height when keyboard is open
  double get availableHeight => screenHeight - keyboardHeight;
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXTENSIONS FOR CLEAN ACCESS
// ═══════════════════════════════════════════════════════════════════════════════

extension ResponsiveContextX on BuildContext {
  /// Access ResponsiveHelper via context
  /// Usage: context.rs.s(16)
  ResponsiveHelper get rs => ResponsiveHelper.of(this);

  // Quick accessors for common operations
  double s(double value) => rs.s(value);
  double sFont(double value) => rs.sFont(value);
  double sHeight(double value) => rs.sHeight(value);

  bool get isMobile => rs.isMobile;
  bool get isTablet => rs.isTablet;
  bool get isDesktop => rs.isDesktop;
  bool get isPortrait => rs.isPortrait;
  bool get isLandscape => rs.isLandscape;
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive builder that provides ResponsiveHelper
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ResponsiveHelper rs) builder;

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to trigger rebuilds on size changes
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, ResponsiveHelper.of(context));
      },
    );
  }
}

/// Widget that returns different layouts based on device type
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveHelper.of(context);
    return rs.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Widget that returns different layouts based on orientation
class OrientationLayout extends StatelessWidget {
  const OrientationLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  final Widget portrait;
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveHelper.of(context);
    return rs.byOrientation(portrait: portrait, landscape: landscape);
  }
}

/// Constrained content wrapper for large screens
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveHelper.of(context);
    final effectiveMaxWidth = maxWidth ?? rs.contentMaxWidth();

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: rs.horizontalPadding(),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Gap widget that scales responsively
class ResponsiveGap extends StatelessWidget {
  const ResponsiveGap(this.size, {super.key, this.horizontal = false});

  final double size;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveHelper.of(context);
    final scaledSize = horizontal ? rs.s(size) : rs.sHeight(size);
    return SizedBox(
      width: horizontal ? scaledSize : null,
      height: horizontal ? null : scaledSize,
    );
  }
}