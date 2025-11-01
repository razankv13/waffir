// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:waffir/core/services/admob_service.dart';
// import 'package:waffir/core/config/environment_config.dart';

// // Provider for AdMob service instance
// final adMobServiceProvider = Provider<AdMobService>((ref) {
//   return AdMobService.instance;
// });

// // Provider for ad initialization status
// final adInitializationProvider = FutureProvider<bool>((ref) async {
//   final service = ref.read(adMobServiceProvider);
//   if (!EnvironmentConfig.enableAds) return false;

//   try {
//     await service.initialize();
//     return service.isInitialized;
//   } catch (e) {
//     return false;
//   }
// });

// // Provider for checking if ads should be shown (considering subscription status)
// final shouldShowAdsProvider = Provider<bool>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   final isPremium = ref.watch(isPremiumUserProvider);

//   // Don't show ads for premium users
//   if (isPremium) {
//     return false;
//   }

//   return service.shouldShowAds();
// });

// // Provider for premium subscription status
// final isPremiumForAdsProvider = Provider<bool>((ref) {
//   return ref.watch(isPremiumUserProvider);
// });

// // Provider for comprehensive ad visibility check
// final adVisibilityProvider = Provider<AdVisibility>((ref) {
//   final adsEnabled = EnvironmentConfig.enableAds;
//   final isPremium = ref.watch(isPremiumUserProvider);
//   final service = ref.read(adMobServiceProvider);
//   final hasConsent = service.hasUserConsent;
//   final isInitialized = service.isInitialized;

//   if (!adsEnabled) {
//     return AdVisibility.disabled('Ads are disabled in configuration');
//   }

//   if (isPremium) {
//     return AdVisibility.hidden('Premium user - ads hidden');
//   }

//   if (!isInitialized) {
//     return AdVisibility.notReady('Ad service not initialized');
//   }

//   if (!hasConsent) {
//     return AdVisibility.noConsent('User consent required');
//   }

//   return AdVisibility.visible();
// });

// // Provider for user consent status
// final adConsentStatusProvider = Provider<bool>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   return service.hasUserConsent;
// });

// // Provider for ad personalization status
// final adPersonalizationProvider = Provider<bool>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   return service.isPersonalizedAds;
// });

// // Provider for interstitial ad readiness
// final interstitialAdReadyProvider = Provider<bool>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   return service.isInterstitialAdReady;
// });

// // Provider for rewarded ad readiness
// final rewardedAdReadyProvider = Provider<bool>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   return service.isRewardedAdReady;
// });

// // Provider family for checking if rewarded ad is available for specific reward type
// final rewardedAdAvailableProvider = Provider.family<bool, String>((ref, rewardType) {
//   final service = ref.read(adMobServiceProvider);
//   return service.isRewardedAdAvailable(rewardType);
// });

// // Provider family for checking if interstitial should be shown for specific action
// final shouldShowInterstitialProvider = Provider.family<bool, String>((ref, action) {
//   final service = ref.read(adMobServiceProvider);
//   return service.shouldShowInterstitialForAction(action);
// });

// // Provider for available reward types
// final availableRewardTypesProvider = Provider<List<String>>((ref) {
//   final service = ref.read(adMobServiceProvider);
//   return service.getAvailableRewardTypes();
// });

// // AsyncNotifier for managing ad state
// class AdStateNotifier extends AsyncNotifier<AdState> {
//   late AdMobService _adMobService;

//   @override
//   Future<AdState> build() async {
//     _adMobService = ref.read(adMobServiceProvider);
//     return _loadInitialState();
//   }

//   Future<AdState> _loadInitialState() async {
//     if (!EnvironmentConfig.enableAds) {
//       return AdState.adsDisabled();
//     }

//     try {
//       if (!_adMobService.isInitialized) {
//         await _adMobService.initialize();
//       }

//       return AdState(
//         isInitialized: _adMobService.isInitialized,
//         hasUserConsent: _adMobService.hasUserConsent,
//         isPersonalizedAds: _adMobService.isPersonalizedAds,
//         isInterstitialAdReady: _adMobService.isInterstitialAdReady,
//         isRewardedAdReady: _adMobService.isRewardedAdReady,
//         interstitialShowCount: _adMobService.interstitialShowCount,
//         rewardedShowCount: _adMobService.rewardedShowCount,
//         shouldShowAds: _adMobService.shouldShowAds(),
//         adsEnabled: EnvironmentConfig.enableAds,
//       );
//     } catch (error) {
//       return AdState.error(error.toString());
//     }
//   }

