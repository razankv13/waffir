import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Waffir logo widget with Arabic text "وفــــــر"
///
/// Displays the Waffir brand logo with customizable size and color.
/// Matches the Figma design specifications.
///
/// Example:
/// ```dart
/// WaffirLogo(
///   size: LogoSize.large,
///   showIcon: true,
/// )
/// ```
class WaffirLogo extends StatelessWidget {
  const WaffirLogo({
    super.key,
    this.size = LogoSize.medium,
    this.color,
    this.showIcon = true,
    this.textDirection = TextDirection.rtl,
  });

  final LogoSize size;
  final Color? color;
  final bool showIcon;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;
    final textSize = _getTextSize();
    final iconSize = _getIconSize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon (if enabled)
        if (showIcon) ...[
          _buildIcon(logoColor, iconSize),
          SizedBox(height: size == LogoSize.large ? 24.0 : 16.0),
        ],

        // Arabic text "وفــــــر"
        Directionality(
          textDirection: textDirection,
          child: Text(
            'وفــــــر',
            style: _getTextStyle(textSize, logoColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(Color logoColor, double iconSize) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            logoColor,
            logoColor.withValues(alpha: 0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: logoColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.percent,
          size: iconSize * 0.5,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  double _getTextSize() {
    switch (size) {
      case LogoSize.small:
        return 32.0;
      case LogoSize.medium:
        return 48.0;
      case LogoSize.large:
        return 59.4; // From Figma splash screen
    }
  }

  double _getIconSize() {
    switch (size) {
      case LogoSize.small:
        return 60.0;
      case LogoSize.medium:
        return 100.0;
      case LogoSize.large:
        return 140.0;
    }
  }

  TextStyle _getTextStyle(double fontSize, Color color) {
    return AppTypography.waffirLogo.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }
}

/// Logo size options
enum LogoSize {
  small,
  medium,
  large,
}
