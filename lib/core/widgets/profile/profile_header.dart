import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

/// A profile header widget that displays user avatar, name, and email.
///
/// Pixel-perfect implementation matching Figma Profile screen (node 34:3080):
/// - Frame dimensions: 393×852px (Figma reference)
/// - Header height: 234px
/// - Avatar: 80×80px, circular with 2px rgba(255,255,255,0.4) border
/// - Background: #0F352D with image overlay
/// - Border radius: 0px 0px 30px 30px (bottom corners only)
/// - Padding: 24px (all sides)
/// - Gap: 8px between avatar, name, and email
/// - Name: Parkinsans 20px weight 600, line-height 1em
/// - Email: Parkinsans 14px weight 500, line-height 1em
/// - Edit icon: Hidden in Figma design (showEditIcon=false by default)
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.backgroundImage,
    this.onEditTap,
    this.showEditIcon = false, // Hidden in Figma design
  });

  /// The user's display name
  final String name;

  /// The user's email address
  final String email;

  /// Optional avatar image URL
  final String? avatarUrl;

  /// Optional background image URL (defaults to Figma design asset)
  final String? backgroundImage;

  /// Callback when edit icon is tapped
  final VoidCallback? onEditTap;

  /// Whether to show the edit icon on the avatar (false in Figma design)
  final bool showEditIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);

    return Container(
      // Exact height from Figma: 234px, scaled responsively
      height: responsive.scale(234),
      width: double.infinity,
      decoration: BoxDecoration(
        // Primary color: #0F352D (primaryColorDarkest)
        color: colorScheme.primary,
        // Bottom corners only: 30px radius (exact from Figma)
        borderRadius: responsive.scaleBorderRadius(
          const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        // Background image from Figma design
        image: DecorationImage(
          image: backgroundImage != null
              ? NetworkImage(backgroundImage!)
              : Assets.images.profileHeaderBgBd1db0.provider(),
          fit: BoxFit.cover,
          // Overlay to maintain text readability
          colorFilter: ColorFilter.mode(
            colorScheme.primary.withValues(alpha: 0.7),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          // Exact padding from Figma: 24px all sides
          padding: responsive.scalePadding(const EdgeInsets.all(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Avatar with optional edit icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Avatar: 80×80px circular (exact from Figma)
                  Container(
                    width: responsive.scale(80),
                    height: responsive.scale(80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Border: 2px solid rgba(255,255,255,0.4) (exact from Figma)
                      border: Border.all(
                        color: colorScheme.surface.withValues(alpha: 0.4),
                        width: responsive.scale(2),
                      ),
                      image: avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: responsive.scale(40),
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          )
                        : null,
                  ),

                  // Edit icon (hidden in Figma design)
                  if (showEditIcon)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: onEditTap,
                        child: Container(
                          width: responsive.scale(24),
                          height: responsive.scale(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: responsive.scale(12),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: responsive.scale(11),
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Gap: 8px (exact from Figma)
              SizedBox(height: responsive.scale(8)),

              // Name: Parkinsans 20px weight 600, line-height 1em, color #FFFFFF
              Text(
                name,
                style: AppTypography.profileName.copyWith(
                  color: colorScheme.surface, // White
                  fontSize: responsive.scaleFontSize(20, minSize: 16),
                ),
                textAlign: TextAlign.center,
              ),

              // Gap: 8px between name and email (Figma shows tight spacing, using same 8px)
              SizedBox(height: responsive.scale(8)),

              // Email: Parkinsans 14px weight 500, line-height 1em, color #FFFFFF
              Text(
                email,
                style: AppTypography.profileEmail.copyWith(
                  color: colorScheme.surface, // White
                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact version of the profile header for sub-screens.
///
/// Shows a smaller avatar and user info, typically used in settings
/// or profile management screens.
class CompactProfileHeader extends StatelessWidget {
  const CompactProfileHeader({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.onTap,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: colorScheme.surfaceContainerHighest,
              ),
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: 28,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Chevron
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
          ],
        ),
      ),
    );
  }
}
