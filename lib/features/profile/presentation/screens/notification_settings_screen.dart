import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/providers/push_notification_providers.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';

enum _NotificationType { allOffers, topOffers }

/// Notification Settings Screen
///
/// Refactored to HookConsumerWidget and integrated with ProfileController
/// for persisting notification settings to Supabase backend.
class NotificationSettingsScreen extends HookConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    // Watch profile state
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.asData?.value.profile;

    // Local state using hooks
    final pushEnabled = useState(profile?.notifyPushEnabled ?? false);
    final emailEnabled = useState(profile?.notifyEmailEnabled ?? true);

    // Local checkboxes (not persisted to backend yet - UI only)
    final hotDeals = useState(true);
    final storeOffers = useState(true);
    final bankCardsOffers = useState(true);

    // Notification type based on profile's notifyOfferPreference
    final notificationType = useState(
      profile?.notifyOfferPreference == 'popular'
          ? _NotificationType.topOffers
          : _NotificationType.allOffers,
    );

    final isSaving = useState(false);

    // Sync local state when profile data changes
    useEffect(() {
      if (profile != null) {
        pushEnabled.value = profile.notifyPushEnabled;
        emailEnabled.value = profile.notifyEmailEnabled;
        notificationType.value = profile.notifyOfferPreference == 'popular'
            ? _NotificationType.topOffers
            : _NotificationType.allOffers;
      }
      return null;
    }, [profile?.notifyPushEnabled, profile?.notifyEmailEnabled, profile?.notifyOfferPreference]);

    // Check device push permission on mount
    useEffect(() {
      Future<void> checkPermission() async {
        try {
          final hasPermission = await ref.read(pushNotificationPermissionProvider.future);
          pushEnabled.value = hasPermission && (profile?.notifyPushEnabled ?? false);
        } catch (_) {
          // If push notification service isn't available, keep current state
        }
      }

      checkPermission();
      return null;
    }, const []);

    Future<void> save() async {
      if (isSaving.value) return;

      isSaving.value = true;

      // Convert notification type to preference string
      final offerPreference =
          notificationType.value == _NotificationType.topOffers ? 'popular' : 'all';

      // Call profile controller to save notification settings
      final failure = await ref.read(profileControllerProvider.notifier).updateNotificationSettings(
            notifyPushEnabled: pushEnabled.value,
            notifyEmailEnabled: emailEnabled.value,
            notifyOfferPreference: offerPreference,
          );

      isSaving.value = false;

      if (!context.mounted) return;

      if (failure == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.success.saved.tr()),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: theme.colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    Future<void> handlePushToggle(bool value) async {
      if (value) {
        try {
          final service = ref.read(pushNotificationServiceProvider);
          final settings = await service.requestPermissions();
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            pushEnabled.value = true;
            ref.invalidate(pushNotificationPermissionProvider);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permission denied. Please enable in device settings.'),
                ),
              );
            }
            pushEnabled.value = false;
          }
        } catch (_) {
          // Push notification service not available
          pushEnabled.value = false;
        }
      } else {
        // Cannot disable programmatically
        pushEnabled.value = false;
      }
    }

    final topInset = MediaQuery.paddingOf(context).top;
    final contentTop = topInset + responsive.scale(context.responsive.topSafeArea + 8);

    // Show loading if profile is not loaded yet
    if (profileAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          const BlurredBackground(),

          // Main content + bottom button (space-between with bottom padding 120)
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: responsive.scale(16),
                    right: responsive.scale(16),
                    top: contentTop,
                    bottom: responsive.scale(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Section(
                        title: LocaleKeys.profile.notificationSettings.title.tr(),
                        responsive: responsive,
                        child: Column(
                          children: [
                            _ToggleRow(
                              title: LocaleKeys.profile.notificationSettings.pushNotifications.tr(),
                              value: pushEnabled.value,
                              responsive: responsive,
                              onChanged: handlePushToggle,
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _CheckboxGroup(
                              responsive: responsive,
                              enabled: pushEnabled.value,
                              items: [
                                _CheckboxItemData(
                                  label: LocaleKeys.profile.notificationSettings.hotDeals.tr(),
                                  value: hotDeals.value,
                                  onChanged: (v) => hotDeals.value = v,
                                ),
                                _CheckboxItemData(
                                  label: LocaleKeys.profile.notificationSettings.storeOffers.tr(),
                                  value: storeOffers.value,
                                  onChanged: (v) => storeOffers.value = v,
                                ),
                                _CheckboxItemData(
                                  label: LocaleKeys.profile.notificationSettings.bankCardsOffers.tr(),
                                  value: bankCardsOffers.value,
                                  onChanged: (v) => bankCardsOffers.value = v,
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _DividerLine(responsive: responsive),
                            SizedBox(height: responsive.scale(12)),
                            _ToggleRow(
                              title: LocaleKeys.profile.notificationSettings.emailNotifications.tr(),
                              value: emailEnabled.value,
                              responsive: responsive,
                              onChanged: (value) => emailEnabled.value = value,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.scale(32)),
                      _Section(
                        title: LocaleKeys.profile.notificationSettings.typeTitle.tr(),
                        responsive: responsive,
                        child: Column(
                          children: [
                            _RadioRow(
                              title: LocaleKeys.profile.notificationSettings.allOffers.tr(),
                              subtitle: LocaleKeys.profile.notificationSettings.allOffersSubtitle.tr(),
                              isSelected: notificationType.value == _NotificationType.allOffers,
                              responsive: responsive,
                              onTap: () => notificationType.value = _NotificationType.allOffers,
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _DividerLine(responsive: responsive),
                            SizedBox(height: responsive.scale(12)),
                            _RadioRow(
                              title: LocaleKeys.profile.notificationSettings.topOffers.tr(),
                              subtitle: LocaleKeys.profile.notificationSettings.topOffersSubtitle.tr(),
                              isSelected: notificationType.value == _NotificationType.topOffers,
                              responsive: responsive,
                              onTap: () => notificationType.value = _NotificationType.topOffers,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: responsive.scale(16),
                  right: responsive.scale(16),
                  bottom: responsive.scale(120),
                ),
                child: Center(
                  child: SizedBox(
                    width: responsive.scale(330),
                    child: AppButton.primary(
                      text: LocaleKeys.buttons.save.tr(),
                      isLoading: isSaving.value,
                      enabled: !isSaving.value,
                      onPressed: isSaving.value ? null : save,
                      width: responsive.scale(330),
                      borderRadius: BorderRadius.circular(responsive.scale(30)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Back button
          WaffirBackButton(size: responsive.scale(44)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.responsive, required this.child});

  final String title;
  final ResponsiveHelper responsive;
  final Widget child;

  static const _kTitleColor = Color(0xFF0F352D);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: responsive.scaleFontSize(20, minSize: 16),
            height: 1.15,
            color: _kTitleColor,
          ),
        ),
        SizedBox(height: responsive.scale(32)),
        child,
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.responsive,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ResponsiveHelper responsive;
  final ValueChanged<bool> onChanged;

  static const _kTextColor = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.scale(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: responsive.scaleFontSize(16, minSize: 14),
                height: 1.15,
                color: _kTextColor,
              ),
            ),
          ),
          _ScaledToggleSwitch(responsive: responsive, value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ScaledToggleSwitch extends StatelessWidget {
  const _ScaledToggleSwitch({
    required this.responsive,
    required this.value,
    required this.onChanged,
  });

  final ResponsiveHelper responsive;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsive.scale(52),
      height: responsive.scale(32),
      child: FittedBox(
        fit: BoxFit.fill,
        child: CustomToggleSwitch(value: value, onChanged: onChanged),
      ),
    );
  }
}

class _CheckboxItemData {
  const _CheckboxItemData({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
}

class _CheckboxGroup extends StatelessWidget {
  const _CheckboxGroup({required this.responsive, required this.enabled, required this.items});

  final ResponsiveHelper responsive;
  final bool enabled;
  final List<_CheckboxItemData> items;

  static const _kSubtleTextColor = Color(0xFFA3A3A3);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(12)),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _CheckboxRow(
              label: items[i].label,
              value: items[i].value,
              enabled: enabled,
              responsive: responsive,
              textStyle: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: responsive.scaleFontSize(12),
                height: 1.15,
                color: _kSubtleTextColor,
              ),
              onTap: () => items[i].onChanged(!items[i].value),
            ),
            if (i != items.length - 1) SizedBox(height: responsive.scale(8)),
          ],
        ],
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.label,
    required this.value,
    required this.enabled,
    required this.responsive,
    required this.textStyle,
    required this.onTap,
  });

  final String label;
  final bool value;
  final bool enabled;
  final ResponsiveHelper responsive;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = enabled ? onTap : null;

    return InkWell(
      onTap: effectiveOnTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: responsive.scale(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: textStyle)),
            _FigmaCheckbox(responsive: responsive, checked: value, enabled: enabled),
          ],
        ),
      ),
    );
  }
}

class _FigmaCheckbox extends StatelessWidget {
  const _FigmaCheckbox({required this.responsive, required this.checked, required this.enabled});

  final ResponsiveHelper responsive;
  final bool checked;
  final bool enabled;

  static const _kCheckedFill = Color(0xFF0F352D);
  static const _kAccentColor = Color(0xFF00FF88);
  static const _kDisabledFill = Color(0xFFCECECE);
  static const _kDisabledCheck = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    final size = responsive.scale(24);

    final fillColor = enabled ? _kCheckedFill : _kDisabledFill;
    final checkColor = enabled ? _kAccentColor : _kDisabledCheck;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: checked ? fillColor : Colors.transparent,
          borderRadius: BorderRadius.circular(responsive.scale(4)),
        ),
        child: checked
            ? Center(
                child: Icon(Icons.check, size: responsive.scale(14), color: checkColor),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.responsive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final ResponsiveHelper responsive;
  final VoidCallback onTap;

  static const _kTextColor = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.scale(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: responsive.scaleFontSize(16, minSize: 14),
                      height: 1.15,
                      color: _kTextColor,
                    ),
                  ),
                  SizedBox(height: responsive.scale(12)),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: responsive.scaleFontSize(11.9),
                      height: 1.15,
                      color: _kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            _FigmaRadio(responsive: responsive, selected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _FigmaRadio extends StatelessWidget {
  const _FigmaRadio({required this.responsive, required this.selected});

  final ResponsiveHelper responsive;
  final bool selected;

  static const _kRingColor = Color(0xFF0F352D);
  static const _kDotColor = Color(0xFF00FF88);

  @override
  Widget build(BuildContext context) {
    final size = responsive.scale(24);

    if (selected) {
      return SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _kRingColor,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Center(
            child: Container(
              width: responsive.scale(8),
              height: responsive.scale(8),
              decoration: const BoxDecoration(color: _kDotColor, shape: BoxShape.circle),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(color: _kRingColor, width: responsive.scale(2)),
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({required this.responsive});

  final ResponsiveHelper responsive;

  static const _kDividerColor = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, height: responsive.scale(1), color: _kDividerColor);
  }
}
