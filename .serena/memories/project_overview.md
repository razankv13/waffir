# Project Overview

## Project Name
Waffir (Flutter Template)

## Purpose
A production-ready Flutter template with clean architecture, Supabase backend, RevenueCat subscriptions, Google AdMob monetization, multi-flavor environments, and comprehensive service integrations.

## Tech Stack

### Framework & Language
- **Flutter** (SDK: ^3.9.0)
- **Dart** (^3.9.0)
- Multi-platform support: iOS, Android, Web, macOS, Windows, Linux

### State Management
- **Riverpod** - Primary state management solution
- `flutter_riverpod` - Core Riverpod package
- `riverpod_annotation` - Code generation support
- Manual providers predominantly used (limited code generation)
- `AsyncNotifier<T>` for complex async state
- `StreamProvider` for real-time updates

### Navigation
- **GoRouter** (^16.2.1) - Declarative routing
- Route guards for authentication
- Shell routes for persistent navigation
- Named routes configuration

### Backend & Database
- **Supabase Flutter** (^2.5.6) - Primary backend (✅ Fully initialized)
  - Authentication, database, storage
  - Configured via environment variables
- **Firebase** (Multiple packages) - ⚠️ **DISABLED BY DEFAULT**
  - Infrastructure ready but initialization commented out
  - Core, Auth, Firestore, Storage, Messaging, Analytics, Crashlytics, Remote Config, Performance

### Local Storage
- **Hive CE** (^2.6.0) - Encrypted local database
- **flutter_secure_storage** (^9.2.2) - Encryption key storage
- Auto-generated type adapters

### Monetization & Analytics
- **RevenueCat** (`purchases_flutter` ^9.4.0) - ✅ In-app purchases and subscriptions
- **Google Mobile Ads** (^5.1.0) - ✅ AdMob integration with GDPR/CCPA support
- **Microsoft Clarity** (`clarity_flutter` ^1.4.2) - ✅ User behavior analytics
- **Sentry** (`sentry_flutter` ^9.6.0) - Crash reporting (optional)

### Code Generation
- **Freezed** (^3.2.0) - Immutable models and union types
- **json_serializable** (^6.8.0) - JSON serialization
- **build_runner** (^2.4.11) - Code generation runner
- **flutter_gen_runner** - Asset class generation
- **hive_ce_generator** (^1.6.0) - Hive type adapters

### UI & Theming
- **Material 3** design system
- **google_fonts** (^6.2.1) - Custom fonts
- **flutter_animate** (^4.5.0) - Animations
- **shimmer** (^3.0.0) - Loading skeletons
- Light and dark theme support

### Localization
- **easy_localization** (^3.0.7) - i18n support
- 3 languages: English, Spanish, French
- Translations in `assets/translations/`

### Network & HTTP
- **Dio** (^5.4.3) - HTTP client
- **connectivity_plus** (^6.0.3) - Network status
- Interceptors for auth, retry, logging, connectivity
- **cached_network_image** (^3.3.1) - Image caching

### Multi-Environment
- **flutter_flavorizr** (^2.4.1) - Flavor management
- **flutter_dotenv** (^6.0.0) - Environment variables
- 3 flavors: dev, staging, production

### Testing
- **mocktail** (^1.0.4) - Mocking
- **mockito** (^5.4.4) - Additional mocking
- **golden_toolkit** (^0.15.0) - Golden tests
- **patrol** (^3.12.1) - Integration testing
- **network_image_mock** (^2.1.1) - Network mocking

### Additional Features
- OAuth: Google Sign-In, Sign in with Apple
- Permissions: `permission_handler`, `local_auth` (biometrics)
- Media: `image_picker`, `flutter_svg`, `cached_network_image`
- Utilities: `share_plus`, `url_launcher`, `path_provider`, `package_info_plus`, `device_info_plus`
- Forms: `flutter_form_builder`, `form_builder_validators`
- Logging: `logger` package

## Platform Support
- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows (configured)
- ✅ Linux (configured)