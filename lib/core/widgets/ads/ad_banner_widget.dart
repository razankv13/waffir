import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/services/admob_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/widgets/loading/loading_indicators.dart';

/// Banner ad size configurations
enum AdBannerSize {
  standard,
  large,
  medium,
  full,
  leaderboard,
  adaptive,
}

extension AdBannerSizeExtension on AdBannerSize {
  AdSize get adSize {
    switch (this) {
      case AdBannerSize.standard:
        return AdSize.banner;
      case AdBannerSize.large:
        return AdSize.largeBanner;
      case AdBannerSize.medium:
        return AdSize.mediumRectangle;
      case AdBannerSize.full:
        return AdSize.fullBanner;
      case AdBannerSize.leaderboard:
        return AdSize.leaderboard;
      case AdBannerSize.adaptive:
        return AdSize.banner; // Will be adapted in the widget
    }
  }

  double get height {
    switch (this) {
      case AdBannerSize.standard:
        return 50.0;
      case AdBannerSize.large:
        return 100.0;
      case AdBannerSize.medium:
        return 250.0;
      case AdBannerSize.full:
        return 60.0;
      case AdBannerSize.leaderboard:
        return 90.0;
      case AdBannerSize.adaptive:
        return 50.0; // Will be calculated dynamically
    }
  }
}

/// A reusable banner ad widget that integrates with the app's theme and state management
class AdBannerWidget extends ConsumerStatefulWidget {
  const AdBannerWidget({
    super.key,
    this.size = AdBannerSize.standard,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showPlaceholder = true,
    this.placeholderText,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdClicked,
    this.onAdImpression,
    this.autoRefresh = false,
    this.refreshInterval = const Duration(minutes: 1),
  });

  final AdBannerSize size;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showPlaceholder;
  final String? placeholderText;
  final VoidCallback? onAdLoaded;
  final void Function(LoadAdError)? onAdFailedToLoad;
  final VoidCallback? onAdClicked;
  final VoidCallback? onAdImpression;
  final bool autoRefresh;
  final Duration refreshInterval;

  @override
  ConsumerState<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends ConsumerState<AdBannerWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isLoading = false;
  bool _isLoaded = false;
  bool _hasError = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadBannerAd();

    // Set up auto-refresh if enabled
    if (widget.autoRefresh) {
      _startAutoRefresh();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(widget.refreshInterval, () {
      if (mounted) {
        _refreshAd();
        _startAutoRefresh();
      }
    });
  }

  void _refreshAd() {
    if (!mounted || _isLoading) return;

    _bannerAd?.dispose();
    _bannerAd = null;
    setState(() {
      _isLoaded = false;
      _hasError = false;
      _errorMessage = null;
    });
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    final adMobService = AdMobService.instance;

    if (!adMobService.shouldShowAds()) {
      AppLogger.info('📱 Ads disabled or no consent - not loading banner ad');
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final adUnitId = adMobService.getAdUnitId(AdType.banner);
      final adRequest = adMobService.getAdRequest();

      AdSize adSize = widget.size.adSize;

      // Handle adaptive banner size
      if (widget.size == AdBannerSize.adaptive && mounted) {
        final screenWidth = MediaQuery.of(context).size.width.toInt();
        adSize = AdSize.getInlineAdaptiveBannerAdSize(screenWidth, 50);
      }

      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: adSize,
        request: adRequest,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            AppLogger.info('📱 Banner ad loaded successfully');
            adMobService.logAdLoaded(AdType.banner, adUnitId);
            adMobService.resetAdFailureCount('banner_ad');

            if (mounted) {
              setState(() {
                _isLoading = false;
                _isLoaded = true;
                _hasError = false;
              });
              _animationController.forward();
              widget.onAdLoaded?.call();
            }
          },
          onAdFailedToLoad: (ad, error) {
            AppLogger.error('❌ Banner ad failed to load: ${error.message}');
            adMobService.logAdFailure(AdType.banner, adUnitId, error.message);
            adMobService.trackAdFailure('banner_ad');

            ad.dispose();
            if (mounted) {
              setState(() {
                _isLoading = false;
                _isLoaded = false;
                _hasError = true;
                _errorMessage = error.message;
              });
              widget.onAdFailedToLoad?.call(error);
            }
          },
          onAdClicked: (ad) {
            AppLogger.info('📱 Banner ad clicked');
            adMobService.logAdClick(AdType.banner, adUnitId);
            widget.onAdClicked?.call();
          },
          onAdImpression: (ad) {
            AppLogger.info('📱 Banner ad impression recorded');
            adMobService.logAdImpression(AdType.banner, adUnitId);
            widget.onAdImpression?.call();
          },
        ),
      );

      await _bannerAd!.load();
    } catch (error, stackTrace) {
      AppLogger.error('❌ Exception loading banner ad', error: error, stackTrace: stackTrace);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoaded = false;
          _hasError = true;
          _errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colorScheme = Theme.of(context).colorScheme;

    // Don't show anything if ads are disabled or user doesn't have premium
    if (!AdMobService.instance.shouldShowAds()) {
      return const SizedBox.shrink();
    }

    Widget content;

    if (_isLoading) {
      content = _buildLoadingWidget(colorScheme);
    } else if (_hasError) {
      content = _buildErrorWidget(colorScheme);
    } else if (_isLoaded && _bannerAd != null) {
      content = _buildAdWidget();
    } else {
      content = widget.showPlaceholder
          ? _buildPlaceholderWidget(colorScheme)
          : const SizedBox.shrink();
    }

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs2,
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surfaceContainerLowest,
        borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSm,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSm,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: content,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ColorScheme colorScheme) {
    return SizedBox(
      height: widget.size.height,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator(
              size: AppSpacing.iconSm,
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs3),
            Text(
              'Loading ad...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ColorScheme colorScheme) {
    return SizedBox(
      height: widget.size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSpacing.iconSm,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.xs2),
            Text(
              'Failed to load ad',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
            if (_errorMessage != null && AdMobService.instance.isInitialized) ...[
              const SizedBox(height: AppSpacing.xs2),
              GestureDetector(
                onTap: _refreshAd,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs3,
                    vertical: AppSpacing.xs2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusXs,
                  ),
                  child: Text(
                    'Tap to retry',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdWidget() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        alignment: Alignment.center,
        height: _bannerAd!.size.height.toDouble(),
        width: _bannerAd!.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  Widget _buildPlaceholderWidget(ColorScheme colorScheme) {
    return SizedBox(
      height: widget.size.height,
      child: Center(
        child: Text(
          widget.placeholderText ?? 'Advertisement',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}