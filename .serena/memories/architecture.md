# Architecture

## Clean Architecture

The codebase follows **strict clean architecture** with three layers:

### 1. Domain Layer (`lib/features/*/domain/`)
- **Entities**: Business objects (immutable, using Freezed)
- **Repositories**: Abstract interfaces (no implementation details)
- **Use Cases**: Business logic (not heavily used yet)
- Pure Dart, no Flutter dependencies

### 2. Data Layer (`lib/features/*/data/`)
- **Repositories**: Concrete implementations of domain repository interfaces
- **Services**: External service integrations (API calls, database operations)
- **Providers**: Riverpod provider definitions for dependency injection

### 3. Presentation Layer (`lib/features/*/presentation/`)
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components specific to the feature
- **Controllers**: Riverpod `AsyncNotifier` classes for state management

## Directory Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment configuration
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error types (failures, exceptions)
│   ├── extensions/         # Extension methods
│   ├── navigation/         # GoRouter configuration
│   ├── network/            # Network service (Dio)
│   ├── providers/          # Core Riverpod providers
│   ├── result/             # Result type for error handling
│   ├── services/           # Core services (Firebase, AdMob, RevenueCat, etc.)
│   ├── storage/            # Hive service
│   ├── themes/             # Material 3 theme definitions
│   ├── utils/              # Utility functions
│   └── widgets/            # Reusable widgets (buttons, dialogs, ads, etc.)
├── features/               # Feature modules
│   ├── auth/              # ✅ Complete (domain, data, presentation)
│   ├── home/              # ✅ Complete
│   ├── settings/          # ✅ Complete
│   ├── subscription/      # ✅ Complete
│   ├── onboarding/        # ⚠️ Presentation only
│   ├── profile/           # ⚠️ Presentation only
│   └── sample/            # ⚠️ Simplified
├── gen/                    # Auto-generated assets
├── l10n/                   # Localization
├── router/                 # Router configuration
├── app.dart               # Root app widget
├── flavors.dart           # Flavor configuration
├── main.dart              # Main entry point
├── main_dev.dart          # Dev flavor entry
├── main_staging.dart      # Staging flavor entry
└── main_production.dart   # Production flavor entry
```

## Feature Structure (Clean Architecture)

Each complete feature follows this structure:

```
lib/features/[feature_name]/
├── domain/
│   ├── entities/          # Business models (Freezed classes)
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic (optional, not heavily used)
├── data/
│   ├── models/            # Data models (JSON serializable)
│   ├── repositories/      # Repository implementations
│   ├── datasources/       # API/database data sources
│   └── providers/         # Riverpod providers for DI
└── presentation/
    ├── screens/           # Full-page UI
    ├── widgets/           # Feature-specific widgets
    └── controllers/       # State management (AsyncNotifier)
```

## Core Services

Located in `lib/core/services/`:

1. **Supabase** - ✅ Fully initialized
2. **RevenueCat** (`revenue_cat_service.dart`) - ✅ Fully initialized (25KB)
3. **AdMob** (`admob_service.dart`) - ✅ Fully initialized (25KB service with GDPR)
4. **Hive** (`lib/core/storage/hive_service.dart`) - ✅ Fully initialized with encryption
5. **Microsoft Clarity** (`clarity_service.dart`) - ✅ Fully initialized
6. **Network Service** (`lib/core/network/network_service.dart`) - Dio-based HTTP client
7. **Firebase** (`firebase_service.dart`) - ⚠️ **DISABLED BY DEFAULT** (infrastructure ready)

## Navigation

GoRouter-based navigation:
- Main router: `lib/core/navigation/app_router.dart`
- Route guards: `lib/core/navigation/route_guards.dart`
- Named routes: `lib/core/navigation/routes.dart`
- Shell routes for persistent bottom navigation
- Auth state-based redirects

## Error Handling

### Failures (Domain Layer)
- `lib/core/errors/failures.dart`
- Immutable error types using Freezed
- Types: Network, Server, Cache, Authentication failures

### Exceptions (Data Layer)
- `lib/core/errors/exceptions.dart`
- Thrown by data sources
- Converted to Failures in repositories

## Dependency Injection

Riverpod providers used throughout:
- Singleton pattern for services
- Provider composition for dependencies
- Family providers for parameterized state
- Manual providers predominantly (limited code generation)