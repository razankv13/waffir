import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/constants/locale_keys.dart';

class StoreNotFoundView extends StatelessWidget {
  const StoreNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.stores.detail.notFound.tr(),
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
