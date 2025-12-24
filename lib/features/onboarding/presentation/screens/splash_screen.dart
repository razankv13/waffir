import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/auth/data/providers/auth_bootstrap_providers.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_bootstrap_data.dart';
import 'package:waffir/gen/assets.gen.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final isMounted = context.mounted;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final fadeAnimation = useMemoized(
      () => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut)),
      [animationController],
    );

    final hasNavigated = useState(false);
    final isNavigating = useRef(false);
    final isShowingInviteDialog = useState(false);
    final bootstrapErrorMessage = useState<String?>(null);

    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final bootstrap = ref.watch(authBootstrapControllerProvider);
    final pendingInviteId = ref.watch(pendingFamilyInviteIdProvider);

    useEffect(() {
      animationController.forward();
      return null;
    }, [animationController]);

    Future<String?> extractInviteIdFromList(AuthBootstrapData data) async {
      for (final invite in data.familyInvites) {
        final id = invite['invite_id'] ?? invite['inviteId'] ?? invite['id'];
        if (id is String && id.trim().isNotEmpty) return id.trim();
        if (id != null && id.toString().trim().isNotEmpty) return id.toString().trim();
      }
      return null;
    }

    Future<void> maybeHandleFamilyInvites(AuthBootstrapData data) async {
      if (isShowingInviteDialog.value || !isMounted) return;

      final resolvedInviteId = (pendingInviteId?.trim().isNotEmpty ?? false)
          ? pendingInviteId!.trim()
          : await extractInviteIdFromList(data);

      if (resolvedInviteId == null || resolvedInviteId.isEmpty) return;

      isShowingInviteDialog.value = true;
      try {
        final action = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final responsive = context.responsive;
            return AlertDialog(
              title: Text(LocaleKeys.onboarding.familyInvite.title.tr()),
              content: Text(
                LocaleKeys.onboarding.familyInvite.message.tr(args: [resolvedInviteId]),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop('reject'),
                  child: Text(
                    LocaleKeys.buttons.reject.tr(),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop('accept'),
                  style: FilledButton.styleFrom(
                    padding: responsive.scalePadding(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  child: Text(LocaleKeys.buttons.accept.tr()),
                ),
              ],
            );
          },
        );

        if (action == null || !isMounted) return;

        await ref
            .read(supabaseAuthBootstrapRepositoryProvider)
            .respondFamilyInvite(inviteId: resolvedInviteId, action: action);
        ref.read(pendingFamilyInviteIdProvider.notifier).clear();
        await ref.read(authBootstrapControllerProvider.notifier).refresh();

        if (isMounted) {
          final message = action == 'accept'
              ? LocaleKeys.onboarding.familyInvite.inviteAccepted.tr()
              : LocaleKeys.onboarding.familyInvite.inviteRejected.tr();
          context.showInfoSnackBar(message: message);
        }
      } catch (e) {
        if (isMounted) {
          context.showErrorSnackBar(message: e.toString());
        }
      } finally {
        if (isMounted) isShowingInviteDialog.value = false;
      }
    }

    Future<void> maybeNavigate() async {
      if (!isMounted || hasNavigated.value || isNavigating.value) return;
      isNavigating.value = true;

      try {
        bootstrapErrorMessage.value = null;

        // Keep the splash visible briefly for the brand animation.
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!isMounted || hasNavigated.value) return;

        final settingsService = ref.read(settingsServiceProvider);
        final selectedCity = settingsService.getPreference<String>('selected_city');
        if (selectedCity == null) {
          hasNavigated.value = true;
          context.go(AppRoutes.citySelection);
          return;
        }

        if (!isAuthenticated) {
          hasNavigated.value = true;
          context.go(AppRoutes.login);
          return;
        }

        if (bootstrap.isLoading) return;

        if (bootstrap.hasError) {
          bootstrapErrorMessage.value = bootstrap.error.toString();
          return;
        }

        if (!bootstrap.hasValue) return;
        final data = bootstrap.value;
        if (data == null) return;

        await maybeHandleFamilyInvites(data);
        if (!isMounted || hasNavigated.value) return;

        final user = ref.read(activeUserProvider);
        final acceptedTerms = user?.preferences['acceptedTerms'] == true;
        final hasName = user?.displayName?.trim().isNotEmpty ?? false;
        final hasGender = user?.gender?.trim().isNotEmpty ?? false;

        hasNavigated.value = true;
        context.go(
          (hasName && hasGender && acceptedTerms) ? AppRoutes.home : AppRoutes.accountDetails,
        );
      } finally {
        isNavigating.value = false;
      }
    }

    useEffect(() {
      unawaited(maybeNavigate());
      return null;
    }, [isAuthenticated, bootstrap, pendingInviteId]);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(context),
                SizedBox(height: responsive.scale(40)),
                _buildAppName(context),
                if (isAuthenticated && bootstrap.isLoading) ...[
                  SizedBox(height: responsive.scale(24)),
                  CircularProgressIndicator(color: colorScheme.secondary),
                ],
                if (bootstrapErrorMessage.value != null) ...[
                  SizedBox(height: responsive.scale(24)),
                  Padding(
                    padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 24)),
                    child: Text(
                      bootstrapErrorMessage.value!,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: responsive.scale(16)),
                  FilledButton(
                    onPressed: () => ref.read(authBootstrapControllerProvider.notifier).refresh(),
                    child: Text(LocaleKeys.buttons.retry.tr()),
                  ),
                  TextButton(
                    onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                    child: Text(
                      LocaleKeys.auth.logout.tr(),
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final responsive = context.responsive;
    return Hero(
      tag: 'app_logo',
      child: Image.asset(
        Assets.icons.appIconNoBg.path,
        width: responsive.scaleWithRange(220, min: 160, max: 280),
        height: responsive.scaleWithRange(217, min: 156, max: 280),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAppName(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Hero(
      tag: 'app_name',
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'وفـــــــر',
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: responsive.scaleFontSize(52, minSize: 28),
                fontWeight: FontWeight.w900,
                color: colorScheme.secondary,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              textDirection: ui.TextDirection.rtl,
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              'waffir',
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: responsive.scaleFontSize(40, minSize: 22),
                fontWeight: FontWeight.w700,
                color: colorScheme.secondary,
                height: 1.0,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
