// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:waffir/core/constants/app_colors.dart';
// import 'package:waffir/core/constants/app_spacing.dart';
// import 'package:waffir/core/constants/app_typography.dart';

// /// Dark theme configuration
// class DarkTheme {
//   static ThemeData get theme {
//     return ThemeData(
//       // Material 3 Configuration
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: AppColors.darkColorScheme,
      
//       // Typography
//       textTheme: AppTypography.textTheme.apply(
//         bodyColor: AppColors.textPrimaryDark,
//         displayColor: AppColors.textPrimaryDark,
//       ),
      
//       // App Bar
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         scrolledUnderElevation: 1,
//         centerTitle: true,
//         backgroundColor: AppColors.darkColorScheme.surface,
//         surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
//         foregroundColor: AppColors.darkColorScheme.onSurface,
//         titleTextStyle: AppTypography.titleLarge.copyWith(
//           color: AppColors.textPrimaryDark,
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         shadowColor: AppColors.darkColorScheme.shadow,
//         iconTheme: const IconThemeData(
//           color: AppColors.textPrimaryDark,
//         ),
//         actionsIconTheme: const IconThemeData(
//           color: AppColors.textPrimaryDark,
//         ),
//       ),
      
//       // Scaffold
//       scaffoldBackgroundColor: AppColors.darkColorScheme.surface,
      
//       // Primary Color (for legacy widgets)
//       primarySwatch: _createMaterialColor(AppColors.darkColorScheme.primary),
//       primaryColor: AppColors.darkColorScheme.primary,
      
//       // Cards
//       cardTheme: CardThemeData(
//         elevation: AppSpacing.elevation1,
//         margin: AppSpacing.paddingSm,
//         shape: const RoundedRectangleBorder(
//           borderRadius: AppSpacing.cardBorderRadius,
//         ),
//         color: AppColors.darkColorScheme.surface,
//         surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
//         shadowColor: AppColors.darkColorScheme.shadow,
//       ),
      
//       // Buttons
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           elevation: AppSpacing.elevation1,
//           shadowColor: AppColors.darkColorScheme.shadow,
//           surfaceTintColor: AppColors.darkColorScheme.primary,
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.md,
//             vertical: AppSpacing.sm,
//           ),
//           shape: const RoundedRectangleBorder(
//             borderRadius: AppSpacing.buttonBorderRadius,
//           ),
//           textStyle: AppTypography.button,
//         ),
//       ),
      
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.md,
//             vertical: AppSpacing.sm,
//           ),
//           shape: const RoundedRectangleBorder(
//             borderRadius: AppSpacing.buttonBorderRadius,
//           ),
//           side: BorderSide(color: AppColors.darkColorScheme.outline),
//           textStyle: AppTypography.button,
//         ),
//       ),
      
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.sm,
//             vertical: AppSpacing.xs2,
//           ),
//           shape: const RoundedRectangleBorder(
//             borderRadius: AppSpacing.buttonBorderRadius,
//           ),
//           textStyle: AppTypography.button,
//         ),
//       ),
      
//       filledButtonTheme: FilledButtonThemeData(
//         style: FilledButton.styleFrom(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.md,
//             vertical: AppSpacing.sm,
//           ),
//           shape: const RoundedRectangleBorder(
//             borderRadius: AppSpacing.buttonBorderRadius,
//           ),
//           textStyle: AppTypography.button,
//         ),
//       ),
      
//       // Form Fields
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.darkColorScheme.surface,
//         border: OutlineInputBorder(
//           borderRadius: AppSpacing.inputBorderRadius,
//           borderSide: BorderSide(color: AppColors.darkColorScheme.outline),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: AppSpacing.inputBorderRadius,
//           borderSide: BorderSide(color: AppColors.darkColorScheme.outline),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: AppSpacing.inputBorderRadius,
//           borderSide: BorderSide(
//             color: AppColors.darkColorScheme.primary,
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: AppSpacing.inputBorderRadius,
//           borderSide: BorderSide(color: AppColors.darkColorScheme.error),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: AppSpacing.inputBorderRadius,
//           borderSide: BorderSide(
//             color: AppColors.darkColorScheme.error,
//             width: 2,
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.sm,
//           vertical: AppSpacing.xs3,
//         ),
//         hintStyle: AppTypography.bodyMedium.copyWith(
//           color: AppColors.darkColorScheme.onSurfaceVariant,
//         ),
//         labelStyle: AppTypography.bodyMedium.copyWith(
//           color: AppColors.darkColorScheme.onSurfaceVariant,
//         ),
//         errorStyle: AppTypography.bodySmall.copyWith(
//           color: AppColors.darkColorScheme.error,
//         ),
//       ),
      
