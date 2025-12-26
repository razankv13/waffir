import 'package:flutter/material.dart';

/// Responsive design helper for scaling UI elements across different screen sizes
///
/// Based on Figma design frame dimensions (393×852px mobile)
///
/// Example usage:
/// ```dart
/// final responsive = ResponsiveHelper(context);
///
/// Container(
///   width: responsive.scale(200), // Scales 200px proportionally
///   padding: responsive.scalePadding(EdgeInsets.all(16)),
/// )
/// ```
class ResponsiveHelper {
  ResponsiveHelper(this.context);

  final BuildContext context;

  /// Reference design dimensions from Figma
  static const double figmaWidth = 393.0;
  static const double figmaHeight = 852.0;

  /// Screen breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;

  /// Get current screen size
  Size get screenSize => MediaQuery.of(context).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Calculate horizontal scale factor based on screen width
  double get scaleWidth => screenWidth / figmaWidth;

  /// Calculate vertical scale factor based on screen height
  double get scaleHeight => screenHeight / figmaHeight;

  /// Average scale factor (balanced between width and height)
  double get scaleAverage => (scaleWidth + scaleHeight) / 2;

  /// Device type detection
  bool get isMobile => screenWidth < mobileBreakpoint;
  bool get isTablet => screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;
  bool get isDesktop => screenWidth >= tabletBreakpoint;

  /// Scale a dimension proportionally based on screen width
  ///
  /// Example: `scale(16)` returns 16px on reference width, scales on others
  double scale(double size) {
    return size * scaleWidth;
  }

  /// Scale with minimum value constraint
  ///
  /// Prevents values from becoming too small on smaller screens
  /// Example: `scaleWithMin(12, min: 10)` won't go below 10px
  double scaleWithMin(double size, {required double min}) {
    return scale(size).clamp(min, double.infinity);
  }

  /// Scale with maximum value constraint
  ///
  /// Prevents values from becoming too large on bigger screens
  /// Example: `scaleWithMax(200, max: 300)` won't exceed 300px
  double scaleWithMax(double size, {required double max}) {
    return scale(size).clamp(0.0, max);
  }

  /// Scale with both min and max constraints
  ///
  /// Example: `scaleWithRange(16, min: 12, max: 24)`
  double scaleWithRange(double size, {required double min, required double max}) {
    return scale(size).clamp(min, max);
  }

  /// Scale font size with minimum readable size constraint
  ///
  /// Automatically prevents text from becoming too small
  /// Default minimum: 10px
  double scaleFontSize(double fontSize, {double minSize = 10.0}) {
    return scaleWithMin(fontSize, min: minSize);
  }

  /// Scale EdgeInsets proportionally
  ///
  /// Example: `scalePadding(EdgeInsets.all(16))`
  EdgeInsets scalePadding(EdgeInsets padding) {
    return EdgeInsets.only(
      left: scale(padding.left),
      top: scale(padding.top),
      right: scale(padding.right),
      bottom: scale(padding.bottom),
    );
  }

  /// Scale Size proportionally
  ///
  /// Example: `scaleSize(Size(200, 100))`
  Size scaleSize(Size size) {
    return Size(scale(size.width), scale(size.height));
  }

  /// Scale Offset proportionally
  ///
  /// Example: `scaleOffset(Offset(10, 20))`
  Offset scaleOffset(Offset offset) {
    return Offset(scale(offset.dx), scale(offset.dy));
  }

