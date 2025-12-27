import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Content type enum for intelligent error icon selection.
enum ImageContentType {
  /// Store/business logo
  store,

  /// Product image
  product,

  /// User avatar/profile photo
  avatar,

  /// Deal/offer banner
  deal,

  /// Credit card image
  creditCard,

  /// Generic image
  generic,
}

/// A cached network image widget with shimmer loading and smart error handling.
///
/// Wraps [CachedNetworkImage] with project conventions:
/// - Shimmer placeholder during loading (respects theme colors)
/// - Content-aware error icons
/// - ResponsiveHelper integration for all dimensions
/// - Circular variant for avatars
///
/// Example usage:
/// ```dart
/// // Basic usage
/// AppNetworkImage(
///   imageUrl: 'https://example.com/product.jpg',
///   width: 120,
///   height: 120,
/// )
///
/// // Circular avatar
/// AppNetworkImage.avatar(
///   imageUrl: user.photoURL,
///   size: 80,
/// )
///
/// // Store image with custom fit
/// AppNetworkImage(
///   imageUrl: store.logoUrl,
///   width: 160,
///   height: 160,
///   fit: BoxFit.contain,
///   contentType: ImageContentType.store,
/// )
/// ```
class AppNetworkImage extends StatelessWidget {
  /// Creates an AppNetworkImage with standard rectangular shape.
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.contentType = ImageContentType.generic,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.useResponsiveScaling = true,
    this.cacheKey,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 300),
  })  : _isCircular = false,
        _size = null;

  /// Creates a circular avatar variant.
  ///
  /// Example:
  /// ```dart
  /// AppNetworkImage.avatar(
  ///   imageUrl: user.photoURL!,
  ///   size: 80,
  /// )
  /// ```
  const AppNetworkImage.avatar({
    super.key,
    required this.imageUrl,
    required double size,
    this.placeholder,
    this.errorWidget,
    this.useResponsiveScaling = true,
    this.cacheKey,
    this.fadeInDuration = const Duration(milliseconds: 300),
  })  : width = size,
        height = size,
        fit = BoxFit.cover,
        borderRadius = null,
        contentType = ImageContentType.avatar,
        color = null,
        colorBlendMode = null,
        alignment = Alignment.center,
        memCacheWidth = null,
        memCacheHeight = null,
        _isCircular = true,
        _size = size;

  /// The URL of the image to load.
  final String imageUrl;

  /// Width in Figma design pixels (will be scaled via ResponsiveHelper if [useResponsiveScaling] is true).
  final double? width;

  /// Height in Figma design pixels (will be scaled via ResponsiveHelper if [useResponsiveScaling] is true).
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Border radius in Figma design pixels (will be scaled via ResponsiveHelper if [useResponsiveScaling] is true).
  final BorderRadius? borderRadius;

  /// Content type for intelligent error icon selection.
  final ImageContentType contentType;

  /// Custom placeholder widget (overrides default shimmer).
  final Widget? placeholder;

  /// Custom error widget (overrides content-type based default).
  final Widget? errorWidget;

  /// Color to blend with the image.
  final Color? color;

  /// Blend mode for color.
  final BlendMode? colorBlendMode;

  /// Image alignment within its bounds.
  final Alignment alignment;

  /// Whether to apply ResponsiveHelper scaling to dimensions.
  final bool useResponsiveScaling;

  /// Optional cache key for the image.
  final String? cacheKey;

  /// Memory cache width for resized images (improves memory usage).
  final int? memCacheWidth;

  /// Memory cache height for resized images (improves memory usage).
  final int? memCacheHeight;

  /// Duration of fade-in animation.
  final Duration fadeInDuration;

  // Private fields for circular variant
  final bool _isCircular;
  final double? _size;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final colorScheme = Theme.of(context).colorScheme;

    // Calculate scaled dimensions
    final scaledWidth = useResponsiveScaling && width != null
        ? responsive.s(width!)
        : width;
    final scaledHeight = useResponsiveScaling && height != null
        ? responsive.s(height!)
        : height;
    final scaledBorderRadius = useResponsiveScaling && borderRadius != null
        ? responsive.sBorderRadius(borderRadius!)
        : borderRadius;

    // For circular variant
    if (_isCircular) {
      final scaledSize = useResponsiveScaling && _size != null
          ? responsive.s(_size!)
          : _size;

      return ClipOval(
        child: _buildCachedImage(
          context,
          scaledSize,
          scaledSize,
          null,
          colorScheme,
        ),
      );
    }

    // Standard rectangular image
    Widget image = _buildCachedImage(
      context,
      scaledWidth,
      scaledHeight,
      scaledBorderRadius,
      colorScheme,
    );

    // Apply border radius clipping
    if (scaledBorderRadius != null) {
      image = ClipRRect(
        borderRadius: scaledBorderRadius,
        child: image,
      );
    }

    return image;
  }

  Widget _buildCachedImage(
    BuildContext context,
    double? scaledWidth,
    double? scaledHeight,
    BorderRadius? scaledBorderRadius,
    ColorScheme colorScheme,
  ) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: scaledWidth,
      height: scaledHeight,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      cacheKey: cacheKey,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) =>
          placeholder ??
          _buildShimmerPlaceholder(
            scaledWidth,
            scaledHeight,
            scaledBorderRadius,
            colorScheme,
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          _buildErrorWidget(
            scaledWidth,
            scaledHeight,
            scaledBorderRadius,
            colorScheme,
          ),
    );
  }

  Widget _buildShimmerPlaceholder(
    double? width,
    double? height,
    BorderRadius? borderRadius,
    ColorScheme colorScheme,
  ) {
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainer,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: _isCircular ? null : borderRadius,
          shape: _isCircular ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    double? width,
    double? height,
    BorderRadius? borderRadius,
    ColorScheme colorScheme,
  ) {
    final iconSize = _calculateErrorIconSize(width, height);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: _isCircular ? null : borderRadius,
        shape: _isCircular ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Center(
        child: Icon(
          _getErrorIcon(),
          size: iconSize,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  double _calculateErrorIconSize(double? width, double? height) {
    // Calculate icon size based on container dimensions
    final minDimension = [
      width ?? 48.0,
      height ?? 48.0,
    ].reduce((a, b) => a < b ? a : b);

    // Icon should be about 40% of the container size, with min/max constraints
    return (minDimension * 0.4).clamp(20.0, 64.0);
  }

  /// Returns the appropriate error icon based on content type.
  IconData _getErrorIcon() {
    switch (contentType) {
      case ImageContentType.store:
        return Icons.store;
      case ImageContentType.product:
        return Icons.shopping_bag_outlined;
      case ImageContentType.avatar:
        return Icons.person;
      case ImageContentType.deal:
        return Icons.local_offer_outlined;
      case ImageContentType.creditCard:
        return Icons.credit_card;
      case ImageContentType.generic:
        return Icons.image_not_supported_outlined;
    }
  }
}
