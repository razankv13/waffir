import 'package:mocktail/mocktail.dart';
import 'package:waffir/features/auth/domain/repositories/auth_repository.dart';
import 'package:waffir/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:waffir/core/services/revenue_cat_service.dart';
import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/network/api_client.dart';
import 'package:waffir/core/services/firebase_service.dart';
import 'package:waffir/core/services/biometric_service.dart';

/// Mock Auth Repository
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock Subscription Repository
class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

/// Mock RevenueCat Service
class MockRevenueCatService extends Mock implements RevenueCatService {}

/// Mock Hive Service
class MockHiveService extends Mock implements HiveService {}

/// Mock Settings Service
class MockSettingsService extends Mock implements SettingsService {}

/// Mock API Client
class MockApiClient extends Mock implements ApiClient {}

/// Mock Firebase Service
class MockFirebaseService extends Mock implements FirebaseService {}

/// Mock Biometric Service
class MockBiometricService extends Mock implements BiometricService {}

/// Mock setup helper
class MockSetup {
  /// Sets up mock fallback values for all mock objects
  static void setUpMockFallbacks() {
    // Register fallback values for common types used in mocks
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(const Duration(seconds: 1));
    registerFallbackValue(DateTime.now());
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
  }

  /// Creates default mocks for basic testing
  static MockAuthRepository createMockAuthRepository() => MockAuthRepository();

  static MockSubscriptionRepository createMockSubscriptionRepository() => MockSubscriptionRepository();

  static MockRevenueCatService createMockRevenueCatService() => MockRevenueCatService();

  static MockHiveService createMockHiveService() => MockHiveService();

  static MockSettingsService createMockSettingsService() => MockSettingsService();

  static MockApiClient createMockApiClient() => MockApiClient();

  static MockFirebaseService createMockFirebaseService() => MockFirebaseService();

  static MockBiometricService createMockBiometricService() => MockBiometricService();
}