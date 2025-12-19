import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide AsyncResult;
import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';
import 'package:waffir/features/deals/presentation/controllers/hot_deals_controller.dart';

class _FakeDealsRepository implements DealsRepository {
  _FakeDealsRepository({
    required this.pages,
    this.toggleLikeResult = const Result.success(true),
    this.trackViewResult = const Result.success(null),
  });

  final Map<int, List<Deal>> pages;
  Result<bool> toggleLikeResult;
  Result<void> trackViewResult;

  @override
  AsyncResult<List<Deal>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode = 'en',
    int limit = 20,
    int offset = 0,
  }) async {
    return Result.success(pages[offset] ?? const <Deal>[]);
  }

  @override
  AsyncResult<void> trackDealView({required String dealId, String dealType = 'product'}) async {
    return trackViewResult;
  }

  @override
  AsyncResult<bool> toggleDealLike({required String dealId, String dealType = 'product'}) async {
    return toggleLikeResult;
  }
}

Deal _deal(String id, {int likes = 0, int views = 0, bool liked = false}) {
  return Deal(
    id: id,
    title: 'T$id',
    description: 'D$id',
    price: 10,
    imageUrl: 'https://example.com/$id.png',
    likesCount: likes,
    viewsCount: views,
    isLiked: liked,
    isFeatured: true,
  );
}

void main() {
  test('HotDealsController loads first page and sets hasMore', () async {
    final repo = _FakeDealsRepository(
      pages: {0: List.generate(20, (i) => _deal('d$i'))},
    );

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en')),
        dealsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(hotDealsControllerProvider.future);
    expect(state.deals, hasLength(20));
    expect(state.hasMore, isTrue);
  });

  test('HotDealsController loadMore appends and updates hasMore', () async {
    final repo = _FakeDealsRepository(
      pages: {
        0: List.generate(20, (i) => _deal('d$i')),
        20: List.generate(5, (i) => _deal('d${i + 20}')),
      },
    );

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en')),
        dealsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(hotDealsControllerProvider.future);

    await container.read(hotDealsControllerProvider.notifier).loadMore();

    final current = container.read(hotDealsControllerProvider).asData!.value;
    expect(current.deals, hasLength(25));
    expect(current.hasMore, isFalse);
  });

  test('HotDealsController toggleLike updates isLiked and likesCount on success', () async {
    final repo = _FakeDealsRepository(
      pages: {0: [_deal('d1', likes: 2, liked: false)]},
      toggleLikeResult: const Result.success(true),
    );

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en')),
        dealsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(hotDealsControllerProvider.future);
    final controller = container.read(hotDealsControllerProvider.notifier);
    final deal = container.read(hotDealsControllerProvider).asData!.value.deals.first;

    final failure = await controller.toggleLike(deal);
    expect(failure, isNull);

    final updated = container.read(hotDealsControllerProvider).asData!.value.deals.first;
    expect(updated.isLiked, isTrue);
    expect(updated.likesCount, 3);
  });

  test('HotDealsController toggleLike rolls back on failure', () async {
    final repo = _FakeDealsRepository(
      pages: {0: [_deal('d1', likes: 2, liked: false)]},
      toggleLikeResult: Result.failure(const Failure.server(message: 'boom')),
    );

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en')),
        dealsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(hotDealsControllerProvider.future);
    final controller = container.read(hotDealsControllerProvider.notifier);
    final original = container.read(hotDealsControllerProvider).asData!.value.deals.first;

    final failure = await controller.toggleLike(original);
    expect(failure, isA<ServerFailure>());

    final current = container.read(hotDealsControllerProvider).asData!.value.deals.first;
    expect(current.isLiked, isFalse);
    expect(current.likesCount, 2);
  });
}
