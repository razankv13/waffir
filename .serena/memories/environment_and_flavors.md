# Environment & Flavors

## Flavor System

Uses **flutter_flavorizr** for multi-environment support.

### Available Flavors

1. **dev** - Development
   - App Name: "App (Dev)"
   - Bundle ID: `com.example.fluttertemplate.dev`
   - Environment File: `.env.dev`

2. **staging** - Staging
   - App Name: "App (Staging)"
   - Bundle ID: `com.example.fluttertemplate.staging`
   - Environment File: `.env.staging`

3. **production** - Production
   - App Name: "App"
   - Bundle ID: `com.example.fluttertemplate`
   - Environment File: `.env.production`

### Configuration File

Defined in `flavorizr.yaml` at project root.

### Platform Support

Flavors configured for:
- Android (applicationId)
- iOS (bundleId)
- macOS (bundleId)

### Running with Flavors

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart
```

### Entry Points

- `lib/main_dev.dart` - Dev flavor
- `lib/main_staging.dart` - Staging flavor
- `lib/main_production.dart` - Production flavor
- `lib/main.dart` - Default (production)

### Flavor Access in Code

```dart
import 'package:flutter_template/flavors.dart';

// Current flavor
Flavor currentFlavor = F.appFlavor;

// Flavor name
String flavorName = F.name;  // "dev", "staging", or "production"

// App title
String appTitle = F.title;
```

## Environment Configuration

### Environment Files

- `.env` - Fallback/default
- `.env.dev` - Development environment
- `.env.staging` - Staging environment
- `.env.production` - Production environment
- `.env.example` - Template (not used at runtime)

### Configuration Class

`lib/core/config/environment_config.dart` - Central configuration access

### Key Configuration Variables

**Supabase:**
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

**Firebase:**
- Various Firebase config keys
- **Note:** Firebase is DISABLED by default

**RevenueCat:**
- `REVENUE_CAT_API_KEY`
- Platform-specific keys

**AdMob:**
- `ADMOB_APP_ID_IOS`
- `ADMOB_APP_ID_ANDROID`
- Ad unit IDs for different ad types

**Sentry:**
- `SENTRY_DSN`
- `ENABLE_SENTRY`

**Microsoft Clarity:**
- `CLARITY_PROJECT_ID`

**Feature Flags:**
- `ENABLE_ADS`
- `ENABLE_ANALYTICS`
- Various feature toggles

### Usage in Code

```dart
import 'package:flutter_template/core/config/environment_config.dart';

// Access configuration
final supabaseUrl = EnvironmentConfig.supabaseUrl;
final enableAds = EnvironmentConfig.enableAds;
final currentEnv = EnvironmentConfig.currentEnvironment;
```

### Adding New Environment Variables

1. Add to `.env.example` (documentation)
2. Add to `.env.dev`, `.env.staging`, `.env.production` (with appropriate values)
3. Add getter to `EnvironmentConfig` class
4. Use `EnvironmentConfig.yourVariable` in code

## Initialization Flow

1. Set app flavor (dev/staging/production)
2. Load environment configuration from `.env` files
3. Initialize system configurations (orientation, status bar)
4. Initialize EasyLocalization (i18n)
5. Initialize Supabase
6. Initialize Hive with encryption
7. ~~Initialize Firebase~~ (disabled by default)
8. Initialize RevenueCat
9. Initialize AdMob (if `ENABLE_ADS=true`)
10. Initialize Clarity analytics
11. Initialize Sentry (if `ENABLE_SENTRY=true`)
12. Run app with error zone

## Regenerating Flavors

After modifying `flavorizr.yaml`:

```bash
flutter pub run flutter_flavorizr -f
```

This regenerates:
- Android flavor configurations
- iOS schemes and configurations
- macOS configurations
- Dart flavor files