import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/features/stores/data/providers/stores_providers.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_view.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_not_found_view.dart';

class StoreDetailScreen extends HookConsumerWidget {
  const StoreDetailScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeByIdProvider(storeId));
    final uiState = ref.watch(storeDetailUiControllerProvider(storeId));
    final controller = ref.read(storeDetailUiControllerProvider(storeId).notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode == 'ar';

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (store != null) {
          controller.seedFromStore(store);
        }
      });
      return null;
    }, [store]);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: store == null
            ? const StoreNotFoundView()
            : StoreDetailView(
                store: store,
                isRTL: isRTL,
                isFavorite: uiState.isFavorite,
                testimonials: uiState.testimonials,
                onToggleFavorite: controller.toggleFavorite,
              ),
      ),
    );
  }
}
