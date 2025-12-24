# Waffir AI Agent Guide (for Codex / LLMs)

This file is the **single source of truth** for how an AI coding agent should operate in this repository.

## How to Read This (Priority Order)

When making decisions, follow this precedence (highest → lowest):

1. **Non‑negotiable rules (MUST/NEVER) in this file**
2. **Codebase memory**: `.serena/memories/` (existing architecture + project conventions)
3. **Existing code patterns** already present in the repo
4. **Upstream package docs** (always fetched via Context7)

If two rules conflict, prefer **more specific / more local** guidance (project > repo patterns > upstream docs).

## ✅ Non‑Negotiables (Quick Checklist)

- **Search & navigation:** use **Serena MCP** tools (never basic grep/glob).
- **Context first:** read `.serena/memories/` before implementing.
- **Packages:** use **Context7** before touching any library APIs.
- **UI state & lifecycle:** **Flutter Hooks first** (avoid `StatefulWidget` / `ConsumerStatefulWidget`).
- **Theming:** use `Theme.of(context)` / `colorScheme` in widgets (no `AppColors` imports in UI).
- **Responsive UI:** use `ResponsiveHelper` for **all** sizing/padding/fonts (no hardcoded pixels).
- **Generated code:** never edit `*.g.dart` / `*.freezed.dart`; run build_runner after annotated changes.
- **Flavors:** run using flavors; default `flutter run` uses production flavor.

---

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
- **Responsive Design**: **MANDATORY** - ALWAYS use `ResponsiveHelper` for ALL dimensions, padding, spacing, and font sizes. See Responsive Design Guidelines below.
- **Flutter Hooks**: **CRITICAL** - ALWAYS prefer `HookWidget` / `HookConsumerWidget` over `StatefulWidget` for any UI state or lifecycle.

## 🪝 Flutter Hooks First (CRITICAL)

**Rule:** If a widget needs **local UI state** or **lifecycle** (init/dispose, controllers, listeners, animations), you MUST use **Flutter Hooks** instead of `StatefulWidget` / `ConsumerStatefulWidget`.

### Preferred Widget Types

- **`HookWidget`**: UI-only widgets that need hooks.
- **`HookConsumerWidget`** (from `hooks_riverpod`): when you need both **hooks** and **Riverpod `WidgetRef`**.
- **`HookConsumer(builder: ...)`**: for small hook+ref islands inside a bigger widget.

> Use `StatefulWidget` only when there is no practical hooks-based equivalent. If you *must* do that, add a short comment explaining why.

### Which State Goes Where?

- **Local, ephemeral UI state** (toggles, selected tab, animations, scroll position): **hooks**
- **Shared / business state** (auth, profile, remote data, feature state): **Riverpod** (`AsyncNotifier`, `Provider`, etc.)

### Common Hook Mappings

- `initState` / `dispose` → `useEffect(() { ...; return () { cleanup }; }, [deps])`
- `setState` → `useState<T>()`
- `TextEditingController` → `useTextEditingController()`
- `ScrollController` → `useScrollController()`
- `FocusNode` → `useFocusNode()`
- `TickerProviderStateMixin` / animation setup → `useSingleTickerProvider()` + `useAnimationController()`

### Tiny Example (StatefulWidget → HookWidget)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Counter extends HookWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return Row(
      children: [
        Text('Count: ${count.value}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => count.value++,
        ),
      ],
    );
  }
}
```

---

## 📋 Code Generation Rules (CRITICAL)

**ALWAYS follow these rules when working with code generation in this project:**

### Build Configuration Standards

This project uses `build.yaml` with specific configurations for code generation. **You MUST adhere to these settings:**

**Line Length**: 120 characters (configured for Riverpod generator)
- All generated code follows this standard
- When writing code that will be generated, keep this limit in mind

### Generated File Patterns

**NEVER edit these generated files directly:**
- `*.g.dart` - JSON serialization, Riverpod providers, Hive adapters
- `*.freezed.dart` - Freezed immutable classes

**⚠️ WARNING:** Any manual edits to generated files will be overwritten on next build!

### When to Run Build Runner (MANDATORY)

**Always run `dart run build_runner build --delete-conflicting-outputs` after:**

1. **Freezed Changes**:
   - Creating/modifying classes with `@freezed` annotation
   - Adding new union types or copyWith methods
   - Changing class fields or adding new sealed classes

2. **JSON Serializable Changes**:
   - Adding/modifying classes with `@JsonSerializable()` annotation
   - Changing field names or types in serializable models
   - Adding custom JSON converters

3. **Riverpod Changes**:
   - Creating providers with `@riverpod` annotation
   - Modifying provider parameters or return types
   - Adding family providers with code generation

4. **Hive Changes**:
   - Creating/modifying classes with `@HiveType()` annotation
   - Adding fields with `@HiveField()` annotation
   - Changing type adapter IDs

### JSON Serialization Configuration (build.yaml)

**The following JSON serialization options are configured:**
```yaml
json_serializable:
  any_map: false                      # Strict Map<String, dynamic> only
  checked: false                      # No runtime type checking
  create_factory: true                # Generate fromJson factory
  create_to_json: true                # Generate toJson method
  disallow_unrecognized_keys: false   # Allow extra keys in JSON
  explicit_to_json: false             # Auto-detect nested serialization
  field_rename: none                  # Use exact field names (no snake_case conversion)
  include_if_null: true               # Include null values in JSON output
