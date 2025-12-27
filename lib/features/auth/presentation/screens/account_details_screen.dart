import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/inputs/gender_selector.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';

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
class AccountDetailsScreen extends HookConsumerWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(activeUserProvider);
    final nameController = useTextEditingController();
    useListenable(nameController);

    final selectedGender = useState<Gender?>(null);
    final acceptedTerms = useState(false);
    final isSubmitting = useState(false);

    // Auto-fill name from OAuth provider data (Google/Apple)
    useEffect(() {
      if (nameController.text.isEmpty &&
          user?.displayName != null &&
          user!.displayName!.trim().isNotEmpty) {
        nameController.text = user.displayName!;
      }
      return null;
    }, [user?.displayName]);

    bool isFormValid() {
      return selectedGender.value != null &&
          acceptedTerms.value &&
          nameController.text.trim().isNotEmpty;
    }

    /// Validates and confirms account details
    Future<void> confirm() async {
      final isFormValidNow = isFormValid();
      if (!isFormValidNow || isSubmitting.value) return;

      isSubmitting.value = true;
      try {
        final currentUser = ref.read(activeUserProvider);
        if (currentUser == null) {
          throw Exception(tr(LocaleKeys.errors.unauthorizedError));
        }

        final fullName = nameController.text.trim();
        final nameParts = fullName.split(RegExp('\\s+')).where((p) => p.isNotEmpty).toList();
        final firstName = nameParts.isNotEmpty ? nameParts.first : null;
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null;

        final updated = currentUser.copyWith(
          displayName: fullName,
          firstName: firstName,
          lastName: lastName,
          gender: selectedGender.value?.name,
          photoURL: currentUser.photoURL, // Preserve OAuth avatar URL
          preferences: <String, dynamic>{
            ...currentUser.preferences,
            'acceptedTerms': acceptedTerms.value,
          },
        );

        // Save user profile data to Supabase
        final authController = ref.read(authControllerProvider.notifier);
        await authController.updateUserData(updated);

        // Sync city selection to Supabase if set
        final settingsService = ref.read(settingsServiceProvider);
        final selectedCity = settingsService.getPreference<String>('selected_city');
        if (selectedCity != null && selectedCity.isNotEmpty) {
          final profileController = ref.read(profileControllerProvider.notifier);
          await profileController.updateSettings(cityId: selectedCity);
        }

        if (!context.mounted) return;
        context.go(AppRoutes.home);
      } catch (e) {
        if (context.mounted) context.showErrorSnackBar(message: e.toString());
      } finally {
        if (context.mounted) isSubmitting.value = false;
      }
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isRTL = context.locale.languageCode == 'ar';
    final isSmallScreen = size.height < 700;
    final responsive = ResponsiveHelper.of(context);

    final horizontalPadding = responsive.s(16);
    final double contentVerticalGap = responsive.s(32);
    final double labelToFieldSpacing = responsive.s(16);
    final double optionGap = responsive.s(80);
    final double genderControlGap = responsive.s(10);
    final double termsCheckboxGap = responsive.s(8);
    final double termsButtonGap = responsive.s(32);
    final double buttonWidth = responsive.sConstrained(330, min: 280, max: 360);
    final double buttonBottomPadding = isSmallScreen
        ? responsive.sConstrained(80, min: 64, max: 90)
        : responsive.sConstrained(120, min: 100, max: 140);
    final isFormValidValue = isFormValid();

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // White background
            ColoredBox(color: colorScheme.surface),

            // Blurred background
            const BlurredBackground(),

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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(height: responsive.s(context.rs.topSafeArea)),

                                // Avatar display for OAuth users (Google/Apple)
                                if (user?.photoURL != null && user!.photoURL!.isNotEmpty) ...[
                                  Center(
                                    child: Container(
                                      width: responsive.s(80),
                                      height: responsive.s(80),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorScheme.surfaceContainerHighest,
                                        border: Border.all(
                                          color: colorScheme.primary.withValues(alpha: 0.3),
                                          width: 2,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: AppNetworkImage.avatar(
                                        imageUrl: user.photoURL!,
                                        size: 80,
                                        errorWidget: Icon(
                                          Icons.person,
                                          size: responsive.s(40),
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: responsive.s(24)),
                                ],

                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    tr(LocaleKeys.accountDetails.nameLabel),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: responsive.sFont(20, minSize: 18),
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: labelToFieldSpacing),
                                _PillTextField(
                                  controller: nameController,
                                  hintText: tr(LocaleKeys.accountDetails.nameHint),
                                  colorScheme: colorScheme,
                                  theme: theme,
                                ),
                                SizedBox(height: contentVerticalGap),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    tr(LocaleKeys.accountDetails.detailsTitle),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: responsive.sFont(20, minSize: 18),
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: labelToFieldSpacing),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: responsive.s(12)),
                                  child: GenderSelector(
                                    selectedGender: selectedGender.value,
                                    onChanged: (gender) => selectedGender.value = gender,
                                    optionGap: optionGap,
                                    controlGap: genderControlGap,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.rs.screenHeight * .2),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    acceptedTerms.value = !acceptedTerms.value;
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _RoundedSquareCheckbox(
                                        isSelected: acceptedTerms.value,
                                        colorScheme: colorScheme,
                                      ),
                                      SizedBox(width: termsCheckboxGap),
                                      Flexible(
                                        child: Text(
                                          tr(LocaleKeys.accountDetails.termsAcceptance),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: responsive.sFont(14, minSize: 12),
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
                                  text: tr(LocaleKeys.buttons.continueBtn),
                                  onPressed: isFormValidValue && !isSubmitting.value
                                      ? confirm
                                      : null,
                                  isLoading: isSubmitting.value,
                                  enabled: isFormValidValue && !isSubmitting.value,
                                  width: buttonWidth,
                                  borderRadius: responsive.sBorderRadius(
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
    final responsive = ResponsiveHelper.of(context);
    final double fieldHeight = responsive.sConstrained(48, min: 44, max: 56);
    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: responsive.sBorderRadius(BorderRadius.circular(16)),
      ),
      padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 12)),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: responsive.sFont(16, minSize: 14),
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: responsive.sFont(16, minSize: 14),
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
    final responsive = ResponsiveHelper.of(context);
    final double boxSize = responsive.sConstrained(24, min: 20, max: 28);
    final double borderWidth = responsive.sConstrained(2, min: 1.5, max: 2.5);
    final double iconSize = responsive.sConstrained(12.15, min: 10, max: 14);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: responsive.sBorderRadius(BorderRadius.circular(4)),
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
