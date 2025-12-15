# Stores → Supabase integration plan (mock-first)

Target UI: `lib/features/stores/presentation/screens/stores_screen.dart`

Goal: make `StoresScreen` behave like a real network-backed screen (loading/success/error) while keeping Supabase out of
presentation/domain, and ensuring the switch from mock → Supabase is a data-layer-only change.

## Current state (what exists today)

- `StoresScreen` is a `ConsumerStatefulWidget` and reads synchronous mock providers from:
  - `lib/features/stores/data/providers/stores_providers.dart`
- Those providers return `List<StoreModel>` directly from:
  - `lib/features/stores/data/mock_data/stores_mock_data.dart`
- This means:
  - No true loading state
  - No error state
  - No repository contract in `lib/features/stores/domain/repositories/` (directory is empty)

## Desired end state (high level)

- Presentation watches a single provider: `storesControllerProvider` (or a small set of controllers) and renders:
  - `loading`: skeleton/progress UI that matches the screen layout
  - `error`: retry affordance + message
  - `success`: current layout (near you + mall sections + filters)
- Domain defines the contract: `StoresRepository`
- Data implements:
  - `MockStoresRepository` (backed by existing `StoresMockData`)
  - `SupabaseStoresRepository` (stub for now; later real implementation)
- Switching mock → Supabase is controlled by a single provider switch (same pattern as deals feature).

## Proposed folder & file structure (stores feature)

This mirrors the successful pattern already used by deals (`docs/DEALS_SUPABASE_INTEGRATION_PLAN.md`).

```
lib/features/stores/
├── domain/
│   ├── entities/
│   │   └── store.dart
│   └── repositories/
│       └── stores_repository.dart              # NEW
├── data/
│   ├── datasources/
│   │   ├── stores_remote_data_source.dart      # NEW
│   │   ├── mock_stores_remote_data_source.dart # NEW (wraps StoresMockData)
│   │   └── supabase_stores_remote_data_source.dart # NEW (stub for now)
│   ├── mock_data/
│   │   └── stores_mock_data.dart               # existing (keep)
│   ├── models/
│   │   └── store_model.dart                    # existing (DTO for Supabase rows)
│   ├── repositories/
│   │   ├── mock_stores_repository.dart         # NEW
│   │   └── supabase_stores_repository.dart     # NEW (stub for now)
│   └── providers/
│       ├── stores_backend_providers.dart       # NEW (mock/supabase switch)
│       └── stores_providers.dart               # existing (to be deprecated/migrated)
└── presentation/
    ├── controllers/
    │   └── stores_controller.dart              # NEW (AsyncNotifier)
    └── screens/
        └── stores_screen.dart                  # update to consume controller
```

Notes:
- Keep the existing `stores_providers.dart` during migration, but stop reading it from `StoresScreen` once the controller
  is in place.
- `StoreModel` remains the row/DTO boundary used by data sources; domain uses `Store`.

## Domain: repository contract

Use the same `AsyncResult<T>` pattern used by the deals feature:

`lib/features/stores/domain/repositories/stores_repository.dart`

```dart
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';

abstract class StoresRepository {
  AsyncResult<List<Store>> fetchStores({
    String? searchQuery,
    StoreCategory? category,
  });
}
```

Rationale:
- `StoresScreen` currently needs: search + category filter.
- “Near to you” vs “Mall” can be derived from fields (e.g. `location`) inside domain logic or presentation filtering.
  If the API eventually supports server-side filtering, add optional params later (backwards compatible).

## Data: remote data source abstraction

`lib/features/stores/data/datasources/stores_remote_data_source.dart`

```dart
import 'package:waffir/features/stores/data/models/store_model.dart';

abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> fetchStores({
    String? searchQuery,
    String? category, // server-friendly string; keep domain enum out of data-source API
  });
}
```

### Mock data source (network-like behavior)

`lib/features/stores/data/datasources/mock_stores_remote_data_source.dart`

- Introduce a small delay (e.g. 350–700ms) to behave like a network request.
- Add a simple, deterministic error toggle for testing error UI (e.g. via a provider flag or debug-only env var).
- Reuse `StoresMockData` for the actual dataset.

```dart
class MockStoresRemoteDataSource implements StoresRemoteDataSource {
  @override
  Future<List<StoreModel>> fetchStores({String? searchQuery, String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Optionally throw to simulate network failure.
    final stores = StoresMockData.stores;
    // Apply lightweight filtering here for realism.
    return stores;
  }
}
```

### Supabase data source (stub for now)

`lib/features/stores/data/datasources/supabase_stores_remote_data_source.dart`

- Do not call Supabase yet (backend not deployed).
- Throw a domain-level “feature not available” failure through the repository.

When backend is ready, this is where Supabase queries live (e.g. `Supabase.instance.client.from('stores')...`).

## Data: repositories (mock + supabase)

Pattern mirrors deals:

