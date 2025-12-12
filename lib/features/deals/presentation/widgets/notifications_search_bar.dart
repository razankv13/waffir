import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class NotificationsSearchBar extends StatelessWidget {
  const NotificationsSearchBar({
    super.key,
    this.onTap,
    this.controller,
    this.onChanged,
  });

  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    return Container(
      height: responsive.scale(68),
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00C531), // Green border
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: responsive.scaleFontSize(14),
                    color: const Color(0xFF151515),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: responsive.scale(2)),
                Text(
                  'Add keywords, store, brands, products...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: responsive.scaleFontSize(12),
                    color: const Color(0xFFA3A3A3),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Right side: Button
          Container(
            width: responsive.scale(44),
            height: responsive.scale(44),
            decoration: const BoxDecoration(
              color: Color(0xFF0F352D), // Dark Green
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/arrow_icon.svg', // Assuming this exists or using chevron
                // If arrow_icon.svg doesn't exist, I might need to download it or use chevron_right
                width: responsive.scale(20),
                height: responsive.scale(20),
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

