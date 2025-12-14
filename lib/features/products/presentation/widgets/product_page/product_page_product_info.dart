import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageProductInfo extends StatelessWidget {
  const ProductPageProductInfo({
    super.key,
    required this.theme,
  });

  final ProductPageTheme theme;

  static const String detailsText =
      "Dick's Sporting Goods has Nike Men's P-6000 Shoes (Flax/Gold/Sail/Gum) on sale for \$49.97. Shipping is free for Score Card Members (free to join).\n\n"
      "Note: Available sizes vary. Our links may go to a product variant that is out of stock or not included in this deal. Please use the available sorting options on the product page to select the available items on sale.";

  static const String featuresText =
      'Breathable mesh has real and synthetic leather overlays to give a 2000s running aesthetic'
      'Tongue webbing with "Bowerman Series" branding, Nike logo on tongue tab, and molded synthetic leather Swoosh design'
      'Foam midsole provides lightweight cushioning for a plush underfoot feel'
      'Full rubber outsole gives you durable traction';

  static const String priceResearchText =
      'Our Research indicates this offer is \$26.21 Lower (29% savings) than the best price.\n\n'
      'Rates 4.9 out of 5 stars based on over 2,600 nike customer reviews.';

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    Widget section({
      required String label,
      required TextStyle labelStyle,
      required String body,
      required TextStyle bodyStyle,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: labelStyle.copyWith(
              color: theme.colors.textPrimary,
              fontSize: responsive.scaleFontSize(labelStyle.fontSize ?? 16, minSize: 10),
            ),
          ),
          SizedBox(height: responsive.scale(8)),
          Text(
            body,
            style: bodyStyle.copyWith(
              color: theme.colors.textPrimary,
              fontSize: responsive.scaleFontSize(bodyStyle.fontSize ?? 14, minSize: 10),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          section(
            label: 'Details:',
            labelStyle: theme.textStyles.sectionLabelBold,
            body: detailsText,
            bodyStyle: theme.textStyles.body,
          ),
          SizedBox(height: responsive.scale(16)),
          section(
            label: 'Features:',
            labelStyle: theme.textStyles.sectionLabelBold,
            body: featuresText,
            bodyStyle: theme.textStyles.body,
          ),
          SizedBox(height: responsive.scale(16)),
          section(
            label: 'Price Research:',
            labelStyle: theme.textStyles.sectionLabelBold,
            body: priceResearchText,
            bodyStyle: theme.textStyles.bodyRegular,
          ),
        ],
      ),
    );
  }
}
