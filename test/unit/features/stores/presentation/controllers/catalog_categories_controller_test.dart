import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';
import 'package:waffir/features/stores/domain/repositories/catalog_categories_repository.dart';
import 'package:waffir/features/stores/presentation/controllers/catalog_categories_controller.dart';

class _MockCatalogCategoriesRepository extends Mock implements CatalogCategoriesRepository {}

void main() {
  group('CatalogCategoriesController', () {
    late _MockCatalogCategoriesRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockCatalogCategoriesRepository();
      container = ProviderContainer(
        overrides: [
          localeProvider.overrideWith((ref) => const Locale('en')),
          catalogCategoriesRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('loads categories using repository', () async {
      when(() => repository.fetchActiveCategories(languageCode: any(named: 'languageCode'))).thenAnswer(
        (_) async => Result.success(
          const <CatalogCategory>[
            CatalogCategory(id: 'cat-1', slug: 'dining', nameEn: 'Dining', nameAr: 'مطاعم', isActive: true),
          ],
        ),
      );

      final data = await container.read(catalogCategoriesControllerProvider.future);
      expect(data, hasLength(1));
      expect(data.single.slug, 'dining');

      verify(() => repository.fetchActiveCategories(languageCode: any(named: 'languageCode'))).called(1);
    });
  });
}