```

**What this means for your code:**
- Use exact field names (no automatic snake_case conversion)
- Null values WILL be included in JSON output
- No runtime type checking - ensure type safety at compile time
- Extra JSON keys won't cause errors (flexible API responses)

### Code Generation Best Practices

1. **Freezed Classes**:
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';

   part 'user.freezed.dart';  // REQUIRED
   part 'user.g.dart';        // REQUIRED for JSON serialization

   @freezed
   class User with _$User {
     const factory User({
       required String id,
       required String name,
       String? email,
     }) = _User;

     factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
   }
   ```

2. **JSON Serializable (without Freezed)**:
   ```dart
   import 'package:json_annotation/json_annotation.dart';

   part 'response.g.dart';  // REQUIRED

   @JsonSerializable()
   class ApiResponse {
     final bool success;
     final String? message;

     ApiResponse({required this.success, this.message});

     factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
     Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
   }
   ```

3. **Riverpod Providers (Code Generation)**:
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part 'providers.g.dart';  // REQUIRED

   @riverpod
   Future<User> user(UserRef ref, String id) async {
     // Line length: 120 characters max for generated code
     return await ref.read(userRepositoryProvider).fetchUser(id);
   }
   ```

4. **Hive Type Adapters**:
   ```dart
   import 'package:hive/hive.dart';

   part 'settings.g.dart';  // REQUIRED

   @HiveType(typeId: 0)  // Unique typeId required
   class Settings {
     @HiveField(0)
     final bool darkMode;

     @HiveField(1)
     final String language;

     Settings({required this.darkMode, required this.language});
   }
   ```

### Build Runner Commands Summary

```bash
# Generate code once (most common)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous development
dart run build_runner watch --delete-conflicting-outputs

# Clean all generated files (use when build fails)
dart run build_runner clean

# Generate only asset files (flutter_gen)
dart run build_runner build --build-filter="lib/gen/**"
```

### Troubleshooting Generated Code

**If build_runner fails:**
1. Run `dart run build_runner clean`
2. Check for missing `part` directives
3. Ensure all annotations are correct
4. Verify no syntax errors in source files
5. Run `flutter clean && flutter pub get`
6. Run `dart run build_runner build --delete-conflicting-outputs` again

**Common mistakes to avoid:**
- ❌ Forgetting `part` directive for generated files
- ❌ Editing `.g.dart` or `.freezed.dart` files directly
- ❌ Not running build_runner after modifying annotated classes
- ❌ Using wrong typeId for Hive adapters (must be unique)
- ❌ Missing `const factory` for Freezed classes
- ❌ Not including `with _$ClassName` mixin for Freezed

## 📱 Responsive Design Guidelines (MANDATORY)

**CRITICAL: ALL UI dimensions, padding, spacing, and font sizes MUST use ResponsiveHelper for cross-device compatibility.**

### Design Reference

This project is based on **Figma design frames with dimensions 393×852px (mobile)**.

**Golden Rule**: NEVER hardcode pixel values from Figma. ALWAYS use `ResponsiveHelper` to scale them proportionally.

### Device Breakpoints

- **Mobile**: < 600px width
- **Tablet**: 600px - 900px width
- **Desktop**: ≥ 900px width

### Usage Patterns

**1. Basic Dimension Scaling (Most Common)**

```dart
// ❌ WRONG - Hardcoded Figma values
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
)

