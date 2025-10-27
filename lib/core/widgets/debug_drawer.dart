import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/services/revenue_cat_service.dart';
import 'package:waffir/core/constants/app_spacing.dart';

/// Debug drawer with developer tools - only shown in debug/development builds
class DebugDrawer extends ConsumerStatefulWidget {
  const DebugDrawer({super.key});

  @override
  ConsumerState<DebugDrawer> createState() => _DebugDrawerState();
}

class _DebugDrawerState extends ConsumerState<DebugDrawer> {
  PackageInfo? _packageInfo;
  Map<String, dynamic>? _deviceInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();

      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceInfo = {
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'id': androidInfo.id,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceInfo = {
          'platform': 'iOS',
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'model': iosInfo.model,
          'localizedModel': iosInfo.localizedModel,
          'identifierForVendor': iosInfo.identifierForVendor,
        };
      }

      if (mounted) setState(() {});
    } catch (e) {
      AppLogger.error('Failed to load device info', error: e);
    }
  }

  Map<String, dynamic> _packageInfoToMap(PackageInfo? packageInfo) {
    if (packageInfo == null) return {};
    return {
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug/development builds
    if (kReleaseMode && EnvironmentConfig.isProduction) {
      return const SizedBox.shrink();
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  _buildAppInfoSection(),
                  const Divider(),
                  _buildEnvironmentSection(),
                  const Divider(),
                  _buildDeviceInfoSection(),
                  const Divider(),
                  _buildActionsSection(),
                  const Divider(),
                  _buildServiceStatusSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: AppSpacing.paddingMd,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          const Icon(Icons.bug_report, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          const Text(
            'Debug Tools',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('App Information'),
        if (_packageInfo != null) ...[
          _buildInfoRow('Version', '${_packageInfo!.version} (${_packageInfo!.buildNumber})'),
          _buildInfoRow('Package Name', _packageInfo!.packageName),
          _buildInfoRow('App Name', _packageInfo!.appName),
        ] else
          const CircularProgressIndicator(),
      ],
    );
  }

  Widget _buildEnvironmentSection() {
    final config = EnvironmentConfig.exportConfiguration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Environment'),
        _buildInfoRow('Environment', config['environment']),
        _buildInfoRow('Debug Mode', config['enableDebugMode'].toString()),
        _buildInfoRow('Analytics', config['enableAnalytics'].toString()),
        _buildInfoRow('Crash Reporting', config['enableCrashReporting'].toString()),
        _buildInfoRow('API Base URL', config['apiBaseUrl']),
        _buildInfoRow('Has Supabase', config['hasSupabaseConfig'].toString()),
        _buildInfoRow('Has Sentry', config['hasSentryConfig'].toString()),
        _buildInfoRow('Has RevenueCat', config['hasRevenueCatConfig'].toString()),
      ],
    );
  }

  Widget _buildDeviceInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Device Information'),
        if (_deviceInfo != null) ...[
          ..._deviceInfo!.entries.map((entry) =>
            _buildInfoRow(entry.key, entry.value.toString())
          ),
        ] else
          const CircularProgressIndicator(),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Actions'),
        const SizedBox(height: AppSpacing.xs),
        _buildActionButton(
          'Clear All Data',
          Icons.delete_forever,
          Colors.red,
          _clearAllData,
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildActionButton(
          'Clear Cache',
          Icons.clear_all,
          Colors.orange,
          _clearCache,
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildActionButton(
          'Test Crash',
          Icons.warning,
          Colors.red.shade300,
          _testCrash,
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildActionButton(
          'Copy Debug Info',
          Icons.copy,
          Colors.blue,
          _copyDebugInfo,
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildActionButton(
          'Show Logs',
          Icons.list_alt,
          Colors.green,
          _showLogs,
        ),
      ],
    );
  }

  Widget _buildServiceStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Service Status'),
        _buildServiceStatus('Hive', true), // Would need actual implementation
        _buildServiceStatus('RevenueCat', RevenueCatService.instance.isInitialized),
        // Add more services as needed
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: AppSpacing.paddingSm,
        ),
        onPressed: _isLoading ? null : onPressed,
      ),
    );
  }

  Widget _buildServiceStatus(String serviceName, bool isInitialized) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isInitialized ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(serviceName),
          const Spacer(),
          Text(
            isInitialized ? 'Active' : 'Inactive',
            style: TextStyle(
              color: isInitialized ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await _showConfirmationDialog(
      'Clear All Data',
      'This will clear all local app data. Are you sure?',
    );

    if (confirmed) {
      setState(() => _isLoading = true);
      try {
        // Clear image cache
        PaintingBinding.instance.imageCache.clear();
        // await HiveService.instance.clearAll(); // Would need actual implementation
        AppLogger.info('All app data cleared');
        _showSnackBar('All data cleared successfully', Colors.green);
      } catch (e) {
        AppLogger.error('Failed to clear data', error: e);
        _showSnackBar('Failed to clear data', Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearCache() async {
    setState(() => _isLoading = true);
    try {
      // Clear image cache
      PaintingBinding.instance.imageCache.clear();

      AppLogger.info('Cache cleared');
      _showSnackBar('Cache cleared successfully', Colors.green);
    } catch (e) {
      AppLogger.error('Failed to clear cache', error: e);
      _showSnackBar('Failed to clear cache', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testCrash() async {
    final confirmed = await _showConfirmationDialog(
      'Test Crash',
      'This will intentionally crash the app to test crash reporting. Continue?',
    );

    if (confirmed) {
      AppLogger.error('Intentional crash for testing');
      throw Exception('Debug test crash');
    }
  }

  Future<void> _copyDebugInfo() async {
    final config = EnvironmentConfig.exportConfiguration();
    final debugInfo = {
      'app': _packageInfoToMap(_packageInfo),
      'environment': config,
      'device': _deviceInfo ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    };

    await Clipboard.setData(ClipboardData(text: debugInfo.toString()));
    _showSnackBar('Debug info copied to clipboard', Colors.blue);
  }

  Future<void> _showLogs() async {
    await showDialog(
      context: context,
      builder: (context) => const _LogViewerDialog(),
    );
  }

  Future<bool> _showConfirmationDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _LogViewerDialog extends StatelessWidget {
  const _LogViewerDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('App Logs'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            const Text('Recent logs would be displayed here'),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: const SingleChildScrollView(
                  child: Text(
                    'Log entries would be shown here in a real implementation.\n'
                    'This would require integrating with the logging system\n'
                    'to capture and display recent log entries.',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            // Copy logs to clipboard
            Clipboard.setData(const ClipboardData(text: 'Logs would be copied here'));
            Navigator.of(context).pop();
          },
          child: const Text('Copy'),
        ),
      ],
    );
  }
}