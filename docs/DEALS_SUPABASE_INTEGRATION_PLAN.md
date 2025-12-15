# Deals Feature — Supabase Integration (Mock-first)

**Scope:** `lib/features/deals/` → **Hot Deals** (`lib/features/deals/presentation/screens/hot_deals_screen.dart`)

**Goal:** Move Hot Deals data access behind clean-architecture interfaces so we can ship UI now with **mocked** data, and later switch to **Supabase-backed** implementation with minimal code changes.

---

## Current State (Baseline)

- `HotDealsScreen` currently consumes synchronous mock providers (`filteredDealsProvider`) that read from `DealsMockData`.
- Feature already has:
  - Domain entity: `lib/features/deals/domain/entities/deal.dart`
  - Data model: `lib/features/deals/data/models/deal_model.dart`
  - Mock data: `lib/features/deals/data/mock_data/deals_mock_data.dart`
  - Providers (mostly mock + UI state): `lib/features/deals/data/providers/deals_providers.dart`

---

## Proposed Folder/File Structure (Additions)

```
lib/features/deals/
  domain/
    repositories/
      deals_repository.dart

  data/
    datasources/
      deals_remote_data_source.dart
      mock_deals_remote_data_source.dart
      supabase_deals_remote_data_source.dart   # stub (no real API calls yet)

    repositories/
      mock_deals_repository.dart
      supabase_deals_repository.dart           # stub (returns featureNotAvailable)

    providers/
      deals_backend_providers.dart             # switch mock/supabase

  presentation/
    controllers/
      hot_deals_controller.dart                # AsyncNotifier
```

---

## Architecture Decisions

### 1) Repository Contract (Domain)
- `DealsRepository.getHotDeals()` returns `AsyncResult<List<Deal>>` (project-wide `Result<T>` pattern).
- Supports **optional filter arguments** (category/search) to make future Supabase querying a drop-in.

### 2) Data Access (Data Layer)
- `DealsRemoteDataSource.fetchHotDeals()` returns data-layer objects (`List<DealModel>`) so mapping remains contained.
- Mock data source uses `DealsMockData.hotDeals`.
- Supabase data source is a **stub** for now (no real calls; returns a failure via repository).

### 3) Swap-ability
- `dealsRepositoryProvider` chooses:
  - `MockDealsRepository` when `EnvironmentConfig.useMockDeals == true`
  - `SupabaseDealsRepository` when `false`

### 4) Presentation State
- `HotDealsController` is an `AsyncNotifier<List<Deal>>`.
- `HotDealsScreen` consumes `hotDealsControllerProvider` and renders:
  - Loading
  - Error
  - Success

---

## Checkpoints (Progress Tracking)

### Phase A — Backend Abstraction
- [x] Add `DealsRepository` interface (domain)
- [x] Add `DealsRemoteDataSource` interface (data)
- [x] Add `MockDealsRemoteDataSource` implementation
- [x] Add `MockDealsRepository` implementation

### Phase B — Future Supabase Stub
- [x] Add `SupabaseDealsRemoteDataSource` stub (no calls)
- [x] Add `SupabaseDealsRepository` stub returning `Failure.featureNotAvailable`
- [x] Add `EnvironmentConfig.useMockDeals` + `.env.example` flag

### Phase C — State + Screen Wiring
- [x] Add `HotDealsController` (AsyncNotifier)
- [x] Update `HotDealsScreen` to consume `AsyncValue<List<Deal>>`
- [x] Keep existing search + category filtering UX (client-side for now)

### Phase D — Validation
- [ ] `flutter analyze`
- [ ] Run relevant tests (if any) and fix only impacted failures

---

## When Supabase Backend Is Ready (Exact Changes)

### Replace Stub → Real Supabase
1. Validate/adjust Supabase schema assumptions used in `SupabaseDealsRemoteDataSource`:
   - Table: `deals`
   - Expected columns (snake_case supported): `id`, `title`, `description`, `price`, `original_price`, `discount_percentage`,
     `image_url`, `brand`, `rating`, `review_count`, `category`, `is_new`, `is_featured`, `created_at`, `expires_at`
2. Set `USE_MOCK_DEALS=false` in your flavor env file once RLS/data are deployed.
3. If column names differ, update row parsing in `lib/features/deals/data/datasources/supabase_deals_remote_data_source.dart`.

### No UI Changes Expected
- `HotDealsScreen` stays the same.
- Controller stays the same.
- Only data-layer implementation changes.

---

## Notes / Non-goals
- No pagination, infinite scroll, or caching yet (easy to add later in controller/repo).
- No visual polish; focus is loading/error/success behavior.
- No real Supabase calls until backend is deployed.