// ✅ CORRECT - Scaled from Figma
final responsive = ResponsiveHelper(context);
// OR use extension:
Container(
  width: context.responsive.scale(200),   // Scales 200px from Figma
  height: context.responsive.scale(100),  // Scales 100px from Figma
  padding: context.responsive.scalePadding(EdgeInsets.all(16)),
)
```

**2. Font Sizes (Prevents Too-Small Text)**

```dart
// ❌ WRONG
Text(
  'Hello',
  style: TextStyle(fontSize: 14),
)

// ✅ CORRECT - Scales with minimum readable size
Text(
  'Hello',
  style: TextStyle(
    fontSize: context.responsive.scaleFontSize(14, minSize: 10),
  ),
)
```

**3. Padding & Spacing**

```dart
// ❌ WRONG
Padding(
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  child: child,
)

// ✅ CORRECT
Padding(
  padding: context.responsive.scalePadding(
    EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  ),
  child: child,
)
```

**4. Border Radius**

```dart
// ❌ WRONG
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
)

// ✅ CORRECT
Container(
  decoration: BoxDecoration(
    borderRadius: context.responsive.scaleBorderRadius(
      BorderRadius.circular(12),
    ),
  ),
)
```

**5. Size Constraints (Min/Max Values)**

```dart
// For elements that shouldn't get too small on small screens
final width = context.responsive.scaleWithMin(100, min: 80);

// For elements that shouldn't get too large on big screens
final maxWidth = context.responsive.scaleWithMax(300, max: 400);

// Both min and max constraints
final constrained = context.responsive.scaleWithRange(
  150,
  min: 120,
  max: 200,
);
```

**6. Device-Specific Layouts**

```dart
// Different values per device type
final columns = context.responsive.responsiveValue(
  mobile: 2,
  tablet: 3,
  desktop: 4,
);

