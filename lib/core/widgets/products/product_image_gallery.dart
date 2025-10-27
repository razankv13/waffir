import 'package:flutter/material.dart';

/// Product image gallery with swipeable images and indicators
///
/// Example usage:
/// ```dart
/// ProductImageGallery(
///   imageUrls: [
///     'https://example.com/image1.jpg',
///     'https://example.com/image2.jpg',
///     'https://example.com/image3.jpg',
///   ],
/// )
/// ```
class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({
    super.key,
    required this.imageUrls,
    this.height = 400,
    this.showIndicators = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  final List<String> imageUrls;
  final double height;
  final bool showIndicators;
  final bool autoPlay;
  final Duration autoPlayInterval;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.autoPlay && widget.imageUrls.length > 1) {
      Future.delayed(widget.autoPlayInterval, _autoPlayNext);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _autoPlayNext() {
    if (!mounted) return;

    if (_currentPage < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    if (widget.autoPlay) {
      Future.delayed(widget.autoPlayInterval, _autoPlayNext);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.imageUrls.isEmpty) {
      return Container(
        height: widget.height,
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Could open full screen view
                },
                child: Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Page Indicators
          if (widget.showIndicators && widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Navigation arrows (for desktop/tablet)
          if (widget.imageUrls.length > 1)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ),

          if (widget.imageUrls.length > 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  onPressed: _currentPage < widget.imageUrls.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
