import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
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
import 'package:waffir/gen/assets.gen.dart';

/// Onboarding screen with language selection and gradient background
///
/// Features:
/// - Bilingual content (English + Arabic) displayed simultaneously
/// - Language toggle buttons with visual selection state using AppButton
/// - Beautiful gradient background illustration
/// - Pixel-perfect responsive design matching Figma specifications (393x852 base)
/// - Theme-compliant color usage via colorScheme
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isArabic = false;

  void _selectLanguage(String languageCode) {
    HapticFeedback.selectionClick();
    final supportedLocales = context.supportedLocales;
    final locale = supportedLocales.firstWhere(
      (l) => l.languageCode == languageCode,
      orElse: () => const Locale('en', 'US'),
    );
    setState(() {
      _isArabic = locale.languageCode == 'ar';
    });
    context.setLocale(locale);
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

    // Responsive horizontal padding
    final horizontalPadding = ResponsiveHelper(
      context,
    ).horizontalPadding(mobile: 16.0, tablet: 32.0, desktop: 48.0);

    // Responsive spacing
    final sectionGap = ResponsiveHelper(
      context,
    ).verticalPadding(mobile: 40.0, tablet: 48.0, desktop: 56.0);

    final contentGap = ResponsiveHelper(
      context,
    ).verticalPadding(mobile: 64.0, tablet: 80.0, desktop: 96.0);

    final bottomPadding = ResponsiveHelper(
      context,
    ).verticalPadding(mobile: 120.0, tablet: 80.0, desktop: 60.0);

    // Pixel-perfect values from Figma (393x852)
    const double titleFontSize = 20.0;
    const double bodyFontSize = 16.0;
    const double languageHeadingFontSize = 16.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive shape dimensions
            final shapeWidth = ResponsiveHelper(context).scale(467.78);
            final shapeHeight = ResponsiveHelper(context).scale(461.3);

            return Stack(
              children: [
                // Blurred shape background (exported from Figma)
                Positioned(
                  left: -40,
                  top: -100,
                  child: Image.asset(
                    Assets.images.onboardingShape.path,
                    width: shapeWidth,
                    height: shapeHeight,
                    fit: BoxFit.cover,
                  ),
                ),

                // Main scrollable content
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: context.isDesktopSize ? 600 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top spacer (gradient height from Figma)
                          SizedBox(height: ResponsiveHelper(context).scale(87.0)),

                          // Content sections
                          Column(
                            children: [
                              // English Section (Figma: "Welcome to Waffir")
                              _buildContentSection(
                                title: 'Welcome to ',
                                brandName: 'Waffir',
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
                              ),

                              SizedBox(height: sectionGap),

                              // Arabic Section (Figma: "مرحباً بكم في وفــــر")
                              _buildContentSection(
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
                              ),
                            ],
                          ),

                          // Spacing between content and language selection
                          SizedBox(height: contentGap),

                          // Language selection and continue button
                          Column(
                            children: [
                              // Heading: Please choose your language
                              Text(
                                LocaleKeys.onboarding.chooseLanguage.tr(),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: languageHeadingFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurface,
                                  height: 1.0,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Language selection buttons using AppButton
                              Column(
                                children: [
                                  // Arabic button (Secondary variant - 2px dark green border)
                                  Semantics(
                                    button: true,
                                    selected: _isArabic,
                                    label: _isArabic
                                        ? LocaleKeys.onboarding.languageButton.arabicSelected.tr()
                                        : LocaleKeys.onboarding.languageButton.selectArabic.tr(),
                                    child: SizedBox(
                                      height: 56,
                                      child: _isArabic
                                          ? AppButton.secondary(
                                              text: 'العربية',
                                              onPressed: () => _selectLanguage('ar'),
                                              width: double.infinity,
                                            )
                                          : AppButton.tertiary(
                                              text: 'العربية',
                                              onPressed: () => _selectLanguage('ar'),
                                              width: double.infinity,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // English button (Tertiary variant - 1px gray border, 60px radius)
                                  Semantics(
                                    button: true,
                                    selected: !_isArabic,
                                    label: !_isArabic
                                        ? LocaleKeys.onboarding.languageButton.englishSelected.tr()
                                        : LocaleKeys.onboarding.languageButton.selectEnglish.tr(),
                                    child: SizedBox(
                                      height: 56,
                                      child: _isArabic
                                          ? AppButton.tertiary(
                                              text: 'English',
                                              onPressed: () => _selectLanguage('en'),
                                              width: double.infinity,
                                            )
                                          : AppButton.secondary(
                                              text: 'English',
                                              onPressed: () => _selectLanguage('en'),
                                              width: double.infinity,
                                            ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: sectionGap),

                              // Continue button using AppButton.primary
                              Semantics(
                                button: true,
                                label: LocaleKeys.onboarding.languageButton.continueToLogin.tr(),
                                child: SizedBox(
                                  height: 56,
                                  child: AppButton.primary(
                                    text: LocaleKeys.buttons.continueBtn.tr(),
                                    onPressed: _continue,
                                    width: double.infinity,
                                  ),
                                ),
                              ),

                              SizedBox(height: bottomPadding),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds a content section with title and description (joined from bulletPoints)
  Widget _buildContentSection({
    required String title,
    required String brandName,
    required List<String> bulletPoints,
    required bool isArabic,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required double titleFontSize,
    required double bodyFontSize,
  }) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;
    const double titleHeight = 1.0;
    const double bodyHeight = 1.2;
    const double titleSpacing = 16.0;
    final String description = bulletPoints.join(' ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title (using theme colors for consistency)
        Directionality(
          textDirection: direction,
          child: Text(
            '$title$brandName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface, // Black text for theme compliance
              height: titleHeight,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: titleSpacing),

        // Description paragraph
        Directionality(
          textDirection: direction,
          child: Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: bodyFontSize,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface, // Black text for theme compliance
              height: bodyHeight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
