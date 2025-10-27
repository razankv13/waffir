# Flutter Template - Architecture Documentation

> **Document Purpose**: This comprehensive guide details the architectural patterns, structure, and design principles of this production-ready Flutter template. Designed for LLM-based requirement generation, team onboarding, and architectural understanding.

> **Template Context**: This is a production-ready Flutter application template implementing Clean Architecture with Domain-Driven Design, featuring multi-environment support, complete monetization stack, and enterprise-ready service infrastructure.

---

## 📋 Document Metadata

- **Architecture Pattern**: Clean Architecture (Domain-Driven Design)
- **Organization Pattern**: Feature-First with Core Infrastructure
- **State Management**: Riverpod with AsyncNotifier pattern
- **Navigation**: GoRouter (Navigator 2.0) with route guards
- **Backend Strategy**: Backend-as-a-Service (Supabase primary, Firebase optional)
- **Testing Strategy**: Unit + Widget + Integration (Patrol)
- **Last Updated**: 2025-10-15

---

## 🎯 Architectural Principles

### Core Design Principles

1. **Separation of Concerns**
   - Each layer has clear, distinct responsibilities
   - No business logic in UI
   - No UI dependencies in business logic

2. **Dependency Rule**
   - Dependencies point inward: Presentation → Data → Domain
   - Domain layer is framework-independent
   - Outer layers depend on inner layers, never vice versa

3. **Single Responsibility**
   - Each class, function, and module has one reason to change
   - Controllers manage state only
   - Repositories handle data access only
   - Services handle external integrations only

4. **Open/Closed Principle**
   - Open for extension, closed for modification
   - New features don't require changing existing code
   - Abstract interfaces allow multiple implementations

5. **Interface Segregation**
   - Repositories define minimal interfaces
   - Clients depend on abstractions, not concrete implementations

6. **Dependency Inversion**
   - High-level modules don't depend on low-level modules
   - Both depend on abstractions (repository interfaces)

---

## 🏗️ Clean Architecture Overview

### Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │  Screens   │  │  Widgets   │  │Controllers │            │
│  │    (UI)    │  │ (Reusable) │  │  (State)   │            │
│  └────────────┘  └────────────┘  └────────────┘            │
│                          ↓ depends on ↓                      │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │Repositories│  │  Services  │  │  Providers │            │
│  │   (Impl)   │  │ (External) │  │ (Riverpod) │            │
│  └────────────┘  └────────────┘  └────────────┘            │
│                          ↓ implements ↓                      │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │  Entities  │  │Repositories│  │ Use Cases  │            │
│  │  (Models)  │  │ (Abstract) │  │ (Optional) │            │
│  └────────────┘  └────────────┘  └────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

### Layer Communication Flow

```
User Interaction
       ↓
┌──────────────┐
│     UI       │  Widget builds, user taps button
└──────┬───────┘
       ↓ ref.read()
┌──────────────┐
│  Controller  │  Manages state, calls repository
└──────┬───────┘
       ↓ async call
┌──────────────┐
│  Repository  │  Implements domain interface
└──────┬───────┘
       ↓ uses
┌──────────────┐
│   Service    │  External API, Firebase, Supabase
└──────────────┘
       ↓
External System (API, Database, etc.)
```

---

## 📁 Project Structure

### Complete Directory Tree

