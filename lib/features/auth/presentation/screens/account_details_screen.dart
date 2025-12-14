import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/core/widgets/inputs/gender_selector.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Account details screen (pixel-perfect to Figma node `34:5441`)
///
/// Collects user information after authentication:
/// - Name (required)
/// - Gender (required)
/// - Terms acceptance (required)
///
/// Features:
/// - White surface with blurred shape background
/// - Rounded square checkboxes (24px, 4px radius, 2px stroke, bright green check)
/// - Pill-shaped text input with 16px radius, 12px horizontal padding, left-aligned text
/// - Primary button 330x48 with 30px radius (Parkinsans 600, 14px)
/// - RTL aware layout and responsive scaling via ResponsiveHelper
/// - Theme-based coloring (no AppColors imports in widgets)
class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  Gender? _selectedGender;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Validates and confirms account details
  void _confirm() {
    if (_selectedGender != null && _acceptedTerms && _nameController.text.trim().isNotEmpty) {
      // Save user details
      // Navigate to home
      context.go(AppRoutes.home);
    }
  }

  /// Checks if form is valid and button should be enabled
  bool get _isFormValid {
    return _selectedGender != null && _acceptedTerms && _nameController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isRTL = context.locale.languageCode == 'ar';
    final isSmallScreen = size.height < 700;
    final responsive = ResponsiveHelper(context);

    final horizontalPadding = responsive.scale(16);
    final double backButtonTopPadding = responsive.scaleWithRange(64, min: 56, max: 72);
    final double contentVerticalGap = responsive.scale(32);
    final double labelToFieldSpacing = responsive.scale(16);
    final double optionGap = responsive.scale(80);
    final double genderControlGap = responsive.scale(10);
    final double termsCheckboxGap = responsive.scale(8);
    final double termsButtonGap = responsive.scale(32);
    final double buttonWidth = responsive.scaleWithRange(330, min: 280, max: 360);
    final double buttonBottomPadding = isSmallScreen
        ? responsive.scaleWithRange(80, min: 64, max: 90)
        : responsive.scaleWithRange(120, min: 100, max: 140);
    final double blurHorizontalOffset = responsive.scale(40);
    final double blurTopOffset = responsive.scale(100);
    final double blurShapeWidth = responsive.scale(467.78);
    final double blurShapeHeight = responsive.scale(461.3);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // White background
            Container(color: colorScheme.surface),

            // Blur shape background (positioned top-left, mirrored for RTL)
            Positioned(
              left: isRTL ? null : -blurHorizontalOffset,
              right: isRTL ? -blurHorizontalOffset : null,
              top: -blurTopOffset,
              child: Transform.scale(
                scaleX: isRTL ? -1.0 : 1.0,
                child: Image.asset(
                  Assets.images.loginBlurShape.path,
                  width: blurShapeWidth,
                  height: blurShapeHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Main content
            SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: buttonBottomPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: backButtonTopPadding),
                                  child: const Row(children: [WaffirBackButton()]),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Name',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: responsive.scaleFontSize(20, minSize: 18),
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: labelToFieldSpacing),
                                _PillTextField(
                                  controller: _nameController,
                                  hintText: 'Full Name',
                                  colorScheme: colorScheme,
                                  theme: theme,
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: contentVerticalGap),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Account Details',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: responsive.scaleFontSize(20, minSize: 18),
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: labelToFieldSpacing),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: responsive.scale(12)),
                                  child: GenderSelector(
                                    selectedGender: _selectedGender,
                                    onChanged: (gender) {
                                      setState(() {
                                        _selectedGender = gender;
                                      });
                                    },
                                    optionGap: optionGap,
                                    controlGap: genderControlGap,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _acceptedTerms = !_acceptedTerms;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _RoundedSquareCheckbox(
                                        isSelected: _acceptedTerms,
                                        colorScheme: colorScheme,
                                      ),
                                      SizedBox(width: termsCheckboxGap),
                                      Flexible(
                                        child: Text(
                                          'Accept of terms and use of Privacy Policy',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                                            fontWeight: FontWeight.w400,
                                            height: 1.4,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: termsButtonGap),
                                AppButton.primary(
                                  text: 'Continue',
                                  onPressed: _isFormValid ? _confirm : null,
                                  width: buttonWidth,
                                  borderRadius: responsive.scaleBorderRadius(
                                    BorderRadius.circular(30),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped text field with left-aligned text - 16px border radius
class _PillTextField extends StatelessWidget {
  const _PillTextField({
    required this.controller,
    required this.hintText,
    required this.colorScheme,
    required this.theme,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final double fieldHeight = responsive.scaleWithRange(48, min: 44, max: 56);
    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(16)),
      ),
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 12)),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: responsive.scaleFontSize(16, minSize: 14),
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: responsive.scaleFontSize(16, minSize: 14),
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          fillColor: colorScheme.surfaceContainerHighest,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// Rounded square checkbox - 4px border radius, bright green check icon
class _RoundedSquareCheckbox extends StatelessWidget {
  const _RoundedSquareCheckbox({required this.isSelected, required this.colorScheme});

  final bool isSelected;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final double boxSize = responsive.scaleWithRange(24, min: 20, max: 28);
    final double borderWidth = responsive.scaleWithRange(2, min: 1.5, max: 2.5);
    final double iconSize = responsive.scaleWithRange(12.15, min: 10, max: 14);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(4)),
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(color: colorScheme.primary, width: borderWidth),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: iconSize,
              color: colorScheme.secondary, // Changed to secondary (#00FF88)
            )
          : null,
    );
  }
}
