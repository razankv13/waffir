# Flutter Production-Ready Template Generation Prompt

## Project Overview
Create a comprehensive, production-ready Flutter template application that serves as a starting point for new projects. The template should implement clean architecture principles, be highly scalable, and include all modern Flutter best practices with the latest stable versions of packages.

## Core Requirements

### 1. Project Structure
Create a scalable folder structure following clean architecture:
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_constants.dart
│   │   ├── app_spacing.dart
│   │   └── app_typography.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── string_extensions.dart
│   │   └── datetime_extensions.dart
│   ├── themes/
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── logger.dart
│   └── widgets/
│       ├── animations/
│       ├── buttons/
│       ├── dialogs/
│       ├── loaders/
│       └── snackbars/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── home/
│   └── settings/
├── l10n/
│   ├── en-US.json
│   ├── es-ES.json
│   └── fr-FR.json
├── router/
│   ├── app_router.dart
│   └── route_guards.dart
└── main.dart
```

### 2. Dependencies (pubspec.yaml)
Include these packages with their latest stable versions:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Code Generation
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  
  # Navigation
  go_router: ^14.2.0
  
  # UI/Theming
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  
  # Localization
  easy_localization: ^3.0.7
  
  # Backend/Database
  supabase_flutter: ^2.5.6
  
  # Local Storage
  hive_ce: ^2.6.0
  hive_ce_flutter: ^2.1.0
  flutter_secure_storage: ^9.2.2
  
  # Network & Images
  cached_network_image: ^3.3.1
  dio: ^5.4.3
  connectivity_plus: ^6.0.3
  
  # Permissions
  permission_handler: ^11.3.1
  
  # Additional Firebase Dependencies
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.0
  flutter_svg: ^2.0.10
  image_picker: ^1.1.2
  share_plus: ^9.0.0
  url_launcher: ^6.2.6
  path_provider: ^2.1.3
  package_info_plus: ^8.0.0
  device_info_plus: ^10.1.0
  
  # Forms & Validation
  flutter_form_builder: ^9.3.0
  form_builder_validators: ^9.1.0
  
  # Error Handling & Logging
  flutter_dotenv: ^5.1.0
  logger: ^2.3.0
  sentry_flutter: ^8.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
  hive_ce_generator: ^1.6.0
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.4.0
```

### 3. Core Features to Implement

#### A. Authentication System
- Create a complete auth flow with login, register, forgot password screens
- Implement auth state management with Riverpod
- Use Freezed for auth models (User, AuthState, etc.)
- Include biometric authentication support
- Implement secure token storage using flutter_secure_storage

#### B. Theme System
- Implement Material 3 (Material You) design system
- Create light and dark themes with smooth transitions
- Use native Theme.of(context) for all theming
- Include theme persistence in Hive
- Implement dynamic color support (Material You)
- Create a theme provider with Riverpod

#### C. Localization Setup
- Configure easy_localization with at least 3 languages
- Create translation files structure
- Implement language switcher in settings
- Add RTL support for Arabic (optional example)
- Create localization provider

#### D. Routing System with Go Router
```dart
// Implement protected routes, deep linking, and navigation guards
// Include redirect logic for auth state
// Setup shell routes for bottom navigation
// Implement route transitions and animations
```

#### E. Custom Widgets

**Custom Dialog System:**
- Create reusable dialog widgets with animations
- Success, Error, Confirmation, and Info dialogs
- Use flutter_animate for smooth animations
- Include backdrop blur effects
- Support for custom content

**Custom Snackbar System:**
- Create themed snackbar utilities
- Success, Error, Warning, Info variants
- Support for actions and icons
- Queue management for multiple snackbars
- Swipe to dismiss functionality

**Loading Indicators:**
- Custom circular progress indicators
- Skeleton loaders with shimmer effect
- Full-screen loading overlays
- Pull-to-refresh indicators

#### F. Network Layer
- Create Dio interceptors for auth tokens
- Implement retry logic with exponential backoff
- Add request/response logging in debug mode
- Create base API client class
- Implement offline mode detection
- Cache management with cached_network_image