- Repository calls data source
- Maps `StoreModel` → domain `Store`
- Converts exceptions into `AsyncResult` failures

`lib/features/stores/data/repositories/mock_stores_repository.dart`

```dart
class MockStoresRepository implements StoresRepository {
  MockStoresRepository(this._remote);
  final StoresRemoteDataSource _remote;

  @override
  AsyncResult<List<Store>> fetchStores({String? searchQuery, StoreCategory? category}) async {
    return Result.guard(() async {
      final rows = await _remote.fetchStores(
        searchQuery: searchQuery,
        category: category?.displayName,
      );
      return rows.map((m) => m.toDomain()).toList(growable: false);
    });
  }
}
```

`lib/features/stores/data/repositories/supabase_stores_repository.dart` (stub)

```dart
class SupabaseStoresRepository implements StoresRepository {
  @override
  AsyncResult<List<Store>> fetchStores({String? searchQuery, StoreCategory? category}) async {
    return Result.failure(const Failure.featureNotAvailable(message: 'Stores backend not deployed yet'));
  }
}
```

## Providers: mock ↔ supabase switch

Create `lib/features/stores/data/providers/stores_backend_providers.dart` similar to deals’ `deals_backend_providers.dart`.

- Decide flag naming:
  - Option A: `EnvironmentConfig.useMockStores` backed by `USE_MOCK_STORES` (default `true`)
  - Option B: piggy-back on an existing “use mock data” master flag if one exists

Providers to expose:
- `storesRemoteDataSourceProvider`
- `storesRepositoryProvider`

The only change when backend is ready should be:
- Implement Supabase remote data source + repository
- Flip the environment flag default (or per environment)

## Presentation: Riverpod state management (AsyncNotifier)

Preferred: an `AsyncNotifier<StoresState>` similar to `HotDealsController`.

`lib/features/stores/presentation/controllers/stores_controller.dart`

### State shape

Keep it minimal and focused on UI concerns:

```dart
class StoresState {
  const StoresState({
    required this.stores,
    required this.searchQuery,
    required this.selectedCategory,
  });

  final List<Store> stores;
  final String searchQuery;
  final StoreCategory selectedCategory;
}
```

### Controller responsibilities

- Holds `searchQuery` and `selectedCategory`
- Fetches from repository (async)
- Exposes `AsyncValue<StoresState>` so `StoresScreen` can render loading/error/success
- Provides `refresh`, `updateSearch`, `updateCategory`

Pseudo-flow:

1. `build()` initializes to defaults then fetches once.
2. `updateSearch/updateCategory` updates state optimistically (or stores local fields), then re-fetches.

## `stores_screen.dart`: example consumption changes

Replace reading the synchronous providers with:

```dart
final asyncState = ref.watch(storesControllerProvider);

return asyncState.when(
  loading: () => const StoresLoadingView(), // skeleton matching layout
  error: (e, st) => StoresErrorView(onRetry: () => ref.read(storesControllerProvider.notifier).refresh()),
  data: (state) {
    final nearYou = state.stores.where((s) => /* derive */).toList();
    final malls = groupByMall(state.stores);
    return StoresSuccessView(
      nearYouStores: nearYou,
      mallStoresByMall: malls,
      onSearch: ref.read(storesControllerProvider.notifier).updateSearch,
      onCategoryChanged: ref.read(storesControllerProvider.notifier).updateCategory,
    );
  },
);
```

Important:
- Keep all sizing via `ResponsiveHelper` (already used in `StoresScreen`).
- Keep colors via `Theme.of(context)` / `colorScheme` (no `AppColors` imports in widgets).
- Preserve existing pixel-perfect UI widgets (`WaffirSearchBar`, `StoresCategoryChips`, `StoreCard`, CTA overlay).

## Checklist: exact changes when Supabase backend is ready

1. Data source
   - Implement `SupabaseStoresRemoteDataSource.fetchStores` using `Supabase.instance.client`.
   - Decide table/view name and columns; map rows to `StoreModel.fromJson`.
2. Repository
   - Replace stub in `SupabaseStoresRepository` to call the Supabase data source.
   - Ensure exception → `Failure` mapping is consistent with other features.
3. Provider switch
   - Flip `USE_MOCK_STORES` to `false` in staging/production env files.
4. Validation
   - Run `dart run build_runner build --delete-conflicting-outputs` if model annotations change.
   - Run `flutter analyze` + relevant tests.

## Known cleanup to consider (optional, but recommended)

- `lib/features/stores/data/models/store_model.dart` currently imports:
  - `package:waffir/features/products/domain/entities/store.dart`
  - If stores feature should own its store entity, align this import to
    `package:waffir/features/stores/domain/entities/store.dart` and reconcile any differences.
- `lib/features/stores/data/providers/stores_providers.dart` uses `flutter_riverpod/legacy.dart`; prefer modern Riverpod
  APIs once the controller replaces those synchronous providers.
