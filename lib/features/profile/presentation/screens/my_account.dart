import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/mock/mock_user_data.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';

/// My Account Page
///
/// Pixel-perfect implementation matching Figma node `7774:6668`.
///
/// Note: Despite the file name, this screen currently renders the "My Account Page" UI
/// (avatar + activity cards + menu + logout) as requested.
class MyAccount extends ConsumerWidget {
  void _showDeleteAccountBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      useSafeArea: false,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.paddingOf(sheetContext).bottom;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: responsive.scale(48) + bottomInset),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.scale(24))),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B1B1B).withValues(alpha: 0.12),
                blurRadius: responsive.scale(25),
                offset: Offset(responsive.scale(2), responsive.scale(4)),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: responsive.scalePadding(const EdgeInsets.fromLTRB(6, 6, 6, 0)),
                child: SizedBox(
                  height: responsive.scale(44),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: responsive.scale(10)),
                          child: Container(
                            width: responsive.scale(32),
                            height: responsive.scale(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(responsive.scale(9999)),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: responsive.scale(44),
                          height: responsive.scale(44),
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(sheetContext).pop(),
                                customBorder: const CircleBorder(),
                                child: Container(
                                  width: responsive.scale(32),
                                  height: responsive.scale(32),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF2F2F2),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: responsive.scaleWithRange(16, min: 14, max: 18),
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.scale(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: responsive.scale(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                          child: Column(
                            children: [
                              Text(
                                LocaleKeys.profile.myAccount.deleteAccount.tr(),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontFamily: 'Parkinsans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: responsive.scaleFontSize(18, minSize: 16),
                                  height: 1.4,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: responsive.scale(12)),
                              Text(
                                LocaleKeys.profile.myAccount.deleteDescription.tr(),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Parkinsans',
                                  fontWeight: FontWeight.w400,
                                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                                  height: 1.4,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: responsive.scale(32)),

                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: responsive.scale(48),
                              child: AppButton.primary(
                                onPressed: () => Navigator.of(sheetContext).pop(),
                                backgroundColor: const Color(0xFFFF0000),
                                foregroundColor: Colors.white,
                                borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(30)),
                                child: Text(
                                  LocaleKeys.profile.myAccount.confirmDelete.tr(),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontFamily: 'Parkinsans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: responsive.scaleFontSize(14, minSize: 12),
                                    height: 1.0,
                                color: Colors.white,
                              ),
                            ),
                            ),
                          ),
                          SizedBox(height: responsive.scale(12)),
                          SizedBox(
                            width: double.infinity,
                            height: responsive.scale(48),
                            child: AppButton.secondary(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(30)),
                              foregroundColor: colorScheme.onSurface,
                              child: Text(
                                LocaleKeys.buttons.cancel.tr(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontFamily: 'Parkinsans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                                  height: 1.0,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  const MyAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = ResponsiveHelper(context);

    final user = currentMockUser;

    // Figma frame reference: 393×852
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Figma: back row padding top = 64. On iOS, 64 ≈ status bar (44) + 20.
    final headerTopPadding = topInset + responsive.scale(20);

    final horizontalPadding = responsive.scale(16);

    // Figma: root padding bottom = 120.
    final bottomPadding = responsive.scale(120) + bottomInset;

    final cardGap = responsive.scale(12);

    final activityRowWidth = context.screenWidth - (horizontalPadding * 2);

    final avatarSize = responsive.scale(80);
    final editBadgeSize = responsive.scale(24);

    final titleWelcomeStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(14, minSize: 12),
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: colorScheme.onSurface,
    );

    final titleNameStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(20, minSize: 16),
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: colorScheme.onSurface,
    );

    final menuTextStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(14, minSize: 12),
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: colorScheme.onSurface,
    );

    final destructiveTextStyle = menuTextStyle.copyWith(color: colorScheme.error);

    // Gradient used across icons and subtle background (derived from theme colors).
    final gradientStart = colorScheme.secondary;
    final gradientEnd =
        Color.lerp(colorScheme.secondary, colorScheme.primary, 0.35) ?? colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: colorScheme.surface)),

          // Background blurred green shape (Figma: x=-40, y=-85.54, w=467.78, h=394.6, blur=100)
          Positioned(
            left: responsive.scale(-40),
            top: responsive.scale(-85.54),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: responsive.scale(100),
                sigmaY: responsive.scale(100),
                tileMode: TileMode.decal,
              ),
              child: Container(
                width: responsive.scale(467.78),
                height: responsive.scale(394.6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsive.scale(200)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      gradientStart.withValues(alpha: 0.25),
                      gradientEnd.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button row
                  Padding(
                    padding: responsive.scalePadding(
                      EdgeInsets.only(left: 16, right: 16, top: headerTopPadding),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: WaffirBackButton(
                        size: responsive.scale(44),
                        onTap: () => context.pop(),
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.scale(32)),

                  // Avatar + welcome/name
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      children: [
                        _AvatarWithEditBadge(
                          size: avatarSize,
                          editBadgeSize: editBadgeSize,
                          borderColor: colorScheme.surface.withValues(alpha: 0.4),
                          shadowColor: Colors.black.withValues(alpha: 0.25),
                          avatarUrl: user.avatarUrl,
                          onEditTap: () {
                            // No-op for now (design-only screen)
                          },
                        ),
                        SizedBox(width: responsive.scale(16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.profile.myAccount.welcome.tr(), style: titleWelcomeStyle),
                            SizedBox(height: responsive.scale(8)),
                            Text(user.name, style: titleNameStyle),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: responsive.scale(32)),

                  // Activity cards row (width=362, gap=12)
                  Center(
                    child: SizedBox(
                      width: activityRowWidth,
                      child: Row(
                        children: [
                          Expanded(
                          child: _ActivityStatCard(
                            icon: _GradientSvgIcon(
                              assetPath: 'assets/icons/like_inactive.svg',
                              gradientStart: gradientStart,
                              gradientEnd: gradientEnd,
                              size: responsive.scale(24),
                            ),
                            label: LocaleKeys.profile.myAccount.likes
                                .tr(namedArgs: {'count': '200k'}),
                            borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                            textStyle: menuTextStyle,
                            paddingVertical: responsive.scale(16),
                            gap: responsive.scale(16),
                          ),
                          ),
                          SizedBox(width: cardGap),
                          Expanded(
                            child: _ActivityStatCard(
                            icon: _GradientSvgIcon(
                              assetPath: 'assets/icons/comment.svg',
                              gradientStart: gradientStart,
                              gradientEnd: gradientEnd,
                              size: responsive.scale(24),
                            ),
                            label: LocaleKeys.profile.myAccount.comments
                                .tr(namedArgs: {'count': '20'}),
                            borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                            textStyle: menuTextStyle,
                            paddingVertical: responsive.scale(16),
                            gap: responsive.scale(16),
                          ),
                          ),
                          SizedBox(width: cardGap),
                          Expanded(
                            child: _ActivityStatCard(
                            icon: _GradientIcon(
                              icon: Icons.favorite,
                              gradientStart: gradientStart,
                              gradientEnd: gradientEnd,
                              size: responsive.scale(24),
                            ),
                            label: LocaleKeys.profile.myAccount.votes.tr(namedArgs: {'count': '201'}),
                            borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                            textStyle: menuTextStyle,
                            paddingVertical: responsive.scale(16),
                            gap: responsive.scale(16),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.scale(24)),

                  // Menu list + dividers
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        _MenuRow(
                          label: LocaleKeys.profile.myAccount.managePersonalDetails.tr(),
                          textStyle: menuTextStyle,
                          chevronColor: colorScheme.onSurface,
                          dividerColor: colorScheme.surfaceContainerHighest,
                          onTap: () {
                            context.pushNamed(AppRouteNames.profilePersonalDetails);
                          },
                        ),
                        _MenuRow(
                          label: LocaleKeys.profile.menu.favourites.tr(),
                          textStyle: menuTextStyle,
                          chevronColor: colorScheme.onSurface,
                          dividerColor: colorScheme.surfaceContainerHighest,
                          onTap: () {
                            context.pushNamed(AppRouteNames.profileFavorites);
                          },
                        ),
                        _MenuRow(
                          label: LocaleKeys.profile.myAccount.selectedCreditCards.tr(),
                          textStyle: menuTextStyle,
                          chevronColor: colorScheme.onSurface,
                          dividerColor: colorScheme.surfaceContainerHighest,
                          onTap: () {
                            context.pushNamed(AppRouteNames.profileSelectedCreditCards);
                          },
                        ),
                        _MenuRow(
                          label: LocaleKeys.profile.myAccount.deleteAccount.tr(),
                          textStyle: destructiveTextStyle,
                          chevronColor: colorScheme.onSurface,
                          dividerColor: colorScheme.surfaceContainerHighest,
                          showDivider: false,
                          onTap: () {
                            _showDeleteAccountBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Log out button (330×48, radius 30)
                  Padding(
                    padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
                    child: Center(
                      child: SizedBox(
                        width: responsive.scale(330),
                        height: responsive.scale(48),
                        child: AppButton.primary(
                          onPressed: () {
                            // No-op for now
                          },
                          borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(30)),
                          child: Text(
                            LocaleKeys.auth.logout.tr(),
                            style: textTheme.labelLarge?.copyWith(
                              fontFamily: 'Parkinsans',
                              fontSize: responsive.scaleFontSize(14, minSize: 12),
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _AvatarWithEditBadge extends StatelessWidget {
  const _AvatarWithEditBadge({
    required this.size,
    required this.editBadgeSize,
    required this.borderColor,
    required this.shadowColor,
    required this.avatarUrl,
    required this.onEditTap,
  });

  final double size;
  final double editBadgeSize;
  final Color borderColor;
  final Color shadowColor;
  final String? avatarUrl;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: responsive.scale(2)),
            ),
            child: ClipOval(
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? Container(
                      color: colorScheme.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  : Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.person,
                            size: size * 0.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Edit badge (24×24) with shadow
          Positioned(
            right: responsive.scale(-2),
            top: responsive.scale(-2),
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
                      color: shadowColor,
                      blurRadius: responsive.scale(12),
                      offset: Offset(0, responsive.scale(0)),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.edit,
                  size: responsive.scaleWithRange(11, min: 10, max: 14),
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityStatCard extends StatelessWidget {
  const _ActivityStatCard({
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.textStyle,
    required this.paddingVertical,
    required this.gap,
  });

  final Widget icon;
  final String label;
  final Color borderColor;
  final TextStyle textStyle;
  final double paddingVertical;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: borderColor, width: responsive.scale(1)),
      ),
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: gap),
          Text(label, textAlign: TextAlign.center, style: textStyle),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.label,
    required this.textStyle,
    required this.chevronColor,
    required this.dividerColor,
    required this.onTap,
    this.showDivider = true,
  });

  final String label;
  final TextStyle textStyle;
  final Color chevronColor;
  final Color dividerColor;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      children: [
        SizedBox(
          height: responsive.scale(44),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.scale(8)),
              child: Row(
                children: [
                  Expanded(child: Text(label, style: textStyle)),
                  Icon(Icons.chevron_right, size: responsive.scale(24), color: chevronColor),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) Divider(height: responsive.scale(8), thickness: 1, color: dividerColor),
      ],
    );
  }
}

class _GradientSvgIcon extends StatelessWidget {
  const _GradientSvgIcon({
    required this.assetPath,
    required this.gradientStart,
    required this.gradientEnd,
    required this.size,
  });

  final String assetPath;
  final Color gradientStart;
  final Color gradientEnd;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStart, gradientEnd],
        ).createShader(bounds);
      },
      child: SvgPicture.asset(assetPath, width: size, height: size),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  const _GradientIcon({
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.size,
  });

  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStart, gradientEnd],
        ).createShader(bounds);
      },
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}
