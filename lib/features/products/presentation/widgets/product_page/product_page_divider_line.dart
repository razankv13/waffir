import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageDividerLine extends StatelessWidget {
  const ProductPageDividerLine({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    return Container(
      height: responsive.s(1),
      color: color,
    );
  }
}
