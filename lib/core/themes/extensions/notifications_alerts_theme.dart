import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/themes/app_text_styles.dart';

/// Theme extension for Notifications & Alerts screen with exact Figma colors
///
/// Provides pixel-perfect color tokens for the Deal Alerts view (node 7774:3441)
/// while allowing widgets to remain theme-driven via Theme.of(context).
///
/// Usage:
/// ```dart
/// final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
/// Container(color: naTheme.selectedColor);
/// Text('Title', style: naTheme.sectionTitleStyle);
/// ```
class NotificationsAlertsTheme extends ThemeExtension<NotificationsAlertsTheme> {
  const NotificationsAlertsTheme({
    required this.background,
    required this.selectedColor,
    required this.unselectedColor,
    required this.textPrimary,
    required this.dividerColor,
    required this.dealTileBackground,
    required this.dealTileBorder,
    required this.dealTileLetterColor,
    required this.alertCardBackground,
    required this.alertImageBorder,
    required this.addButtonBackground,
    required this.addButtonBorder,
    required this.searchBorder,
    required this.searchButtonBackground,
    required this.backIconColor,
    required this.chevronColor,
    required this.plusIconColor,
    required this.headerDivider,
    required this.notificationTileBackground,
    required this.notificationTileBorder,
    required this.timestampColor,
    required this.sectionTitleStyle,
    required this.filterSelectedStyle,
    required this.filterUnselectedStyle,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.dealTitleStyle,
    required this.dealSubtitleStyle,
    required this.dealLetterStyle,
    required this.alertTitleStyle,
    required this.addButtonTextStyle,
    required this.searchLabelStyle,
    required this.searchPlaceholderStyle,
    required this.notificationTitleStyle,
    required this.notificationSubtitleStyle,
    required this.notificationTimestampStyle,
  });

  // Colors extracted from Figma node 7774:3441
  final Color background;
  final Color selectedColor;
  final Color unselectedColor;
  final Color textPrimary;
  final Color dividerColor;
  final Color dealTileBackground;
  final Color dealTileBorder;
  final Color dealTileLetterColor;
  final Color alertCardBackground;
  final Color alertImageBorder;
  final Color addButtonBackground;
  final Color addButtonBorder;
  final Color searchBorder;
  final Color searchButtonBackground;
  final Color backIconColor;
  final Color chevronColor;
  final Color plusIconColor;
  final Color headerDivider;

  // System notification colors
  final Color notificationTileBackground;
  final Color notificationTileBorder;
  final Color timestampColor;

  // Text styles (references to AppTextStyles with exact specs)
  final TextStyle sectionTitleStyle;
  final TextStyle filterSelectedStyle;
  final TextStyle filterUnselectedStyle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle dealTitleStyle;
  final TextStyle dealSubtitleStyle;
  final TextStyle dealLetterStyle;
  final TextStyle alertTitleStyle;
  final TextStyle addButtonTextStyle;
  final TextStyle searchLabelStyle;
  final TextStyle searchPlaceholderStyle;

  // System notification text styles
  final TextStyle notificationTitleStyle;
  final TextStyle notificationSubtitleStyle;
  final TextStyle notificationTimestampStyle;