//   /// Refresh ad state
//   Future<void> refreshState() async {
//     state = const AsyncValue.loading();
//     try {
//       final newState = await _loadInitialState();
//       state = AsyncValue.data(newState);
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//     }
//   }

//   /// Load interstitial ad
//   Future<bool> loadInterstitialAd() async {
//     try {
//       await _adMobService.loadInterstitialAd();
//       await refreshState();
//       return true;
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to load interstitial ad: $error',
//       ));
//       return false;
//     }
//   }

//   /// Show interstitial ad
//   Future<bool> showInterstitialAd({String? context}) async {
//     try {
//       final result = await _adMobService.showInterstitialAd(context: context);
//       await refreshState();
//       return result;
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to show interstitial ad: $error',
//       ));
//       return false;
//     }
//   }

//   /// Load rewarded ad
//   Future<bool> loadRewardedAd() async {
//     try {
//       await _adMobService.loadRewardedAd();
//       await refreshState();
//       return true;
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to load rewarded ad: $error',
//       ));
//       return false;
//     }
//   }

//   /// Show rewarded ad
//   Future<RewardedAdResult> showRewardedAd({
//     required String rewardType,
//     String? context,
//   }) async {
//     try {
//       final result = await _adMobService.showRewardedAd(
//         rewardType: rewardType,
//         context: context,
//       );
//       await refreshState();
//       return result;
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to show rewarded ad: $error',
//       ));
//       return RewardedAdResult.error(error.toString());
//     }
//   }

//   /// Preload ads for better user experience
//   Future<void> preloadAds() async {
//     try {
//       await _adMobService.preloadInterstitialAd();
//       await _adMobService.preloadRewardedAd();
//       await refreshState();
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to preload ads: $error',
//       ));
//     }
//   }

//   /// Reset user consent (for testing)
//   Future<void> resetConsent() async {
//     try {
//       await _adMobService.resetConsent();
//       await refreshState();
//     } catch (error) {
//       state = state.whenData((current) => current.copyWith(
//         error: 'Failed to reset consent: $error',
//       ));
//     }
//   }

//   /// Clear error state
//   void clearError() {
//     state = state.whenData((current) => current.copyWith(error: null));
//   }
// }

// // Provider for ad state notifier
// final adStateNotifierProvider = AsyncNotifierProvider<AdStateNotifier, AdState>(() {
//   return AdStateNotifier();
// });

// // Data class for ad state
// class AdState {
//   const AdState({
//     this.isInitialized = false,
//     this.hasUserConsent = false,
//     this.isPersonalizedAds = false,
//     this.isInterstitialAdReady = false,
//     this.isRewardedAdReady = false,
//     this.interstitialShowCount = 0,
//     this.rewardedShowCount = 0,
//     this.shouldShowAds = false,
//     this.adsEnabled = true,
//     this.error,
//     this.isLoading = false,
//   });

//   final bool isInitialized;
//   final bool hasUserConsent;
//   final bool isPersonalizedAds;
//   final bool isInterstitialAdReady;
//   final bool isRewardedAdReady;
//   final int interstitialShowCount;
//   final int rewardedShowCount;
//   final bool shouldShowAds;
//   final bool adsEnabled;
//   final String? error;
//   final bool isLoading;

//   /// Factory constructor for ads disabled state
//   factory AdState.adsDisabled() {
//     return const AdState(
//       isInitialized: false,
//       shouldShowAds: false,
//       adsEnabled: false,
//     );
//   }

//   /// Factory constructor for error state
//   factory AdState.error(String errorMessage) {
//     return AdState(
//       error: errorMessage,
//       shouldShowAds: false,
//     );
//   }

//   /// Factory constructor for loading state
//   factory AdState.loading() {
//     return const AdState(
//       isLoading: true,
//     );
//   }

//   AdState copyWith({
//     bool? isInitialized,
//     bool? hasUserConsent,
//     bool? isPersonalizedAds,
//     bool? isInterstitialAdReady,
//     bool? isRewardedAdReady,
//     int? interstitialShowCount,
//     int? rewardedShowCount,
//     bool? shouldShowAds,
//     bool? adsEnabled,
//     String? error,
//     bool? isLoading,
//   }) {
//     return AdState(
//       isInitialized: isInitialized ?? this.isInitialized,
//       hasUserConsent: hasUserConsent ?? this.hasUserConsent,
//       isPersonalizedAds: isPersonalizedAds ?? this.isPersonalizedAds,
//       isInterstitialAdReady: isInterstitialAdReady ?? this.isInterstitialAdReady,
//       isRewardedAdReady: isRewardedAdReady ?? this.isRewardedAdReady,
//       interstitialShowCount: interstitialShowCount ?? this.interstitialShowCount,
//       rewardedShowCount: rewardedShowCount ?? this.rewardedShowCount,
//       shouldShowAds: shouldShowAds ?? this.shouldShowAds,
//       adsEnabled: adsEnabled ?? this.adsEnabled,
//       error: error,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }

