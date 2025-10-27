import 'dart:io';

import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/services/firebase_service.dart';
import 'package:waffir/core/services/revenue_cat_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob service for managing Google Mobile Ads
class AdMobService {
  AdMobService._internal();
  static AdMobService? _instance;
  static AdMobService get instance => _instance ??= AdMobService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Consent and configuration state
  bool _hasUserConsent = false;
  bool _isPersonalizedAds = false;
  ConsentInformation? _consentInformation;
  ConsentForm? _consentForm;

  // Ad loading state tracking
  final Map<String, bool> _adLoadingState = {};
  final Map<String, int> _adFailureCount = {};

  // Interstitial ad management
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  DateTime? _lastInterstitialShownTime;
  int _interstitialShowCount = 0;

  // Rewarded ad management
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  DateTime? _lastRewardedShownTime;
  int _rewardedShowCount = 0;

  // Getters
  bool get hasUserConsent => _hasUserConsent;
  bool get isPersonalizedAds => _isPersonalizedAds;
  bool get requiresConsent => EnvironmentConfig.requireConsentForAds;
  bool get isInterstitialAdReady => _isInterstitialAdReady;
  int get interstitialShowCount => _interstitialShowCount;
  bool get isRewardedAdReady => _isRewardedAdReady;
  int get rewardedShowCount => _rewardedShowCount;

