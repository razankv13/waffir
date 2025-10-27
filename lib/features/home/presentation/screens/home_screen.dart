import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.showInfoSnackBar(
                message: 'Notifications feature coming soon!',
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.waving_hand,
                          color: Colors.amber,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Welcome back!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to explore the amazing features of this Flutter template?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _QuickActionCard(
                  icon: Icons.person_outlined,
                  title: 'Profile',
                  subtitle: 'View and edit your profile',
                  onTap: () {
                    // Navigation handled by BottomNavigation
                    context.showInfoSnackBar(
                      message: 'Tap Profile in bottom navigation',
                    );
                  },
                ),
                _QuickActionCard(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Customize your preferences',
                  onTap: () {
                    // Navigation handled by BottomNavigation
                    context.showInfoSnackBar(
                      message: 'Tap Settings in bottom navigation',
                    );
                  },
                ),
                _QuickActionCard(
                  icon: Icons.widgets_outlined,
                  title: 'Widgets Demo',
                  subtitle: 'See custom widgets in action',
                  onTap: () => _showWidgetDemo(context),
                ),
                _QuickActionCard(
                  icon: Icons.color_lens_outlined,
                  title: 'Theme Demo',
                  subtitle: 'Test light and dark themes',
                  onTap: () => _showThemeDemo(context),
                ),
                _QuickActionCard(
                  icon: Icons.list_alt_outlined,
                  title: 'Sample List',
                  subtitle: 'View paginated list demo',
                  onTap: () => context.push(AppRoutes.sampleList),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recent activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.login),
                    ),
                    title: const Text('Signed in successfully'),
                    subtitle: const Text('Welcome to Flutter Template'),
                    trailing: Text(
                      '2 min ago',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.account_circle),
                    ),
                    title: const Text('Account created'),
                    subtitle: const Text('Your profile is ready'),
                    trailing: Text(
                      '5 min ago',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Feature showcase
            Text(
              'Template Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            const Column(
              children: [
                _FeatureItem(
                  icon: Icons.architecture,
                  title: 'Clean Architecture',
                  description: 'Feature-based modular structure with clear separation of concerns',
                ),
                _FeatureItem(
                  icon: Icons.route,
                  title: 'Go Router Navigation',
                  description: 'Type-safe navigation with route guards and deep linking',
                ),
                _FeatureItem(
                  icon: Icons.palette,
                  title: 'Material 3 Theming',
                  description: 'Beautiful design system with light and dark themes',
                ),
                _FeatureItem(
                  icon: Icons.security,
                  title: 'Authentication Ready',
                  description: 'Supabase integration with secure user management',
                ),
                _FeatureItem(
                  icon: Icons.storage,
                  title: 'Local Storage',
                  description: 'Hive database with encryption for offline data',
                ),
                _FeatureItem(
                  icon: Icons.language,
                  title: 'Internationalization',
                  description: 'Multi-language support with Easy Localization',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWidgetDemo(BuildContext context) {
    DialogService.showCustomDialog(
      context: context,
      child: BaseDialog(
        type: DialogType.info,
        title: 'Widget Demo',
        content: '',
        primaryButtonText: 'Show Loading',
        secondaryButtonText: 'Show Success',
        onPrimaryPressed: () async {
          Navigator.of(context).pop();
          context.showLoadingDialog(message: 'Loading demo...');
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            context.hideLoadingDialog();
            context.showSuccessSnackBar(message: 'Loading demo completed!');
          }
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop();
          context.showSuccessSnackBar(
            message: 'This is a success snackbar!',
            actionLabel: 'UNDO',
            onActionPressed: () {
              context.showInfoSnackBar(message: 'Action pressed!');
            },
          );
        },
        customContent: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Try out our custom widgets:'),
            SizedBox(height: 16),
            Row(
              children: [
                LoadingIndicator(type: LoadingIndicatorType.dots),
                SizedBox(width: 16),
                LoadingIndicator(type: LoadingIndicatorType.pulse),
                SizedBox(width: 16),
                LoadingIndicator(type: LoadingIndicatorType.wave),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDemo(BuildContext context) {
    DialogService.showInfoDialog(
      context: context,
      title: 'Theme Demo',
      content: 'This template includes beautiful Material 3 themes. Toggle between light and dark modes in your system settings to see the difference!',
      primaryButtonText: 'Got it',
    );
  }
}

class _QuickActionCard extends StatelessWidget {

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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