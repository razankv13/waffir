import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';

/// Manage Personal Details (Form)
///
/// Pixel-perfect screen matching Figma node `7774:6971`.
/// - White background + blurred shape
/// - Title (Parkinsans 16, w500)
/// - 3 filled fields (radius 16, fill #F2F2F2, horizontal padding 16)
/// - Save button (330x48, radius 30)
class ManagePersonalDetailsFormScreen extends HookConsumerWidget {
  const ManagePersonalDetailsFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper.of(context);

    // Watch profile state
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.asData?.value.profile;

    // Watch auth state for email
    final authStateAsync = ref.watch(authStateProvider);
    final authState = authStateAsync.asData?.value;
    final userEmail = authState?.user?.email ?? '';
    final userPhone = authState?.user?.phoneNumber ?? '';

    // Local state
    final isSaving = useState(false);

    // Text controllers - initialize with profile data
    final nameController = useTextEditingController(text: profile?.fullName ?? '');
    final emailController = useTextEditingController(text: userEmail);
    final phoneController = useTextEditingController(text: userPhone);

    // Sync controllers when profile data changes
    useEffect(() {
      if (profile != null && nameController.text.isEmpty) {
        nameController.text = profile.fullName ?? '';
      }
      if (userEmail.isNotEmpty && emailController.text.isEmpty) {
        emailController.text = userEmail;
      }
      if (userPhone.isNotEmpty && phoneController.text.isEmpty) {
        phoneController.text = userPhone;
      }
      return null;
    }, [profile?.fullName, userEmail, userPhone]);

    Future<void> save() async {
      isSaving.value = true;

      // Update profile (only fullName is editable via profile controller)
      final failure = await ref.read(profileControllerProvider.notifier).updateProfile(
            fullName: nameController.text,
          );

      isSaving.value = false;

      if (!context.mounted) return;

      if (failure == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.success.saved.tr()),
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

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Figma: back row padding top = 64. On iOS, 64 ~ status bar (44) + 20.
    final headerTopPadding = topInset + responsive.s(20);

    // Figma root padding bottom = 120.
    final bottomPadding = responsive.s(120) + bottomInset;

    final horizontalPadding = responsive.s(16);

    final fieldHeight = responsive.sConstrained(56, min: 52, max: 64);
    final fieldRadius = responsive.sBorderRadius(BorderRadius.circular(16));

    final titleStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(16, minSize: 14),
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: colorScheme.onSurface,
    );

    final fieldTextStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(16, minSize: 14),
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: colorScheme.onSurface,
    );

    // Background blur gradient derived from theme (keeps dark-mode safe while matching look)
    final gradientStart = colorScheme.secondary;
    final gradientEnd = Color.lerp(colorScheme.secondary, colorScheme.primary, 0.35) ?? colorScheme.primary;

    // Show loading if profile is not loaded yet
    if (profileAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: colorScheme.surface)),

          // Blurred shape (Figma: x=-40, y=-85.54, w=467.78, h=394.6, blur=100)
          Positioned(
            left: responsive.s(-40),
            top: responsive.s(-85.54),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: responsive.s(100),
                sigmaY: responsive.s(100),
                tileMode: TileMode.decal,
              ),
              child: Container(
                width: responsive.s(467.78),
                height: responsive.s(394.6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsive.s(200)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      gradientStart.withValues(alpha: 0.25),
                      gradientEnd.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button row
                  Padding(
                    padding: responsive.sPadding(
                      EdgeInsets.only(left: 16, right: 16, top: headerTopPadding),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: WaffirBackButton(
                        size: responsive.s(44),
                        onTap: () => context.pop(),
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.s(32)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(LocaleKeys.profile.myAccount.managePersonalDetails.tr(), style: titleStyle),
                        SizedBox(height: responsive.s(24)),

                        // Fields (gap 8)
                        _FilledClearField(
                          controller: nameController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                        ),
                        SizedBox(height: responsive.s(8)),
                        _FilledClearField(
                          controller: emailController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                          keyboardType: TextInputType.emailAddress,
                          enabled: false, // Email is not editable
                        ),
                        SizedBox(height: responsive.s(8)),
                        _FilledClearField(
                          controller: phoneController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                          keyboardType: TextInputType.phone,
                          enabled: false, // Phone is not editable
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
                    child: Center(
                      child: SizedBox(
                        width: responsive.s(330),
                        height: responsive.s(48),
                        child: AppButton.primary(
                          onPressed: isSaving.value ? null : save,
                          isLoading: isSaving.value,
                          borderRadius: responsive.sBorderRadius(BorderRadius.circular(30)),
                          child: Text(
                            LocaleKeys.buttons.save.tr(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontFamily: 'Parkinsans',
                              fontSize: responsive.sFont(14, minSize: 12),
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilledClearField extends StatelessWidget {
  const _FilledClearField({
    required this.controller,
    required this.height,
    required this.borderRadius,
    required this.fillColor,
    required this.textStyle,
    this.keyboardType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final double height;
  final BorderRadius borderRadius;
  final Color fillColor;
  final TextStyle textStyle;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final closeBg = const Color(0xFF595959); // Figma fill_ERW5KG

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: enabled ? fillColor : fillColor.withValues(alpha: 0.5),
        borderRadius: borderRadius,
      ),
      padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              enabled: enabled,
              textAlign: TextAlign.center, // Figma shows centered text
              style: textStyle.copyWith(
                color: enabled ? textStyle.color : textStyle.color?.withValues(alpha: 0.5),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                fillColor: fillColor,
              ),
            ),
          ),
          if (enabled) ...[
            SizedBox(width: responsive.s(12)),
            GestureDetector(
              onTap: controller.clear,
              child: Container(
                width: responsive.s(24),
                height: responsive.s(24),
                padding: responsive.sPadding(const EdgeInsets.all(4)),
                decoration: BoxDecoration(color: closeBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  size: responsive.sConstrained(16, min: 14, max: 18),
                  color: colorScheme.surface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
