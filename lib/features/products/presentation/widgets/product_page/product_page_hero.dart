import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageHero extends StatelessWidget {
  const ProductPageHero({
    super.key,
    required this.height,
    required this.borderColor,
    required this.imageAssetPath,
  });

  final double height;
  final Color borderColor;
  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    return Container(
      height: height,
      padding: responsive.sPadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: borderColor, width: responsive.s(1)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(responsive.s(0)),
        child: Image.asset(imageAssetPath, fit: BoxFit.cover),
      ),
    );
  }
}
