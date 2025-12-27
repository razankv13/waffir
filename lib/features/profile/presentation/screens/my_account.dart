import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';
import 'package:waffir/features/profile/presentation/screens/profile_screen/widgets/profile_dialogs.dart';

/// My Account Page
///
/// Pixel-perfect implementation matching Figma node `7774:6668`.
/// Refactored to HookConsumerWidget and integrated with ProfileController
/// for real profile data and delete account functionality.
class MyAccount extends HookConsumerWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = ResponsiveHelper.of(context);

    // Watch profile state
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.asData?.value.profile;

    // Watch auth state for email
    final authStateAsync = ref.watch(authStateProvider);
    final authState = authStateAsync.asData?.value;

    // Local state for delete operation
    final isDeleting = useState(false);

    // Figma frame reference: 393×852
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Figma: back row padding top = 64. On iOS, 64 ≈ status bar (44) + 20.
    final headerTopPadding = topInset + responsive.s(20);

    final horizontalPadding = responsive.s(16);

    // Figma: root padding bottom = 120.
    final bottomPadding = responsive.s(120) + bottomInset;

    final cardGap = responsive.s(12);

    final activityRowWidth = responsive.screenWidth - (horizontalPadding * 2);

    final avatarSize = responsive.s(80);
    final editBadgeSize = responsive.s(24);

    final titleWelcomeStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(14, minSize: 12),
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: colorScheme.onSurface,
    );

    final titleNameStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(20, minSize: 16),
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: colorScheme.onSurface,
    );

    final menuTextStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(14, minSize: 12),
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: colorScheme.onSurface,
    );

    final destructiveTextStyle = menuTextStyle.copyWith(color: colorScheme.error);

    // Gradient used across icons and subtle background (derived from theme colors).
    final gradientStart = colorScheme.secondary;
    final gradientEnd =
        Color.lerp(colorScheme.secondary, colorScheme.primary, 0.35) ?? colorScheme.primary;

    void showDeleteAccountBottomSheet() {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        useSafeArea: false,
        builder: (sheetContext) {
          return _DeleteAccountBottomSheet(
            onConfirm: () async {
              Navigator.of(sheetContext).pop();
              isDeleting.value = true;

              final failure = await ref
                  .read(profileControllerProvider.notifier)
                  .requestAccountDeletion();

              isDeleting.value = false;

              if (!context.mounted) return;

              if (failure == null) {
                // Account deletion requested, sign out
                await ref.read(authControllerProvider.notifier).signOut();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.message),
                    backgroundColor: colorScheme.error,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            onCancel: () => Navigator.of(sheetContext).pop(),
          );
        },
      );
    }

    // Show loading if profile is not loaded yet
    if (profileAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: colorScheme.surface)),

          // Background blurred green shape (Figma: x=-40, y=-85.54, w=467.78, h=394.6, blur=100)
          const BlurredBackground(),

          // Loading overlay when deleting
          if (isDeleting.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: WaffirBackButton(size: responsive.s(44), onTap: () => context.pop()),
                  ),

                  SizedBox(height: responsive.s(32)),

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
                          avatarUrl: profile?.avatarUrl,
                          onEditTap: () {
                            // Navigate to personal details for editing
                            context.pushNamed(AppRouteNames.profilePersonalDetails);
                          },
                        ),
                        SizedBox(width: responsive.s(16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.profile.myAccount.welcome.tr(),
                              style: titleWelcomeStyle,
                            ),
                            SizedBox(height: responsive.s(8)),
                            Text(profile?.displayName ?? 'User', style: titleNameStyle),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: responsive.s(32)),

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
                                size: responsive.s(24),
                              ),
                              label: LocaleKeys.profile.myAccount.likes.tr(
                                namedArgs: {'count': '200k'},
                              ),
                              borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                              textStyle: menuTextStyle,
                              paddingVertical: responsive.s(16),
                              gap: responsive.s(16),
                            ),
                          ),
                          SizedBox(width: cardGap),
                          Expanded(
                            child: _ActivityStatCard(
                              icon: _GradientSvgIcon(
                                assetPath: 'assets/icons/comment.svg',
                                gradientStart: gradientStart,
                                gradientEnd: gradientEnd,
                                size: responsive.s(24),
                              ),
                              label: LocaleKeys.profile.myAccount.comments.tr(
                                namedArgs: {'count': '20'},
                              ),
                              borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                              textStyle: menuTextStyle,
                              paddingVertical: responsive.s(16),
                              gap: responsive.s(16),
                            ),
                          ),
                          SizedBox(width: cardGap),
                          Expanded(
                            child: _ActivityStatCard(
                              icon: _GradientIcon(
                                icon: Icons.favorite,
                                gradientStart: gradientStart,
                                gradientEnd: gradientEnd,
                                size: responsive.s(24),
                              ),
                              label: LocaleKeys.profile.myAccount.votes.tr(
                                namedArgs: {'count': '201'},
                              ),
                              borderColor: colorScheme.onSurface.withValues(alpha: 0.05),
                              textStyle: menuTextStyle,
                              paddingVertical: responsive.s(16),
                              gap: responsive.s(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.s(24)),

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
                          onTap: showDeleteAccountBottomSheet,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Log out button (330×48, radius 30)
                  Padding(
                    padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
                    child: Center(
                      child: SizedBox(
                        width: responsive.s(330),
                        height: responsive.s(48),
                        child: AppButton.primary(
                          onPressed: () {
                            ProfileDialogs.showSignOutDialog(context, ref);
                          },
                          borderRadius: responsive.sBorderRadius(BorderRadius.circular(30)),
                          child: Text(
                            LocaleKeys.auth.logout.tr(),
                            style: textTheme.labelLarge?.copyWith(
                              fontFamily: 'Parkinsans',
                              fontSize: responsive.sFont(14, minSize: 12),
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

class _DeleteAccountBottomSheet extends StatelessWidget {
  const _DeleteAccountBottomSheet({required this.onConfirm, required this.onCancel});

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: responsive.s(48) + bottomInset),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.s(24))),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B1B1B).withValues(alpha: 0.12),
            blurRadius: responsive.s(25),
            offset: Offset(responsive.s(2), responsive.s(4)),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: responsive.sPadding(const EdgeInsets.fromLTRB(6, 6, 6, 0)),
            child: SizedBox(
              height: responsive.s(44),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: responsive.s(10)),
                      child: Container(
                        width: responsive.s(32),
                        height: responsive.s(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(responsive.s(9999)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: responsive.s(44),
                      height: responsive.s(44),
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onCancel,
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: responsive.s(32),
                              height: responsive.s(32),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.close_rounded,
                                size: responsive.sConstrained(16, min: 14, max: 18),
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
            padding: EdgeInsets.symmetric(horizontal: responsive.s(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: responsive.s(8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.s(16)),
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.profile.myAccount.deleteAccount.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'Parkinsans',
                          fontWeight: FontWeight.w700,
                          fontSize: responsive.sFont(18, minSize: 16),
                          height: 1.4,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: responsive.s(12)),
                      Text(
                        LocaleKeys.profile.myAccount.deleteDescription.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Parkinsans',
                          fontWeight: FontWeight.w400,
                          fontSize: responsive.sFont(14, minSize: 12),
                          height: 1.4,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.s(32)),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: responsive.s(48),
                      child: AppButton.primary(
                        onPressed: onConfirm,
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        borderRadius: responsive.sBorderRadius(BorderRadius.circular(30)),
                        child: Text(
                          LocaleKeys.profile.myAccount.confirmDelete.tr(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontFamily: 'Parkinsans',
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.sFont(14, minSize: 12),
                            height: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.s(12)),
                    SizedBox(
                      width: double.infinity,
                      height: responsive.s(48),
                      child: AppButton.secondary(
                        onPressed: onCancel,
                        borderRadius: responsive.sBorderRadius(BorderRadius.circular(30)),
                        foregroundColor: colorScheme.onSurface,
                        child: Text(
                          LocaleKeys.buttons.cancel.tr(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontFamily: 'Parkinsans',
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.sFont(14, minSize: 12),
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
    final responsive = ResponsiveHelper.of(context);
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
              border: Border.all(color: borderColor, width: responsive.s(2)),
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
                  : AppNetworkImage.avatar(
                      imageUrl: avatarUrl!,
                      size: size,
                      useResponsiveScaling: false, // Size already scaled
                      errorWidget: Container(
                        color: colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person,
                          size: size * 0.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
            ),
          ),

          // Edit badge (24×24) with shadow
          Positioned(
            right: responsive.s(-2),
            top: responsive.s(-2),
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
                      blurRadius: responsive.s(12),
                      offset: Offset(0, responsive.s(0)),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.edit,
                  size: responsive.sConstrained(11, min: 10, max: 14),
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
    final responsive = ResponsiveHelper.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: borderColor, width: responsive.s(1)),
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
    final responsive = ResponsiveHelper.of(context);

    return Column(
      children: [
        SizedBox(
          height: responsive.s(44),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.s(8)),
              child: Row(
                children: [
                  Expanded(child: Text(label, style: textStyle)),
                  Icon(Icons.chevron_right, size: responsive.s(24), color: chevronColor),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) Divider(height: responsive.s(8), thickness: 1, color: dividerColor),
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
