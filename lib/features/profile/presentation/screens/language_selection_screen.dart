import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';

/// Language Selection Screen
///
/// Pixel-perfect implementation based on Figma node `7774:7230` (Switch Language).
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';
  bool _isSaving = false;

  Future<void> _saveLanguage() async {
    setState(() => _isSaving = true);

    // TODO(waffir): Wire to EasyLocalization + persisted preference.
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $_selectedLanguage'),
        duration: const Duration(seconds: 2),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = context.responsive;
    final safeAreaInsets = MediaQuery.of(context).padding;

    // Figma: total top padding for back button area is 64px.
    // We subtract the actual safe area inset so the *total* matches Figma on notched devices.
    final backTopPadding = (responsive.scale(64) - safeAreaInsets.top).clamp(0.0, double.infinity);

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
                Padding(
                  padding: EdgeInsets.only(
                    left: responsive.scale(16),
                    right: responsive.scale(16),
                    top: backTopPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: WaffirBackButton(size: responsive.scale(44)),
                  ),
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
                      _LanguagePillButton(
                        label: 'العربية',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        borderColor: const Color(0xFFCECECE),
                        borderWidth: responsive.scale(1),
                        borderRadius: responsive.scale(60),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => setState(() => _selectedLanguage = 'Arabic'),
                      ),
                      SizedBox(height: responsive.scale(16)),
                      _LanguagePillButton(
                        label: 'English',
                        width: responsive.scale(361),
                        height: responsive.scale(48),
                        borderColor: colorScheme.primary,
                        borderWidth: responsive.scale(2),
                        borderRadius: responsive.scale(30),
                        textStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 11),
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => setState(() => _selectedLanguage = 'English'),
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
                      onPressed: _isSaving ? null : _saveLanguage,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.scale(30)),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: responsive.scale(18),
                              height: responsive.scale(18),
                              child: CircularProgressIndicator(
                                strokeWidth: responsive.scaleWithMin(2, min: 1.5),
                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                              ),
                            )
                          : Text(
                              'Save',
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
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.textStyle,
    required this.onPressed,
  });

  final String label;
  final double width;
  final double height;
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
