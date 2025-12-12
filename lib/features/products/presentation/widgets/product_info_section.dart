import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Product information section widget
///
/// Displays product description, brand, and specifications
/// Matches Figma specifications with 16px padding
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.title,
    required this.description,
    this.brand,
    this.specifications,
    this.features,
    this.priceResearch,
  });

  final String title;
  final String description;
  final String? brand;
  final Map<String, String>? specifications;
  final String? features;
  final String? priceResearch;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    const figmaTextColor = Color(0xFF151515);

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          if (brand != null) ...[
            _brandText(brand!, responsive, figmaTextColor),
            SizedBox(height: responsive.scale(8)),
          ],

          // Title
          _titleText(title, responsive, figmaTextColor),

          SizedBox(height: responsive.scale(16)),

          // Details (Figma "Details:")
          _sectionHeader(
            'Details:',
            responsive,
            color: figmaTextColor,
            fontWeight: FontWeight.w400,
            lineHeight: 1.3374472856521606,
          ),
          _sectionBody(
            description,
            responsive,
            color: figmaTextColor,
            fontWeight: FontWeight.w500,
            lineHeight: 1.4,
          ),

          // Features or Specifications
          if ((features != null && features!.trim().isNotEmpty) ||
              (specifications != null && specifications!.isNotEmpty)) ...[
            SizedBox(height: responsive.scale(16)),
            if (features != null && features!.trim().isNotEmpty) ...[
              _sectionHeader(
                'Features:',
                responsive,
                color: figmaTextColor,
                fontWeight: FontWeight.w700,
                lineHeight: 1.114539384841919,
              ),
              _sectionBody(
                features!,
                responsive,
                color: figmaTextColor,
                fontWeight: FontWeight.w500,
                lineHeight: 1.4,
              ),
            ] else ...[
              _sectionHeader(
                'Specifications:',
                responsive,
                color: figmaTextColor,
                fontWeight: FontWeight.w700,
                lineHeight: 1.114539384841919,
              ),
              SizedBox(height: responsive.scale(8)),
              ..._buildSpecifications(specifications!, responsive, figmaTextColor),
            ],
          ],

          // Price Research
          if (priceResearch != null && priceResearch!.trim().isNotEmpty) ...[
            SizedBox(height: responsive.scale(16)),
            _sectionHeader(
              'Price Research:',
              responsive,
              color: figmaTextColor,
              fontWeight: FontWeight.w700,
              lineHeight: 1.114539384841919,
            ),
            _sectionBody(
              priceResearch!,
              responsive,
              color: figmaTextColor,
              fontWeight: FontWeight.w400,
              lineHeight: 1.4,
            ),
          ],
        ],
      ),
    );
  }

  // Typography builders (Parkinsans as per Figma)
  Widget _brandText(String text, ResponsiveHelper responsive, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Parkinsans',
        fontSize: responsive.scale(12),
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: color.withOpacity(0.65),
      ),
    );
  }

  Widget _titleText(String text, ResponsiveHelper responsive, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Parkinsans',
        fontSize: responsive.scale(20),
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      ),
    );
  }

  Widget _sectionHeader(
    String text,
    ResponsiveHelper responsive, {
    required Color color,
    required FontWeight fontWeight,
    required double lineHeight,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.scale(8)),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Parkinsans',
          fontSize: responsive.scale(16),
          fontWeight: fontWeight,
          height: lineHeight,
          color: color,
        ),
      ),
    );
  }

  Widget _sectionBody(
    String text,
    ResponsiveHelper responsive, {
    required Color color,
    required FontWeight fontWeight,
    required double lineHeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Parkinsans',
        fontSize: responsive.scale(14),
        fontWeight: fontWeight,
        height: lineHeight,
        color: color,
      ),
    );
  }

  List<Widget> _buildSpecifications(
    Map<String, String> specs,
    ResponsiveHelper responsive,
    Color color,
  ) {
    return specs.entries.map(
      (entry) {
        return Padding(
          padding: responsive.scalePadding(const EdgeInsets.only(bottom: 8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: responsive.scale(12),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: color.withOpacity(0.75),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: responsive.scale(12),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }
}