  /// Initialize AdMob service
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.info('📱 AdMob already initialized');
      return;
    }

    if (!EnvironmentConfig.enableAds) {
      AppLogger.info('📱 Ads disabled via configuration');
      return;
    }

    try {
      AppLogger.info('📱 Initializing AdMob...');

      // Initialize Google Mobile Ads SDK
      await MobileAds.instance.initialize();

      // Initialize consent if required
      if (requiresConsent) {
        await _initializeConsent();
      } else {
        _hasUserConsent = true;
        _isPersonalizedAds = EnvironmentConfig.enableAdPersonalization;
      }

      // Configure ad request settings
      await _configureAdSettings();

      _isInitialized = true;
      AppLogger.info('✅ AdMob initialization completed');

      // Log analytics event
      await _logAnalyticsEvent('admob_initialized', {
        'has_consent': _hasUserConsent,
        'personalized_ads': _isPersonalizedAds,
        'test_ads': EnvironmentConfig.enableTestAds,
      });
    } catch (error, stackTrace) {
      AppLogger.error('❌ AdMob initialization failed', error: error, stackTrace: stackTrace);
      await _logAnalyticsEvent('admob_init_failed', {'error': error.toString()});
      rethrow;
    }
  }

  /// Initialize user consent for ads - simplified implementation
  Future<void> _initializeConsent() async {
    try {
      AppLogger.info('📱 Initializing ad consent...');

      // Simplified consent management - in production, implement full UMP SDK
      // For now, default to having consent and use environment config for personalization
      _hasUserConsent = true;
      _isPersonalizedAds = EnvironmentConfig.enableAdPersonalization;

      AppLogger.info('✅ Ad consent initialized - Consent: $_hasUserConsent, Personalized: $_isPersonalizedAds');
    } catch (error, stackTrace) {
      AppLogger.error('❌ Failed to initialize ad consent', error: error, stackTrace: stackTrace);
      // Default to non-personalized ads if consent fails
      _hasUserConsent = true;
      _isPersonalizedAds = false;
    }
  }

  /// Load consent form - placeholder for production implementation
  Future<void> _loadConsentForm() async {
    try {
      AppLogger.info('📋 Loading consent form - using default values');
      // In production, implement proper UMP SDK consent form
      _hasUserConsent = true;
      _isPersonalizedAds = EnvironmentConfig.enableAdPersonalization;
    } catch (error, stackTrace) {
      AppLogger.error('❌ Failed to load consent form', error: error, stackTrace: stackTrace);
      _hasUserConsent = true;
      _isPersonalizedAds = false;
    }
  }

  /// Show consent form to user - placeholder for production implementation
  Future<void> _showConsentForm() async {
    try {
      AppLogger.info('📋 Showing consent form - using default values');
      // In production, implement proper consent form UI with UMP SDK
      _hasUserConsent = true;
      _isPersonalizedAds = EnvironmentConfig.enableAdPersonalization;
      AppLogger.info('📱 Consent form completed - Consent: $_hasUserConsent, Personalized: $_isPersonalizedAds');
    } catch (error, stackTrace) {
      AppLogger.error('❌ Failed to show consent form', error: error, stackTrace: stackTrace);
      _hasUserConsent = true;
      _isPersonalizedAds = false;
    }
  }

  /// Configure ad request settings
  Future<void> _configureAdSettings() async {
    try {
      // Set request configuration based on consent
      RequestConfiguration requestConfiguration = RequestConfiguration(
        testDeviceIds: EnvironmentConfig.enableTestAds ? ['33BE2250B43518CCDA7DE426D04EE231'] : [],
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
      );

      await MobileAds.instance.updateRequestConfiguration(requestConfiguration);

      AppLogger.info('✅ Ad settings configured');
    } catch (error, stackTrace) {
      AppLogger.error('❌ Failed to configure ad settings', error: error, stackTrace: stackTrace);
    }
  }

  /// Get ad request with proper configuration
  AdRequest getAdRequest() {
    return AdRequest(
      nonPersonalizedAds: !_isPersonalizedAds,
    );
  }

  /// Get current ad unit ID based on platform and ad type
  String getAdUnitId(AdType adType) {
    final isAndroid = Platform.isAndroid;

    switch (adType) {
      case AdType.banner:
        return isAndroid
            ? EnvironmentConfig.bannerAdUnitIdAndroid
            : EnvironmentConfig.bannerAdUnitIdIOS;
      case AdType.interstitial:
        return isAndroid
            ? EnvironmentConfig.interstitialAdUnitIdAndroid
            : EnvironmentConfig.interstitialAdUnitIdIOS;
      case AdType.rewarded:
        return isAndroid
            ? EnvironmentConfig.rewardedAdUnitIdAndroid
            : EnvironmentConfig.rewardedAdUnitIdIOS;
      case AdType.native:
        return isAndroid
            ? EnvironmentConfig.nativeAdUnitIdAndroid
            : EnvironmentConfig.nativeAdUnitIdIOS;
    }
  }

  /// Check if ads should be shown (not for premium users)
  bool shouldShowAds() {
    if (!EnvironmentConfig.enableAds || !_isInitialized || !_hasUserConsent) {
      return false;
    }

    // Check if user has premium subscription
    try {
      final revenueCatService = RevenueCatService.instance;
      if (revenueCatService.isInitialized && revenueCatService.hasActiveSubscription()) {
        AppLogger.info('📱 Premium user detected - ads disabled');
        return false;
      }
    } catch (error) {
      AppLogger.warning('📱 Error checking subscription status: $error');
      // If we can't check subscription status, default to showing ads
    }

    return true;
  }

  /// Track ad loading state
  void setAdLoadingState(String adId, bool isLoading) {
    _adLoadingState[adId] = isLoading;
  }

  /// Check if ad is loading
  bool isAdLoading(String adId) {
    return _adLoadingState[adId] ?? false;
  }

  /// Track ad failure
  void trackAdFailure(String adId) {
    _adFailureCount[adId] = (_adFailureCount[adId] ?? 0) + 1;

    if (_adFailureCount[adId]! >= 3) {
      AppLogger.warning('📱 Ad $adId has failed 3+ times, consider backing off');
    }
  }

  /// Reset ad failure count
  void resetAdFailureCount(String adId) {
    _adFailureCount.remove(adId);
  }

  /// Get ad failure count
  int getAdFailureCount(String adId) {
    return _adFailureCount[adId] ?? 0;
  }

  /// Log analytics event for ad interactions
  Future<void> _logAnalyticsEvent(String eventName, Map<String, dynamic> parameters) async {
    try {
      await FirebaseService.instance.logEvent(
        name: eventName,
        parameters: parameters.map((key, value) => MapEntry(key, value.toString())),
      );
    } catch (error) {
      AppLogger.warning('Failed to log ad analytics event: $error');
    }
  }

  /// Log ad impression
  Future<void> logAdImpression(AdType adType, String adUnitId) async {
    await _logAnalyticsEvent('ad_impression', {
      'ad_type': adType.name,
      'ad_unit_id': adUnitId,
      'personalized': _isPersonalizedAds,
    });
  }

  /// Log ad click
  Future<void> logAdClick(AdType adType, String adUnitId) async {
    await _logAnalyticsEvent('ad_clicked', {
      'ad_type': adType.name,
      'ad_unit_id': adUnitId,
      'personalized': _isPersonalizedAds,
    });
  }

  /// Log ad loaded successfully
  Future<void> logAdLoaded(AdType adType, String adUnitId) async {
    await _logAnalyticsEvent('ad_loaded', {
      'ad_type': adType.name,
      'ad_unit_id': adUnitId,
    });
  }

  /// Log ad failed to load
  Future<void> logAdFailure(AdType adType, String adUnitId, String error) async {
    await _logAnalyticsEvent('ad_failed', {
      'ad_type': adType.name,
      'ad_unit_id': adUnitId,
      'error': error,
    });
  }

  /// Reset consent (for testing or user request)
  Future<void> resetConsent() async {
    try {
      if (_consentInformation != null) {
        await _consentInformation!.reset();
        _hasUserConsent = false;
        _isPersonalizedAds = false;
        AppLogger.info('📱 Ad consent has been reset');
      }
    } catch (error, stackTrace) {
      AppLogger.error('❌ Failed to reset ad consent', error: error, stackTrace: stackTrace);
    }
  }

  // ========== INTERSTITIAL AD METHODS ==========

  /// Load an interstitial ad
  Future<void> loadInterstitialAd({bool force = false}) async {
    if (!shouldShowAds()) {
      AppLogger.info('📱 Ads disabled - not loading interstitial ad');
      return;
    }

    if (_isInterstitialAdReady && !force) {
      AppLogger.info('📱 Interstitial ad already loaded');
      return;
    }

    if (isAdLoading('interstitial_ad')) {
      AppLogger.info('📱 Interstitial ad already loading');
      return;
    }

    setAdLoadingState('interstitial_ad', true);

    try {
      final adUnitId = getAdUnitId(AdType.interstitial);
      final adRequest = getAdRequest();

      AppLogger.info('📱 Loading interstitial ad...');

      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: adRequest,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            AppLogger.info('✅ Interstitial ad loaded successfully');
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            resetAdFailureCount('interstitial_ad');
            setAdLoadingState('interstitial_ad', false);

            logAdLoaded(AdType.interstitial, adUnitId);

            // Set up ad callbacks
            _setupInterstitialAdCallbacks(ad, adUnitId);
          },
          onAdFailedToLoad: (LoadAdError error) {
            AppLogger.error('❌ Interstitial ad failed to load: ${error.message}');
            _isInterstitialAdReady = false;
            trackAdFailure('interstitial_ad');
            setAdLoadingState('interstitial_ad', false);

            logAdFailure(AdType.interstitial, adUnitId, error.message);

            // Retry loading after delay if failure count is low
            final failureCount = getAdFailureCount('interstitial_ad');
            if (failureCount < 3) {
              Future.delayed(Duration(seconds: failureCount * 30), () {
                loadInterstitialAd();
              });
            }
          },
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error('❌ Exception loading interstitial ad', error: error, stackTrace: stackTrace);
      _isInterstitialAdReady = false;
      setAdLoadingState('interstitial_ad', false);
      trackAdFailure('interstitial_ad');
    }
  }

  /// Set up interstitial ad callbacks
  void _setupInterstitialAdCallbacks(InterstitialAd ad, String adUnitId) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        AppLogger.info('📱 Interstitial ad showed full screen');
        logAdImpression(AdType.interstitial, adUnitId);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        AppLogger.info('📱 Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        _lastInterstitialShownTime = DateTime.now();

        // Load next interstitial ad
        Future.delayed(const Duration(seconds: 1), () {
          loadInterstitialAd();
        });
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        AppLogger.error('❌ Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        trackAdFailure('interstitial_ad');

        logAdFailure(AdType.interstitial, adUnitId, error.message);
      },
      onAdClicked: (InterstitialAd ad) {
        AppLogger.info('📱 Interstitial ad clicked');
        logAdClick(AdType.interstitial, adUnitId);
      },
    );
  }

  /// Show interstitial ad with frequency capping
  Future<bool> showInterstitialAd({
    String? context,
    bool ignoreFrequency = false,
  }) async {
    if (!shouldShowAds()) {
      AppLogger.info('📱 Ads disabled - not showing interstitial ad');
      return false;
    }

    if (!_isInterstitialAdReady || _interstitialAd == null) {
      AppLogger.warning('📱 Interstitial ad not ready');
      // Try to load ad for next time (fire and forget)
      loadInterstitialAd().ignore();
      return false;
    }

    // Check frequency capping
    if (!ignoreFrequency && !_shouldShowInterstitialNow()) {
      AppLogger.info('📱 Interstitial ad frequency capping - not showing now');
      return false;
    }

    try {
      AppLogger.info('📱 Showing interstitial ad${context != null ? ' for context: $context' : ''}');

      await _interstitialAd!.show();
      _interstitialShowCount++;

      // Log analytics with context
      await _logAnalyticsEvent('interstitial_ad_shown', {
        'context': context ?? 'unknown',
        'show_count': _interstitialShowCount,
      });

      return true;
    } catch (error, stackTrace) {
      AppLogger.error('❌ Exception showing interstitial ad', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// Check if interstitial ad should be shown based on frequency rules
  bool _shouldShowInterstitialNow() {
    final frequency = EnvironmentConfig.interstitialAdFrequency;

    // Check show count frequency
    if (_interstitialShowCount > 0 && _interstitialShowCount % frequency != 0) {
      return false;
    }

    // Check time-based frequency (minimum 30 seconds between shows)
    if (_lastInterstitialShownTime != null) {
      final timeSinceLastShow = DateTime.now().difference(_lastInterstitialShownTime!);
      if (timeSinceLastShow.inSeconds < 30) {
        return false;
      }
    }

    return true;
  }

  /// Check if it's a good time to show interstitial (for app flow management)
  bool shouldShowInterstitialForAction(String action) {
    if (!_isInterstitialAdReady) return false;

    // Define actions where interstitials are appropriate
    final appropriateActions = [
      'level_complete',
      'article_read',
      'feature_unlock',
      'navigation_back',
      'tab_switch',
      'content_complete',
    ];

    return appropriateActions.contains(action) && _shouldShowInterstitialNow();
  }

  /// Preload interstitial ad for better user experience
  Future<void> preloadInterstitialAd() async {
    if (!_isInterstitialAdReady && !isAdLoading('interstitial_ad')) {
      AppLogger.info('📱 Preloading interstitial ad');
      await loadInterstitialAd();
    }
  }

  // ========== REWARDED AD METHODS ==========

  /// Load a rewarded ad
  Future<void> loadRewardedAd({bool force = false}) async {
    if (!shouldShowAds()) {
      AppLogger.info('📱 Ads disabled - not loading rewarded ad');
      return;
    }

    if (_isRewardedAdReady && !force) {
      AppLogger.info('📱 Rewarded ad already loaded');
      return;
    }

    if (isAdLoading('rewarded_ad')) {
      AppLogger.info('📱 Rewarded ad already loading');
      return;
    }

    setAdLoadingState('rewarded_ad', true);

    try {
      final adUnitId = getAdUnitId(AdType.rewarded);
      final adRequest = getAdRequest();

      AppLogger.info('📱 Loading rewarded ad...');

      await RewardedAd.load(
        adUnitId: adUnitId,
        request: adRequest,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            AppLogger.info('✅ Rewarded ad loaded successfully');
            _rewardedAd = ad;
            _isRewardedAdReady = true;
            resetAdFailureCount('rewarded_ad');
            setAdLoadingState('rewarded_ad', false);

            logAdLoaded(AdType.rewarded, adUnitId);

            // Set up ad callbacks
            _setupRewardedAdCallbacks(ad, adUnitId);
          },
          onAdFailedToLoad: (LoadAdError error) {
            AppLogger.error('❌ Rewarded ad failed to load: ${error.message}');
            _isRewardedAdReady = false;
            trackAdFailure('rewarded_ad');
            setAdLoadingState('rewarded_ad', false);

            logAdFailure(AdType.rewarded, adUnitId, error.message);

            // Retry loading after delay if failure count is low
            final failureCount = getAdFailureCount('rewarded_ad');
            if (failureCount < 3) {
              Future.delayed(Duration(seconds: failureCount * 30), () {
                loadRewardedAd();
              });
            }
          },
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error('❌ Exception loading rewarded ad', error: error, stackTrace: stackTrace);
      _isRewardedAdReady = false;
      setAdLoadingState('rewarded_ad', false);
      trackAdFailure('rewarded_ad');
    }
  }

  /// Set up rewarded ad callbacks
  void _setupRewardedAdCallbacks(RewardedAd ad, String adUnitId) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        AppLogger.info('📱 Rewarded ad showed full screen');
        logAdImpression(AdType.rewarded, adUnitId);
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        AppLogger.info('📱 Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        _lastRewardedShownTime = DateTime.now();

        // Load next rewarded ad
        Future.delayed(const Duration(seconds: 1), () {
          loadRewardedAd();
        });
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        AppLogger.error('❌ Rewarded ad failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        trackAdFailure('rewarded_ad');

        logAdFailure(AdType.rewarded, adUnitId, error.message);
      },
      onAdClicked: (RewardedAd ad) {
        AppLogger.info('📱 Rewarded ad clicked');
        logAdClick(AdType.rewarded, adUnitId);
      },
    );
  }

  /// Show rewarded ad and handle rewards
  Future<RewardedAdResult> showRewardedAd({
    required String rewardType,
    String? context,
  }) async {
    if (!shouldShowAds()) {
      AppLogger.info('📱 Ads disabled - not showing rewarded ad');
      return RewardedAdResult.adsDisabled;
    }

    if (!_isRewardedAdReady || _rewardedAd == null) {
      AppLogger.warning('📱 Rewarded ad not ready');
      // Try to load ad for next time (fire and forget)
      loadRewardedAd().ignore();
      return RewardedAdResult.notReady;
    }

    try {
      AppLogger.info('📱 Showing rewarded ad${context != null ? ' for context: $context' : ''}');

      bool rewardGranted = false;
      RewardItem? rewardItem;

      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          AppLogger.info('🎁 User earned reward: ${reward.amount} ${reward.type}');
          rewardGranted = true;
          rewardItem = reward;

          // Log reward earned analytics
          _logAnalyticsEvent('rewarded_ad_reward_earned', {
            'reward_type': rewardType,
            'reward_amount': reward.amount,
            'reward_item_type': reward.type,
            'context': context ?? 'unknown',
          });
        },
      );

      _rewardedShowCount++;

      // Log analytics
      await _logAnalyticsEvent('rewarded_ad_shown', {
        'reward_type': rewardType,
        'context': context ?? 'unknown',
        'show_count': _rewardedShowCount,
      });

      if (rewardGranted) {
        return RewardedAdResult.rewardGranted(rewardItem!);
      } else {
        return RewardedAdResult.dismissed;
      }
    } catch (error, stackTrace) {
      AppLogger.error('❌ Exception showing rewarded ad', error: error, stackTrace: stackTrace);
      return RewardedAdResult.error(error.toString());
    }
  }

  /// Check if rewarded ad is available for a specific reward type
  bool isRewardedAdAvailable(String rewardType) {
    if (!shouldShowAds()) return false;
    if (!_isRewardedAdReady) return false;

    // Check if enough time has passed since last rewarded ad (cooldown)
    if (_lastRewardedShownTime != null) {
      final timeSinceLastShow = DateTime.now().difference(_lastRewardedShownTime!);
      if (timeSinceLastShow.inMinutes < 1) {
        return false; // 1 minute cooldown between rewarded ads
      }
    }

    return true;
  }

  /// Preload rewarded ad for better user experience
  Future<void> preloadRewardedAd() async {
    if (!_isRewardedAdReady && !isAdLoading('rewarded_ad')) {
      AppLogger.info('📱 Preloading rewarded ad');
      await loadRewardedAd();
    }
  }

  /// Get available reward types (can be customized based on app needs)
  List<String> getAvailableRewardTypes() {
    return [
      'coins',
      'gems',
      'lives',
      'premium_feature',
      'remove_ads',
      'unlock_content',
      'bonus_points',
    ];
  }

  /// Dispose resources
  void dispose() {
    _instance = null;
    _isInitialized = false;
    _hasUserConsent = false;
    _isPersonalizedAds = false;
    _adLoadingState.clear();
    _adFailureCount.clear();
    _consentForm?.dispose();

    // Dispose interstitial ad
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
    _lastInterstitialShownTime = null;
    _interstitialShowCount = 0;

    // Dispose rewarded ad
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
    _lastRewardedShownTime = null;
    _rewardedShowCount = 0;
  }
}

