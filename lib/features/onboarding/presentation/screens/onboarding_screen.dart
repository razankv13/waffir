import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/storage/settings_service.dart';

/// Onboarding screen with language selection and gradient background
///
/// Features:
/// - Bilingual content (English + Arabic) displayed simultaneously
/// - Language toggle buttons with visual selection state
/// - Beautiful gradient background illustration
/// - Responsive design matching Figma specifications
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isArabic = false;

  void _selectLanguage(String languageCode) {
    HapticFeedback.selectionClick();
    setState(() {
      _isArabic = languageCode == 'ar';
    });
    context.setLocale(Locale(languageCode));
  }

  Future<void> _continue() async {
    unawaited(HapticFeedback.mediumImpact());
    final settingsService = ref.read(settingsServiceProvider);
    await settingsService.completeOnboarding();

    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    // Define responsive breakpoints
    final isExtraSmall = screenHeight < 650;
    final isSmall = screenHeight >= 650 && screenHeight < 750;
    // Medium is >= 750 && < 900
    // Large is >= 900

    // Calculate responsive values
    final gradientHeight = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: screenHeight * 0.28,
      small: screenHeight * 0.32,
      medium: screenHeight * 0.34,
      large: screenHeight * 0.38,
    );

    final titleFontSize = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: 20.0,
      small: 22.0,
      medium: 24.0,
      large: 25.4,
    );

    final bodyFontSize = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: 13.0,
      small: 14.0,
      medium: 15.0,
      large: 16.0,
    );

    final sectionSpacing = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: 16.0,
      small: 24.0,
      medium: 28.0,
      large: 40.0,
    );

    final buttonSpacing = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: 16.0,
      small: 24.0,
      medium: 28.0,
      large: 40.0,
    );

    final bottomPadding = _getResponsiveValue(
      screenHeight: screenHeight,
      extraSmall: 16.0,
      small: 20.0,
      medium: 20.0,
      large: 32.0,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/onboarding_gradient.png',
                fit: BoxFit.cover,
                height: gradientHeight,
              ),
            ),

            // Main content without scrolling
            Column(
              children: [
                SizedBox(height: gradientHeight),

                // Progress indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: _buildProgressIndicators(colorScheme),
                ),

                // English Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExtraSmall ? 16 : 24,
                  ),
                  child: _buildContentSection(
                    title: 'Welcome to ',
                    brandName: 'waffir',
                    bulletPoints: const [
                      'Find the best discounts in one place.',
                      'Compare offers and save instantly.',
                      'Never miss a deal again.',
                    ],
                    isArabic: false,
                    theme: theme,
                    colorScheme: colorScheme,
                    titleFontSize: titleFontSize,
                    bodyFontSize: bodyFontSize,
                    isCompact: isExtraSmall || isSmall,
                  ),
                ),

                SizedBox(height: sectionSpacing),

                // Arabic Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExtraSmall ? 16 : 24,
                  ),
                  child: _buildContentSection(
                    title: 'مرحباً بكم في ',
                    brandName: 'وفــــر',
                    bulletPoints: const [
                      'اعثر على أفضل الخصومات في مكان واحد.',
                      'قارن العروض ووفّر فورًا.',
                      'لا تفوّت أي عرض بعد الآن.',
                    ],
                    isArabic: true,
                    theme: theme,
                    colorScheme: colorScheme,
                    titleFontSize: titleFontSize,
                    bodyFontSize: bodyFontSize,
                    isCompact: isExtraSmall || isSmall,
                  ),
                ),

                // Flexible space to push buttons to bottom
                const Expanded(child: SizedBox()),

                // Language selection buttons
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExtraSmall ? 32 : 56,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildLanguageButton(
                          label: 'العربية',
                          isSelected: _isArabic,
                          onTap: () => _selectLanguage('ar'),
                          theme: theme,
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildLanguageButton(
                          label: 'English',
                          isSelected: !_isArabic,
                          onTap: () => _selectLanguage('en'),
                          theme: theme,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: buttonSpacing),

                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildContinueButton(
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                ),

                SizedBox(height: bottomPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to get responsive values based on screen height
  double _getResponsiveValue({
    required double screenHeight,
    required double extraSmall,
    required double small,
    required double medium,
    required double large,
  }) {
    if (screenHeight < 650) return extraSmall;
    if (screenHeight < 750) return small;
    if (screenHeight < 900) return medium;
    return large;
  }

  /// Builds a content section with title and bullet points
  Widget _buildContentSection({
    required String title,
    required String brandName,
    required List<String> bulletPoints,
    required bool isArabic,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required double titleFontSize,
    required double bodyFontSize,
    required bool isCompact,
  }) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final titleHeight = isCompact ? 1.3 : 1.4;
    final bodyHeight = isCompact ? 1.4 : 1.5;
    final titleSpacing = isCompact ? 12.0 : 16.0;
    final bulletSpacing = isCompact ? 1.0 : 2.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title with brand name
        Directionality(
          textDirection: direction,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w300,
                    color: colorScheme.onSurface,
                    height: titleHeight,
                  ),
                ),
                TextSpan(
                  text: brandName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    height: titleHeight,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: titleSpacing),

        // Description bullet points
        Column(
          mainAxisSize: MainAxisSize.min,
          children: bulletPoints.map((text) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: bulletSpacing),
              child: Directionality(
                textDirection: direction,
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: bodyFontSize,
                    color: colorScheme.onSurface,
                    height: bodyHeight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Builds a language selection button
  Widget _buildLanguageButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: isSelected
          ? '$label، محدد'
          : 'اختر لغة $label',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 167),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the continue button
  Widget _buildContinueButton({required ThemeData theme, required ColorScheme colorScheme}) {
    return Semantics(
      button: true,
      label: 'متابعة إلى تسجيل الدخول',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 394),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _continue,
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Continue',
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, color: colorScheme.onSurface),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds progress indicators showing step 2 of 3
  Widget _buildProgressIndicators(ColorScheme colorScheme) {
    return Semantics(
      label: 'الخطوة ٢ من ٣',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressDot(colorScheme, isActive: false), // City selection (completed)
          const SizedBox(width: 8),
          _buildProgressDot(colorScheme, isActive: true), // Current (Onboarding)
          const SizedBox(width: 8),
          _buildProgressDot(colorScheme, isActive: false), // Login (upcoming)
        ],
      ),
    );
  }

  /// Builds a single progress dot
  Widget _buildProgressDot(ColorScheme colorScheme, {required bool isActive}) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
