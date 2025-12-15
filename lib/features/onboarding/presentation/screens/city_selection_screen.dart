import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/inputs/city_list_item.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';

/// City selection screen
///
/// Allows users to select their city from a scrollable list
/// of Saudi Arabian cities (bilingual: Arabic + English)
class CitySelectionScreen extends ConsumerStatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  ConsumerState<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends ConsumerState<CitySelectionScreen> {
  String? _selectedCity;
  bool _isLoading = false;

  // Saudi cities in Arabic and English
  final List<Map<String, String>> _cities = const [
    {'ar': 'الرياض', 'en': 'Riyadh'},
    {'ar': 'جدة', 'en': 'Jeddah'},
    {'ar': 'مكة', 'en': 'Mecca'},
    {'ar': 'المدينة المنورة', 'en': 'Medina'},
    {'ar': 'الخبر', 'en': 'Khobar'},
    {'ar': 'الدمام', 'en': 'Dammam'},
    {'ar': 'تبوك', 'en': 'Tabuk'},
    {'ar': 'ابها', 'en': 'Abha'},
    {'ar': 'الطائف', 'en': 'Taif'},
    {'ar': 'القسيم', 'en': 'Qassim'},
    {'ar': 'ينبع', 'en': 'Yanbu'},
    {'ar': 'الجبيل', 'en': 'Jubail'},
    {'ar': 'نجران', 'en': 'Najran'},
    {'ar': 'جيزان', 'en': 'Jizan'},
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
            content: const Text('حدث خطأ أثناء حفظ اختيارك. يرجى المحاولة مرة أخرى.'),
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
              'اختر مدينتك',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                height: 27 / 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(height: verticalPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Semantics(
              label: 'سنعرض لك جميع الخصومات المتوفرة من البنوك والبطاقات من حولك.',
              child: Text(
                'سنعرض لك جميع الخصومات المتوفرة من البنوك والبطاقات من حولك.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  height: 27 / 20,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
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
        final cityName = city['en']!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: CityListItem(
            cityName: cityName,
            isSelected: _selectedCity == cityName,
            onTap: () {
              setState(() {
                _selectedCity = cityName;
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
            text: 'استمر',
            onPressed: isEnabled ? _onContinue : null,
            size: ButtonSize.large,
            isLoading: _isLoading,
            enabled: isEnabled,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            borderRadius: BorderRadius.circular(60),
            tooltip: _selectedCity == null ? 'يرجى اختيار مدينة للمتابعة' : null,
          ),
        ),
      ),
    );
  }
}