  /// Get responsive value based on screen size
  ///
  /// Example:
  /// ```dart
  /// final padding = responsive.responsiveValue(
  ///   mobile: 16.0,
  ///   tablet: 24.0,
  ///   desktop: 32.0,
  /// );
  /// ```
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive widget based on screen size
  ///
  /// Example:
  /// ```dart
  /// responsive.responsiveWidget(
  ///   mobile: MobileLayout(),
  ///   tablet: TabletLayout(),
  ///   desktop: DesktopLayout(),
  /// );
  /// ```
  Widget responsiveWidget({required Widget mobile, Widget? tablet, Widget? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get grid column count based on screen width
  ///
  /// Default: 2 for mobile, 3 for tablet, 4 for desktop
  int gridColumns({int? mobile, int? tablet, int? desktop}) {
    return responsiveValue(mobile: mobile ?? 2, tablet: tablet ?? 3, desktop: desktop ?? 4);
  }

  /// Get responsive horizontal padding
  ///
  /// Default: 16px for mobile, 24px for tablet, 32px for desktop
  double horizontalPadding({double? mobile, double? tablet, double? desktop}) {
    return responsiveValue(
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
  }

  /// Get responsive vertical padding
  ///
  /// Default: 16px for mobile, 20px for tablet, 24px for desktop
  double verticalPadding({double? mobile, double? tablet, double? desktop}) {
    return responsiveValue(
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 20.0,
      desktop: desktop ?? 24.0,
    );
  }

  /// Get responsive content max width
  ///
  /// Useful for centering content on large screens
  /// Default: full width for mobile, 1200px for desktop
  double contentMaxWidth({double? mobile, double? tablet, double? desktop}) {
    return responsiveValue(
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? 900.0,
      desktop: desktop ?? 1200.0,
    );
  }

  /// Apply scaling to BoxConstraints
  ///
  /// Example: `scaleConstraints(BoxConstraints(maxWidth: 300))`
  BoxConstraints scaleConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: scale(constraints.minWidth),
      maxWidth: constraints.maxWidth.isFinite ? scale(constraints.maxWidth) : constraints.maxWidth,
      minHeight: scale(constraints.minHeight),
      maxHeight: constraints.maxHeight.isFinite
          ? scale(constraints.maxHeight)
          : constraints.maxHeight,
    );
  }

  /// Scale border radius
  ///
  /// Example: `scaleBorderRadius(BorderRadius.circular(16))`
  BorderRadius scaleBorderRadius(BorderRadius radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(scale(radius.topLeft.x)),
      topRight: Radius.circular(scale(radius.topRight.x)),
      bottomLeft: Radius.circular(scale(radius.bottomLeft.x)),
      bottomRight: Radius.circular(scale(radius.bottomRight.x)),
    );
  }

  /// Get safe area insets
  EdgeInsets get safeAreaInsets => MediaQuery.of(context).padding;

  /// Get bottom safe area (for notched devices)
  double get bottomSafeArea => safeAreaInsets.bottom;

  /// Get top safe area (for status bar)
  double get topSafeArea => safeAreaInsets.top;

  /// Check if device has notch/bottom safe area
  bool get hasBottomNotch => bottomSafeArea > 0;

  /// Check if device has top notch/status bar
  bool get hasTopNotch => topSafeArea > 0;
}

/// Extension on BuildContext for easier access to ResponsiveHelper
extension ResponsiveContext on BuildContext {
  /// Quick access to ResponsiveHelper
  ///
  /// Example: `context.responsive.scale(16)`
  ResponsiveHelper get responsive => ResponsiveHelper(this);

  /// Quick access to screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Quick access to screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Quick check if mobile
  bool get isMobile => screenWidth < ResponsiveHelper.mobileBreakpoint;

  /// Quick check if tablet
  bool get isTablet =>
      screenWidth >= ResponsiveHelper.mobileBreakpoint &&
      screenWidth < ResponsiveHelper.tabletBreakpoint;

  /// Quick check if desktop
  bool get isDesktop => screenWidth >= ResponsiveHelper.tabletBreakpoint;
}

/// Responsive widget wrapper that rebuilds on size changes
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, responsive) {
///     return Container(
///       width: responsive.scale(200),
///       child: Text('Responsive!'),
///     );
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, ResponsiveHelper responsive) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveHelper(context);
        return builder(context, responsive);
      },
    );
  }
}

/// Responsive value widget that returns different values based on screen size
///
/// Example:
/// ```dart
/// ResponsiveValue<int>(
///   mobile: 2,
///   tablet: 3,
///   desktop: 4,
///   builder: (context, value) {
///     return GridView(
///       crossAxisCount: value,
///       // ...
///     );
///   },
/// )
/// ```
class ResponsiveValue<T> extends StatelessWidget {
  const ResponsiveValue({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    required this.builder,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final value = responsive.responsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);
    return builder(context, value);
  }
}
