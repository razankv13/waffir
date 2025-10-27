import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // Colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onSurface => colorScheme.onSurface;
  Color get onError => colorScheme.onError;

  // Screen dimensions
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  
  // Device orientation
  Orientation get orientation => mediaQuery.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  
  // Platform
  TargetPlatform get platform => theme.platform;
  bool get isAndroid => platform == TargetPlatform.android;
  bool get isIOS => platform == TargetPlatform.iOS;
  bool get isMacOS => platform == TargetPlatform.macOS;
  bool get isWindows => platform == TargetPlatform.windows;
  bool get isLinux => platform == TargetPlatform.linux;
  bool get isFuchsia => platform == TargetPlatform.fuchsia;
  bool get isMobile => isAndroid || isIOS;
  bool get isDesktop => isMacOS || isWindows || isLinux;
  bool get isWeb => identical(0, 0.0); // Simple web detection

  // Responsive breakpoints
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;
  bool get isLargeScreen => screenWidth >= 900;
  bool get isExtraLargeScreen => screenWidth >= 1200;
  
  // Device type based on screen size
  bool get isPhone => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktopSize => screenWidth >= 900;

  // Safe area
  double get safeAreaTop => padding.top;
  double get safeAreaBottom => padding.bottom;
  double get safeAreaLeft => padding.left;
  double get safeAreaRight => padding.right;
  
  // Keyboard
  bool get isKeyboardOpen => viewInsets.bottom > 0;
  double get keyboardHeight => viewInsets.bottom;
  
  // Text scaling
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);
  
  // Accessibility
  bool get accessibleNavigation => mediaQuery.accessibleNavigation;
  bool get boldText => mediaQuery.boldText;
  bool get highContrast => mediaQuery.highContrast;
  bool get disableAnimations => mediaQuery.disableAnimations;
  
  // Navigation
  NavigatorState get navigator => Navigator.of(this);
  bool get canPop => navigator.canPop();
  
  // Navigation methods
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push(route);
  
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) => navigator.pushNamed(routeName, arguments: arguments);
  
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) => navigator.pushReplacement(newRoute, result: result);
  
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => navigator.pushReplacementNamed(
        routeName,
        result: result,
        arguments: arguments,
      );
  
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) => navigator.pushAndRemoveUntil(newRoute, predicate);
  
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) => navigator.pushNamedAndRemoveUntil(
        newRouteName,
        predicate,
        arguments: arguments,
      );
  
  void pop<T extends Object?>([T? result]) => navigator.pop(result);
  
  void popUntil(RoutePredicate predicate) => navigator.popUntil(predicate);
  
  Future<bool> maybePop<T extends Object?>([T? result]) => navigator.maybePop(result);
  
  // SnackBar
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  
  void showSnackBar(SnackBar snackBar) {
    scaffoldMessenger.showSnackBar(snackBar);
  }
  
  void hideCurrentSnackBar() {
    scaffoldMessenger.hideCurrentSnackBar();
  }
  
  void removeCurrentSnackBar() {
    scaffoldMessenger.removeCurrentSnackBar();
  }
  
  void clearSnackBars() {
    scaffoldMessenger.clearSnackBars();
  }
  
  // Dialogs
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color? barrierColor = Colors.black54,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      builder: (context) => child,
    );
  }
  
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      builder: (context) => child,
    );
  }
  
  // Focus
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
  
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }
  
  // Localization (will be available after adding easy_localization)
  Locale get locale => Localizations.localeOf(this);
  
  // Responsive helper methods
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktopSize && desktop != null) {
      return desktop;
    }
    if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
  
  double responsiveWidth({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  double responsiveHeight({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  // Padding helpers
  EdgeInsets get screenPadding => EdgeInsets.all(responsive(
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ));
  
  EdgeInsets get contentPadding => EdgeInsets.symmetric(
        horizontal: responsive(
          mobile: 16.0,
          tablet: 32.0,
          desktop: 48.0,
        ),
        vertical: 16.0,
      );
}