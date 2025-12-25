import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

class _ProfileHeaderSpec {
  const _ProfileHeaderSpec._();

  static const double frameHeight = 234;
  static const double basePadding = 24;
  static const double avatarSize = 80;
  static const double avatarBorderWidth = 2;
  static const double avatarIconSize = 40;
  static const double editBadgeSize = 24;
  static const double editIconSize = 11;
  static const double verticalGap = 8;
  static const BorderRadius borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
  );
  static const double overlayTopOpacity = 0.9;
  static const double overlayBottomOpacity = 0.7;
  static const Alignment backgroundAlignment = Alignment(0.0, -0.2);
}

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
    final safeTop = responsive.topSafeArea;
    final headerHeight =
        responsive.scale(_ProfileHeaderSpec.frameHeight) + safeTop;
    final avatarSize = responsive.scale(_ProfileHeaderSpec.avatarSize);
    final avatarBorderWidth = responsive.scale(
      _ProfileHeaderSpec.avatarBorderWidth,
    );
    final placeholderIconSize = responsive.scale(
      _ProfileHeaderSpec.avatarIconSize,
    );
    final borderRadius = responsive.scaleBorderRadius(
      _ProfileHeaderSpec.borderRadius,
    );
    final gap = responsive.scale(_ProfileHeaderSpec.verticalGap);
    final editBadgeSize = responsive.scale(_ProfileHeaderSpec.editBadgeSize);
    final editIconSize = responsive.scale(_ProfileHeaderSpec.editIconSize);
    final ImageProvider backgroundImageProvider = backgroundImage != null
        ? CachedNetworkImageProvider(backgroundImage!)
        : Assets.images.profileHeaderBgBd1db0.provider();

    return RepaintBoundary(
      child: SizedBox(
        height: headerHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: colorScheme.primary),
              ),
              Positioned.fill(
                child: Image(
                  image: backgroundImageProvider,
                  fit: BoxFit.cover,
                  alignment: _ProfileHeaderSpec.backgroundAlignment,
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.primary.withValues(
                          alpha: _ProfileHeaderSpec.overlayTopOpacity,
                        ),
                        colorScheme.primary.withValues(
                          alpha: _ProfileHeaderSpec.overlayBottomOpacity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: responsive.scalePadding(
                    const EdgeInsets.all(_ProfileHeaderSpec.basePadding),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface.withValues(
                                  alpha: 0.4,
                                ),
                                width: avatarBorderWidth,
                              ),
                              image: avatarUrl != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                            child: avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: placeholderIconSize,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  )
                                : null,
                          ),
                          if (showEditIcon)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: onEditTap,
                                child: Container(
                                  width: editBadgeSize,
                                  height: editBadgeSize,
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: responsive.scale(12),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: editIconSize,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: gap),
                      Text(
                        name,
                        style: AppTypography.profileName.copyWith(
                          color: colorScheme.surface,
                          fontSize: responsive.scaleFontSize(20, minSize: 16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: gap),
                      Text(
                        email,
                        style: AppTypography.profileEmail.copyWith(
                          color: colorScheme.surface,
                          fontSize: responsive.scaleFontSize(14, minSize: 12),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
                        image: CachedNetworkImageProvider(avatarUrl!),
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
