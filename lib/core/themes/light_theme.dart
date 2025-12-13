import 'package:flutter/material.dart';
import 'package:waffir/core/themes/app_theme.dart';

/// Light theme configuration.
///
/// NOTE: This delegates to [AppTheme.lightTheme] so there is a single source of truth for palette + component theming.
class LightTheme {
  static ThemeData get theme => AppTheme.lightTheme;
}