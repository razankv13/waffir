import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';

class StoreActionsSection extends StatelessWidget {
  const StoreActionsSection({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textColor = Theme.of(context).colorScheme.outline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: responsive.scale(16),
            runSpacing: responsive.scale(12),
            children: [
              StoreReactionPill(
                count: 21,
                isActive: isFavorite,
                onToggle: () {
                  HapticFeedback.lightImpact();
                  onToggleFavorite();
                },
              ),
              const StoreIconCountPill(
                icon: Icons.mode_comment_outlined,
                label: '45',
              ),
              const StoreIconOnlyPill(icon: Icons.star_rate_rounded),
            ],
          ),
        ),
        SizedBox(width: responsive.scale(8)),
        Flexible(
          child: Text(
            '3 hours ago',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(12),
              fontWeight: FontWeight.w400,
              color: textColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class StoreReactionPill extends StatelessWidget {
  const StoreReactionPill({
    super.key,
    required this.count,
    required this.onToggle,
    required this.isActive,
  });

  final int count;
  final VoidCallback onToggle;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final capsuleRadius = BorderRadius.circular(responsive.scale(1000));
    final iconColor = colorScheme.onSurfaceVariant;

    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: capsuleRadius,
      child: InkWell(
        borderRadius: capsuleRadius,
        onTap: onToggle,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: responsive.scale(44)),
          child: Padding(
            padding: responsive.scalePadding(
              const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_alt_rounded,
                  size: responsive.scale(18),
                  color: isActive ? colorScheme.primary : iconColor,
                ),
                SizedBox(width: responsive.scale(6)),
                Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: responsive.scaleFontSize(14),
                    fontWeight: FontWeight.w500,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: responsive.scale(6)),
                Icon(
                  Icons.thumb_down_alt_outlined,
                  size: responsive.scale(18),
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoreIconCountPill extends StatelessWidget {
  const StoreIconCountPill({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
      ),
      padding: responsive.scalePadding(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      constraints: BoxConstraints(minHeight: responsive.scale(44)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: responsive.scale(20),
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: responsive.scale(6)),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: responsive.scaleFontSize(14),
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class StoreIconOnlyPill extends StatelessWidget {
  const StoreIconOnlyPill({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: responsive.scale(44),
      height: responsive.scale(44),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: responsive.scale(20),
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class StoreTestimonialsSection extends StatelessWidget {
  const StoreTestimonialsSection({super.key, required this.testimonials});

  final List<StoreTestimonial> testimonials;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.scale(24)),
        color: colorScheme.surfaceContainerHighest,
      ),
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StoreCommentComposer(),
          SizedBox(height: responsive.scale(16)),
          for (final testimonial in testimonials) ...[
            StoreTestimonialCard(testimonial: testimonial),
            SizedBox(height: responsive.scale(16)),
          ],
        ],
      ),
    );
  }
}

class StoreCommentComposer extends StatelessWidget {
  const StoreCommentComposer({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: responsive.scale(28),
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.person_outline,
            color: colorScheme.primary,
            size: responsive.scale(24),
          ),
        ),
        SizedBox(width: responsive.scale(12)),
        Expanded(
          child: Container(
            height: responsive.scale(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(responsive.scale(16)),
              color: const Color(0xFFF2F2F2),
            ),
            padding: responsive.scalePadding(
              const EdgeInsets.symmetric(horizontal: 16),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Share your experience with this store...',
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: responsive.scaleFontSize(13),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF595959),
              ),
            ),
          ),
        ),
        SizedBox(width: responsive.scale(12)),
        Container(
          width: responsive.scale(44),
          height: responsive.scale(44),
          decoration: const BoxDecoration(
            color: Color(0xFF0F352D),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: responsive.scale(18),
          ),
        ),
      ],
    );
  }
}

class StoreTestimonialCard extends StatelessWidget {
  const StoreTestimonialCard({super.key, required this.testimonial});

  final StoreTestimonial testimonial;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: responsive.scale(40),
              height: responsive.scale(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.08),
              ),
              child: Icon(Icons.person_outline, color: colorScheme.primary),
            ),
            SizedBox(width: responsive.scale(12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testimonial.author,
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: responsive.scaleFontSize(14),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF151515),
                  ),
                ),
                Text(
                  testimonial.location,
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: responsive.scaleFontSize(12),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF595959),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: responsive.scale(12)),
        Text(
          testimonial.body,
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: responsive.scaleFontSize(12),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF151515),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
