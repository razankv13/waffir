import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class WaffirBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const WaffirBackButton({
    super.key,
    this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => context.pop(),
      borderRadius: BorderRadius.circular(size / 2 + 10), // Sufficiently large radius
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF2F2F2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: math.pi, // Rotate 180 degrees to point left
          child: SvgPicture.asset(
            'assets/icons/chevron_right.svg',
            width: size * (24 / 44), // Scale icon relative to button size (24/44 ratio)
            height: size * (24 / 44),
            colorFilter: const ColorFilter.mode(
              Color(0xFF0F352D),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
