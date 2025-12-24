/// RevenueCat package and entitlement identifiers.
///
/// These are placeholder values - update with actual RevenueCat dashboard values
/// once you configure your products in the RevenueCat dashboard.
class SubscriptionConstants {
  SubscriptionConstants._();

  // ============================================
  // ENTITLEMENT IDs (from RevenueCat dashboard)
  // ============================================

  /// Entitlement for individual/single user subscription
  static const String singleEntitlement = 'waffir_single';

  /// Entitlement for family subscription
  static const String familyEntitlement = 'waffir_family';

  // ============================================
  // PACKAGE IDENTIFIERS
  // ============================================
  // Standard RevenueCat packages use $rc_ prefix.
  // Custom packages can use any identifier.
  // Update these once you configure products in RevenueCat dashboard.

  /// Monthly subscription for individual users
  /// Maps to: waffir_single entitlement
  static const String monthlySingle = r'$rc_monthly';

  /// Yearly subscription for individual users
  /// Maps to: waffir_single entitlement
  static const String yearlySingle = r'$rc_annual';

  /// Monthly subscription for family plan
  /// Maps to: waffir_family entitlement
  static const String monthlyFamily = 'monthly_family';

  /// Yearly subscription for family plan
  /// Maps to: waffir_family entitlement
  static const String yearlyFamily = 'annual_family';

  // ============================================
  // OFFERING IDENTIFIER
  // ============================================

  /// Default offering identifier
  static const String defaultOffering = 'default';

  // ============================================
  // PRODUCT IDs (for App Store / Play Store)
  // ============================================
  // These should match the product IDs configured in:
  // - App Store Connect (iOS)
  // - Google Play Console (Android)
  // Update these when you create the products in the stores.

  /// iOS Product IDs
  static const String iosMonthlyProductId = 'net.waffir.app.subscription.monthly';
  static const String iosYearlyProductId = 'net.waffir.app.subscription.yearly';
  static const String iosMonthlyFamilyProductId = 'net.waffir.app.subscription.monthly.family';
  static const String iosYearlyFamilyProductId = 'net.waffir.app.subscription.yearly.family';

  /// Android Product IDs
  static const String androidMonthlyProductId = 'waffir_monthly_subscription';
  static const String androidYearlyProductId = 'waffir_yearly_subscription';
  static const String androidMonthlyFamilyProductId = 'waffir_monthly_family_subscription';
  static const String androidYearlyFamilyProductId = 'waffir_yearly_family_subscription';

  // ============================================
  // GRACE PERIOD
  // ============================================

  /// Grace period duration (platform-dependent)
  /// iOS: typically 16 days
  /// Android: typically 7 days
  static const Duration gracePeriodDuration = Duration(days: 16);
}
