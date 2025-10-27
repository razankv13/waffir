# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.


## 🔧 MCP Tool Usage (REQUIRED)

**ALWAYS use the following MCP tools automatically - they are optimized for this codebase:**

### 1. Code Search & Navigation - Serena MCP (MANDATORY)

**NEVER use basic grep/glob tools for code searching. ALWAYS use Serena MCP tools instead:**

- **`mcp__serena__find_symbol`**: Locate classes, methods, functions, properties by name path
- **`mcp__serena__search_for_pattern`**: Search for text/regex patterns in code files
- **`mcp__serena__get_symbols_overview`**: Get high-level file structure before diving deep
- **`mcp__serena__find_referencing_symbols`**: Find all references to a symbol (critical for refactoring)
- **`mcp__serena__list_dir`**: List non-gitignored files and directories efficiently
- **`mcp__serena__find_file`**: Find files by name pattern

**Benefits:** Token-efficient code reading, semantic understanding, faster navigation, type-aware search

### 2. Codebase Memory System (CHECK FIRST)

**ALWAYS check memories BEFORE starting any task to understand existing patterns and architecture:**

- **`mcp__serena__list_memories`**: See available memories about this codebase
- **`mcp__serena__read_memory`**: Read specific memory files for context
- **`mcp__serena__write_memory`**: Document new patterns or architecture decisions
- **`mcp__serena__delete_memory`**: Remove outdated memories (only if user requests)

**Location:** `.serena/memories/` - Contains project-specific architectural knowledge, patterns, and gotchas

### 3. Package Documentation - Context7 MCP (MANDATORY)

**ALWAYS use Context7 BEFORE working with any library or package:**

Before implementing features with packages like Riverpod, GoRouter, Freezed, Syncfusion, worker_manager, etc.:
1. Use Context7 to fetch the latest documentation
2. Understand the API, best practices, and patterns
3. Then implement using the documented approach

**This ensures:** Up-to-date API usage, best practices, fewer bugs, proper patterns

### 4. Workflow for Code Tasks

**Recommended order of operations:**

1. **Check memories first**: `mcp__serena__list_memories` → `mcp__serena__read_memory` for relevant context
2. **Use symbol overview**: `mcp__serena__get_symbols_overview` to understand file structure
3. **Search semantically**: `mcp__serena__find_symbol` or `mcp__serena__search_for_pattern` for specific code
4. **Check references**: `mcp__serena__find_referencing_symbols` before modifying code
5. **Consult docs**: Use Context7 for any package-related questions
6. **Document learnings**: `mcp__serena__write_memory` for new patterns discovered

## Project Overview

Waffir - A production-ready Flutter application with clean architecture, Supabase backend, RevenueCat subscriptions, Google AdMob monetization, multi-flavor environments, and comprehensive service integrations.

## ⚠️ Important Notes

- **Firebase**: Infrastructure exists but initialization is **DISABLED by default**. Uncomment code in `lib/core/services/firebase_service.dart` to enable.
- **Production Ready**: Supabase, RevenueCat, AdMob, Clarity, and Hive are fully initialized and working.
- **Flavors**: Always use flavors when running. Default `flutter run` uses production flavor.
- **Tests**: 9 test files provide examples/patterns. Expand coverage for production use.
- **Theme System**: **CRITICAL** - ALWAYS use `Theme.of(context)` to access colors and styles. NEVER directly import or use `AppColors` in widget files. The theme system ensures proper light/dark mode support and Material 3 consistency.

## Development Commands

### Running the App
```bash
# Run with flavors (recommended)
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart

# Run default (production)
flutter run

# Run with specific device
flutter run --flavor dev -t lib/main_dev.dart -d chrome
flutter run --flavor staging -t lib/main_staging.dart -d macos

# Legacy: Run with dart-define (still supported)
flutter run --dart-define=ENVIRONMENT=staging
flutter run --dart-define=ENVIRONMENT=production
```

### Code Generation
```bash
# Generate code once (Freezed, JSON, Riverpod, Hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean
```

### Asset Generation
```bash
# Generate asset classes (flutter_gen)
dart run build_runner build --build-filter="lib/gen/**"
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/features/auth/presentation/controllers/auth_controller_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run tests with Patrol
patrol test
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix common issues
dart fix --apply
```

### Building
```bash
# Android
flutter build apk --release --flavor production -t lib/main_production.dart
flutter build appbundle --release --flavor production -t lib/main_production.dart

# iOS
flutter build ipa --release --flavor production -t lib/main_production.dart

# macOS
flutter build macos --release --flavor production -t lib/main_production.dart

# Web
flutter build web --release -t lib/main_production.dart
```

## Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Configure environment (copy and edit)
cp .env.example .env.dev

# 4. Run with dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# 5. (Optional) Enable Firebase
# Uncomment initialization in lib/core/services/firebase_service.dart
```

## Flavors

Uses [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr) for multi-environment support.

### Available Flavors

- **dev** - Development (`.env.dev`, `com.waffir.app.dev`)
- **staging** - Staging (`.env.staging`, `com.waffir.app.staging`)
- **production** - Production (`.env.production`, `com.waffir.app`)

### Flavor Usage

```dart
import 'package:waffir/flavors.dart';

