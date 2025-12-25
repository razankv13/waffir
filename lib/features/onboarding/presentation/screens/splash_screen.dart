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
    final bootstrapTimeoutReached = useState(false);

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
      if (isShowingInviteDialog.value || !context.mounted) return;

      final resolvedInviteId = (pendingInviteId?.trim().isNotEmpty ?? false)
          ? pendingInviteId!.trim()
          : await extractInviteIdFromList(data);

      if (resolvedInviteId == null || resolvedInviteId.isEmpty) return;

      isShowingInviteDialog.value = true;
      try {
        final action = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            final theme = Theme.of(dialogContext);
            final colorScheme = theme.colorScheme;
            final responsive = dialogContext.responsive;
            return AlertDialog(
              title: Text(LocaleKeys.onboarding.familyInvite.title.tr()),
              content: Text(
                LocaleKeys.onboarding.familyInvite.message.tr(args: [resolvedInviteId]),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop('reject'),
                  child: Text(
                    LocaleKeys.buttons.reject.tr(),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop('accept'),
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

        if (action == null || !context.mounted) return;

        await ref
            .read(supabaseAuthBootstrapRepositoryProvider)
            .respondFamilyInvite(inviteId: resolvedInviteId, action: action);
        ref.read(pendingFamilyInviteIdProvider.notifier).clear();
        await ref.read(authBootstrapControllerProvider.notifier).refresh();

        if (context.mounted) {
          final message = action == 'accept'
              ? LocaleKeys.onboarding.familyInvite.inviteAccepted.tr()
              : LocaleKeys.onboarding.familyInvite.inviteRejected.tr();
          context.showInfoSnackBar(message: message);
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorSnackBar(message: e.toString());
        }
      } finally {
        if (context.mounted) isShowingInviteDialog.value = false;
      }
    }

    Future<void> maybeNavigate() async {
      if (!context.mounted || hasNavigated.value || isNavigating.value) return;
      isNavigating.value = true;

      try {
        bootstrapErrorMessage.value = null;

        // Keep the splash visible briefly for the brand animation.
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!context.mounted || hasNavigated.value) return;

        final settingsService = ref.read(settingsServiceProvider);
        final selectedCity = settingsService.getPreference<String>('selected_city');
        if (selectedCity == null) {
          hasNavigated.value = true;
          if (context.mounted) context.go(AppRoutes.citySelection);
          return;
        }

        if (!isAuthenticated) {
          hasNavigated.value = true;
          if (context.mounted) context.go(AppRoutes.login);
          return;
        }

        // Handle bootstrap loading with timeout
        if (bootstrap.isLoading && !bootstrapTimeoutReached.value) {
          return; // Will retry when bootstrap state changes
        }

        // If timeout reached while still loading, check profile before navigating
        if (bootstrapTimeoutReached.value && bootstrap.isLoading) {
          hasNavigated.value = true;
          if (context.mounted) {
            final user = ref.read(activeUserProvider);
            final acceptedTerms = user?.preferences['acceptedTerms'] == true;
            final hasName = user?.displayName?.trim().isNotEmpty ?? false;
            final hasGender = user?.gender?.trim().isNotEmpty ?? false;

            context.go(
              (hasName && hasGender && acceptedTerms) ? AppRoutes.home : AppRoutes.accountDetails,
            );
          }
          return;
        }

        if (bootstrap.hasError) {
          bootstrapErrorMessage.value = bootstrap.error.toString();
          return;
        }

        if (!bootstrap.hasValue) {
          // No data yet but not loading - check profile before navigating
          hasNavigated.value = true;
          if (context.mounted) {
            final user = ref.read(activeUserProvider);
            final acceptedTerms = user?.preferences['acceptedTerms'] == true;
            final hasName = user?.displayName?.trim().isNotEmpty ?? false;
            final hasGender = user?.gender?.trim().isNotEmpty ?? false;

            context.go(
              (hasName && hasGender && acceptedTerms) ? AppRoutes.home : AppRoutes.accountDetails,
            );
          }
          return;
        }

        final data = bootstrap.value;
        if (data == null) {
          // Null data - check profile before navigating
          hasNavigated.value = true;
          if (context.mounted) {
            final user = ref.read(activeUserProvider);
            final acceptedTerms = user?.preferences['acceptedTerms'] == true;
            final hasName = user?.displayName?.trim().isNotEmpty ?? false;
            final hasGender = user?.gender?.trim().isNotEmpty ?? false;

            context.go(
              (hasName && hasGender && acceptedTerms) ? AppRoutes.home : AppRoutes.accountDetails,
            );
          }
          return;
        }

        await maybeHandleFamilyInvites(data);
        if (!context.mounted || hasNavigated.value) return;

        final user = ref.read(activeUserProvider);
        final acceptedTerms = user?.preferences['acceptedTerms'] == true;
        final hasName = user?.displayName?.trim().isNotEmpty ?? false;
        final hasGender = user?.gender?.trim().isNotEmpty ?? false;

        hasNavigated.value = true;
        if (context.mounted) {
          context.go(
            (hasName && hasGender && acceptedTerms) ? AppRoutes.home : AppRoutes.accountDetails,
          );
        }
      } finally {
        isNavigating.value = false;
      }
    }

    // Bootstrap timeout: if loading takes too long, navigate anyway
    useEffect(() {
      if (!isAuthenticated || !bootstrap.isLoading || hasNavigated.value) {
        return null;
      }

      final timer = Timer(const Duration(seconds: 10), () {
        if (context.mounted && !hasNavigated.value) {
          bootstrapTimeoutReached.value = true;
        }
      });

      return timer.cancel;
    }, [isAuthenticated, bootstrap.isLoading]);

    // Use primitive values for dependencies to minimize unnecessary effect triggers
    final bootstrapHasValue = bootstrap.hasValue;
    final bootstrapHasError = bootstrap.hasError;
    final bootstrapIsLoading = bootstrap.isLoading;

    useEffect(() {
      // Early exit if already navigated
      if (hasNavigated.value) return null;
      unawaited(maybeNavigate());
      return null;
    }, [isAuthenticated, bootstrapHasValue, bootstrapHasError, bootstrapIsLoading, pendingInviteId, bootstrapTimeoutReached.value]);

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
                  if (bootstrapTimeoutReached.value) ...[
                    SizedBox(height: responsive.scale(16)),
                    Text(
                      LocaleKeys.onboarding.splash.takingLonger.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
