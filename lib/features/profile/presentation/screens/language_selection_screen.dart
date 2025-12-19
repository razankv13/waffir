import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';

/// Language Selection Screen
///
/// Pixel-perfect implementation based on Figma node `7774:7230` (Switch Language).
/// Refactored to HookConsumerWidget and integrated with ProfileController
/// for persisting language setting to Supabase backend + EasyLocalization.
class LanguageSelectionScreen extends HookConsumerWidget {
  const LanguageSelectionScreen({super.key});

  /// Map language code to display label.
  static const _languageLabels = {
    'ar': 'العربية',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
  };

  /// Map language code to Locale.
  static const _languageLocales = {
    'ar': Locale('ar', 'SA'),
    'en': Locale('en', 'US'),
    'es': Locale('es', 'ES'),
    'fr': Locale('fr', 'FR'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = context.responsive;
    final safeAreaInsets = MediaQuery.of(context).padding;

    // Watch profile state
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.asData?.value.profile;

    // Local state using hooks
    // Default to current device locale if profile not loaded, fallback to 'en'
    final currentLocale = context.locale.languageCode;
    final selectedLanguage = useState(profile?.language ?? currentLocale);
    final isSaving = useState(false);

    // Sync selected language when profile data changes
    useEffect(() {
      if (profile != null && profile.language.isNotEmpty) {
        selectedLanguage.value = profile.language;
      }
      return null;
    }, [profile?.language]);

    Future<void> saveLanguage() async {
      if (isSaving.value) return;

      isSaving.value = true;

      // Call profile controller to save language setting
      final failure = await ref.read(profileControllerProvider.notifier).updateSettings(
            language: selectedLanguage.value,
          );

      // Also update EasyLocalization locale
      final newLocale = _languageLocales[selectedLanguage.value];
      if (newLocale != null && context.mounted) {
        await context.setLocale(newLocale);
      }

      isSaving.value = false;

      if (!context.mounted) return;

      if (failure == null) {
        final languageLabel = _languageLabels[selectedLanguage.value] ?? selectedLanguage.value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $languageLabel'),
            duration: const Duration(seconds: 2),
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message ?? 'Failed to save'),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    // Figma: screen bottom padding is 120px.
    final bottomPadding = (responsive.scale(120) - safeAreaInsets.bottom).clamp(
      0.0,
      double.infinity,
    );

    final titleStyle = (textTheme.bodyLarge ?? const TextStyle()).copyWith(
      fontSize: responsive.scaleFontSize(16, minSize: 12),
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: colorScheme.onSurface,
    );

    // Show loading if profile is not loaded yet
    if (profileAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background shape (exported from Figma) + blur.
          Positioned(
            left: -responsive.scale(40),
            top: -responsive.scale(85.54),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: responsive.scale(100),
                sigmaY: responsive.scale(100),
              ),
              child: SvgPicture.asset(
                'assets/images/language_switch_shape.svg',
                width: responsive.scale(467.78),
                height: responsive.scale(394.6),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content.
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: WaffirBackButton(size: responsive.scale(44)),
                ),

                SizedBox(height: responsive.scale(32)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                  child: Text('Change Language', style: titleStyle),
                ),

                SizedBox(height: responsive.scale(32)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                  child: Column(
                    children: [
                      // Arabic option
                      _LanguagePillButton(
                        label: 'العربية',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        isSelected: selectedLanguage.value == 'ar',
                        borderColor: selectedLanguage.value == 'ar'
                            ? colorScheme.primary
                            : const Color(0xFFCECECE),
                        borderWidth: selectedLanguage.value == 'ar'
                            ? responsive.scale(2)
                            : responsive.scale(1),
                        borderRadius: responsive.scale(selectedLanguage.value == 'ar' ? 30 : 60),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight:
                              selectedLanguage.value == 'ar' ? FontWeight.w600 : FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => selectedLanguage.value = 'ar',
                      ),
                      SizedBox(height: responsive.scale(16)),
                      // English option
                      _LanguagePillButton(
                        label: 'English',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        isSelected: selectedLanguage.value == 'en',
                        borderColor: selectedLanguage.value == 'en'
                            ? colorScheme.primary
                            : const Color(0xFFCECECE),
                        borderWidth: selectedLanguage.value == 'en'
                            ? responsive.scale(2)
                            : responsive.scale(1),
                        borderRadius: responsive.scale(selectedLanguage.value == 'en' ? 30 : 60),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight:
                              selectedLanguage.value == 'en' ? FontWeight.w600 : FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => selectedLanguage.value = 'en',
                      ),
                      SizedBox(height: responsive.scale(16)),
                      // Spanish option
                      _LanguagePillButton(
                        label: 'Español',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        isSelected: selectedLanguage.value == 'es',
                        borderColor: selectedLanguage.value == 'es'
                            ? colorScheme.primary
                            : const Color(0xFFCECECE),
                        borderWidth: selectedLanguage.value == 'es'
                            ? responsive.scale(2)
                            : responsive.scale(1),
                        borderRadius: responsive.scale(selectedLanguage.value == 'es' ? 30 : 60),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight:
                              selectedLanguage.value == 'es' ? FontWeight.w600 : FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => selectedLanguage.value = 'es',
                      ),
                      SizedBox(height: responsive.scale(16)),
                      // French option
                      _LanguagePillButton(
                        label: 'Français',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        isSelected: selectedLanguage.value == 'fr',
                        borderColor: selectedLanguage.value == 'fr'
                            ? colorScheme.primary
                            : const Color(0xFFCECECE),
                        borderWidth: selectedLanguage.value == 'fr'
                            ? responsive.scale(2)
                            : responsive.scale(1),
                        borderRadius: responsive.scale(selectedLanguage.value == 'fr' ? 30 : 60),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight:
                              selectedLanguage.value == 'fr' ? FontWeight.w600 : FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => selectedLanguage.value = 'fr',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: EdgeInsets.only(
                    left: responsive.scale(31.5),
                    right: responsive.scale(31.5),
                    bottom: bottomPadding,
                  ),
                  child: SizedBox(
                    width: responsive.scale(330),
                    height: responsive.scale(48),
                    child: FilledButton(
                      onPressed: isSaving.value ? null : saveLanguage,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.scale(30)),
                        ),
                      ),
                      child: isSaving.value
                          ? SizedBox(
                              width: responsive.scale(18),
                              height: responsive.scale(18),
                              child: CircularProgressIndicator(
                                strokeWidth: responsive.scaleWithMin(2, min: 1.5),
                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                              ),
                            )
                          : Text(
                              LocaleKeys.buttons.save.tr(),
                              style: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                                fontSize: responsive.scaleFontSize(14, minSize: 11),
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagePillButton extends StatelessWidget {
  const _LanguagePillButton({
    required this.label,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.textStyle,
    required this.onPressed,
  });

  final String label;
  final double width;
  final double height;
  final bool isSelected;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: borderColor, width: borderWidth),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: Text(label, style: textStyle),
      ),
    );
  }
}