//   bool get hasError => error != null;
//   bool get canShowInterstitials => shouldShowAds && isInterstitialAdReady;
//   bool get canShowRewarded => shouldShowAds && isRewardedAdReady;
//   bool get isReady => isInitialized && hasUserConsent;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AdState &&
//           runtimeType == other.runtimeType &&
//           isInitialized == other.isInitialized &&
//           hasUserConsent == other.hasUserConsent &&
//           isPersonalizedAds == other.isPersonalizedAds &&
//           isInterstitialAdReady == other.isInterstitialAdReady &&
//           isRewardedAdReady == other.isRewardedAdReady &&
//           interstitialShowCount == other.interstitialShowCount &&
//           rewardedShowCount == other.rewardedShowCount &&
//           shouldShowAds == other.shouldShowAds &&
//           adsEnabled == other.adsEnabled &&
//           error == other.error &&
//           isLoading == other.isLoading;

//   @override
//   int get hashCode =>
//       isInitialized.hashCode ^
//       hasUserConsent.hashCode ^
//       isPersonalizedAds.hashCode ^
//       isInterstitialAdReady.hashCode ^
//       isRewardedAdReady.hashCode ^
//       interstitialShowCount.hashCode ^
//       rewardedShowCount.hashCode ^
//       shouldShowAds.hashCode ^
//       adsEnabled.hashCode ^
//       error.hashCode ^
//       isLoading.hashCode;

//   @override
//   String toString() {
//     return 'AdState{isInitialized: $isInitialized, hasUserConsent: $hasUserConsent, '
//         'isPersonalizedAds: $isPersonalizedAds, isInterstitialAdReady: $isInterstitialAdReady, '
//         'isRewardedAdReady: $isRewardedAdReady, interstitialShowCount: $interstitialShowCount, '
//         'rewardedShowCount: $rewardedShowCount, shouldShowAds: $shouldShowAds, '
//         'adsEnabled: $adsEnabled, error: $error, isLoading: $isLoading}';
//   }
// }

// /// Enum for different ad visibility states
// enum AdVisibilityState {
//   visible,
//   hidden,
//   disabled,
//   notReady,
//   noConsent,
// }

// /// Class representing ad visibility with reason
// class AdVisibility {
//   const AdVisibility._(this.state, this.reason);

//   final AdVisibilityState state;
//   final String reason;

//   /// Ads are visible and should be shown
//   factory AdVisibility.visible() {
//     return const AdVisibility._(AdVisibilityState.visible, 'Ads can be shown');
//   }

//   /// Ads are hidden (e.g., for premium users)
//   factory AdVisibility.hidden(String reason) {
//     return AdVisibility._(AdVisibilityState.hidden, reason);
//   }

//   /// Ads are disabled in configuration
//   factory AdVisibility.disabled(String reason) {
//     return AdVisibility._(AdVisibilityState.disabled, reason);
//   }

//   /// Ads are not ready (e.g., service not initialized)
//   factory AdVisibility.notReady(String reason) {
//     return AdVisibility._(AdVisibilityState.notReady, reason);
//   }

//   /// User consent is required
//   factory AdVisibility.noConsent(String reason) {
//     return AdVisibility._(AdVisibilityState.noConsent, reason);
//   }

//   bool get shouldShowAds => state == AdVisibilityState.visible;
//   bool get isHiddenForPremium => state == AdVisibilityState.hidden && reason.contains('Premium');
//   bool get isDisabled => state == AdVisibilityState.disabled;
//   bool get requiresConsent => state == AdVisibilityState.noConsent;
//   bool get isNotReady => state == AdVisibilityState.notReady;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AdVisibility &&
//           runtimeType == other.runtimeType &&
//           state == other.state &&
//           reason == other.reason;

//   @override
//   int get hashCode => state.hashCode ^ reason.hashCode;

//   @override
//   String toString() => 'AdVisibility{state: $state, reason: $reason}';
// }