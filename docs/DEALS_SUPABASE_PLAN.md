# Deals → Supabase integration plan

> Scope: Hot Deals flow should behave like a real network fetch today (mocked), and swap cleanly to Supabase when the backend is live.

## Folder & file structure
```
lib/features/deals/
├── domain/
│   ├── entities/deal.dart                # existing Freezed entity
│   └── repositories/deals_repository.dart # NEW interface
├── data/
│   ├── datasources/deals_remote_data_source.dart # mock + interface
│   ├── datasources/supabase_deals_remote_data_source.dart # Supabase implementation (behind flag)
│   ├── repositories/mock_deals_repository.dart   # NEW repository impl
│   ├── providers/deals_backend_providers.dart    # DI wiring (mock ↔ supabase)
│   └── mock_data/deals_mock_data.dart            # existing fake payloads
└── presentation/
    ├── controllers/hot_deals_controller.dart     # NEW AsyncNotifier state
    └── screens/hot_deals_screen.dart             # UPDATED to consume controller
```

## Domain
- `Deal` entity (existing) stays unchanged.
- `DealsRepository` interface (`domain/repositories/deals_repository.dart`):
  ```dart
  abstract class DealsRepository {
    AsyncResult<List<Deal>> fetchHotDeals({String? category, String? searchQuery});
  }
  ```

## Data layer (mocked, Supabase-ready)
- `DealsRemoteDataSource` abstraction with `fetchHotDeals(...)`.
- `MockDealsRemoteDataSource` simulates latency, maps UI categories (`For You`, `Front Page`, `Popular`) to filters, and supports text search.
- `MockDealsRepository` maps models → domain and wraps results in `Result<...>` with `Failure` on errors.
- Providers (`deals_backend_providers.dart`):
  - `dealsRemoteDataSourceProvider` → `MockDealsRemoteDataSource`
  - `dealsRepositoryProvider` → `MockDealsRepository`
  - Swap here later for Supabase without touching UI.

## Presentation / state management
- `HotDealsController` (`presentation/controllers/hot_deals_controller.dart`):
  - `AutoDisposeAsyncNotifier<HotDealsState>`.
  - Keeps `deals`, `selectedCategory`, `searchQuery`, `failure`.
  - Methods: `refresh`, `updateCategory`, `updateSearch`.
  - Initial load uses mock data but surfaces loading and error states.
- UI hook (`hot_deals_screen.dart`):
  - Watches `hotDealsControllerProvider`.
  - Shows `_HotDealsLoadingState`, `_HotDealsErrorState`, or list/empty states.
  - Search and category chips call controller methods (no direct data access).

## Example consumption (already applied)
- `lib/features/deals/presentation/screens/hot_deals_screen.dart`
  - Removes direct dependency on `DealsMockData` providers.
  - Uses `hotDealsControllerProvider` for data + loading/error handling.
  - Category chips call `updateCategory`; search bar calls `updateSearch`.

## What changes when Supabase is ready
The Supabase implementation is already in place and wired behind `USE_MOCK_DEALS`.

1. Deploy the backend schema + RLS and seed some data.
   - Table: `deals`
   - Columns expected (either style works; code normalizes snake_case → camelCase):
     - `discount_percentage` / `discountPercentage`, `image_url` / `imageUrl`, `is_featured` / `isFeatured`, etc.
2. Flip the environment flag:
   - Set `USE_MOCK_DEALS=false` (see `EnvironmentConfig.useMockDeals`).
3. Verify/adjust query behavior in:
   - `lib/features/deals/data/datasources/supabase_deals_remote_data_source.dart`
     - Hot deals threshold (`discount_percentage >= 20`)
     - Feed mapping: `Front Page` → `is_featured = true`, `Popular` → order by rating/reviews
     - Search: PostgREST `.or('title.ilike...,description.ilike...,brand.ilike...')`
4. No changes required in:
   - `lib/features/deals/presentation/controllers/hot_deals_controller.dart`
   - `lib/features/deals/presentation/screens/hot_deals_screen.dart`
5. Optional hardening once real data exists:
   - Add pagination (`range(from, to)`) and server-side text search (FTS/TSVector).
   - Add tests: repository (mock vs supabase) + controller state transitions.

## Notes
- No real Supabase calls are made now; mock simulates network delay and server-side filtering.
- All networking is behind `DealsRepository`; the only swap needed later is the data source binding.
- Build runner is **not** required for these additions (no new Freezed classes created). Run `dart run build_runner build --delete-conflicting-outputs` only if you later add new `@freezed`/`@JsonSerializable` models.
