import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
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

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // White background
            Container(color: colorScheme.surface),

            // Blur shape background (positioned top-left, mirrored for RTL)
            Positioned(
              left: isRTL ? null : -40,
              right: isRTL ? -40 : null,
              top: -100,
              child: Transform.scale(
                scaleX: isRTL ? -1.0 : 1.0,
                child: Image.asset(
                  Assets.images.loginBlurShape.path,
                  width: 467.78,
                  height: 461.3,
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
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [AppBackButton(size: 38, showBackground: true)]),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: size.width > 600 ? 24 : 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),

                          // Title - 20px, Parkinsans 700
                          Text(
                            'تفاصيل الحساب',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Name input - 16px border radius
                          _PillTextField(
                            controller: _nameController,
                            hintText: 'الاسم',
                            colorScheme: colorScheme,
                            theme: theme,
                            onChanged: (_) => setState(() {}),
                          ),

                          const SizedBox(height: 11),

                          // Gender selection
                          SizedBox(
                            height: 56,
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

                          const SizedBox(height: 11),

                          // Referral code input - 16px border radius
                          _PillTextField(
                            controller: _referralController,
                            hintText: 'رمز الخصم / رمز الدعوة',
                            colorScheme: colorScheme,
                            theme: theme,
                          ),

                          const SizedBox(height: 105),

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
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'أوافق على الشروط وسياسة الخصوصية',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Confirm button - 330x48, 30px border radius
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: isSmallScreen ? 60 : 120),
                    child: Center(
                      child: AppButton.primary(
                        text: 'تأكيد',
                        onPressed: _isFormValid ? _confirm : null,
                        width: 330,
                        borderRadius: BorderRadius.circular(30),
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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16), // Changed from 30 to 16
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 16, // Explicit 16px
            fontWeight: FontWeight.w500, // Parkinsans 500
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16, // Explicit 16px
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4), // Changed from 6 to 4
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outline, width: 2),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 16,
              color: colorScheme.secondary, // Changed to secondary (#00FF88)
            )
          : null,
    );
  }
}