```
lib/
├── main.dart                          # 🚀 Production entry point
├── main_dev.dart                      # Development flavor entry
├── main_staging.dart                  # Staging flavor entry
├── main_production.dart               # Production flavor entry
├── flavors.dart                       # Flavor configuration enum
├── firebase_options.dart              # Firebase platform configs
├── hive_registrar.g.dart             # Auto-generated Hive adapters
│
├── gen/                               # 🤖 AUTO-GENERATED ASSETS
│   └── assets.gen.dart                # Type-safe asset classes
│
├── l10n/                              # 🌍 LOCALIZATION
│   └── (empty - using assets/translations)
│
├── core/                              # ⚙️ CORE INFRASTRUCTURE
│   │
│   ├── config/                        # Environment Configuration
│   │   └── environment_config.dart    # Centralized env var access
│   │
│   ├── constants/                     # App Constants
│   │   ├── app_colors.dart           # Color palette (Material 3)
│   │   ├── app_constants.dart        # Global constants
│   │   ├── app_spacing.dart          # Spacing system
│   │   └── app_typography.dart       # Text styles
│   │
│   ├── errors/                        # Error Handling
│   │   ├── exceptions.dart           # Data layer exceptions
│   │   └── failures.dart             # Domain layer failures (Freezed)
│   │
│   ├── extensions/                    # Dart Extensions
│   │   ├── context_extensions.dart   # BuildContext utilities
│   │   ├── string_extensions.dart    # String helpers
│   │   └── datetime_extensions.dart  # DateTime formatting
│   │
│   ├── navigation/                    # 🧭 NAVIGATION
│   │   ├── app_router.dart           # GoRouter configuration
│   │   ├── route_guards.dart         # Auth & subscription guards
│   │   └── routes.dart               # Route path constants
│   │
│   ├── network/                       # 🌐 NETWORKING
│   │   ├── network_service.dart      # Dio HTTP client
│   │   └── interceptors/             # HTTP Interceptors
│   │       ├── auth_interceptor.dart         # Add auth tokens
│   │       ├── retry_interceptor.dart        # Retry failed requests
│   │       ├── logging_interceptor.dart      # Log requests/responses
│   │       └── connectivity_interceptor.dart # Check connectivity
│   │
│   ├── providers/                     # Ad Providers
│   │   └── ad_providers.dart         # AdMob provider definitions
│   │
│   ├── services/                      # 🔥 CORE SERVICES
│   │   ├── firebase_service.dart     # Firebase (⚠️ disabled by default)
│   │   ├── revenue_cat_service.dart  # RevenueCat subscriptions (✅)
│   │   ├── admob_service.dart        # AdMob ads (✅ 25KB!)
│   │   ├── clarity_service.dart      # Microsoft Clarity analytics (✅)
│   │   ├── biometric_service.dart    # Face ID, Touch ID, Fingerprint
│   │   └── auth/                     # Firebase auth wrapper
│   │
│   ├── storage/                       # 💾 LOCAL STORAGE
│   │   ├── hive_service.dart         # Hive with encryption (✅)
│   │   ├── models/                   # Storage models
│   │   │   ├── app_settings.dart     # App settings model
│   │   │   └── hive_user.dart        # Cached user model
│   │   └── adapters/                 # (empty - using hive_registrar)
│   │
│   ├── themes/                        # 🎨 THEMING
│   │   └── app_theme.dart            # Material 3 light/dark themes
│   │
│   ├── utils/                         # 🛠️ UTILITIES
│   │   ├── logger.dart               # Structured logging
│   │   ├── validators.dart           # Form validators
│   │   └── formatters.dart           # Input formatters
│   │
│   └── widgets/                       # 🎭 REUSABLE COMPONENTS
│       ├── ads/                       # Ad Widgets
│       │   ├── ad_banner_widget.dart         # Banner ad component
│       │   └── ad_consent_dialog.dart        # GDPR consent
│       ├── animations/                # Animation widgets
│       ├── buttons/                   # Button Components
│       │   └── app_button.dart        # Primary button (6 variants, 3 sizes)
│       ├── dialogs/                   # Dialog Services
│       │   └── dialog_service.dart    # Centralized dialogs
│       ├── loaders/                   # Loading widgets
│       ├── loading/                   # Loading indicators
│       ├── premium/                   # Premium Features
│       │   └── premium_feature_wrapper.dart  # Paywall wrapper
│       ├── snackbars/                 # Snackbar Services
│       │   └── snackbar_service.dart  # Standardized snackbars
│       └── debug/                     # Debug Tools
│           ├── debug_drawer.dart      # Dev tools drawer
│           └── debug_overlay.dart     # Performance overlay
│
└── features/                          # 📦 FEATURE MODULES
    │
    ├── auth/                          # ✅ AUTHENTICATION (Clean Architecture)
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── user_dto.dart
    │   │   ├── repositories/
    │   │   │   ├── firebase_auth_repository.dart
    │   │   │   └── supabase_auth_repository.dart
    │   │   └── providers/
    │   │       ├── auth_repository_provider.dart
    │   │       └── auth_state_provider.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_model.dart            # Freezed entity
    │   │   └── repositories/
    │   │       └── auth_repository.dart       # Abstract interface
    │   └── presentation/
    │       ├── controllers/
    │       │   └── auth_controller.dart       # AsyncNotifier
    │       ├── screens/
    │       │   ├── login_screen.dart
    │       │   ├── signup_screen.dart
    │       │   ├── forgot_password_screen.dart
    │       │   └── otp_verification_screen.dart
    │       └── widgets/
    │           ├── auth_form.dart
    │           └── social_login_buttons.dart
    │
    ├── home/                          # ✅ HOME (Clean Architecture)
    │   ├── data/
    │   │   ├── models/
    │   │   ├── repositories/
    │   │   └── providers/
    │   ├── domain/
    │   │   ├── entities/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── controllers/
    │       ├── screens/
    │       │   └── home_screen.dart
    │       └── widgets/
    │           ├── home_app_bar.dart
    │           └── dashboard_card.dart
    │
    ├── settings/                      # ✅ SETTINGS (Clean Architecture)
    │   ├── data/
    │   │   ├── models/
    │   │   ├── repositories/
    │   │   │   └── settings_repository.dart
    │   │   └── providers/
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── app_settings.dart
    │   │   └── repositories/
    │   │       └── settings_repository.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── settings_controller.dart
    │       ├── screens/
    │       │   ├── settings_screen.dart
    │       │   ├── theme_settings_screen.dart
    │       │   └── privacy_settings_screen.dart
    │       └── widgets/
    │           └── settings_tile.dart
    │
    ├── subscription/                  # ✅ SUBSCRIPTION (Clean Architecture)
    │   ├── data/
    │   │   ├── models/
    │   │   ├── repositories/
    │   │   │   └── subscription_repository.dart
    │   │   └── providers/
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── customer_info.dart
    │   │   │   ├── subscription_product.dart
    │   │   │   ├── subscription_offering.dart
    │   │   │   └── entitlement.dart
    │   │   └── repositories/
    │   │       └── subscription_repository.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── subscription_controller.dart
    │       ├── screens/
    │       │   ├── paywall_screen.dart
    │       │   └── subscription_management_screen.dart
    │       └── widgets/
    │           ├── pricing_card.dart
    │           └── subscription_status.dart
    │
    ├── onboarding/                    # ⚠️ ONBOARDING (Presentation Only)
    │   └── presentation/
    │       ├── screens/
    │       │   ├── splash_screen.dart
    │       │   └── onboarding_screen.dart
    │       └── widgets/
    │           └── onboarding_page.dart
    │
    ├── profile/                       # ⚠️ PROFILE (Presentation Only)
    │   └── presentation/
    │       ├── screens/
    │       │   └── profile_screen.dart
    │       └── widgets/
    │           ├── profile_header.dart
    │           └── profile_menu_item.dart
    │
    └── sample/                        # ⚠️ SAMPLE (Simplified)
        ├── data/
        │   ├── models/
        │   ├── repositories/
        │   └── providers/
        ├── domain/
        │   ├── entities/
        │   └── repositories/
        └── presentation/
            ├── screens/
            └── widgets/
```

### Directory Purpose Summary