// Different widgets per device type
context.responsive.responsiveWidget(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

**7. Device Detection**

```dart
// Using ResponsiveHelper instance
final responsive = ResponsiveHelper(context);
if (responsive.isMobile) {
  // Mobile-specific code
}

// Using context extension (shorter)
if (context.isMobile) {
  // Mobile-specific code
} else if (context.isTablet) {
  // Tablet-specific code
} else if (context.isDesktop) {
  // Desktop-specific code
}
```

**8. Responsive Builder Widget**

```dart
// For complex responsive widgets that need access to responsive helper
ResponsiveBuilder(
  builder: (context, responsive) {
    return Container(
      width: responsive.scale(200),
      padding: responsive.scalePadding(EdgeInsets.all(16)),
      child: Column(
        children: [
          Text(
            'Responsive!',
            style: TextStyle(
              fontSize: responsive.scaleFontSize(16),
            ),
          ),
        ],
      ),
    );
  },
)
```

**9. Grid Layouts**

```dart
// Responsive grid columns
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsive.gridColumns(), // 2/3/4 based on device
    crossAxisSpacing: context.responsive.scale(16),
    mainAxisSpacing: context.responsive.scale(16),
  ),
)
```

**10. Content Max Width (Centering on Large Screens)**

```dart
Container(
  width: context.responsive.contentMaxWidth(), // Full on mobile, max 1200 on desktop
  child: YourContent(),
)
```

### Helper Methods Reference

| Method | Use Case | Example |
|--------|----------|---------|
| `scale(double)` | General dimensions | `scale(200)` |
| `scaleWithMin(double, min)` | Prevent too small | `scaleWithMin(100, min: 80)` |
| `scaleWithMax(double, max)` | Prevent too large | `scaleWithMax(300, max: 400)` |
| `scaleWithRange(double, min, max)` | Constrain both | `scaleWithRange(150, min: 120, max: 200)` |
| `scaleFontSize(double, minSize)` | Font sizes | `scaleFontSize(14, minSize: 10)` |
| `scalePadding(EdgeInsets)` | Padding/margins | `scalePadding(EdgeInsets.all(16))` |
| `scaleBorderRadius(BorderRadius)` | Border radius | `scaleBorderRadius(BorderRadius.circular(12))` |
| `scaleSize(Size)` | Size objects | `scaleSize(Size(200, 100))` |
| `scaleOffset(Offset)` | Offset values | `scaleOffset(Offset(10, 20))` |
| `scaleConstraints(BoxConstraints)` | Constraints | `scaleConstraints(BoxConstraints(maxWidth: 300))` |
| `responsiveValue<T>()` | Different values per device | See example above |
| `responsiveWidget()` | Different widgets per device | See example above |
| `gridColumns()` | Grid column counts | `gridColumns()` returns 2/3/4 |
| `horizontalPadding()` | Standard horizontal padding | Returns 16/24/32 |
| `verticalPadding()` | Standard vertical padding | Returns 16/20/24 |
| `contentMaxWidth()` | Max content width | Returns ∞/900/1200 |

### Quick Access via Context Extension

```dart
// These are equivalent:
ResponsiveHelper(context).scale(16)
context.responsive.scale(16)

// Device checks:
context.isMobile    // < 600px
context.isTablet    // 600-900px
context.isDesktop   // ≥ 900px

// Screen dimensions:
context.screenWidth
context.screenHeight
```

### Common Patterns

**1. Figma to Flutter Workflow**

1. Get dimension from Figma design (e.g., width: 343px)
2. Use `context.responsive.scale(343)` in Flutter
3. For fonts, use `context.responsive.scaleFontSize(16)`
4. For padding, use `context.responsive.scalePadding(EdgeInsets...)`

**2. Safe Area Handling**

```dart
// Check for notch/safe area
if (context.responsive.hasBottomNotch) {
  // Add extra padding
  padding = context.responsive.bottomSafeArea;
}

// Access safe area insets
final safeArea = context.responsive.safeAreaInsets;
```

**3. Custom Breakpoint Logic**

```dart
final responsive = context.responsive;

if (responsive.screenWidth < 400) {
  // Very small phones
} else if (responsive.isMobile) {
  // Standard mobile
} else if (responsive.isTablet) {
  // Tablet
} else {
  // Desktop
}
```

### Critical Rules Summary

✅ **DO:**
- ALWAYS use `context.responsive.scale()` for Figma dimensions
- ALWAYS use `scaleFontSize()` for text sizes
- ALWAYS use `scalePadding()` for EdgeInsets
- ALWAYS use `scaleBorderRadius()` for rounded corners
- Use `responsiveValue()` for device-specific values
- Use device detection helpers (`isMobile`, `isTablet`, `isDesktop`)

❌ **DON'T:**
- NEVER hardcode pixel values from Figma designs
- NEVER use raw numbers for dimensions, padding, or fonts
- NEVER ignore responsive scaling (breaks tablet/desktop)
- NEVER create custom scaling logic (use ResponsiveHelper)

### Colors (Design Tokens)

**Source of truth**
- In widget code, prefer `Theme.of(context).colorScheme.*`.
- Do not import `AppColors` in widgets. Only theme/config code should read `AppColors` directly.

**Palette (Figma Color-Palettes) → `AppColors`**

- `AppColors.waffirGreen01` = `#DCFCE7`
- `AppColors.waffirGreen02` = `#00FF88`
- `AppColors.waffirGreen03` = `#00C531`
- `AppColors.waffirGreen04` = `#0F352D`
- `AppColors.gray01` = `#F2F2F2`
- `AppColors.gray02` = `#CECECE`
- `AppColors.gray03` = `#A3A3A3`
- `AppColors.gray04` = `#595959`
- `AppColors.black` = `#151515`
- `AppColors.white` = `#FFFFFF`
- `AppColors.white40` = `rgba(255,255,255,0.4)`
- `AppColors.indigo` = `#3A2D98`
- `AppColors.red` = `#FF0000`
- `AppColors.goldGradient` = `#FFD900 → #FF9A03`

**Theme mapping (preferred in UI)**
- `Theme.of(context).colorScheme.primary` (Waffir green 04)
- `Theme.of(context).colorScheme.secondary` (Waffir green 02)
- `Theme.of(context).colorScheme.tertiary` (Indigo)
- `Theme.of(context).colorScheme.error` (Red)

### Testing Responsive Layouts

```bash
# Test on different screen sizes
flutter run -d chrome  # Desktop browser (can resize)
flutter run -d macos   # Desktop
flutter run -d iphone  # Mobile

# In Chrome DevTools: Toggle device toolbar to test various sizes
```

**File Location**: `lib/core/utils/responsive_helper.dart`

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

- **dev** - Development (`.env.dev`, `net.waffir.app.dev`)
- **staging** - Staging (`.env.staging`, `net.waffir.app.staging`)
- **production** - Production (`.env.production`, `net.waffir.app`)

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

- **AGENTS.md / CLAUDE.md** - AI assistance guide (this file)
- **FIREBASE_SETUP.md** - Firebase configuration instructions
- **requirements.md** - Original project requirements
- **scripts/README.md** - Deployment scripts documentation
- **README.md** - Minimal (needs expansion)