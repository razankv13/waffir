import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';
import 'package:waffir/features/stores/domain/repositories/catalog_categories_repository.dart';

final catalogCategoriesControllerProvider =
    AsyncNotifierProvider<CatalogCategoriesController, List<CatalogCategory>>(
      CatalogCategoriesController.new,
    );

class CatalogCategoriesController extends AsyncNotifier<List<CatalogCategory>> {
  CatalogCategoriesRepository get _repository =>
      ref.read(catalogCategoriesRepositoryProvider);

  @override
  Future<List<CatalogCategory>> build() async {
    final languageCode = ref.watch(localeProvider).languageCode;
    final result = await _repository.fetchActiveCategories(
      languageCode: languageCode,
    );
    return result.when(success: (d) => d, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