| Directory | Purpose | Layer | Status |
|-----------|---------|-------|--------|
| `lib/core/` | Shared infrastructure | All | Complete |
| `lib/features/` | Feature modules | All | Mixed |
| `lib/gen/` | Auto-generated code | N/A | Generated |
| `lib/core/config/` | Environment config | Core | Complete |
| `lib/core/services/` | External integrations | Data | Complete |
| `lib/core/widgets/` | Reusable UI | Presentation | Complete |
| `lib/core/navigation/` | Routing logic | Presentation | Complete |

---

## 🎨 Layer Detailed Design

## 1. Domain Layer (`features/*/domain/`)

### Purpose
Contains business logic and entities. Framework-independent, no Flutter dependencies.

### Components

#### Entities
Immutable business objects using Freezed.

```dart
// domain/entities/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

**Characteristics**:
- Immutable (Freezed)
- No external dependencies
- Business-focused (not tied to database schema)
- JSON serialization for data transfer
- CopyWith for updates

#### Repository Interfaces
Abstract contracts defining data operations.

```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  /// Stream of authentication state changes
  Stream<UserModel?> authStateChanges();

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Delete user account
  Future<void> deleteAccount();
}
```

**Characteristics**:
- Abstract interfaces only
- No implementation details
- Business operation focused
- Returns domain entities
- Throws domain Failures

#### Use Cases (Optional, not heavily used)
Single-purpose business operations.

```dart
// domain/use_cases/sign_in_use_case.dart
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<UserModel> execute({
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (email.isEmpty || password.isEmpty) {
      throw const Failure.validation('Email and password required');
    }

    // Delegate to repository
    return await _authRepository.signIn(
      email: email,
      password: password,
    );
  }
}
```

### Domain Layer Rules
✅ **Allowed**:
- Pure Dart code
- Freezed entities
- Abstract interfaces
- Business logic validation
- Domain-specific exceptions (Failures)

❌ **Not Allowed**:
- Flutter dependencies
- External package dependencies (except Freezed)
- UI logic
- Data fetching logic
- Service implementations

---

## 2. Data Layer (`features/*/data/`)

### Purpose
Implements domain interfaces with actual data sources and external services.

### Components

#### Models (DTOs)
Data transfer objects for external APIs.

```dart
// data/models/user_dto.dart
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoX on UserDto {
  /// Convert DTO to domain entity
  UserModel toDomain() {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}

extension UserModelX on UserModel {
  /// Convert domain entity to DTO
  UserDto toDto() {
    return UserDto(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}
```

#### Repository Implementations
Concrete implementations of domain repository interfaces.

```dart
// data/repositories/firebase_auth_repository.dart
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _logger = logger ?? Logger();

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const Failure.authentication('Sign in failed');
      }

      _logger.i('User signed in: ${user.uid}');

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase auth error: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected sign in error', e, stackTrace);
      throw Failure.unknown(e.toString());
    }
  }

  // Error handling
  Failure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        return const Failure.authentication('Invalid email or password');
      case 'user-disabled':
        return const Failure.authentication('Account has been disabled');
      case 'too-many-requests':
        return const Failure.authentication('Too many attempts. Try again later');
      default:
        return Failure.authentication(e.message ?? 'Authentication failed');
    }
  }

  // ... other methods
}
```

**Repository Responsibilities**:
- Implement domain repository interfaces
- Handle data source operations
- Convert DTOs to domain entities
- Transform exceptions to failures
- Log operations
- Handle edge cases

#### Providers (Riverpod)
Dependency injection definitions.

```dart
// data/providers/auth_repository_provider.dart

/// Repository provider (singleton)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Can switch implementations based on flavor or config
  if (EnvironmentConfig.useSupabase) {
    return SupabaseAuthRepository();
  }
  return FirebaseAuthRepository();
});

/// Auth state stream provider
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

/// Current user provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUser();
});
```

### Data Layer Rules
✅ **Allowed**:
- External service integrations
- API calls (Dio, HTTP)
- Database operations (Hive, Firebase, Supabase)
- DTOs with JSON serialization
- Exception to Failure conversion
- Logging
- Caching

❌ **Not Allowed**:
- UI widgets
- BuildContext usage
- Direct state management (use controllers)
- Business logic (belongs in domain)

---

## 3. Presentation Layer (`features/*/presentation/`)

### Purpose
User interface, user interaction, and state management.

### Components

#### Controllers (State Management)
Riverpod AsyncNotifier for state management.

```dart
// presentation/controllers/auth_controller.dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated({
    required UserModel user,
  }) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(String message) = Error;
}

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  Future<AuthState> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    // Listen to auth state changes
    ref.listen(authStateProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            state = AsyncValue.data(AuthState.authenticated(user: user));
          } else {
            state = const AsyncValue.data(AuthState.unauthenticated());
          }
        },
        error: (error, stack) {
          state = AsyncValue.data(
            AuthState.error(error.toString()),
          );
        },
        loading: () {
          state = const AsyncValue.data(AuthState.loading());
        },
      );
    });

    // Return initial state based on current user
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      return AuthState.authenticated(user: user);
    }
    return const AuthState.unauthenticated();
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      return AuthState.authenticated(user: user);
    });
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      return AuthState.authenticated(user: user);
    });
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
      return const AuthState.unauthenticated();
    });
  }
}

