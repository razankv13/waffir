import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/inputs/city_list_item.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';

/// City selection screen
///
/// Allows users to select their city from a scrollable list
class CitySelectionScreen extends ConsumerStatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  ConsumerState<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends ConsumerState<CitySelectionScreen> {
  String? _selectedCity;
  bool _isLoading = false;

  // City data with ID (for storage) and translation key (for display)
  final List<({String id, String key})> _cities = [
    (id: 'Riyadh', key: LocaleKeys.cities.riyadh),
    (id: 'Jeddah', key: LocaleKeys.cities.jeddah),
    (id: 'Mecca', key: LocaleKeys.cities.mecca),
    (id: 'Medina', key: LocaleKeys.cities.medina),
    (id: 'Khobar', key: LocaleKeys.cities.khobar),
    (id: 'Dammam', key: LocaleKeys.cities.dammam),
    (id: 'Tabuk', key: LocaleKeys.cities.tabuk),
    (id: 'Abha', key: LocaleKeys.cities.abha),
    (id: 'Taif', key: LocaleKeys.cities.taif),
    (id: 'Qassim', key: LocaleKeys.cities.qassim),
    (id: 'Yanbu', key: LocaleKeys.cities.yanbu),
    (id: 'Jubail', key: LocaleKeys.cities.jubail),
    (id: 'Najran', key: LocaleKeys.cities.najran),
    (id: 'Jizan', key: LocaleKeys.cities.jizan),
  ];

  Future<void> _onContinue() async {
    if (_selectedCity == null || _isLoading) return;

    // Haptic feedback for primary action
    unawaited(HapticFeedback.mediumImpact());

    setState(() => _isLoading = true);

    try {
      // Save selected city to settings
      final settingsService = ref.read(settingsServiceProvider);
      await settingsService.setPreference<String>('selected_city', _selectedCity!);

      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.errors.saveSelection.tr()),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final responsive = context.responsive;

    // Responsive dimensions
    final horizontalPadding = size.width > 600 ? 32.0 : 24.0;
    final headerVerticalPadding = size.height > 700 ? 24.0 : 16.0;
    final footerBottomPadding = size.height > 700 ? 48.0 : 32.0;

    bool showBackButton = context.pathParameters is Map<String, dynamic>
        ? (context.pathParameters as Map<String, dynamic>)['showBackButton'] == 'true'
            ? true
            : false
        : true;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Blurred background matching Figma design
            const BlurredBackground(),
            Column(
              children: [
                if (showBackButton) WaffirBackButton(size: responsive.scale(44)),
                // Header section with gradient fade
                _buildHeaderSection(
                  context,
                  theme,
                  colorScheme,
                  horizontalPadding,
                  headerVerticalPadding,
                ),

                // Scrollable city list (takes remaining space)
                Expanded(child: _buildCityList(context, colorScheme, horizontalPadding)),

                // Footer section with continue button
                _buildFooterSection(
                  context,
                  theme,
                  colorScheme,
                  horizontalPadding,
                  footerBottomPadding,
                  size.width,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with title and description
  Widget _buildHeaderSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double horizontalPadding,
    double verticalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              LocaleKeys.onboarding.citySelection.title.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                height: 27 / 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              // textDirection removed to respect locale
            ),
          ),
          SizedBox(height: verticalPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Semantics(
              label: LocaleKeys.onboarding.citySelection.subtitle.tr(),
              child: Text(
                LocaleKeys.onboarding.citySelection.subtitle.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  height: 27 / 20,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                // textDirection removed to respect locale
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the scrollable city list
  Widget _buildCityList(BuildContext context, ColorScheme colorScheme, double horizontalPadding) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      itemCount: _cities.length,
      itemBuilder: (context, index) {
        final city = _cities[index];
        final cityId = city.id;
        final cityKey = city.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: CityListItem(
            cityName: cityKey.tr(),
            isSelected: _selectedCity == cityId,
            onTap: () {
              setState(() {
                _selectedCity = cityId;
              });
            },
          ),
        );
      },
    );
  }

  /// Builds the footer section with continue button
  Widget _buildFooterSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double horizontalPadding,
    double bottomPadding,
    double screenWidth,
  ) {
    final isEnabled = _selectedCity != null && !_isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 32,
        bottom: bottomPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth > 600 ? 600 : double.infinity),
          child: AppButton.primary(
            text: LocaleKeys.buttons.continueBtn.tr(),
            onPressed: isEnabled ? _onContinue : null,
            size: ButtonSize.large,
            isLoading: _isLoading,
            enabled: isEnabled,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            borderRadius: BorderRadius.circular(60),
            tooltip: _selectedCity == null ? LocaleKeys.validation.selectCity.tr() : null,
          ),
        ),
      ),
    );
  }
}
