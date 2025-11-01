import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Light theme configuration
class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      // Material 3 Configuration
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      
      // Typography
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      
      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        foregroundColor: AppColors.lightColorScheme.onSurface,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shadowColor: AppColors.lightColorScheme.shadow,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.lightColorScheme.surface,
      
      // Primary Color (for legacy widgets)
      primarySwatch: _createMaterialColor(AppColors.primaryColor),
      primaryColor: AppColors.lightColorScheme.primary,
      
      // Cards
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevation1,
        margin: AppSpacing.paddingSm,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.cardBorderRadius,
        ),
        color: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        shadowColor: AppColors.lightColorScheme.shadow,
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation1,
          shadowColor: AppColors.lightColorScheme.shadow,
          surfaceTintColor: AppColors.lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          textStyle: AppTypography.button,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          side: BorderSide(color: AppColors.lightColorScheme.outline),
          textStyle: AppTypography.button,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs2,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          textStyle: AppTypography.button,
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonBorderRadius,
          ),
          textStyle: AppTypography.button,
        ),
      ),
      
      // Form Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.lightColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.lightColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs3,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.lightColorScheme.error,
        ),
      ),
      
      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        elevation: AppSpacing.elevation2,
        backgroundColor: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        indicatorColor: AppColors.lightColorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: AppColors.lightColorScheme.onSurface,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelSmall.copyWith(
            color: AppColors.lightColorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.lightColorScheme.onSecondaryContainer,
              size: AppSpacing.iconMd,
            );
          }
          return IconThemeData(
            color: AppColors.lightColorScheme.onSurfaceVariant,
            size: AppSpacing.iconMd,
          );
        }),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightColorScheme.primaryContainer,
        foregroundColor: AppColors.lightColorScheme.onPrimaryContainer,
        elevation: AppSpacing.elevation3,
        highlightElevation: AppSpacing.elevation5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        elevation: AppSpacing.elevation5,
        modalElevation: AppSpacing.elevation6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        dragHandleColor: AppColors.lightColorScheme.onSurfaceVariant,
        dragHandleSize: const Size(32, 4),
      ),
      
      // Dialogs
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevation6,
        backgroundColor: AppColors.lightColorScheme.surface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        shadowColor: AppColors.lightColorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onInverseSurface,
        ),
        actionTextColor: AppColors.lightColorScheme.inversePrimary,
        elevation: AppSpacing.elevation4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(AppSpacing.sm),
      ),
      
      // List Tiles
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.lightColorScheme.secondaryContainer,
        iconColor: AppColors.lightColorScheme.onSurfaceVariant,
        textColor: AppColors.lightColorScheme.onSurface,
        selectedColor: AppColors.lightColorScheme.onSecondaryContainer,
        titleTextStyle: AppTypography.bodyLarge,
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        leadingAndTrailingTextStyle: AppTypography.labelSmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
      ),
      
      // Switches and Selection Controls
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightColorScheme.surface;
          }
          return AppColors.lightColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightColorScheme.onSurface.withValues(alpha: 0.12);
          }
          return AppColors.lightColorScheme.surfaceContainerHighest;
        }),
      ),
      
      // Progress Indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.lightColorScheme.primary,
        linearTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
        circularTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: AppColors.lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
  
  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}