  /// Light theme instance with exact Figma colors
  factory NotificationsAlertsTheme.light() {
    return NotificationsAlertsTheme(
      // Background & dividers
      background: AppColors.white, // #FFFFFF
      dividerColor: AppColors.gray01, // #F2F2F2
      headerDivider: AppColors.gray01, // #F2F2F2

      // Selection states
      selectedColor: AppColors.waffirGreen03, // #00C531
      unselectedColor: AppColors.gray03, // #A3A3A3
      textPrimary: AppColors.black, // #151515

      // Deal card components
      dealTileBackground: AppColors.waffirGreen01, // #DCFCE7
      dealTileBorder: const Color(0x0D000000), // rgba(0,0,0,0.05)
      dealTileLetterColor: AppColors.waffirGreen03, // #00C531

      // Alert card components
      alertCardBackground: AppColors.gray01, // #F2F2F2
      alertImageBorder: const Color(0x1A000000), // rgba(0,0,0,0.1)
      addButtonBackground: AppColors.white, // #FFFFFF
      addButtonBorder: const Color(0x0D000000), // rgba(0,0,0,0.05)

      // Search & navigation
      searchBorder: AppColors.waffirGreen03, // #00C531
      searchButtonBackground: AppColors.waffirGreen04, // #0F352D
      backIconColor: AppColors.black, // #151515
      chevronColor: AppColors.black, // #151515
      plusIconColor: AppColors.black, // #151515

      // System notification components
      notificationTileBackground: AppColors.gray01, // #F2F2F2
      notificationTileBorder: const Color(0x1A000000), // rgba(0,0,0,0.1)
      timestampColor: AppColors.gray03, // #A3A3A3

      // Text styles (from AppTextStyles)
      sectionTitleStyle: AppTextStyles.notificationsSectionTitle,
      filterSelectedStyle: AppTextStyles.notificationsFilterSelected,
      filterUnselectedStyle: AppTextStyles.notificationsFilterUnselected,
      titleStyle: AppTextStyles.notificationsTitle,
      subtitleStyle: AppTextStyles.notificationsSubtitle,
      dealTitleStyle: AppTextStyles.notificationsDealTitle,
      dealSubtitleStyle: AppTextStyles.notificationsDealSubtitle,
      dealLetterStyle: AppTextStyles.notificationsDealLetter,
      alertTitleStyle: AppTextStyles.notificationsAlertTitle,
      addButtonTextStyle: AppTextStyles.notificationsAddButton,
      searchLabelStyle: AppTextStyles.notificationsSearchLabel,
      searchPlaceholderStyle: AppTextStyles.notificationsSearchPlaceholder,

      // System notification text styles
      notificationTitleStyle: AppTextStyles.notificationsAlertTitle, // Reuse alert title
      notificationSubtitleStyle: AppTextStyles.notificationsAddButton, // Reuse 12px style
      notificationTimestampStyle: AppTextStyles.notificationsDealSubtitle, // Reuse 11.9px style
    );
  }

  @override
  ThemeExtension<NotificationsAlertsTheme> copyWith({
    Color? background,
    Color? selectedColor,
    Color? unselectedColor,
    Color? textPrimary,
    Color? dividerColor,
    Color? dealTileBackground,
    Color? dealTileBorder,
    Color? dealTileLetterColor,
    Color? alertCardBackground,
    Color? alertImageBorder,
    Color? addButtonBackground,
    Color? addButtonBorder,
    Color? searchBorder,
    Color? searchButtonBackground,
    Color? backIconColor,
    Color? chevronColor,
    Color? plusIconColor,
    Color? headerDivider,
    Color? notificationTileBackground,
    Color? notificationTileBorder,
    Color? timestampColor,
    TextStyle? sectionTitleStyle,
    TextStyle? filterSelectedStyle,
    TextStyle? filterUnselectedStyle,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? dealTitleStyle,
    TextStyle? dealSubtitleStyle,
    TextStyle? dealLetterStyle,
    TextStyle? alertTitleStyle,
    TextStyle? addButtonTextStyle,
    TextStyle? searchLabelStyle,
    TextStyle? searchPlaceholderStyle,
    TextStyle? notificationTitleStyle,
    TextStyle? notificationSubtitleStyle,
    TextStyle? notificationTimestampStyle,
  }) {
    return NotificationsAlertsTheme(
      background: background ?? this.background,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      textPrimary: textPrimary ?? this.textPrimary,
      dividerColor: dividerColor ?? this.dividerColor,
      dealTileBackground: dealTileBackground ?? this.dealTileBackground,
      dealTileBorder: dealTileBorder ?? this.dealTileBorder,
      dealTileLetterColor: dealTileLetterColor ?? this.dealTileLetterColor,
      alertCardBackground: alertCardBackground ?? this.alertCardBackground,
      alertImageBorder: alertImageBorder ?? this.alertImageBorder,
      addButtonBackground: addButtonBackground ?? this.addButtonBackground,
      addButtonBorder: addButtonBorder ?? this.addButtonBorder,
      searchBorder: searchBorder ?? this.searchBorder,
      searchButtonBackground: searchButtonBackground ?? this.searchButtonBackground,
      backIconColor: backIconColor ?? this.backIconColor,
      chevronColor: chevronColor ?? this.chevronColor,
      plusIconColor: plusIconColor ?? this.plusIconColor,
      headerDivider: headerDivider ?? this.headerDivider,
      notificationTileBackground: notificationTileBackground ?? this.notificationTileBackground,
      notificationTileBorder: notificationTileBorder ?? this.notificationTileBorder,
      timestampColor: timestampColor ?? this.timestampColor,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      filterSelectedStyle: filterSelectedStyle ?? this.filterSelectedStyle,
      filterUnselectedStyle: filterUnselectedStyle ?? this.filterUnselectedStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      dealTitleStyle: dealTitleStyle ?? this.dealTitleStyle,
      dealSubtitleStyle: dealSubtitleStyle ?? this.dealSubtitleStyle,
      dealLetterStyle: dealLetterStyle ?? this.dealLetterStyle,
      alertTitleStyle: alertTitleStyle ?? this.alertTitleStyle,
      addButtonTextStyle: addButtonTextStyle ?? this.addButtonTextStyle,
      searchLabelStyle: searchLabelStyle ?? this.searchLabelStyle,
      searchPlaceholderStyle: searchPlaceholderStyle ?? this.searchPlaceholderStyle,
      notificationTitleStyle: notificationTitleStyle ?? this.notificationTitleStyle,
      notificationSubtitleStyle: notificationSubtitleStyle ?? this.notificationSubtitleStyle,
      notificationTimestampStyle: notificationTimestampStyle ?? this.notificationTimestampStyle,
    );
  }

