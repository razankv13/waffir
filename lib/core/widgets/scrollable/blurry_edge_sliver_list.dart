import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:waffir/core/utils/responsive_helper.dart';

/// A [CustomScrollView] that contains a [SliverList] and renders progressive
/// blurry fade overlays at the top and bottom edges.
///
/// This is useful when your screen is already sliver-based but you still want
/// the same edge treatment as [BlurryEdgeListView].
///
/// Example usage:
/// ```dart
/// BlurryEdgeSliverList.builder(
///   sliversBefore: const [
///     SliverAppBar(title: Text('Title')),
///   ],
///   itemCount: items.length,
///   itemBuilder: (context, index) {
///     return ListTile(title: Text(items[index]));
///   },
/// )
/// ```
class BlurryEdgeSliverList extends StatelessWidget {
  const BlurryEdgeSliverList.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.sliversBefore = const <Widget>[],
    this.sliversAfter = const <Widget>[],
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.blurHeight = 80,
    this.blurSigma = 10,
    this.topBlurEnabled = true,
    this.bottomBlurEnabled = true,
    this.gradientStops = const <double>[0.0, 1.0],
    this.overlayColorOpacity = 0.10,
  });

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  /// Slivers that render before the [SliverList] (e.g. headers).
  final List<Widget> sliversBefore;

  /// Slivers that render after the [SliverList] (e.g. footers).
  final List<Widget> sliversAfter;

  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollBehavior? scrollBehavior;

  /// Blur overlay height in Figma pixels (scaled via [ResponsiveHelper]).
  final double blurHeight;

  /// Gaussian blur sigma applied to the overlay.
  final double blurSigma;

  final bool topBlurEnabled;
  final bool bottomBlurEnabled;

  /// Gradient stops for the fade mask (0..1). Typically `[0.0, 1.0]`.
  final List<double> gradientStops;

  /// Opacity applied to the theme surface color behind the blur overlay.
  final double overlayColorOpacity;

  @override
  Widget build(BuildContext context) {
    final overlayHeight = context.rs.s(blurHeight);
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          reverse: reverse,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          scrollBehavior: scrollBehavior,
          slivers: <Widget>[
            ...sliversBefore,
            SliverList(
              delegate: SliverChildBuilderDelegate(
                itemBuilder,
                childCount: itemCount,
              ),
            ),
            ...sliversAfter,
          ],
        ),
        if (topBlurEnabled)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: overlayHeight,
            child: _BlurEdgeOverlay(
              direction: _BlurEdgeDirection.top,
              height: overlayHeight,
              sigma: blurSigma,
              stops: gradientStops,
              color: theme.colorScheme.surface.withOpacity(overlayColorOpacity),
            ),
          ),
        if (bottomBlurEnabled)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: overlayHeight,
            child: _BlurEdgeOverlay(
              direction: _BlurEdgeDirection.bottom,
              height: overlayHeight,
              sigma: blurSigma,
              stops: gradientStops,
              color: theme.colorScheme.surface.withOpacity(overlayColorOpacity),
            ),
          ),
      ],
    );
  }
}

enum _BlurEdgeDirection { top, bottom }

class _BlurEdgeOverlay extends StatelessWidget {
  const _BlurEdgeOverlay({
    required this.direction,
    required this.height,
    required this.sigma,
    required this.stops,
    required this.color,
  });

  final _BlurEdgeDirection direction;
  final double height;
  final double sigma;
  final List<double> stops;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isTop = direction == _BlurEdgeDirection.top;

    final gradient = LinearGradient(
      begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const <Color>[Colors.black, Colors.transparent],
      stops: stops,
    );

    return IgnorePointer(
      child: ShaderMask(
        shaderCallback: gradient.createShader,
        blendMode: BlendMode.dstIn,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: ColoredBox(
              color: color,
              child: SizedBox(height: height),
            ),
          ),
        ),
      ),
    );
  }
}
