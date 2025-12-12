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

/// Account details screen with premium UI design
///
/// Collects user information after authentication:
/// - Name (required)
/// - Gender (required)
/// - Referral/discount code (optional)
/// - Terms acceptance (required)
///
/// Features:
/// - Gradient background (primary to surface)
/// - Rounded square checkboxes (Material 3)
/// - Pill-shaped text inputs
/// - Premium button styling
/// - RTL support for Arabic
/// - Responsive layout (mobile, tablet, desktop)
/// - Theme-based coloring (no hardcoded colors)
class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  Gender? _selectedGender;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _referralController.dispose();
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

    final horizontalPadding = responsive.horizontalPadding(mobile: 16, tablet: 24, desktop: 32);
    final double headingTopSpacing = responsive.scale(80);
    final double headerGap = responsive.scale(32);
    final double labelSpacing = responsive.scale(17);
    final double fieldSpacing = responsive.scale(16);
    final double checkboxGap = responsive.scale(10);
    final double termsSpacing = responsive.scale(105);
    final double termsToButtonSpacing = responsive.scale(32);
    final double buttonWidth = responsive.scaleWithRange(330, min: 280, max: 360);
    final double buttonBottomPadding =
        isSmallScreen ? responsive.scaleWithMin(60, min: 48) : responsive.scaleWithRange(120, min: 90, max: 140);
    final double backButtonHorizontalPadding = responsive.scaleWithMin(16, min: 16);
    final double backButtonTopPadding = responsive.scaleWithMin(64, min: 48);
    final double genderSelectorHeight = responsive.scaleWithRange(56, min: 48, max: 64);
    final double blurHorizontalOffset = responsive.scale(40);
    final double blurTopOffset = responsive.scale(100);
    final double blurShapeWidth = responsive.scale(467.78);
    final double blurShapeHeight = responsive.scale(461.3);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent keyboard from pushing layout
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
              child: Column(
                children: [
                  // Back button (positioned for RTL awareness)
                  Padding(
                    padding: EdgeInsets.only(
                      left: backButtonHorizontalPadding,
                      right: backButtonHorizontalPadding,
                      top: backButtonTopPadding,
                    ),
                    child: const Row(children: [WaffirBackButton()]),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: headingTopSpacing),

                          // Title - 20px, Parkinsans 700
                          Text(
                            'تفاصيل الحساب',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: responsive.scaleFontSize(20, minSize: 18),
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: headerGap),

                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'الاسم',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: responsive.scaleFontSize(16, minSize: 14),
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),

                          SizedBox(height: labelSpacing),

                          // Name input - 16px border radius
                          _PillTextField(
                            controller: _nameController,
                            hintText: 'الاسم',
                            colorScheme: colorScheme,
                            theme: theme,
                            onChanged: (_) => setState(() {}),
                          ),

                          SizedBox(height: fieldSpacing),

                          // Gender selection
                          SizedBox(
                            height: genderSelectorHeight,
                            child: Center(
                              child: GenderSelector(
                                selectedGender: _selectedGender,
                                onChanged: (gender) {
                                  setState(() {
                                    _selectedGender = gender;
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: fieldSpacing),

                          // Referral code input - 16px border radius
                          _PillTextField(
                            controller: _referralController,
                            hintText: 'رمز الخصم / رمز الدعوة',
                            colorScheme: colorScheme,
                            theme: theme,
                          ),

                          SizedBox(height: termsSpacing),
                          // Terms checkbox - 14px text, 4px border radius
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
                                SizedBox(width: checkboxGap),
                                Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'أوافق على الشروط ',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                                            fontWeight: FontWeight.w400,
                                            height: 1.4,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'و',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                                            fontWeight: FontWeight.w400,
                                            height: 1.4,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'سياسة الخصوصية',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                                            fontWeight: FontWeight.w700, // Bold
                                            height: 1.4,
                                            color: colorScheme.onSurfaceVariant,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: termsToButtonSpacing),
                        ],
                      ),
                    ),
                  ),

                  // Confirm button - 330x48, 30px border radius
                  Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: buttonBottomPadding,
                    ),
                    child: Center(
                      child: AppButton.primary(
                        text: 'تأكيد',
                        onPressed: _isFormValid ? _confirm : null,
                        width: buttonWidth,
                        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped text field with centered text - 16px border radius
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
    final double fieldHeight = responsive.scaleWithRange(56, min: 48, max: 64);
    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(16)), // Changed from 30 to 16
      ),
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 22)),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: responsive.scaleFontSize(16, minSize: 14), // Explicit 16px
            fontWeight: FontWeight.w500, // Parkinsans 500
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: responsive.scaleFontSize(16, minSize: 14), // Explicit 16px
              fontWeight: FontWeight.w500, // Parkinsans 500
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
        ),
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
    final double iconSize = responsive.scaleWithRange(16, min: 12, max: 18);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(4)), // Changed from 6 to 4
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outline, width: borderWidth),
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
