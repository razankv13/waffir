import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' hide BiometricType;
import 'package:local_auth/local_auth.dart' as local_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/storage/settings_service.dart';

/// Biometric authentication types
enum BiometricType {
  none,
  fingerprint,
  face,
  iris,
  weak,
  strong,
}

/// Biometric authentication result
class BiometricAuthResult {

  const BiometricAuthResult({
    required this.isSuccess,
    this.errorMessage,
    this.authenticatedWith,
  });

  const BiometricAuthResult.success({this.authenticatedWith})
      : isSuccess = true,
        errorMessage = null;

  const BiometricAuthResult.failure(this.errorMessage)
      : isSuccess = false,
        authenticatedWith = null;
  final bool isSuccess;
  final String? errorMessage;
  final BiometricType? authenticatedWith;
}

/// Service for handling biometric authentication
class BiometricService {

  BiometricService._internal();
  static BiometricService? _instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  static BiometricService get instance {
    _instance ??= BiometricService._internal();
    return _instance!;
  }

  /// Check if biometric authentication is available on device
  Future<bool> isAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      AppLogger.debug('Biometric availability: $isAvailable, device supported: $isDeviceSupported');
      return isAvailable && isDeviceSupported;
    } catch (e) {
      AppLogger.error('Failed to check biometric availability', error: e);
      return false;
    }
  }

  /// Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      return availableBiometrics.map((biometric) {
        switch (biometric) {
          case local_auth.BiometricType.fingerprint:
            return BiometricType.fingerprint;
          case local_auth.BiometricType.face:
            return BiometricType.face;
          case local_auth.BiometricType.iris:
            return BiometricType.iris;
          case local_auth.BiometricType.weak:
            return BiometricType.weak;
          case local_auth.BiometricType.strong:
            return BiometricType.strong;
        }
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to get available biometrics', error: e);
      return [];
    }
  }

  /// Check if biometrics are enrolled on the device
  Future<bool> isEnrolled() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      AppLogger.error('Failed to check biometric enrollment', error: e);
      return false;
    }
  }

  /// Authenticate using biometrics
  Future<BiometricAuthResult> authenticate({
    String? reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool sensitiveTransaction = true,
    bool biometricOnly = false,
  }) async {
    try {
      if (!await isAvailable()) {
        return const BiometricAuthResult.failure('Biometric authentication is not available');
      }

      if (!await isEnrolled()) {
        return const BiometricAuthResult.failure('No biometrics enrolled on this device');
      }

      final authReason = reason ?? AppConstants.biometricReason;
      
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: authReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          sensitiveTransaction: sensitiveTransaction,
          biometricOnly: biometricOnly,
        ),
      );

      if (didAuthenticate) {
        AppLogger.info('✅ Biometric authentication successful');
        
        // Try to determine which biometric was used
        final availableBiometrics = await getAvailableBiometrics();
        final usedBiometric = availableBiometrics.isNotEmpty 
            ? availableBiometrics.first 
            : BiometricType.none;
            
        return BiometricAuthResult.success(authenticatedWith: usedBiometric);
      } else {
        AppLogger.warning('❌ Biometric authentication failed - user cancelled or failed');
        return const BiometricAuthResult.failure('Authentication failed or cancelled');
      }
    } on PlatformException catch (e) {
      AppLogger.error('❌ Biometric authentication platform error', error: e);
      
      String errorMessage = 'Authentication failed';
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'Biometric authentication is not available';
          break;
        case 'NotEnrolled':
          errorMessage = 'No biometrics enrolled on this device';
          break;
        case 'PermanentlyLockedOut':
          errorMessage = 'Biometric authentication is permanently disabled';
          break;
        case 'LockedOut':
          errorMessage = 'Biometric authentication is temporarily disabled';
          break;
        case 'UserCancel':
          errorMessage = 'Authentication cancelled by user';
          break;
        case 'UserFallback':
          errorMessage = 'User selected fallback authentication';
          break;
        case 'BiometricOnlyNotSupported':
          errorMessage = 'Biometric-only authentication not supported';
          break;
        case 'DeviceNotSupported':
          errorMessage = 'Device does not support biometric authentication';
          break;
        case 'PasscodeNotSet':
          errorMessage = 'Device passcode not set';
          break;
        default:
          errorMessage = e.message ?? 'Unknown authentication error';
          break;
      }
      
      return BiometricAuthResult.failure(errorMessage);
    } catch (e) {
      AppLogger.error('❌ Unexpected biometric authentication error', error: e);
      return BiometricAuthResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  /// Quick authentication for app unlock
  Future<BiometricAuthResult> authenticateForAppUnlock() async {
    return authenticate(
      reason: 'Unlock ${AppConstants.appName}',
      stickyAuth: true,
      sensitiveTransaction: false,
    );
  }

  /// Authentication for sensitive transactions
  Future<BiometricAuthResult> authenticateForTransaction({
    String? transactionReason,
  }) async {
    final reason = transactionReason ?? 'Authenticate to proceed with this transaction';
    
    return authenticate(
      reason: reason,
      stickyAuth: true,
      biometricOnly: true,
    );
  }

  /// Get user-friendly biometric type name
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.weak:
        return 'Weak Biometric';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.none:
        return 'None';
    }
  }

  /// Get primary available biometric type name
  Future<String> getPrimaryBiometricName() async {
    final availableBiometrics = await getAvailableBiometrics();
    
    if (availableBiometrics.isEmpty) {
      return 'Biometric';
    }

    // Prioritize face > fingerprint > others
    if (availableBiometrics.contains(BiometricType.face)) {
      return getBiometricTypeName(BiometricType.face);
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return getBiometricTypeName(BiometricType.fingerprint);
    } else {
      return getBiometricTypeName(availableBiometrics.first);
    }
  }

  /// Check if biometrics are enabled in app settings
  Future<bool> isBiometricLoginEnabled() async {
    final settingsService = SettingsService.instance;
    return settingsService.getSettings().biometricsEnabled;
  }

  /// Enable/disable biometric login in app settings
  Future<void> setBiometricLoginEnabled(bool enabled) async {
    final settingsService = SettingsService.instance;
    await settingsService.updateBiometricsEnabled(enabled);
    
    AppLogger.info('Biometric login ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Get comprehensive biometric status
  Future<BiometricStatus> getStatus() async {
    final isDeviceSupported = await isAvailable();
    final isEnrolledOnDevice = await isEnrolled();
    final isEnabledInApp = await isBiometricLoginEnabled();
    final availableBiometrics = await getAvailableBiometrics();
    final primaryBiometricName = await getPrimaryBiometricName();

    return BiometricStatus(
      isDeviceSupported: isDeviceSupported,
      isEnrolledOnDevice: isEnrolledOnDevice,
      isEnabledInApp: isEnabledInApp,
      availableBiometrics: availableBiometrics,
      primaryBiometricName: primaryBiometricName,
    );
  }
}

/// Comprehensive biometric status
class BiometricStatus {

  const BiometricStatus({
    required this.isDeviceSupported,
    required this.isEnrolledOnDevice,
    required this.isEnabledInApp,
    required this.availableBiometrics,
    required this.primaryBiometricName,
  });
  final bool isDeviceSupported;
  final bool isEnrolledOnDevice;
  final bool isEnabledInApp;
  final List<BiometricType> availableBiometrics;
  final String primaryBiometricName;

  bool get isFullyAvailable => 
      isDeviceSupported && isEnrolledOnDevice && isEnabledInApp;
  
  bool get canBeEnabled => 
      isDeviceSupported && isEnrolledOnDevice;
  
  String get statusDescription {
    if (!isDeviceSupported) {
      return 'Biometric authentication is not supported on this device';
    } else if (!isEnrolledOnDevice) {
      return 'No biometrics enrolled. Please set up biometric authentication in device settings';
    } else if (!isEnabledInApp) {
      return 'Biometric authentication is disabled in app settings';
    } else {
      return 'Biometric authentication is enabled and ready';
    }
  }

  @override
  String toString() {
    return 'BiometricStatus(supported: $isDeviceSupported, enrolled: $isEnrolledOnDevice, enabled: $isEnabledInApp, types: $availableBiometrics)';
  }
}

/// Riverpod providers for biometric service
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService.instance;
});

/// Provider for biometric availability
final biometricAvailabilityProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(biometricServiceProvider);
  return service.isAvailable();
});

/// Provider for biometric enrollment status
final biometricEnrollmentProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(biometricServiceProvider);
  return service.isEnrolled();
});

/// Provider for available biometric types
final availableBiometricsProvider = FutureProvider<List<BiometricType>>((ref) async {
  final service = ref.read(biometricServiceProvider);
  return service.getAvailableBiometrics();
});

/// Provider for comprehensive biometric status
final biometricStatusProvider = FutureProvider<BiometricStatus>((ref) async {
  final service = ref.read(biometricServiceProvider);
  return service.getStatus();
});

/// Provider for primary biometric name
final primaryBiometricNameProvider = FutureProvider<String>((ref) async {
  final service = ref.read(biometricServiceProvider);
  return service.getPrimaryBiometricName();
});