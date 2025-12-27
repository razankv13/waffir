import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class DealAlertItem extends StatelessWidget {
  const DealAlertItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.letter,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String letter;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: responsive.sPadding(const EdgeInsets.symmetric(vertical: 8)),
        child: Row(
          children: [
            // Profile Letter
            Container(
              width: responsive.s(64),
              height: responsive.s(64),
              decoration: BoxDecoration(
                color: backgroundColor ?? const Color(0xFFDCFCE7), // Default light green
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                  width: 1.6,
                ),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: textColor ?? const Color(0xFF00C531), // Default green
                    fontSize: responsive.sFont(20),
                    height: 1.15,
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.s(12)),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF151515),
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: responsive.s(4)), // Assuming slight gap
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: responsive.sFont(12),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF151515),
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron
            SvgPicture.asset(
              'assets/icons/chevron_right.svg',
              width: responsive.s(24),
              height: responsive.s(24),
            ),
          ],
        ),
      ),
    );
  }
}

