import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

class StoreDetailBottomBar extends StatelessWidget {
  const StoreDetailBottomBar({
    super.key,
    required this.store,
    required this.isFollowing,
    required this.onToggleFollow,
  });

  final StoreModel store;
  final bool isFollowing;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.scale(10),
            offset: responsive.scaleOffset(const Offset(0, -2)),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              width: responsive.scale(44),
              height: responsive.scale(44),
              decoration: const BoxDecoration(
                color: Color(0xFF0F352D),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isFollowing ? Icons.check : Icons.favorite_border,
                  color: Colors.white,
                  size: responsive.scale(20),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  final willFollow = !isFollowing;
                  onToggleFollow();
                  final message = willFollow
                      ? 'Following ${store.name}'
                      : 'Unfollowed ${store.name}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
              ),
            ),
            SizedBox(width: responsive.scale(16)),
            Expanded(
              child: AppButton.primary(
                text: store.website != null ? 'Visit website' : 'View live offers',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  final message = store.website != null
                      ? 'Opening ${store.website}'
                      : 'Showing latest offers from ${store.name}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreDetailBackButton extends StatelessWidget {
  const StoreDetailBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00FF88),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2F2F2),
            blurRadius: responsive.scale(8),
            spreadRadius: responsive.scale(2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: colorScheme.surface,
          size: responsive.scale(20),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          context.pop();
        },
      ),
    );
  }
}
