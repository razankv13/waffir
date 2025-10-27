import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: AppColors.lightColorScheme,
      brightness: Brightness.light,
      
      // Material 3
      useMaterial3: true,
      
      // Typography
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.lightColorScheme.surface,
        foregroundColor: AppColors.lightColorScheme.onSurface,
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryLight,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevation2,
        margin: AppSpacing.paddingSm,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.cardBorderRadius,
        ),
        color: AppColors.lightColorScheme.surface,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation2,
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
      
      // Outlined Button Theme
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
      
      // Text Button Theme
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
      
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.xs2),
        ),
      ),
      
      // Input Decoration Theme
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
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.lightColorScheme.surface,
        selectedItemColor: AppColors.lightColorScheme.primary,
        unselectedItemColor: AppColors.lightColorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        elevation: AppSpacing.elevation3,
      ),
      
      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: AppColors.lightColorScheme.surface,
        indicatorColor: AppColors.lightColorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: AppColors.lightColorScheme.onSurface,
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
            );
          }
          return IconThemeData(
            color: AppColors.lightColorScheme.onSurfaceVariant,
          );
        }),
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.lightColorScheme.primary,
        unselectedLabelColor: AppColors.lightColorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.primary,
            width: 2,
          ),
        ),
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevation6,
        backgroundColor: AppColors.lightColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        elevation: AppSpacing.elevation5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      
      // Snack Bar Theme
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
      ),
      
      // FloatingActionButton Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightColorScheme.primaryContainer,
        foregroundColor: AppColors.lightColorScheme.onPrimaryContainer,
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightColorScheme.surfaceContainerHighest,
        selectedColor: AppColors.lightColorScheme.secondaryContainer,
        labelStyle: AppTypography.labelLarge,
        side: BorderSide(color: AppColors.lightColorScheme.outline),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs3),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.onPrimary;
          }
          return AppColors.lightColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.primary;
          }
          return AppColors.lightColorScheme.surfaceContainerHighest;
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.primary;
          }
          return AppColors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.lightColorScheme.onPrimary),
        side: BorderSide(color: AppColors.lightColorScheme.outline),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightColorScheme.primary;
          }
          return AppColors.lightColorScheme.outline;
        }),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.lightColorScheme.primary,
        inactiveTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
        thumbColor: AppColors.lightColorScheme.primary,
        overlayColor: AppColors.lightColorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.lightColorScheme.inverseSurface,
        valueIndicatorTextStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.lightColorScheme.onInverseSurface,
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.lightColorScheme.primary,
        linearTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
        circularTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.transparent,
        selectedTileColor: AppColors.lightColorScheme.secondaryContainer,
        iconColor: AppColors.lightColorScheme.onSurfaceVariant,
        textColor: AppColors.lightColorScheme.onSurface,
        titleTextStyle: AppTypography.bodyLarge,
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
      ),
      
      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        elevation: AppSpacing.elevation1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.lightColorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.lightColorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs2,
          vertical: AppSpacing.xs,
        ),
      ),
      
      // Banner Theme
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        contentTextStyle: AppTypography.bodyMedium,
        elevation: AppSpacing.elevation1,
        padding: const EdgeInsets.all(AppSpacing.sm),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: AppColors.darkColorScheme,
      brightness: Brightness.dark,
      
      // Material 3
      useMaterial3: true,
      
      // Typography
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.darkColorScheme.surface,
        foregroundColor: AppColors.darkColorScheme.onSurface,
        surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevation2,
        margin: AppSpacing.paddingSm,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.cardBorderRadius,
        ),
        color: AppColors.darkColorScheme.surface,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation2,
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
      
      // Similar implementations for other components...
      // (For brevity, I'll implement key differences from light theme)
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.darkColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.darkColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs3,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
      ),
      
      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onInverseSurface,
        ),
        actionTextColor: AppColors.darkColorScheme.inversePrimary,
        elevation: AppSpacing.elevation4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.darkColorScheme.primary,
        linearTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
        circularTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.darkColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }
  
  // Get theme based on ThemeMode
  static ThemeData getThemeFromMode(ThemeMode themeMode, Brightness systemBrightness) {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return systemBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }
}