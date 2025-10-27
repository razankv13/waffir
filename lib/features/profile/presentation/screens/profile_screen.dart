import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/core/navigation/routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRouteNames.profileEdit);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Edit Profile',
                    variant: ButtonVariant.outlined,
                    size: ButtonSize.small,
                    onPressed: () {
                      context.pushNamed(AppRouteNames.profileEdit);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            
            // Profile stats
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Days Active',
                      value: '42',
                      icon: Icons.calendar_today,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Tasks Done',
                      value: '156',
                      icon: Icons.task_alt,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Score',
                      value: '98%',
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Personal Information'),
                          subtitle: const Text('Name, email, phone number'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.pushNamed(AppRouteNames.profileEdit);
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.security),
                          title: const Text('Security'),
                          subtitle: const Text('Password, two-factor auth'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Security settings coming soon!',
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: const Text('Notifications'),
                          subtitle: const Text('Push notifications, email alerts'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Notification settings coming soon!',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Preferences',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Language'),
                          subtitle: const Text('English (US)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Language settings coming soon!',
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('Theme'),
                          subtitle: const Text('System default'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.pushNamed(AppRouteNames.themeSettings);
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.storage),
                          title: const Text('Storage'),
                          subtitle: const Text('Manage local data'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Storage settings coming soon!',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.help_outline),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Help center coming soon!',
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.feedback_outlined),
                          title: const Text('Send Feedback'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.showInfoSnackBar(
                              message: 'Feedback form coming soon!',
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('About'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            _showAboutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign out button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Sign Out',
                      variant: ButtonVariant.destructive,
                      onPressed: () => _showSignOutDialog(context),
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    DialogService.showInfoDialog(
      context: context,
      title: 'About Flutter Template',
      content: 'Flutter Template v1.0.0\n\nA production-ready Flutter application template with clean architecture, Material 3 design, and modern development practices.',
      primaryButtonText: 'OK',
    );
  }

  void _showSignOutDialog(BuildContext context) {
    DialogService.showConfirmationDialog(
      context: context,
      title: 'Sign Out',
      content: 'Are you sure you want to sign out of your account?',
      confirmText: 'Sign Out',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: () {
        context.showSuccessSnackBar(
          message: 'Successfully signed out',
        );
        context.go(AppRoutes.login);
      },
    );
  }
}

class _StatCard extends StatelessWidget {

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}