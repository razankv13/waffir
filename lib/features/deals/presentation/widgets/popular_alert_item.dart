import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class PopularAlertItem extends StatelessWidget {
  const PopularAlertItem({
    super.key,
    required this.title,
    this.onAdd,
  });

  final String title;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper.of(context);

    return Container(
      padding: responsive.sPadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Profile Icon/Image Placeholder
          Container(
            width: responsive.s(48),
            height: responsive.s(48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/icons/categories/electronics_icon.svg', // Placeholder icon
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(Color(0xFF151515), BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: responsive.s(12)),
          // Title
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF151515),
                height: 1.15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Add Tag Button
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: responsive.s(40),
              padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: responsive.sFont(12),
                      color: const Color(0xFF151515),
                      height: 1.15,
                    ),
                  ),
                  SizedBox(width: responsive.s(4)),
                  SvgPicture.asset(
                    'assets/icons/plus.svg',
                    width: responsive.s(16),
                    height: responsive.s(16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