/// Controller provider
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});
```

**Controller Responsibilities**:
- Manage UI state
- Call repository methods
- Handle loading states
- Transform errors for UI
- Coordinate multiple repositories
- Business workflow orchestration

#### Screens (Full-Page UI)
Complete screens with scaffold, app bar, body.

```dart
// presentation/screens/login_screen.dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    await controller.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Handle navigation based on state
    if (mounted) {
      final state = ref.read(authControllerProvider);
      state.when(
        data: (authState) {
          authState.when(
            authenticated: (_) {
              context.go(Routes.home);
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            initial: () {},
            loading: () {},
            unauthenticated: () {},
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Sign in button
                AppButton(
                  label: 'Sign In',
                  onPressed: _handleSignIn,
                  isLoading: authState.isLoading,
                  variant: ButtonVariant.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Widgets (Reusable Components)
Feature-specific reusable widgets.

```dart
// presentation/widgets/social_login_buttons.dart
class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Google Sign-In
        AppButton(
          label: 'Continue with Google',
          icon: Icons.g_mobiledata,
          onPressed: () {
            // Handle Google sign in
          },
          variant: ButtonVariant.outlined,
        ),
        const SizedBox(height: 12),

        // Apple Sign-In
        if (Platform.isIOS)
          AppButton(
            label: 'Continue with Apple',
            icon: Icons.apple,
            onPressed: () {
              // Handle Apple sign in
            },
            variant: ButtonVariant.outlined,
          ),
      ],
    );
  }
}
```

### Presentation Layer Rules
✅ **Allowed**:
- Flutter widgets
- BuildContext usage
- State management (Riverpod)
- Navigation
- UI logic
- Form validation
- User input handling

❌ **Not Allowed**:
- Direct API calls (use repositories)
- Business logic (use domain/controllers)
- Database operations (use repositories)

---

## 🔄 State Management Pattern

### Riverpod AsyncNotifier Pattern

#### Why AsyncNotifier?
- Built-in loading/error/data states
- Automatic error handling
- Type-safe state management
- Easy testing
- Composable providers

#### State Flow

```
┌─────────────┐
│  UI Widget  │
└──────┬──────┘
       │ ref.watch(provider)
       ↓
┌──────────────┐
│   Provider   │ (caches state, notifies listeners)
└──────┬───────┘
       │ notifier.method()
       ↓
┌──────────────┐
│  Controller  │ (AsyncNotifier)
└──────┬───────┘
       │ state = AsyncValue.loading()
       ↓
┌──────────────┐
│  Repository  │
└──────┬───────┘
       │ returns result
       ↓
┌──────────────┐
│  Controller  │ (AsyncNotifier)
└──────┬───────┘
       │ state = AsyncValue.data(result)
       ↓
┌──────────────┐
│   Provider   │ (notifies listeners)
└──────┬───────┘
       │ rebuild
       ↓
┌─────────────┐
│  UI Widget  │ (rebuilds with new state)
└─────────────┘
```

#### State Types

```dart
// Loading state
state = const AsyncValue.loading();

// Success state
state = AsyncValue.data(AuthState.authenticated(user: user));

// Error state
state = AsyncValue.error(error, stackTrace);

// Guard pattern (automatic error handling)
state = await AsyncValue.guard(() async {
  final result = await someAsyncOperation();
  return SuccessState(result);
});
```

#### Consumer Patterns

```dart
// 1. ConsumerWidget - For simple cases
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return state.when(
      data: (data) => Text(data),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

// 2. ConsumerStatefulWidget - For stateful widgets
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProvider);
    // ...
  }
}

// 3. Consumer builder - For specific parts of widget tree
Consumer(
  builder: (context, ref, child) {
    final state = ref.watch(myProvider);
    return Text(state);
  },
)
```

---

## 🧭 Navigation Architecture

### GoRouter Configuration

```dart
// core/navigation/app_router.dart
final goRouter = GoRouter(
  initialLocation: Routes.splash,
  redirect: _handleRedirect,
  routes: [
    // Splash (no auth required)
    GoRoute(
      path: Routes.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Auth routes (no auth required)
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.signup,
      name: RouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),

    // Shell route with persistent bottom navigation (auth required)
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          name: RouteNames.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: Routes.settings,
          name: RouteNames.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // Subscription routes (auth required)
    GoRoute(
      path: Routes.paywall,
      name: RouteNames.paywall,
      builder: (context, state) => const PaywallScreen(),
    ),
    GoRoute(
      path: Routes.subscriptionManagement,
      name: RouteNames.subscriptionManagement,
      builder: (context, state) => const SubscriptionManagementScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);

// Route guard logic
Future<String?> _handleRedirect(
  BuildContext context,
  GoRouterState state,
) async {
  // Get auth state
  final container = ProviderContainer();
  final authState = await container.read(authStateProvider.future);

  final isAuthenticated = authState != null;
  final isOnAuthPage = state.matchedLocation.startsWith('/auth');
  final isOnSplash = state.matchedLocation == Routes.splash;

  // If not authenticated and not on auth page, go to login
  if (!isAuthenticated && !isOnAuthPage && !isOnSplash) {
    return Routes.login;
  }

  // If authenticated and on auth page, go to home
  if (isAuthenticated && isOnAuthPage) {
    return Routes.home;
  }

  // No redirect needed
  return null;
}
```

### Route Guards

```dart
// core/navigation/route_guards.dart
abstract class RouteGuard {
  Future<String?> redirect(BuildContext context, GoRouterState state);
}

class AuthGuard implements RouteGuard {
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final container = ProviderContainer();
    final authState = await container.read(authStateProvider.future);

    if (authState == null) {
      return Routes.login;
    }
    return null;
  }
}

class SubscriptionGuard implements RouteGuard {
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final container = ProviderContainer();
    final customerInfo = await container.read(customerInfoProvider.future);

    if (!customerInfo.entitlements.active.containsKey('premium')) {
      return Routes.paywall;
    }
    return null;
  }
}

class OnboardingGuard implements RouteGuard {
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final container = ProviderContainer();
    final hasCompletedOnboarding = await container.read(
      hasCompletedOnboardingProvider.future,
    );

    if (!hasCompletedOnboarding) {
      return Routes.onboarding;
    }
    return null;
  }
}

class CombinedRouteGuard implements RouteGuard {
  final List<RouteGuard> guards;

  CombinedRouteGuard(this.guards);

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    for (final guard in guards) {
      final redirect = await guard.redirect(context, state);
      if (redirect != null) return redirect;
    }
    return null;
  }
}
```

### Navigation Usage

```dart
// Imperative navigation
context.go(Routes.home);
context.push(Routes.settings);
context.pop();

// Named routes with parameters
context.pushNamed(
  RouteNames.profile,
  pathParameters: {'id': userId},
);

// Query parameters
context.pushNamed(
  RouteNames.search,
  queryParameters: {'q': 'flutter'},
);

// Replace (no back button)
context.replace(Routes.home);

// Go with extra data
context.push(Routes.details, extra: myObject);
```

---

## 🗄️ Data Flow Patterns

### Read Operation Flow

```
┌─────────────┐
│ UI Widget   │ User wants to see data
└──────┬──────┘
       │ ref.watch(dataProvider)
       ↓
┌──────────────┐
│ Controller   │ build() method called
└──────┬───────┘
       │ repository.getData()
       ↓
┌──────────────┐
│ Repository   │ Check cache first
└──────┬───────┘
       │ (cache miss)
       ↓
┌──────────────┐
│ Repository   │ Fetch from network
└──────┬───────┘
       │ service.fetchData()
       ↓
┌──────────────┐
│ Service      │ HTTP request
└──────┬───────┘
       │ returns DTO
       ↓
┌──────────────┐
│ Repository   │ Convert DTO to Entity
└──────┬───────┘
       │ Save to cache
       ↓
┌──────────────┐
│ Repository   │ Return entity
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Controller   │ Update state
└──────┬───────┘
       │ state = AsyncValue.data(entity)
       ↓
┌──────────────┐
│ Provider     │ Notify listeners
└──────┬───────┘
       │
       ↓
┌─────────────┐
│ UI Widget   │ Rebuild with data
└─────────────┘
```

### Write Operation Flow

```
┌─────────────┐
│ UI Widget   │ User taps save button
└──────┬──────┘
       │ controller.saveData(data)
       ↓
┌──────────────┐
│ Controller   │ state = AsyncValue.loading()
└──────┬───────┘
       │ repository.saveData(data)
       ↓
┌──────────────┐
│ Repository   │ Validate business rules
└──────┬───────┘
       │ (validation passed)
       ↓
┌──────────────┐
│ Repository   │ Convert entity to DTO
└──────┬───────┘
       │ service.saveData(dto)
       ↓
┌──────────────┐
│ Service      │ HTTP POST/PUT request
└──────┬───────┘
       │ returns updated DTO
       ↓
┌──────────────┐
│ Repository   │ Convert DTO to entity
└──────┬───────┘
       │ Update cache
       ↓
┌──────────────┐
│ Repository   │ Return updated entity
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Controller   │ state = AsyncValue.data(entity)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Provider     │ Notify all listeners
└──────┬───────┘
       │
       ↓
┌─────────────┐
│ All Widgets │ Rebuild with updated data
└─────────────┘
```

### Error Handling Flow

```
Service throws Exception
       ↓
Repository catches exception
       ↓
Repository logs error
       ↓
Repository transforms to Failure
       ↓
Controller receives Failure
       ↓
Controller updates state:
  state = AsyncValue.error(failure, stackTrace)
       ↓
Provider notifies listeners
       ↓
UI Widget rebuilds
       ↓
.when(error: (error, stack) => ErrorWidget())
```

---

## 🛡️ Error Handling Architecture

### Error Types Hierarchy

```dart
// Domain Layer - Failures (Freezed)
@freezed
class Failure with _$Failure {
  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.cache([String? message]) = CacheFailure;
  const factory Failure.authentication([String? message]) = AuthenticationFailure;
  const factory Failure.authorization([String? message]) = AuthorizationFailure;
  const factory Failure.validation([String? message]) = ValidationFailure;
  const factory Failure.notFound([String? message]) = NotFoundFailure;
  const factory Failure.conflict([String? message]) = ConflictFailure;
  const factory Failure.unknown([String? message]) = UnknownFailure;
}

// Data Layer - Exceptions
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}
```

### Error Transformation Pattern

```dart
// Repository converts exceptions to failures
Future<UserModel> getUser(String id) async {
  try {
    final dto = await _apiService.getUser(id);
    return dto.toDomain();
  } on NetworkException catch (e) {
    _logger.e('Network error', e);
    throw Failure.network(e.message);
  } on ServerException catch (e) {
    _logger.e('Server error', e);
    if (e.statusCode == 401) {
      throw const Failure.authentication('Session expired');
    } else if (e.statusCode == 404) {
      throw const Failure.notFound('User not found');
    }
    throw Failure.server(e.message);
  } on CacheException catch (e) {
    _logger.e('Cache error', e);
    throw Failure.cache(e.message);
  } catch (e, stackTrace) {
    _logger.e('Unexpected error', e, stackTrace);
    throw Failure.unknown(e.toString());
  }
}
```

### UI Error Display

```dart
// In widget
final state = ref.watch(userProvider(userId));

state.when(
  data: (user) => UserProfile(user: user),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) {
    if (error is Failure) {
      return error.when(
        network: (message) => ErrorView(
          message: 'No internet connection',
          onRetry: () => ref.refresh(userProvider(userId)),
        ),
        server: (message) => ErrorView(
          message: 'Server error. Please try again.',
          onRetry: () => ref.refresh(userProvider(userId)),
        ),
        authentication: (message) => ErrorView(
          message: 'Please sign in again',
          onRetry: () => context.go(Routes.login),
        ),
        notFound: (message) => const ErrorView(
          message: 'User not found',
        ),
        // ... other error types
        unknown: (message) => ErrorView(
          message: 'Something went wrong',
          onRetry: () => ref.refresh(userProvider(userId)),
        ),
      );
    }
    return ErrorView(message: error.toString());
  },
);
```

---

## 🌍 Multi-Environment Architecture

### Flavor System

```dart
// flavors.dart
enum Flavor {
  dev,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'App (Dev)';
      case Flavor.staging:
        return 'App (Staging)';
      case Flavor.production:
        return 'App';
      default:
        return 'App';
    }
  }

  static bool get isDevelopment => appFlavor == Flavor.dev;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProduction => appFlavor == Flavor.production;
}
```

### Environment Configuration

```dart
// core/config/environment_config.dart
class EnvironmentConfig {
  static late DotEnv _env;

  /// Initialize with specific environment
  static Future<void> initialize(Flavor flavor) async {
    final fileName = _getEnvFileName(flavor);
    _env = DotEnv();
    await _env.load(fileName: fileName);
  }

  static String _getEnvFileName(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return '.env.dev';
      case Flavor.staging:
        return '.env.staging';
      case Flavor.production:
        return '.env.production';
    }
  }

  // Supabase
  static String get supabaseUrl =>
      _env.get('SUPABASE_URL', fallback: '');

  static String get supabaseAnonKey =>
      _env.get('SUPABASE_ANON_KEY', fallback: '');

  // Firebase
  static bool get enableFirebase =>
      _env.getBool('ENABLE_FIREBASE', fallback: false);

  // RevenueCat
  static String get revenueCatApiKeyIOS =>
      _env.get('REVENUE_CAT_API_KEY_IOS', fallback: '');

  static String get revenueCatApiKeyAndroid =>
      _env.get('REVENUE_CAT_API_KEY_ANDROID', fallback: '');

  // AdMob
  static bool get enableAds =>
      _env.getBool('ENABLE_ADS', fallback: true);

  static String get adMobAppIdIOS =>
      _env.get('ADMOB_APP_ID_IOS', fallback: '');

  static String get adMobAppIdAndroid =>
      _env.get('ADMOB_APP_ID_ANDROID', fallback: '');

  // Sentry
  static String get sentryDsn =>
      _env.get('SENTRY_DSN', fallback: '');

  // Clarity
  static String get clarityProjectId =>
      _env.get('CLARITY_PROJECT_ID', fallback: '');

  // Feature Flags
  static bool get enableAnalytics =>
      _env.getBool('ENABLE_ANALYTICS', fallback: true);

  static bool get enableCrashReporting =>
      _env.getBool('ENABLE_CRASH_REPORTING', fallback: true);

  // Environment info
  static String get currentEnvironment => F.name;

  static bool get isDebugMode => !F.isProduction;
}
```

### Environment Files

```bash
# .env.dev
ENVIRONMENT=development
SUPABASE_URL=https://dev.supabase.co
SUPABASE_ANON_KEY=dev_key
ENABLE_FIREBASE=false
ENABLE_ADS=false
ENABLE_ANALYTICS=false
LOG_LEVEL=debug

# .env.staging
ENVIRONMENT=staging
SUPABASE_URL=https://staging.supabase.co
SUPABASE_ANON_KEY=staging_key
ENABLE_FIREBASE=false
ENABLE_ADS=true
ENABLE_ANALYTICS=true
LOG_LEVEL=info

# .env.production
ENVIRONMENT=production
SUPABASE_URL=https://prod.supabase.co
SUPABASE_ANON_KEY=prod_key
ENABLE_FIREBASE=false
ENABLE_ADS=true
ENABLE_ANALYTICS=true
SENTRY_DSN=https://sentry.io/project
LOG_LEVEL=warning
```

---

## 🧪 Testing Architecture

### Testing Pyramid

```
      /\
     /  \      E2E Tests (Patrol)
    /    \     - Critical user flows
   /──────\    - Happy paths
  /        \
 /  Widget  \   Widget Tests
/   Tests    \  - UI components
/────────────\  - Visual regression (Golden)
/              \
/   Unit Tests  \ Unit Tests
/                \ - Business logic
/──────────────────\ - Repositories
                     - Controllers
```

### Test Organization

```
test/
├── unit/                              # Unit Tests
│   ├── features/
│   │   ├── auth/
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   │       └── user_model_test.dart
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_test.dart
│   │   │   └── presentation/
│   │   │       └── controllers/
│   │   │           └── auth_controller_test.dart
│   │   └── ...
│   └── core/
│       ├── utils/
│       │   ├── validators_test.dart
│       │   └── logger_test.dart
│       └── config/
│           └── environment_config_test.dart
│
├── widget/                            # Widget Tests
│   ├── core/
│   │   └── widgets/
│   │       └── buttons/
│   │           └── app_button_test.dart
│   └── features/
│       └── auth/
│           └── screens/
│               └── login_screen_test.dart
│
├── integration/                       # Integration Tests (Patrol)
│   ├── auth_flow_test.dart
│   ├── subscription_flow_test.dart
│   └── home_navigation_test.dart
│
├── helpers/                           # Test Utilities
│   ├── test_config.dart              # Test configuration
│   ├── test_helpers.dart             # Helper functions
│   ├── mock_services.dart            # Service mocks
│   └── mock_providers.dart           # Provider overrides
│
└── fixtures/                          # Test Data
    ├── user_fixture.dart
    └── json/
        └── user_response.json
```

### Unit Test Pattern

```dart
// test/unit/features/auth/presentation/controllers/auth_controller_test.dart
void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController', () {
    test('initial state should be initial', () async {
      final controller = container.read(authControllerProvider);

      expect(
        controller.value,
        const AuthState.initial(),
      );
    });

    test('signIn success should update state to authenticated', () async {
      // Arrange
      final user = UserModel(
        id: '1',
        email: 'test@test.com',
        displayName: 'Test User',
      );

      when(() => mockAuthRepository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => user);

      // Act
      final controller = container.read(authControllerProvider.notifier);
      await controller.signIn(
        email: 'test@test.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authControllerProvider);
      expect(state.hasValue, true);
      expect(
        state.value,
        AuthState.authenticated(user: user),
      );

      verify(() => mockAuthRepository.signIn(
            email: 'test@test.com',
            password: 'password123',
          )).called(1);
    });

    test('signIn failure should update state to error', () async {
      // Arrange
      when(() => mockAuthRepository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const Failure.authentication('Invalid credentials'));

      // Act
      final controller = container.read(authControllerProvider.notifier);
      await controller.signIn(
        email: 'test@test.com',
        password: 'wrong',
      );

      // Assert
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
    });
  });
}
```

### Widget Test Pattern

```dart
// test/widget/core/widgets/buttons/app_button_test.dart
void main() {
  testWidgets('AppButton displays label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('AppButton calls onPressed when tapped', (tester) async {
    var wasCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Test',
            onPressed: () => wasCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(wasCalled, true);
  });

  testWidgets('AppButton shows loading indicator when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Test',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Test'), findsNothing);
  });
}
```

### Integration Test Pattern (Patrol)

```dart
// test/integration/auth_flow_test.dart
void main() {
  patrolTest('Complete authentication flow', (tester) async {
    // Launch app
    await tester.pumpWidgetAndSettle(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for splash screen to finish
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Should be on login screen
    expect(find.text('Sign In'), findsOneWidget);

    // Enter credentials
    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'password123',
    );

    // Tap sign in button
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Should navigate to home screen
    expect(find.text('Home'), findsOneWidget);

    // Tap profile tab
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Should show profile screen
    expect(find.text('Profile'), findsOneWidget);

    // Tap sign out
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    // Should return to login
    expect(find.text('Sign In'), findsOneWidget);
  });

  patrolTest('Sign in with invalid credentials shows error',
      (tester) async {
    await tester.pumpWidgetAndSettle(
      ProviderScope(child: MyApp()),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.enterText(
      find.byType(TextFormField).first,
      'wrong@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'wrongpass',
    );

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Should show error message
    expect(find.text('Invalid email or password'), findsOneWidget);
  });
}
```

---

## 🔌 Dependency Injection

### Provider Hierarchy

```dart
// Service providers (singletons)
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService.instance;
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService.instance;
});

final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

final adMobServiceProvider = Provider<AdMobService>((ref) {
  return AdMobService.instance;
});

// Repository providers (depend on services)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (EnvironmentConfig.useSupabase) {
    final supabase = ref.watch(supabaseProvider);
    return SupabaseAuthRepository(supabase);
  }
  return FirebaseAuthRepository();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return HiveSettingsRepository(hive);
});

// Controller providers (depend on repositories)
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsState>(() {
  return SettingsController();
});

// Stream providers (for real-time data)
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

// Future providers (for one-time async data)
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUser();
});

// Family providers (parameterized)
final userProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.getUser(userId);
});
```

### Provider Override (for testing)

```dart
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    networkServiceProvider.overrideWithValue(MockNetworkService()),
  ],
);
```

---

## 🚀 Initialization Flow

### App Startup Sequence

```dart
// main.dart
Future<void> main() async {
  // 1. Flutter framework binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Set app flavor
  F.appFlavor = Flavor.production;

  // 3. Load environment configuration
  await EnvironmentConfig.initialize(F.appFlavor!);

  // 4. System configurations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 5. Initialize EasyLocalization (i18n)
  await EasyLocalization.ensureInitialized();

  // 6. Initialize Supabase (✅ primary backend)
  await Supabase.initialize(
    url: EnvironmentConfig.supabaseUrl,
    anonKey: EnvironmentConfig.supabaseAnonKey,
  );

  // 7. Initialize Hive (✅ local storage with encryption)
  await HiveService.instance.initialize();

  // 8. Initialize Firebase (⚠️ disabled by default)
  // if (EnvironmentConfig.enableFirebase) {
  //   await FirebaseService.instance.initialize();
  // }

  // 9. Initialize RevenueCat (✅ subscriptions)
  await RevenueCatService.instance.initialize();

  // 10. Initialize AdMob (✅ if enabled)
  if (EnvironmentConfig.enableAds) {
    await AdMobService.instance.initialize();
  }

  // 11. Initialize Clarity (✅ analytics)
  await ClarityService.instance.initialize();

  // 12. Initialize Sentry (✅ if configured)
  if (EnvironmentConfig.sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = EnvironmentConfig.sentryDsn;
        options.environment = EnvironmentConfig.currentEnvironment;
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => _runApp(),
    );
  } else {
    _runApp();
  }
}

void _runApp() {
  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          child: EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: const MyApp(),
          ),
        ),
      );
    },
    (error, stack) {
      // Global error handler
      Logger().e('Uncaught error', error, stack);
      if (EnvironmentConfig.sentryDsn.isNotEmpty) {
        Sentry.captureException(error, stackTrace: stack);
      }
    },
  );
}
```

### Initialization States

```
┌────────────────────┐
│  App Launch        │
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Native Splash     │ (flutter_native_splash)
│  Screen            │
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Framework Init    │ WidgetsFlutterBinding
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Environment Load  │ .env files
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  System Config     │ Orientations, Status Bar
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Services Init     │ Supabase, Hive, RevenueCat, AdMob, Clarity
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Sentry Init       │ Error tracking
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  App Widget        │ MyApp()
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Splash Screen     │ (custom Flutter widget)
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Auth Check        │ Route guards
└─────────┬──────────┘
          ↓
┌────────────────────┐
│  Main Screen       │ Home or Login
└────────────────────┘
```

---

## 📊 Architecture Benefits

| Benefit | Description | Impact |
|---------|-------------|--------|
| **Testability** | Easy to mock, isolate, and test each layer | 90%+ test coverage achievable |
| **Maintainability** | Clear structure, easy to find code | Reduced onboarding time |
| **Scalability** | New features don't affect existing code | Parallel team development |
| **Reusability** | Core services/widgets shared across features | DRY principle |
| **Flexibility** | Easy to swap implementations | Can switch backends |
| **Type Safety** | Compile-time checks with Freezed/Riverpod | Fewer runtime errors |
| **Separation of Concerns** | Each layer has single responsibility | Easier debugging |
| **Team Collaboration** | Clear boundaries for parallel work | Merge conflicts reduced |

---

## 🎯 Best Practices

### 1. Feature Organization
- ✅ Each feature is self-contained
- ✅ Features don't depend on each other
- ✅ Share code via `core/`
- ❌ No cross-feature imports

### 2. Layer Separation
- ✅ Domain has no dependencies
- ✅ Data depends only on Domain
- ✅ Presentation depends on Data and Domain
- ❌ No backwards dependencies

### 3. State Management
- ✅ Use AsyncNotifier for complex state
- ✅ Use StreamProvider for real-time data
- ✅ Use FutureProvider for one-time async
- ❌ No setState in large screens

### 4. Error Handling
- ✅ Use Freezed Failures in domain
- ✅ Transform Exceptions to Failures in repositories
- ✅ Display user-friendly messages in UI
- ❌ Don't expose technical errors to users

### 5. Testing
- ✅ Unit test business logic
- ✅ Widget test UI components
- ✅ Integration test critical flows
- ❌ Don't test framework code

### 6. Dependency Injection
- ✅ Use Riverpod providers
- ✅ Inject dependencies via constructors
- ✅ Override providers in tests
- ❌ No global singletons (except services)

### 7. Code Generation
- ✅ Run build_runner after changes
- ✅ Commit generated files
- ✅ Use Freezed for immutability
- ❌ Don't modify generated files

### 8. Environment Config
- ✅ Use .env files for configuration
- ✅ Never commit secrets
- ✅ Validate required configs at startup
- ❌ No hardcoded API keys

---

## 🚧 Common Pitfalls to Avoid

### 1. Domain Layer Violations
❌ **Don't**: Add Flutter dependencies to domain
```dart
// WRONG - domain layer with Flutter import
import 'package:flutter/material.dart';

@freezed
class UserModel with _$UserModel {
  // ...
}
```

✅ **Do**: Keep domain pure Dart
```dart
// CORRECT - pure Dart with Freezed
@freezed
class UserModel with _$UserModel {
  // ...
}
```

### 2. Repository Leaks
❌ **Don't**: Let repositories leak to UI
```dart
// WRONG - UI directly calling repository
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(authRepositoryProvider);
    repository.signIn(email, password); // Direct call
  }
}
```

✅ **Do**: Use controllers as intermediary
```dart
// CORRECT - UI calls controller
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider.notifier);
    controller.signIn(email, password); // Through controller
  }
}
```

### 3. State Management Misuse
❌ **Don't**: Use setState for complex state
```dart
// WRONG - setState for auth state
class MyScreen extends StatefulWidget {
  // Managing complex auth state with setState
}
```

✅ **Do**: Use Riverpod AsyncNotifier
```dart
// CORRECT - Riverpod for complex state
class AuthController extends AsyncNotifier<AuthState> {
  // Proper state management
}
```

### 4. Navigation Issues
❌ **Don't**: Navigate without context
```dart
// WRONG - Navigator without BuildContext
Navigator.pushNamed('route'); // No context
```

✅ **Do**: Use GoRouter with context
```dart
// CORRECT - GoRouter with context
context.go(Routes.home);
```

---

## 📚 Additional Resources

- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **Riverpod Documentation**: https://riverpod.dev
- **GoRouter Guide**: https://pub.dev/packages/go_router
- **Freezed Documentation**: https://pub.dev/packages/freezed
- **Flutter Best Practices**: https://docs.flutter.dev/perf/best-practices
- **SOLID Principles**: https://en.wikipedia.org/wiki/SOLID

---

## 🎓 Summary

This template implements **Clean Architecture** with **Domain-Driven Design**, featuring:

### Key Architectural Patterns
- **Three-Layer Architecture**: Domain, Data, Presentation
- **Feature-First Organization**: Self-contained feature modules
- **Riverpod State Management**: AsyncNotifier pattern
- **GoRouter Navigation**: Navigator 2.0 with route guards
- **Error Handling**: Freezed Failures and typed exceptions
- **Multi-Environment**: Flavor-based configuration
- **Testing Pyramid**: Unit, Widget, Integration tests

### Production-Ready Features
- ✅ Complete authentication flow
- ✅ Subscription management (RevenueCat)
- ✅ Ad monetization (AdMob)
- ✅ Local storage with encryption (Hive)
- ✅ Backend integration (Supabase/Firebase)
- ✅ Analytics and crash reporting
- ✅ Multi-language support
- ✅ Dark mode support

### Architecture Benefits
- 🎯 **Testable**: Easy mocking and isolation
- 🔧 **Maintainable**: Clear structure and separation
- 📈 **Scalable**: New features don't break existing code
- 🔄 **Reusable**: Shared core infrastructure
- 🤝 **Team-Friendly**: Clear boundaries for collaboration
- 🛡️ **Type-Safe**: Compile-time safety with Freezed and Riverpod

---

*This architecture is battle-tested and designed for production Flutter applications that need to scale from small teams to large organizations. It provides a solid foundation while remaining flexible for future requirements.*

**Last Updated**: 2025-10-15
**Template Version**: 1.0.0
**Minimum Flutter**: 3.9.0
**Architecture Pattern**: Clean Architecture (Domain-Driven Design)
