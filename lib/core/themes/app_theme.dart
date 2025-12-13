import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';

class AppTheme {
  AppTheme._();

  // Light Theme - Single Theme Design
  static ThemeData get lightTheme {
    final colorScheme = AppColors.lightColorScheme;
    return ThemeData(
      // Color Scheme
      colorScheme: colorScheme,
      brightness: Brightness.light,

      // Material 3
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[
        PromoColors.light(AppColors.lightColorScheme),
        ProductPageTheme.light,
        NotificationsAlertsTheme.light(),
      ],

      // Typography
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevation2,
        margin: AppSpacing.paddingSm,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.cardBorderRadius),
        color: colorScheme.surface,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation2,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs2),
          shape: const RoundedRectangleBorder(borderRadius: AppSpacing.buttonBorderRadius),
          textStyle: AppTypography.button,
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(padding: const EdgeInsets.all(AppSpacing.xs2)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputBorderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs3,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        elevation: AppSpacing.elevation3,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: colorScheme.onSurface);
          }
          return AppTypography.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevation6,
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        titleTextStyle: AppTypography.headlineSmall.copyWith(color: colorScheme.onSurface),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppSpacing.elevation5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        elevation: AppSpacing.elevation4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        behavior: SnackBarBehavior.floating,
      ),

      // FloatingActionButton Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: AppTypography.labelLarge,
        side: BorderSide(color: colorScheme.outline),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs3),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return AppColors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.inverseSurface,
        valueIndicatorTextStyle: AppTypography.bodySmall.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.transparent,
        selectedTileColor: colorScheme.secondaryContainer,
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        titleTextStyle: AppTypography.bodyLarge,
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppSpacing.elevation1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(AppSpacing.radiusXl)),
        ),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2, vertical: AppSpacing.xs),
      ),

      // Banner Theme
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: AppTypography.bodyMedium,
        elevation: AppSpacing.elevation1,
        padding: const EdgeInsets.all(AppSpacing.sm),
      ),
    );
  }

  // Convenience getter for theme (always returns light theme)
  static ThemeData get theme => lightTheme;
}