#### G. Local Storage Setup
- Initialize Hive with encryption
- Create type adapters for custom models
- Implement repository pattern for local data
- Create settings storage service
- Implement secure storage for sensitive data

#### H. Supabase Integration
- Initialize Supabase client
- Create auth service with Supabase Auth
- Implement real-time listeners setup
- Create base repository for Supabase operations
- Include error handling and retry logic

#### I. Permission Handling
- Create permission service wrapper
- Implement permission request flows
- Add rationale dialogs for permissions
- Create settings redirect for denied permissions

### 4. Additional Features to Include

#### A. Form Handling
- Create reusable form fields with validation
- Implement form state management
- Add custom validators
- Include password strength indicator
- Create date/time pickers

#### B. Error Handling
- Global error handler
- Custom error widgets
- Sentry integration for production
- Network error handling
- User-friendly error messages

#### C. Developer Tools
- Debug drawer with:
  - Environment switcher
  - Feature flags
  - Cache clear options
  - Log viewer
  - Performance metrics

#### D. App Configuration
- Environment configuration (.env files)
- Build flavors (dev, staging, production)
- App icons and splash screen setup
- Deep linking configuration

#### E. Testing Structure
```
test/
├── unit/
├── widget/
└── integration/
```

### 5. Sample Screens to Include

1. **Onboarding Flow**
   - Welcome screens with animations
   - Feature highlights
   - Permission requests

2. **Authentication**
   - Login screen
   - Registration screen
   - Forgot password screen
   - OTP verification screen

3. **Home Dashboard**
   - Bottom navigation with 4 tabs
   - Drawer menu
   - Search functionality
   - Pull to refresh

4. **Profile/Settings**
   - User profile edit
   - Theme switcher
   - Language selector
   - Notification settings
   - Privacy settings
   - About page

5. **Sample List Screen**
   - Infinite scroll pagination
   - Search and filters
   - Empty state
   - Error state
   - Loading state

### 6. Code Generation Setup

Create build.yaml configuration and implement:
- Freezed models generation
- Riverpod providers generation
- JSON serialization
- Hive adapters generation

### 7. State Management Patterns

Implement these Riverpod patterns:
- AsyncNotifierProvider for async operations
- StateNotifierProvider for complex state
- FutureProvider for one-time fetches
- StreamProvider for real-time data
- Provider for computed values

### 8. Performance Optimizations

- Implement lazy loading for routes
- Use const constructors wherever possible
- Implement image caching strategies
- Add widget keys for performance
- Use ListView.builder for long lists
- Implement debouncing for search

### 9. Security Considerations

- Implement certificate pinning for API calls
- Secure storage for sensitive data
- Obfuscation configuration
- Implement app integrity checks
- Add jailbreak/root detection

### 10. Documentation

Create comprehensive documentation including:
- README.md with setup instructions
- Architecture documentation
- Code style guide
- Contributing guidelines
- API documentation
- State management patterns guide

## Implementation Instructions

1. Start by creating the project structure and installing all dependencies
2. Set up the theme system and ensure Material 3 compliance
3. Implement the routing system with proper guards
4. Create the authentication flow with firebase
5. Set up localization with at least 3 languages
6. Implement all custom widgets with animations
7. Create the network layer with proper error handling
8. Set up local storage with Hive
9. Implement all sample screens
10. Add comprehensive error handling
11. Create development tools and debug features
12. Write documentation

## Code Quality Requirements

- Follow Flutter best practices and lint rules
- Use consistent naming conventions
- Implement proper error handling
- Add meaningful comments for complex logic
- Create reusable components
- Implement proper separation of concerns
- Use dependency injection patterns
- Follow SOLID principles

## Testing Requirements

- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows
- Minimum 70% code coverage
- Mock services for testing

## Performance Targets

- App launch time < 2 seconds
- Smooth 60 FPS animations
- Memory usage < 150MB for normal usage
- Efficient battery usage
- Minimal network requests

Please generate this complete template with all the specified features, ensuring the code is production-ready, well-documented, and follows Flutter best practices. The template should be immediately usable for starting new projects with minimal modifications needed.