# Deals feature (Hot Deals) — mock-first backend abstraction

## Goal
Enable `HotDealsScreen` to behave like real data fetching (loading/error/success) while the Supabase backend is not deployed, and make the switch to Supabase implementation a data-layer-only change.

## Key files
- Domain repository contract: `lib/features/deals/domain/repositories/deals_repository.dart`
- Data sources:
  - `lib/features/deals/data/datasources/deals_remote_data_source.dart`
  - `lib/features/deals/data/datasources/mock_deals_remote_data_source.dart`
  - `lib/features/deals/data/datasources/supabase_deals_remote_data_source.dart` (stub; throws `Failure.featureNotAvailable`)
- Repositories:
  - `lib/features/deals/data/repositories/mock_deals_repository.dart`
  - `lib/features/deals/data/repositories/supabase_deals_repository.dart` (stub)
- Providers + switch:
  - `lib/features/deals/data/providers/deals_backend_providers.dart`
  - Uses `EnvironmentConfig.useMockDeals` (`USE_MOCK_DEALS`, default `true`)
- Presentation:
  - Controller: `lib/features/deals/presentation/controllers/hot_deals_controller.dart` (`AsyncNotifier<List<Deal>>`)
  - Screen: `lib/features/deals/presentation/screens/hot_deals_screen.dart` consumes `hotDealsControllerProvider`

## Mock feed mapping
UI categories are currently: `For You`, `Front Page`, `Popular`.
- Mock DS maps:
  - `For You` -> `DealsMockData.hotDeals`
  - `Front Page` -> `DealsMockData.featuredDeals`
  - `Popular` -> `DealsMockData.deals` sorted by `rating`

## Swap to real Supabase later
Implement only data layer:
- Replace stub logic in `SupabaseDealsRemoteDataSource.fetchHotDeals()` and `SupabaseDealsRepository.getHotDeals()`.
- Keep controller + UI unchanged.

## Note
Local tool environment may not include `flutter`/`dart` binaries; run `flutter analyze` and tests locally.