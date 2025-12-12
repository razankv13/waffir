import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Product image carousel widget for displaying multiple product images
///
/// Matches Figma specifications:
/// - Height: 390px
/// - Image carousel component with dots indicator
/// - Supports swipe gestures
/// - Gap between dots: 8px
class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 390,
    this.showIndicators = true,
  });

  final List<String> imageUrls;
  final double height;
  final bool showIndicators;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  static const _indicatorAnimationDuration = Duration(milliseconds: 250);

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool get _hasMultipleImages => widget.imageUrls.length > 1;

  @override
  void didUpdateWidget(covariant ProductImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentPage >= widget.imageUrls.length) {
      final newPage = widget.imageUrls.isEmpty
          ? 0
          : widget.imageUrls.length - 1;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(_currentPage);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;
    final hasImages = widget.imageUrls.any((url) => url.trim().isNotEmpty);
    final carouselHeight = responsive.scale(widget.height);

    if (!hasImages) {
      return _buildPlaceholder(colorScheme, responsive, carouselHeight);
    }

    return SizedBox(
      height: carouselHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls[index].trim();
                if (imageUrl.isEmpty) {
                  return _buildImageFallback(colorScheme, responsive);
                }
                return _buildImageItem(imageUrl, colorScheme, responsive);
              },
            ),
            _buildBottomGradient(colorScheme, responsive),
            if (widget.showIndicators && _hasMultipleImages)
              Positioned(
                bottom: responsive.scale(16),
                left: 0,
                right: 0,
                child: _buildIndicators(colorScheme, responsive),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(
    String imageUrl,
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
  ) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: const Duration(milliseconds: 150),
      placeholder: (context, url) =>
          _buildImageFallback(colorScheme, responsive),
      errorWidget: (context, url, error) =>
          _buildImageFallback(colorScheme, responsive),
    );
  }

  Widget _buildBottomGradient(
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
  ) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: responsive.scale(140),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.scrim.withValues(alpha: 0),
                colorScheme.scrim.withValues(alpha: 0.55),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageFallback(
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
  ) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: responsive.scale(48),
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
    double carouselHeight,
  ) {
    return Container(
      height: carouselHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: responsive.scale(64),
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildIndicators(
    ColorScheme colorScheme,
    ResponsiveHelper responsive,
  ) {
    final inactiveSize = responsive.scale(6);
    final activeOuterSize = responsive.scale(12);
    final indicatorSpacing = responsive.scale(4);
    final borderWidth = responsive.scale(1).clamp(0.5, 1.5).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.imageUrls.length,
        (index) => AnimatedContainer(
          duration: _indicatorAnimationDuration,
          margin: EdgeInsets.symmetric(horizontal: indicatorSpacing),
          width: index == _currentPage ? activeOuterSize : inactiveSize,
          height: index == _currentPage ? activeOuterSize : inactiveSize,
          decoration: index == _currentPage
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.secondary,
                    width: borderWidth,
                  ),
                )
              : const BoxDecoration(shape: BoxShape.circle),
          child: index == _currentPage
              ? Center(
                  child: Container(
                    width: responsive.scale(6),
                    height: responsive.scale(6),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }
}