//       // Navigation
//       navigationBarTheme: NavigationBarThemeData(
//         height: 80,
//         elevation: AppSpacing.elevation2,
//         backgroundColor: AppColors.darkColorScheme.surface,
//         surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
//         indicatorColor: AppColors.darkColorScheme.secondaryContainer,
//         indicatorShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
//         ),
//         labelTextStyle: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppTypography.labelSmall.copyWith(
//               color: AppColors.darkColorScheme.onSurface,
//               fontWeight: FontWeight.w600,
//             );
//           }
//           return AppTypography.labelSmall.copyWith(
//             color: AppColors.darkColorScheme.onSurfaceVariant,
//           );
//         }),
//         iconTheme: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return IconThemeData(
//               color: AppColors.darkColorScheme.onSecondaryContainer,
//               size: AppSpacing.iconMd,
//             );
//           }
//           return IconThemeData(
//             color: AppColors.darkColorScheme.onSurfaceVariant,
//             size: AppSpacing.iconMd,
//           );
//         }),
//       ),
      
//       // Floating Action Button
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: AppColors.darkColorScheme.primaryContainer,
//         foregroundColor: AppColors.darkColorScheme.onPrimaryContainer,
//         elevation: AppSpacing.elevation3,
//         highlightElevation: AppSpacing.elevation5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
//         ),
//       ),
      
//       // Bottom Sheet
//       bottomSheetTheme: BottomSheetThemeData(
//         backgroundColor: AppColors.darkColorScheme.surface,
//         surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
//         elevation: AppSpacing.elevation5,
//         modalElevation: AppSpacing.elevation6,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(AppSpacing.radiusXl),
//           ),
//         ),
//         dragHandleColor: AppColors.darkColorScheme.onSurfaceVariant,
//         dragHandleSize: const Size(32, 4),
//       ),
      
//       // Dialogs
//       dialogTheme: DialogThemeData(
//         elevation: AppSpacing.elevation6,
//         backgroundColor: AppColors.darkColorScheme.surface,
//         surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
//         shadowColor: AppColors.darkColorScheme.shadow,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
//         ),
//         titleTextStyle: AppTypography.headlineSmall.copyWith(
//           color: AppColors.textPrimaryDark,
//         ),
//         contentTextStyle: AppTypography.bodyMedium.copyWith(
//           color: AppColors.textSecondaryDark,
//         ),
//       ),
      
//       // Snackbar
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: AppColors.darkColorScheme.inverseSurface,
//         contentTextStyle: AppTypography.bodyMedium.copyWith(
//           color: AppColors.darkColorScheme.onInverseSurface,
//         ),
//         actionTextColor: AppColors.darkColorScheme.inversePrimary,
//         elevation: AppSpacing.elevation4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
//         ),
//         behavior: SnackBarBehavior.floating,
//         insetPadding: const EdgeInsets.all(AppSpacing.sm),
//       ),
      
//       // List Tiles
//       listTileTheme: ListTileThemeData(
//         tileColor: Colors.transparent,
//         selectedTileColor: AppColors.darkColorScheme.secondaryContainer,
//         iconColor: AppColors.darkColorScheme.onSurfaceVariant,
//         textColor: AppColors.darkColorScheme.onSurface,
//         selectedColor: AppColors.darkColorScheme.onSecondaryContainer,
//         titleTextStyle: AppTypography.bodyLarge,
//         subtitleTextStyle: AppTypography.bodyMedium.copyWith(
//           color: AppColors.darkColorScheme.onSurfaceVariant,
//         ),
//         leadingAndTrailingTextStyle: AppTypography.labelSmall,
//         contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
//         shape: const RoundedRectangleBorder(
//           borderRadius: AppSpacing.borderRadiusLg,
//         ),
//       ),
      
//       // Switches and Selection Controls
//       switchTheme: SwitchThemeData(
//         thumbColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColors.darkColorScheme.onPrimary;
//           }
//           if (states.contains(WidgetState.disabled)) {
//             return AppColors.darkColorScheme.surface;
//           }
//           return AppColors.darkColorScheme.outline;
//         }),
//         trackColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColors.darkColorScheme.primary;
//           }
//           if (states.contains(WidgetState.disabled)) {
//             return AppColors.darkColorScheme.onSurface.withValues(alpha: 0.12);
//           }
//           return AppColors.darkColorScheme.surfaceContainerHighest;
//         }),
//       ),
      
//       // Progress Indicators
//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: AppColors.darkColorScheme.primary,
//         linearTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
//         circularTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
//       ),
      
//       // Dividers
//       dividerTheme: DividerThemeData(
//         color: AppColors.darkColorScheme.outlineVariant,
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }
  
//   // Helper method to create MaterialColor from Color
//   static MaterialColor _createMaterialColor(Color color) {
//     final strengths = <double>[.05];
//     final swatch = <int, Color>{};
//     final int r = (color.r * 255.0).round() & 0xff;
//     final int g = (color.g * 255.0).round() & 0xff;
//     final int b = (color.b * 255.0).round() & 0xff;

//     for (int i = 1; i < 10; i++) {
//       strengths.add(0.1 * i);
//     }
    
//     for (final strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }
    
//     return MaterialColor(color.toARGB32(), swatch);
//   }
// }