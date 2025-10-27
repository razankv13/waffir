import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/buttons/back_button.dart';
import 'package:waffir/core/widgets/inputs/gender_selector.dart';

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
  ConsumerState<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
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
    return _selectedGender != null &&
        _acceptedTerms &&
        _nameController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              colorScheme.surface,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    AppBackButton(
                      size: 48,
                      showBackground: true,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width > 600 ? 60 : 39,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),

                      // Title
                      Text(
                        'تفاصيل الحساب',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 27),

                      // Name input
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

                      // Referral code input
                      _PillTextField(
                        controller: _referralController,
                        hintText: 'رمز الخصم / رمز الدعوة',
                        colorScheme: colorScheme,
                        theme: theme,
                      ),

                      const SizedBox(height: 105),

                      // Terms checkbox
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

              // Confirm button
              Padding(
                padding: EdgeInsets.only(
                  left: size.width > 600 ? 60 : 39,
                  right: size.width > 600 ? 60 : 39,
                  bottom: size.height > 700 ? 158 : 40,
                ),
                child: _PremiumButton(
                  onPressed: _isFormValid ? _confirm : null,
                  text: 'تأكيد',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped text field with centered text
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
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Rounded square checkbox matching the gender selector style
class _RoundedSquareCheckbox extends StatelessWidget {
  const _RoundedSquareCheckbox({
    required this.isSelected,
    required this.colorScheme,
  });

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
        borderRadius: BorderRadius.circular(6),
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 16,
              color: colorScheme.onPrimary,
            )
          : null,
    );
  }
}

/// Premium button with rounded corners and state-based styling
class _PremiumButton extends StatelessWidget {
  const _PremiumButton({
    required this.onPressed,
    required this.text,
    required this.colorScheme,
    required this.theme,
  });

  final VoidCallback? onPressed;
  final String text;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: isEnabled
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(60),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isEnabled
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