  @override
  ThemeExtension<NotificationsAlertsTheme> lerp(
    ThemeExtension<NotificationsAlertsTheme>? other,
    double t,
  ) {
    if (other is! NotificationsAlertsTheme) return this;

    return NotificationsAlertsTheme(
      background: Color.lerp(background, other.background, t)!,
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t)!,
      unselectedColor: Color.lerp(unselectedColor, other.unselectedColor, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      dealTileBackground: Color.lerp(dealTileBackground, other.dealTileBackground, t)!,
      dealTileBorder: Color.lerp(dealTileBorder, other.dealTileBorder, t)!,
      dealTileLetterColor: Color.lerp(dealTileLetterColor, other.dealTileLetterColor, t)!,
      alertCardBackground: Color.lerp(alertCardBackground, other.alertCardBackground, t)!,
      alertImageBorder: Color.lerp(alertImageBorder, other.alertImageBorder, t)!,
      addButtonBackground: Color.lerp(addButtonBackground, other.addButtonBackground, t)!,
      addButtonBorder: Color.lerp(addButtonBorder, other.addButtonBorder, t)!,
      searchBorder: Color.lerp(searchBorder, other.searchBorder, t)!,
      searchButtonBackground: Color.lerp(searchButtonBackground, other.searchButtonBackground, t)!,
      backIconColor: Color.lerp(backIconColor, other.backIconColor, t)!,
      chevronColor: Color.lerp(chevronColor, other.chevronColor, t)!,
      plusIconColor: Color.lerp(plusIconColor, other.plusIconColor, t)!,
      headerDivider: Color.lerp(headerDivider, other.headerDivider, t)!,
      notificationTileBackground:
          Color.lerp(notificationTileBackground, other.notificationTileBackground, t)!,
      notificationTileBorder: Color.lerp(notificationTileBorder, other.notificationTileBorder, t)!,
      timestampColor: Color.lerp(timestampColor, other.timestampColor, t)!,
      sectionTitleStyle: TextStyle.lerp(sectionTitleStyle, other.sectionTitleStyle, t)!,
      filterSelectedStyle: TextStyle.lerp(filterSelectedStyle, other.filterSelectedStyle, t)!,
      filterUnselectedStyle: TextStyle.lerp(filterUnselectedStyle, other.filterUnselectedStyle, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      dealTitleStyle: TextStyle.lerp(dealTitleStyle, other.dealTitleStyle, t)!,
      dealSubtitleStyle: TextStyle.lerp(dealSubtitleStyle, other.dealSubtitleStyle, t)!,
      dealLetterStyle: TextStyle.lerp(dealLetterStyle, other.dealLetterStyle, t)!,
      alertTitleStyle: TextStyle.lerp(alertTitleStyle, other.alertTitleStyle, t)!,
      addButtonTextStyle: TextStyle.lerp(addButtonTextStyle, other.addButtonTextStyle, t)!,
      searchLabelStyle: TextStyle.lerp(searchLabelStyle, other.searchLabelStyle, t)!,
      searchPlaceholderStyle: TextStyle.lerp(searchPlaceholderStyle, other.searchPlaceholderStyle, t)!,
      notificationTitleStyle: TextStyle.lerp(notificationTitleStyle, other.notificationTitleStyle, t)!,
      notificationSubtitleStyle:
          TextStyle.lerp(notificationSubtitleStyle, other.notificationSubtitleStyle, t)!,
      notificationTimestampStyle:
          TextStyle.lerp(notificationTimestampStyle, other.notificationTimestampStyle, t)!,
    );
  }
}

