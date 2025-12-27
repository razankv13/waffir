import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';
import 'package:waffir/core/widgets/profile/profile_menu_item.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/profile/presentation/widgets/help_center/contact_card.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Help Center Screen
///
/// Displays customer care contact options and useful resources.
/// Matches Figma design (node 7783-4257).
class HelpCenterScreen extends HookConsumerWidget {
  const HelpCenterScreen({super.key});

  // Placeholder URLs (to be replaced with actual URLs)
  static const String _whatsappUrl = 'https://wa.me/1234567890';
  static const String _facebookUrl = 'https://facebook.com/waffir';
  static const String _telegramUrl = 'https://t.me/waffir';
  static const String _emailUrl = 'mailto:support@waffir.net';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final responsive = context.rs;

    return Scaffold(
      body: Stack(
        children: [
          const BlurredBackground(),

          // Main content
          Column(
            children: [
              // App bar with back button and title
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WaffirBackButton(size: responsive.s(44)),
                    SizedBox(height: responsive.s(16)),
                    Padding(
                      padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
                      child: Text(
                        LocaleKeys.helpCenter.title.tr(),
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: responsive.sFont(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: responsive.sPadding(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Care section
                      _buildCustomerCareSection(context),

                      SizedBox(height: responsive.s(32)),

                      // Useful Resources section
                      _buildUsefulResourcesSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the Customer Care section with contact cards
  Widget _buildCustomerCareSection(BuildContext context) {
    final responsive = context.rs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        ProfileSectionHeader(
          title: LocaleKeys.helpCenter.customerCare.tr(),
          padding: EdgeInsets.only(bottom: responsive.s(16)),
        ),

        // Contact cards row
        Row(
          children: [
            // WhatsApp
            ContactCard(
              icon: SvgPicture.asset(
                Assets.icons.social.icWhatsapp.path,
                width: responsive.s(27),
                height: responsive.s(27),
              ),
              label: LocaleKeys.helpCenter.whatsapp.tr(),
              onTap: () => _launchUrl(context, _whatsappUrl),
            ),

            SizedBox(width: responsive.s(12)),

            // Facebook
            ContactCard(
              icon: SvgPicture.asset(
                Assets.icons.social.icFacebook.path,
                width: responsive.s(27),
                height: responsive.s(27),
              ),
              label: LocaleKeys.helpCenter.facebook.tr(),
              onTap: () => _launchUrl(context, _facebookUrl),
            ),

            SizedBox(width: responsive.s(12)),

            // Telegram
            ContactCard(
              icon: Image.asset(
                Assets.icons.social.icTelegram.path,
                width: responsive.s(27),
                height: responsive.s(27),
              ),
              label: LocaleKeys.helpCenter.telegram.tr(),
              onTap: () => _launchUrl(context, _telegramUrl),
            ),

            SizedBox(width: responsive.s(12)),

            // Email
            ContactCard(
              icon: SvgPicture.asset(
                Assets.icons.social.icEmail.path,
                width: responsive.s(27),
                height: responsive.s(27),
              ),
              label: LocaleKeys.helpCenter.email.tr(),
              onTap: () => _launchUrl(context, _emailUrl),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the Useful Resources section with menu items
  Widget _buildUsefulResourcesSection(BuildContext context) {
    final responsive = context.rs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        ProfileSectionHeader(
          title: LocaleKeys.helpCenter.usefulResources.tr(),
          padding: EdgeInsets.only(bottom: responsive.s(16)),
        ),

        // Menu items (no card wrapper, no icons - matching Figma)
        Column(
          children: [
            // FAQs
            ProfileMenuItem(
              label: LocaleKeys.helpCenter.faqs.tr(),
              onTap: () => _showComingSoon(context),
            ),

            // Rules of Use
            ProfileMenuItem(
              label: LocaleKeys.helpCenter.rulesOfUse.tr(),
              onTap: () => _showComingSoon(context),
            ),

            // Terms and Conditions
            ProfileMenuItem(
              label: LocaleKeys.helpCenter.termsAndConditions.tr(),
              onTap: () => _showComingSoon(context),
            ),

            // Privacy Policy
            ProfileMenuItem(
              label: LocaleKeys.helpCenter.privacyPolicy.tr(),
              onTap: () => _showComingSoon(context),
              showDivider: false,
            ),
          ],
        ),
      ],
    );
  }

  /// Launches a URL using url_launcher
  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showErrorSnackbar(context, 'Unable to open link');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackbar(context, 'Unable to open link');
      }
    }
  }

  /// Shows a "Coming Soon" snackbar
  void _showComingSoon(BuildContext context) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocaleKeys.helpCenter.comingSoon.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows an error snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onError),
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