Flavor currentFlavor = F.appFlavor;
String flavorName = F.name;
String appTitle = F.title;
```

### Regenerate Configurations

```bash
flutter pub run flutter_flavorizr -f
```

## Architecture

### Clean Architecture Layers

The codebase follows strict clean architecture with three layers:

**1. Domain Layer** (`features/*/domain/`)
- Entities: Business objects (immutable, using Freezed)
- Repositories: Abstract interfaces (no implementation)
- Use cases: Business logic (not heavily used yet)

**2. Data Layer** (`features/*/data/`)
- Repositories: Concrete implementations of domain repositories
- Services: External service integrations
- Providers: Riverpod provider definitions

**3. Presentation Layer** (`features/*/presentation/`)
- Screens: Full-page UI components
- Widgets: Reusable UI components
- Controllers: Riverpod `AsyncNotifier` classes for state management

### State Management

Uses **Riverpod** (mostly manual providers):

- `AsyncNotifier<T>` for complex async state (see `AuthController`)
- `StreamProvider` for real-time updates (see `authStateProvider`)
- `Provider` for dependencies and computed values
- Family providers for parameterized state
- Code generation configured but limited use (most providers are manual)

### Navigation

**GoRouter** with:
- Declarative routing in `lib/core/navigation/app_router.dart`
- Route guards for authentication (`lib/core/navigation/route_guards.dart`)
- Shell routes for persistent bottom navigation
- Named routes in `lib/core/navigation/routes.dart`

### Key Services

**Supabase** - ✅ Fully Initialized
- Backend-as-a-Service integration
- Authentication, database, storage
- Configured via environment variables

**RevenueCat** (`lib/core/services/revenue_cat_service.dart`) - ✅ Fully Initialized
- In-app purchase and subscription management
- Customer info streaming
- Entitlement checking
- Offerings and products management

**AdMob** (`lib/core/services/admob_service.dart`) - ✅ Fully Initialized (25KB service!)
- Banner, interstitial, rewarded, native ads
- GDPR/CCPA consent management
- Test ads in development
- Frequency capping and retry logic
- Premium user ad suppression

**Hive** (`lib/core/storage/hive_service.dart`) - ✅ Fully Initialized
- Encrypted local storage with flutter_secure_storage
- Auto-generated type adapters
- Settings, user data, and cache management

**Microsoft Clarity** (`lib/core/services/clarity_service.dart`) - ✅ Fully Initialized
- Session recording and user behavior analytics
- Custom user ID tracking
- Environment-based log levels

**Network Service** (`lib/core/network/network_service.dart`)
- Dio-based HTTP client
- Interceptors: auth, retry, logging, connectivity
- Type-safe REST methods
- Centralized error handling

**Firebase** (`lib/core/services/firebase_service.dart`) - ⚠️ **DISABLED BY DEFAULT**
- Infrastructure ready for: Auth, Firestore, Analytics, Crashlytics, Messaging, Remote Config
- All initialization code is commented out
- To enable: Uncomment initialization in `firebase_service.dart`

### Environment Configuration

**Environment Files**: `.env.dev`, `.env.staging`, `.env.production`, `.env` (fallback)

**Key Configuration**: Supabase, Firebase, RevenueCat, AdMob, Sentry, Clarity, feature flags

**Usage**:
```dart
EnvironmentConfig.supabaseUrl
EnvironmentConfig.enableAds
EnvironmentConfig.currentEnvironment
```

### Error Handling

**Failures** (domain layer) - `lib/core/errors/failures.dart`:
- Immutable error types using Freezed
- Network, server, cache, authentication failures

**Exceptions** (data layer) - `lib/core/errors/exceptions.dart`:
- Thrown by data sources
- Converted to Failures in repositories

### Dependency Injection

All services use singleton pattern with Riverpod providers:
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) => FirebaseAuthRepository());
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) => RevenueCatService.instance);
```

## Code Patterns

### Freezed for Immutability
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.authenticated({required UserModel user}) = Authenticated;
}
```

### AsyncNotifier for State Management
```dart
class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async { /* init */ }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await repository.signIn(email, password);
    });
  }
}
```

### Testing Infrastructure

**9 test files provide examples** (ready for expansion):

- Unit tests: `auth_controller_test.dart`, `validators_test.dart`, `logger_test.dart`, `environment_config_test.dart`
- Widget tests: `app_button_test.dart`
- Integration tests: `auth_flow_test.dart`
- Test utilities: `test_config.dart`, `test_helpers.dart`, `mock_services.dart`

**Test dependencies**: mocktail, mockito, golden_toolkit, patrol, network_image_mock

## Important Files

**Main Entry Point**: `lib/main.dart`
- Multi-stage initialization (env, Firebase, Hive, RevenueCat, AdMob)
- Sentry integration for crash reporting
- Error zone handling

**Router**: `lib/core/navigation/app_router.dart`
- All route definitions
- Auth guards integration
- Shell routes for bottom nav

**Environment**: `lib/core/config/environment_config.dart`
- All environment variable access
- Multi-environment support

**Theme**: `lib/core/themes/app_theme.dart`
- Material 3 design system
- Light and dark theme definitions

## Important Widgets

### Core Reusable Widgets (`lib/core/widgets/`)

**AppButton** (`buttons/app_button.dart`)
- Variants: primary, secondary, outlined, text, ghost, destructive
- Sizes: small, medium, large
- Features: loading states, icons, animations, tooltips
- Most commonly used button component

**Ad Widgets** (`ads/`)
- `AdBannerWidget` - Banner ad integration with lifecycle management
- `AdConsentDialog` - GDPR/CCPA consent management

**Premium Feature Wrapper** (`premium/`)
- Wraps features requiring active subscription
- Shows paywall for non-premium users

**Services** (`dialogs/`, `snackbars/`)
- `DialogService` - Centralized dialog management
- `SnackbarService` - Standardized snackbar handling

**Debug Tools** (`debug/`)
- `DebugDrawer` - Development tools drawer
- `DebugOverlay` - Performance and state inspection

## Deployment & Scripts

The `scripts/` directory contains production-ready automation:

- **`deploy.sh`** - Comprehensive CI/CD deployment script (31KB)
- **`config.sh`** - Environment and flavor configuration
- **`create_app_store_connect.sh`** - App Store Connect setup
- **`setup_app_store_upload.sh`** - Upload preparation

See `scripts/README.md` for detailed documentation.

## Initialization Flow

1. Set app flavor (dev/staging/production)
2. Load environment configuration (`.env` files)
3. Initialize system configurations (orientation, status bar)
4. Initialize EasyLocalization (i18n)
5. Initialize Supabase
6. Initialize Hive with encryption
7. ~~Initialize Firebase~~ (disabled by default)
8. Initialize RevenueCat
9. Initialize AdMob (if enabled via environment)
10. Initialize Clarity analytics
11. Initialize Sentry (if enabled via environment)
12. Run app with error zone

## Common Tasks

### Adding a New Feature
1. Create feature folder in `lib/features/[feature_name]/`
2. Add domain entities in `domain/entities/`
3. Define repository interface in `domain/repositories/`
4. Implement repository in `data/repositories/`
5. Create providers in `data/providers/`
6. Build UI in `presentation/screens/` and `presentation/widgets/`
7. Add controller in `presentation/controllers/` (if needed)
8. Add routes to `app_router.dart`
9. Write tests in `test/`

### Adding Environment Variables
1. Add to `.env.example`
2. Add to `.env.dev`, `.env.staging`, `.env.production`
3. Add getter in `EnvironmentConfig` class

### Running Code Generation
Always run after:
- Adding/modifying Freezed classes
- Adding/modifying JSON serializable classes
- Adding/modifying Riverpod providers with annotations
- Adding/modifying Hive type adapters

### Working with Assets
- Images: `assets/images/`
- Icons: `assets/icons/`
- Translations: `assets/translations/` (3 languages: English, Spanish, French)
- Access via: `Assets.images.appIcon`, etc. (auto-generated by flutter_gen)

## Feature Implementation Status

| Feature | Clean Arch | Domain | Data | Presentation | Status |
|---------|-----------|---------|------|--------------|--------|
| Auth | ✅ | ✅ | ✅ | ✅ | Complete |
| Home | ✅ | ✅ | ✅ | ✅ | Complete |
| Settings | ✅ | ✅ | ✅ | ✅ | Complete |
| Subscription | ✅ | ✅ | ✅ | ✅ | Complete |
| Onboarding | ⚠️ | ❌ | ❌ | ✅ | Presentation Only |
| Profile | ⚠️ | ❌ | ❌ | ✅ | Presentation Only |
| Sample | ⚠️ | ✅ | ✅ | ✅ | Simplified |

## Extension Methods

Useful extension methods in `lib/core/extensions/`:

**ContextExtensions**:
- Theme shortcuts, navigation helpers, MediaQuery utilities
- Dialog and snackbar helpers

**StringExtensions**:
- Validation helpers, formatting utilities, capitalization

**DateTimeExtensions**:
- Human-readable formatting, relative time, date comparisons

## Known Limitations

1. **Firebase disabled by default** - Requires manual activation (uncomment in `firebase_service.dart`)
2. **Minimal test coverage** - Only 9 example test files
3. **Empty asset directories** - No placeholder images/icons included
4. **Minimal main README** - `README.md` needs expansion for public use
5. **Limited Riverpod code generation** - Most providers are manually defined

## Documentation Files

- **CLAUDE.md** - AI assistance guide (this file)
- **FIREBASE_SETUP.md** - Firebase configuration instructions
- **requirements.md** - Original project requirements
- **scripts/README.md** - Deployment scripts documentation
- **README.md** - Minimal (needs expansion)
