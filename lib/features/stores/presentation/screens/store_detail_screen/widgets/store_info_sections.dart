import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

class StoreOutletBanner extends StatelessWidget {
  const StoreOutletBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      padding: responsive.scalePadding(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F352D),
        borderRadius: BorderRadius.circular(responsive.scale(12)),
      ),
      child: Row(
        children: [
          Text(
            'See All Outlets',
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(14),
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Take me to nearest outlet',
                style: TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: responsive.scaleFontSize(12),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              SizedBox(width: responsive.scale(4)),
              Icon(
                Icons.arrow_outward_rounded,
                size: responsive.scale(16),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StorePromoHighlight extends StatelessWidget {
  const StorePromoHighlight({super.key, required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final headline = store.description != null && store.description!.isNotEmpty
        ? store.description!
        : '${store.name} 20% discount on selected items.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: responsive.scaleFontSize(18),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF151515),
            height: 1.4,
          ),
        ),
        SizedBox(height: responsive.scale(12)),
        Row(
          children: [
            StoreDiscountTag(
              label: _extractDiscountLabel(headline),
              icon: Icons.sell_outlined,
            ),
            SizedBox(width: responsive.scale(12)),
            Expanded(
              child: Text(
                'At ${store.name}',
                style: TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: responsive.scaleFontSize(14),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF151515),
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StoreDiscountTag extends StatelessWidget {
  const StoreDiscountTag({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      padding: responsive.scalePadding(
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(responsive.scale(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: responsive.scale(16),
            color: const Color(0xFF0F352D),
          ),
          SizedBox(width: responsive.scale(6)),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(16),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F352D),
            ),
          ),
        ],
      ),
    );
  }
}

class StoreAdditionalActions extends StatelessWidget {
  const StoreAdditionalActions({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanks! We’ll inspect this offer.'),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: responsive.scale(20),
            color: const Color(0xFF151515),
          ),
          SizedBox(width: responsive.scale(4)),
          Text(
            'Report expired',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: responsive.scaleFontSize(12),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151515),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class StoreDetailsBlock extends StatelessWidget {
  const StoreDetailsBlock({
    super.key,
    required this.title,
    required this.body,
    required this.titleStyle,
    required this.bodyStyle,
  });

  final String title;
  final String body;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        SizedBox(height: responsive.scale(8)),
        Text(body, style: bodyStyle),
      ],
    );
  }
}

String _extractDiscountLabel(String text) {
  final percentMatch = RegExp(r'(\d+%+)').firstMatch(text);
  if (percentMatch != null) {
    return percentMatch.group(0)!;
  }
  return 'Exclusive';
}
