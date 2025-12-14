import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class WaffirBackButton extends HookWidget {
  const WaffirBackButton({
    super.key,
    this.onTap,
    this.size = 44,
    this.alignment = Alignment.topLeft,
    this.padding,
  });
  final VoidCallback? onTap;
  final double size;
  final Alignment alignment;

  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    final finalPadding = useState(padding);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (padding == null) {
          finalPadding.value = EdgeInsets.only(top: context.responsive.topSafeArea, left: 16);
        }
      });
      return null;
    }, [padding]);
    return Padding(
      padding: finalPadding.value ?? EdgeInsets.zero,
      child: Align(
        alignment: alignment,
        child: InkWell(
          onTap: onTap ?? () => context.pop(),
          borderRadius: BorderRadius.circular(size / 2 + 10), // Sufficiently large radius
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0xFFF2F2F2), blurRadius: 8, spreadRadius: 2)],
            ),
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: math.pi, // Rotate 180 degrees to point left
              child: SvgPicture.asset(
                'assets/icons/chevron_right.svg',
                width: size * (24 / 44), // Scale icon relative to button size (24/44 ratio)
                height: size * (24 / 44),
                colorFilter: const ColorFilter.mode(Color(0xFF0F352D), BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
