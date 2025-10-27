import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/core/widgets/premium_feature_wrapper.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';

class SettingsScreen extends ConsumerWidget with PremiumFeatureMixin {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (!isPremium)
            IconButton(
              icon: const Icon(Icons.star_outline, color: Colors.amber),
              onPressed: () => showPaywall(context),
              tooltip: 'Upgrade to Premium',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Settings
              Text(
                'App Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: const Text('Theme'),
                      subtitle: const Text('Customize app appearance'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(AppRouteNames.themeSettings);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      subtitle: const Text('Change app language'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLanguageDialog(context);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      subtitle: const Text('Manage notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(AppRouteNames.notificationSettings);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy & Security
              Text(
                'Privacy & Security',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy'),
                      subtitle: const Text('Data collection preferences'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(AppRouteNames.privacySettings);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: const Text('Security'),
                      subtitle: const Text('Biometric, passwords'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.showInfoSnackBar(
                          message: 'Security settings coming soon!',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('Account'),
                      subtitle: const Text('Manage your account'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(AppRouteNames.accountSettings);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Subscription Section
              Text(
                'Subscription',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    if (isPremium) ...[
                      ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Row(
                          children: [
                            const Text('Premium Active'),
                            const SizedBox(width: 8),
                            buildPremiumBadge(),
                          ],
                        ),
                        subtitle: const Text('Manage your subscription'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showSubscriptionManagement(context),
                      ),
                    ] else ...[
                      ListTile(
                        leading: const Icon(Icons.star_outline, color: Colors.amber),
                        title: const Text('Upgrade to Premium'),
                        subtitle: const Text('Unlock all premium features'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showPaywall(context),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Data & Storage
              Text(
                'Data & Storage',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storage),
                      title: const Text('Storage Usage'),
                      subtitle: const Text('View app storage usage'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '45 MB',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        _showStorageDialog(context);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.download_outlined),
                      title: const Text('Offline Data'),
                      subtitle: const Text('Manage cached content'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.showInfoSnackBar(
                          message: 'Offline data management coming soon!',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.cloud_sync_outlined),
                      title: const Text('Backup & Sync'),
                      subtitle: const Text('Cloud synchronization'),
                      trailing: Switch.adaptive(
                        value: true,
                        onChanged: (value) {
                          context.showInfoSnackBar(
                            message: value 
                              ? 'Backup enabled' 
                              : 'Backup disabled',
                          );
                        },
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Developer Options
              Text(
                'Developer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bug_report_outlined),
                      title: const Text('Debug Mode'),
                      subtitle: const Text('Enable debug features'),
                      trailing: Switch.adaptive(
                        value: false,
                        onChanged: (value) {
                          _showDebugModeDialog(context, value);
                        },
                      ),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Developer Tools'),
                      subtitle: const Text('Advanced debugging options'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showDeveloperToolsDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // About
              Text(
                'About',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outlined),
                      title: const Text('App Info'),
                      subtitle: const Text('Version, build info'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showAppInfoDialog(context);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.showInfoSnackBar(
                          message: 'Terms of service coming soon!',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.policy_outlined),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.showInfoSnackBar(
                          message: 'Privacy policy coming soon!',
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = [
      {'name': 'English (US)', 'code': 'en'},
      {'name': 'Español', 'code': 'es'},
      {'name': 'Français', 'code': 'fr'},
    ];

    DialogService.showCustomDialog(
      context: context,
      child: BaseDialog(
        type: DialogType.info,
        title: 'Select Language',
        content: '',
        primaryButtonText: 'Cancel',
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) => ListTile(
            title: Text(lang['name']!),
            leading: Icon(
              lang['code'] == 'en' ? Icons.radio_button_checked : Icons.radio_button_off,
              color: lang['code'] == 'en' ? Theme.of(context).primaryColor : null,
            ),
            onTap: () {
              Navigator.of(context).pop();
              context.showInfoSnackBar(
                message: 'Language changed to ${lang['name']}',
              );
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    DialogService.showInfoDialog(
      context: context,
      title: 'Storage Usage',
      content: '''Total: 45.2 MB

• App Data: 12.1 MB
• Cache: 18.3 MB
• Images: 10.2 MB
• Documents: 4.6 MB

Clear cache to free up space.''',
      primaryButtonText: 'Clear Cache',
      secondaryButtonText: 'Close',
      onPrimaryPressed: () {
        Navigator.of(context).pop();
        context.showSuccessSnackBar(
          message: 'Cache cleared successfully',
        );
      },
    );
  }

  void _showDebugModeDialog(BuildContext context, bool enable) {
    if (enable) {
      DialogService.showWarningDialog(
        context: context,
        title: 'Enable Debug Mode',
        content: 'Debug mode will show additional information and may impact performance. Enable debug mode?',
        primaryButtonText: 'Enable',
        secondaryButtonText: 'Cancel',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          context.showWarningSnackBar(
            message: 'Debug mode enabled',
          );
        },
      );
    } else {
      context.showInfoSnackBar(
        message: 'Debug mode disabled',
      );
    }
  }

  void _showDeveloperToolsDialog(BuildContext context) {
    DialogService.showInfoDialog(
      context: context,
      title: 'Developer Tools',
      content: '''Available tools:

• Performance Monitor
• Network Inspector
• State Inspector
• Error Reporter
• Log Viewer

These tools are for development purposes only.''',
      primaryButtonText: 'Open Tools',
      secondaryButtonText: 'Cancel',
      onPrimaryPressed: () {
        Navigator.of(context).pop();
        context.showInfoSnackBar(
          message: 'Developer tools coming soon!',
        );
      },
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    DialogService.showInfoDialog(
      context: context,
      title: 'Flutter Template',
      content: '''Version: 1.0.0
Build: 100
Flutter: 3.35.2
Dart: 3.9.0

© 2024 Flutter Template
All rights reserved.''',
      primaryButtonText: 'OK',
    );
  }
}