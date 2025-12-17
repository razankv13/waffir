import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/mock/mock_user_data.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/core/constants/locale_keys.dart';

/// Manage Personal Details (Form)
///
/// Pixel-perfect screen matching Figma node `7774:6971`.
/// - White background + blurred shape
/// - Title (Parkinsans 16, w500)
/// - 3 filled fields (radius 16, fill #F2F2F2, horizontal padding 16)
/// - Save button (330×48, radius 30)
class ManagePersonalDetailsFormScreen extends ConsumerStatefulWidget {
  const ManagePersonalDetailsFormScreen({super.key});

  @override
  ConsumerState<ManagePersonalDetailsFormScreen> createState() =>
      _ManagePersonalDetailsFormScreenState();
}

class _ManagePersonalDetailsFormScreenState extends ConsumerState<ManagePersonalDetailsFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = currentMockUser;

    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    // Simulate save
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(LocaleKeys.success.saved.tr()), duration: const Duration(seconds: 2)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Figma: back row padding top = 64. On iOS, 64 ≈ status bar (44) + 20.
    final headerTopPadding = topInset + responsive.scale(20);

    // Figma root padding bottom = 120.
    final bottomPadding = responsive.scale(120) + bottomInset;

    final horizontalPadding = responsive.scale(16);

    final fieldHeight = responsive.scaleWithRange(56, min: 52, max: 64);
    final fieldRadius = responsive.scaleBorderRadius(BorderRadius.circular(16));

    final titleStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(16, minSize: 14),
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: colorScheme.onSurface,
    );

    final fieldTextStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(16, minSize: 14),
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: colorScheme.onSurface,
    );

    // Background blur gradient derived from theme (keeps dark-mode safe while matching look)
    final gradientStart = colorScheme.secondary;
    final gradientEnd =
        Color.lerp(colorScheme.secondary, colorScheme.primary, 0.35) ?? colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: colorScheme.surface)),

          // Blurred shape (Figma: x=-40, y=-85.54, w=467.78, h=394.6, blur=100)
          Positioned(
            left: responsive.scale(-40),
            top: responsive.scale(-85.54),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: responsive.scale(100),
                sigmaY: responsive.scale(100),
                tileMode: TileMode.decal,
              ),
              child: Container(
                width: responsive.scale(467.78),
                height: responsive.scale(394.6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsive.scale(200)),
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
                    padding: responsive.scalePadding(
                      EdgeInsets.only(left: 16, right: 16, top: headerTopPadding),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: WaffirBackButton(
                        size: responsive.scale(44),
                        onTap: () => context.pop(),
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.scale(32)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(LocaleKeys.profile.myAccount.managePersonalDetails.tr(), style: titleStyle),
                        SizedBox(height: responsive.scale(24)),

                        // Fields (gap 8)
                        _FilledClearField(
                          controller: _nameController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                        ),
                        SizedBox(height: responsive.scale(8)),
                        _FilledClearField(
                          controller: _emailController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: responsive.scale(8)),
                        _FilledClearField(
                          controller: _phoneController,
                          height: fieldHeight,
                          borderRadius: fieldRadius,
                          fillColor: colorScheme.surfaceContainerHighest,
                          textStyle: fieldTextStyle,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
                    child: Center(
                      child: SizedBox(
                        width: responsive.scale(330),
                        height: responsive.scale(48),
                        child: AppButton.primary(
                          onPressed: _isSaving ? null : _save,
                          isLoading: _isSaving,
                          borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(30)),
                          child: Text(
                            LocaleKeys.buttons.save.tr(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontFamily: 'Parkinsans',
                              fontSize: responsive.scaleFontSize(14, minSize: 12),
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
  });

  final TextEditingController controller;
  final double height;
  final BorderRadius borderRadius;
  final Color fillColor;
  final TextStyle textStyle;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final colorScheme = Theme.of(context).colorScheme;

    final closeBg = const Color(0xFF595959); // Figma fill_ERW5KG

    return Container(
      height: height,
      decoration: BoxDecoration(color: fillColor, borderRadius: borderRadius),
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.center, // Figma shows centered text
              style: textStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                fillColor: fillColor,
              ),
            ),
          ),
          SizedBox(width: responsive.scale(12)),
          GestureDetector(
            onTap: controller.clear,
            child: Container(
              width: responsive.scale(24),
              height: responsive.scale(24),
              padding: responsive.scalePadding(const EdgeInsets.all(4)),
              decoration: BoxDecoration(color: closeBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(
                Icons.close,
                size: responsive.scaleWithRange(16, min: 14, max: 18),
                color: colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