/// Enum for different ad types
enum AdType {
  banner,
  interstitial,
  rewarded,
  native,
}

extension AdTypeExtension on AdType {
  String get name {
    switch (this) {
      case AdType.banner:
        return 'banner';
      case AdType.interstitial:
        return 'interstitial';
      case AdType.rewarded:
        return 'rewarded';
      case AdType.native:
        return 'native';
    }
  }
}

/// Result of showing a rewarded ad
class RewardedAdResult {
  final RewardedAdResultType type;
  final RewardItem? rewardItem;
  final String? error;

  const RewardedAdResult._(this.type, this.rewardItem, this.error);

  /// Ad shown successfully and reward was granted
  factory RewardedAdResult.rewardGranted(RewardItem rewardItem) {
    return RewardedAdResult._(RewardedAdResultType.rewardGranted, rewardItem, null);
  }

  /// Ad was dismissed without granting reward
  static const RewardedAdResult dismissed = RewardedAdResult._(
    RewardedAdResultType.dismissed,
    null,
    null,
  );

  /// Ad could not be shown because it wasn't ready
  static const RewardedAdResult notReady = RewardedAdResult._(
    RewardedAdResultType.notReady,
    null,
    null,
  );

  /// Ads are disabled
  static const RewardedAdResult adsDisabled = RewardedAdResult._(
    RewardedAdResultType.adsDisabled,
    null,
    null,
  );

  /// An error occurred while showing the ad
  factory RewardedAdResult.error(String errorMessage) {
    return RewardedAdResult._(RewardedAdResultType.error, null, errorMessage);
  }

  bool get isSuccess => type == RewardedAdResultType.rewardGranted;
  bool get wasRewardGranted => type == RewardedAdResultType.rewardGranted;
  bool get wasDismissed => type == RewardedAdResultType.dismissed;
  bool get wasNotReady => type == RewardedAdResultType.notReady;
  bool get wereAdsDisabled => type == RewardedAdResultType.adsDisabled;
  bool get hasError => type == RewardedAdResultType.error;
}

/// Types of rewarded ad results
enum RewardedAdResultType {
  rewardGranted,
  dismissed,
  notReady,
  adsDisabled,
  error,
}