# Important Notes & Guidelines

## Critical Rules

### 1. Theme System ⚠️ MOST IMPORTANT
**ALWAYS use `Theme.of(context)` to access colors and styles**
- **NEVER** directly import or use `AppColors` in widget files
- Ensures proper light/dark mode support and Material 3 consistency
- **SEE:** `ui_ux_guidelines_and_widgets` memory for complete widget library

```dart
// ❌ WRONG
import 'package:waffir/core/themes/app_colors.dart';
final color = AppColors.primary;

// ✅ CORRECT
final color = Theme.of(context).colorScheme.primary;
final textStyle = Theme.of(context).textTheme.bodyLarge;
```

### 2. Check Existing Widgets BEFORE Creating New Ones
**Comprehensive widget library available:**
- `lib/core/widgets/products/` - 7 product widgets (card, grid, badges, ratings, prices, size selector, image gallery)
- `lib/core/widgets/search/` - 2 search widgets (search bar, category chips)
- `lib/core/widgets/cart/` - 2 cart widgets (cart button, cart item card)
- `lib/core/widgets/buttons/` - AppButton with multiple variants
- See `ui_ux_guidelines_and_widgets` memory for complete documentation

### 3. Current Design System (Updated 2025)
**Primary Color:** Mint Green (#00D9A3) - Changed from blue
**Secondary Color:** Indigo (#6366F1)
**E-Commerce Colors:**
- Sale Red: #FF3B30
- NEW Badge: #5856D6
- Rating Gold: #FBBF24
- See `ui_ux_guidelines_and_widgets` memory for complete palette

### 4. Flavors Required
- Always use flavors when running the app
- Default `flutter run` uses production flavor
- Use `--flavor dev -t lib/main_dev.dart` for development

### 5. Firebase is DISABLED
- Infrastructure exists but initialization is **commented out by default**
- All services are ready but not active
- To enable: Uncomment initialization code in `lib/core/services/firebase_service.dart`

### 6. Services Status
**✅ Fully Initialized and Working:**
- Supabase (backend, auth, database, storage)
- RevenueCat (in-app purchases)
- AdMob (ads with GDPR/CCPA compliance)
- Hive (encrypted local storage)
- Microsoft Clarity (analytics)

**⚠️ Disabled:**
- Firebase (all services commented out)

## Code Generation

**MUST run after modifying:**
- Freezed classes (`@freezed`)
- JSON serializable classes (`@JsonSerializable`)
- Riverpod providers with annotations
- Hive type adapters
- Assets (images, icons)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

- **Limited coverage**: Only 9 example test files exist
- Tests provide patterns for expansion
- Critical areas need more coverage before production
- Test files in:
  - `test/unit/` - Unit tests
  - `test/widget/` - Widget tests
  - `test/integration/` - Integration tests
  - `test/utils/` - Test utilities and mocks

## Feature Implementation Status

| Feature | Status | Notes |
|---------|--------|-------|
| Auth | ✅ Complete | Full clean architecture |
| Home | ✅ Complete | Full clean architecture |
| Settings | ✅ Complete | Full clean architecture |
| Subscription | ✅ Complete | Full clean architecture |
| Products | 🚧 In Progress | Domain layer complete, presentation pending |
| Onboarding | ⚠️ Partial | Presentation layer only |
| Profile | ⚠️ Partial | Presentation layer only |
| Sample | ⚠️ Simplified | Example feature |

## Assets

**Empty directories** - No placeholder images/icons included:
- `assets/images/` - Empty
- `assets/icons/` - Empty
- `assets/translations/` - Contains 3 language files (en, es, fr)

**Access via flutter_gen:**
```dart
Assets.images.appIcon  // Auto-generated
Assets.icons.menu
```

## Known Limitations

1. **Firebase disabled** - Requires manual activation
2. **Minimal test coverage** - Only 9 example test files
3. **Empty asset directories** - No placeholder images/icons
4. **Minimal main README** - Needs expansion for public use
5. **Limited Riverpod code generation** - Most providers manually defined

## Import Rules

- **Always** use absolute imports from package root
- **Never** use relative imports from `lib/`
- Enforced by linter: `always_use_package_imports: true`

```dart
// ✅ CORRECT
import 'package:waffir/core/themes/app_theme.dart';

// ❌ WRONG
import '../../../core/themes/app_theme.dart';
```

## Extension Methods

Useful extensions in `lib/core/extensions/`:

**ContextExtensions:**
- Theme shortcuts
- Navigation helpers
- MediaQuery utilities
- Dialog and snackbar helpers

**StringExtensions:**
- Validation helpers
- Formatting utilities
- Capitalization

**DateTimeExtensions:**
- Human-readable formatting
- Relative time
- Date comparisons

## Deployment Scripts

Production-ready scripts in `scripts/`:
- `deploy.sh` - Comprehensive CI/CD
- `config.sh` - Environment configuration
- `create_app_store_connect.sh` - App Store setup
- `setup_app_store_upload.sh` - Upload preparation

See `scripts/README.md` for details.

## Performance Considerations

- Use `const` constructors wherever possible
- Prefer `ListView.builder` over `ListView` for long lists
- Use `cached_network_image` for network images
- Implement proper widget keys for list items
- Profile before optimizing

## Riverpod Patterns

- Mostly **manual providers** (limited code generation)
- `AsyncNotifier<T>` for complex async state
- `StreamProvider` for real-time updates
- `Provider` for dependencies and computed values
- Family providers for parameterized state

## Clean Architecture Guidelines

**Domain Layer:**
- Pure Dart, no Flutter dependencies
- Abstract repository interfaces
- Immutable entities (Freezed)

**Data Layer:**
- Repository implementations
- External service integrations
- Exception handling
- Conversion between models and entities

**Presentation Layer:**
- Flutter widgets
- State management (Riverpod)
- UI logic only
- No business logic

## Widget Creation Best Practices

1. **Check existing widgets first** - See `ui_ux_guidelines_and_widgets` memory
2. **Use const constructors** - Better performance
3. **Access theme properly** - Always `Theme.of(context)`
4. **Add documentation** - Use /// for public APIs
5. **Test both themes** - Light and dark mode