import 'package:flutter/material.dart';

@immutable
class PromoColors extends ThemeExtension<PromoColors> {
  const PromoColors({
    required this.discountBg,
    required this.discountText,
    required this.saleBg,
    required this.saleText,
    required this.originalBg,
    required this.originalText,
    required this.actionCount,
  });
  final Color discountBg;
  final Color discountText;
  final Color saleBg;
  final Color saleText;
  final Color originalBg;
  final Color originalText;
  final Color actionCount;

  @override
  PromoColors copyWith({
    Color? discountBg,
    Color? discountText,
    Color? saleBg,
    Color? saleText,
    Color? originalBg,
    Color? originalText,
    Color? actionCount,
  }) {
    return PromoColors(
      discountBg: discountBg ?? this.discountBg,
      discountText: discountText ?? this.discountText,
      saleBg: saleBg ?? this.saleBg,
      saleText: saleText ?? this.saleText,
      originalBg: originalBg ?? this.originalBg,
      originalText: originalText ?? this.originalText,
      actionCount: actionCount ?? this.actionCount,
    );
  }

  @override
  ThemeExtension<PromoColors> lerp(ThemeExtension<PromoColors>? other, double t) {
    if (other is! PromoColors) return this;
    return PromoColors(
      discountBg: Color.lerp(discountBg, other.discountBg, t) ?? discountBg,
      discountText: Color.lerp(discountText, other.discountText, t) ?? discountText,
      saleBg: Color.lerp(saleBg, other.saleBg, t) ?? saleBg,
      saleText: Color.lerp(saleText, other.saleText, t) ?? saleText,
      originalBg: Color.lerp(originalBg, other.originalBg, t) ?? originalBg,
      originalText: Color.lerp(originalText, other.originalText, t) ?? originalText,
      actionCount: Color.lerp(actionCount, other.actionCount, t) ?? actionCount,
    );
  }

  static PromoColors light(ColorScheme scheme) {
    return const PromoColors(
      // Exact Figma light values
      discountBg: Color(0xFFDCFCE7),
      discountText: Color(0xFF0F352D),
      saleBg: Color(0xFF0F352D),
      saleText: Color(0xFF00FF88),
      // Use scheme-guided values where applicable
      originalBg: Color(0xFFF2F2F2),
      originalText: Color(0xFFFF0000),
      actionCount: Color(0xFFA3A3A3),
    );
  }

  static PromoColors dark(ColorScheme scheme) {
    // Tuned values for dark mode while preserving brand intent
    return PromoColors(
      discountBg: const Color(0xFF11312A),
      discountText: const Color(0xFF8CFBD0),
      saleBg: const Color(0xFF0A2A23),
      saleText: const Color(0xFF00E37A),
      originalBg: scheme.surfaceContainerHighest,
      originalText: scheme.error,
      actionCount: scheme.onSurfaceVariant,
    );
  }
}
