import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';

enum _NotificationType { allOffers, topOffers }

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _pushEnabled = false;
  bool _emailEnabled = true;

  bool _hotDeals = true;
  bool _storeOffers = true;
  bool _bankCardsOffers = true;

  _NotificationType _notificationType = _NotificationType.allOffers;

  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    // Simulate persistence.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _isSaving = false);

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.clearSnackBars();
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('Saved'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    final topInset = MediaQuery.paddingOf(context).top;

    final contentTop = topInset + responsive.scale(context.responsive.topSafeArea + 8);

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
                        title: 'Notifications',
                        responsive: responsive,
                        child: Column(
                          children: [
                            _ToggleRow(
                              title: 'Push Notifications',
                              value: _pushEnabled,
                              responsive: responsive,
                              onChanged: (value) => setState(() => _pushEnabled = value),
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _CheckboxGroup(
                              responsive: responsive,
                              enabled: _pushEnabled,
                              items: [
                                _CheckboxItemData(
                                  label: 'Hot Deals',
                                  value: _hotDeals,
                                  onChanged: (v) => setState(() => _hotDeals = v),
                                ),
                                _CheckboxItemData(
                                  label: 'Store Offers',
                                  value: _storeOffers,
                                  onChanged: (v) => setState(() => _storeOffers = v),
                                ),
                                _CheckboxItemData(
                                  label: 'Bank Cards Offers',
                                  value: _bankCardsOffers,
                                  onChanged: (v) => setState(() => _bankCardsOffers = v),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _DividerLine(responsive: responsive),
                            SizedBox(height: responsive.scale(12)),
                            _ToggleRow(
                              title: 'Email Notifications',
                              value: _emailEnabled,
                              responsive: responsive,
                              onChanged: (value) => setState(() => _emailEnabled = value),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.scale(32)),
                      _Section(
                        title: 'Notification Type',
                        responsive: responsive,
                        child: Column(
                          children: [
                            _RadioRow(
                              title: 'All Offers',
                              subtitle: 'Every New Deal',
                              isSelected: _notificationType == _NotificationType.allOffers,
                              responsive: responsive,
                              onTap: () =>
                                  setState(() => _notificationType = _NotificationType.allOffers),
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _DividerLine(responsive: responsive),
                            SizedBox(height: responsive.scale(12)),
                            _RadioRow(
                              title: 'Top Offers',
                              subtitle: 'Only notify me when deals are hot (20+ likes)',
                              isSelected: _notificationType == _NotificationType.topOffers,
                              responsive: responsive,
                              onTap: () =>
                                  setState(() => _notificationType = _NotificationType.topOffers),
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
                      text: 'Save',
                      isLoading: _isSaving,
                      enabled: !_isSaving,
                      onPressed: _isSaving ? null : _save,
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

class _BackgroundBlurShape extends StatelessWidget {
  const _BackgroundBlurShape({required this.responsive});

  final ResponsiveHelper responsive;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: responsive.scale(-40),
      top: responsive.scale(-100),
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            width: responsive.scale(467.78),
            height: responsive.scale(461.3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(responsive.scale(240)),
              gradient: const RadialGradient(
                colors: [Color(0xFFDCFCE7), Color(0x00DCFCE7)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
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
                fontSize: responsive.scaleFontSize(12, minSize: 10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: responsive.scaleFontSize(11.9, minSize: 10),
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
