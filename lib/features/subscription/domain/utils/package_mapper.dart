import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:waffir/features/subscription/domain/constants/subscription_constants.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_selection_provider.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

/// Maps UI selection state to RevenueCat package identifiers.
///
/// This utility handles the conversion between the user's selection in the UI
/// (period + subscription type) and the corresponding RevenueCat package.
class PackageMapper {
  PackageMapper._();

  /// Get package identifier from UI selection.
  ///
  /// Maps the combination of [period] and [option] to the appropriate
  /// RevenueCat package identifier.
  static String getPackageId({
    required SubscriptionPeriod period,
    required AppSubscriptionOption option,
  }) {
    if (period == SubscriptionPeriod.monthly) {
      return option == AppSubscriptionOption.individual
          ? SubscriptionConstants.monthlySingle
          : SubscriptionConstants.monthlyFamily;
    } else {
      return option == AppSubscriptionOption.individual
          ? SubscriptionConstants.yearlySingle
          : SubscriptionConstants.yearlyFamily;
    }
  }

  /// Get entitlement ID based on subscription option.
  ///
  /// Returns the entitlement identifier that should be granted when
  /// the user purchases the selected subscription option.
  static String getEntitlementId(AppSubscriptionOption option) {
    return option == AppSubscriptionOption.family
        ? SubscriptionConstants.familyEntitlement
        : SubscriptionConstants.singleEntitlement;
  }

  /// Find package from offerings based on UI selection.
  ///
  /// Searches the available offerings for a package matching the user's
  /// selection. Returns null if no matching package is found.
  static Package? findPackage({
    required Offerings? offerings,
    required SubscriptionPeriod period,
    required AppSubscriptionOption option,
  }) {
    if (offerings == null) return null;

    final packageId = getPackageId(period: period, option: option);
    final currentOffering = offerings.current ?? _getFirstOffering(offerings);

    if (currentOffering == null) return null;

    // Try to find exact match first by package identifier
    final exactMatch = _findByIdentifier(currentOffering, packageId);
    if (exactMatch != null) return exactMatch;

    // Fall back to package type matching for standard packages
    return _findByPackageType(currentOffering, period, option);
  }

  /// Get the first available offering if current is not set.
  static Offering? _getFirstOffering(Offerings offerings) {
    if (offerings.all.isEmpty) return null;
    return offerings.all.values.first;
  }

  /// Find package by exact identifier match.
  static Package? _findByIdentifier(Offering offering, String packageId) {
    try {
      return offering.availablePackages.firstWhere((pkg) => pkg.identifier == packageId);
    } catch (_) {
      return null;
    }
  }

  /// Find package by package type for standard RevenueCat packages.
  static Package? _findByPackageType(
    Offering offering,
    SubscriptionPeriod period,
    AppSubscriptionOption option,
  ) {
    // For individual plans, use standard package types
    if (option == AppSubscriptionOption.individual) {
      final packageType = period == SubscriptionPeriod.monthly
          ? PackageType.monthly
          : PackageType.annual;

      try {
        return offering.availablePackages.firstWhere((pkg) => pkg.packageType == packageType);
      } catch (_) {
        return null;
      }
    }

    // For family plans, we need custom package identifiers
    // These won't match standard package types, so return null
    // The exact identifier search should have found them if configured
    return null;
  }

  /// Check if user has the required entitlement for the option.
  ///
  /// Returns true if the user's [customerInfo] contains an active entitlement
  /// for the specified [option].
  static bool hasEntitlement(CustomerInfo? customerInfo, AppSubscriptionOption option) {
    if (customerInfo == null) return false;

    final entitlementId = getEntitlementId(option);
    return customerInfo.entitlements.active.containsKey(entitlementId);
  }

  /// Check if user has any active subscription.
  ///
  /// Returns true if the user has any active entitlement.
  static bool hasAnyActiveSubscription(CustomerInfo? customerInfo) {
    if (customerInfo == null) return false;
    return customerInfo.entitlements.active.isNotEmpty;
  }

  /// Get the active entitlement IDs from customer info.
  ///
  /// Returns a list of active entitlement identifiers.
  static List<String> getActiveEntitlementIds(CustomerInfo? customerInfo) {
    if (customerInfo == null) return [];
    return customerInfo.entitlements.active.keys.toList();
  }

  /// Determine if the current subscription is a family plan.
  ///
  /// Returns true if the user's active entitlement includes the family entitlement.
  static bool isCurrentlyOnFamilyPlan(CustomerInfo? customerInfo) {
    return hasEntitlement(customerInfo, AppSubscriptionOption.family);
  }

  /// Determine if the current subscription is an individual plan.
  ///
  /// Returns true if the user's active entitlement includes the single/individual entitlement.
  static bool isCurrentlyOnIndividualPlan(CustomerInfo? customerInfo) {
    return hasEntitlement(customerInfo, AppSubscriptionOption.individual);
  }

  /// Get subscription period from a package.
  ///
  /// Attempts to determine if a package is monthly or yearly based on
  /// its package type.
  static SubscriptionPeriod? getPeriodFromPackage(Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return SubscriptionPeriod.monthly;
      case PackageType.annual:
        return SubscriptionPeriod.yearly;
      case PackageType.weekly:
      case PackageType.twoMonth:
      case PackageType.threeMonth:
      case PackageType.sixMonth:
      case PackageType.lifetime:
      case PackageType.unknown:
      case PackageType.custom:
        // For custom packages, we'd need to check the identifier
        return null;
    }
  }

  /// Get all available packages grouped by subscription option.
  ///
  /// Returns a map with individual and family packages organized by period.
  static Map<AppSubscriptionOption, Map<SubscriptionPeriod, Package?>> getGroupedPackages(
    Offerings? offerings,
  ) {
    return {
      AppSubscriptionOption.individual: {
        SubscriptionPeriod.monthly: findPackage(
          offerings: offerings,
          period: SubscriptionPeriod.monthly,
          option: AppSubscriptionOption.individual,
        ),
        SubscriptionPeriod.yearly: findPackage(
          offerings: offerings,
          period: SubscriptionPeriod.yearly,
          option: AppSubscriptionOption.individual,
        ),
      },
      AppSubscriptionOption.family: {
        SubscriptionPeriod.monthly: findPackage(
          offerings: offerings,
          period: SubscriptionPeriod.monthly,
          option: AppSubscriptionOption.family,
        ),
        SubscriptionPeriod.yearly: findPackage(
          offerings: offerings,
          period: SubscriptionPeriod.yearly,
          option: AppSubscriptionOption.family,
        ),
      },
    };
  }
}
