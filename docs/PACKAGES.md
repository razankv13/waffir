# Flutter Template - Packages Documentation

> **Document Purpose**: This comprehensive guide catalogs all packages used in this production-ready Flutter template. Designed for LLM-based requirement generation, project cloning, and architectural understanding.

> **Template Context**: This is a base template for production Flutter applications featuring clean architecture, multi-environment support, monetization (subscriptions + ads), backend integration, and comprehensive testing infrastructure.

---

## 📋 Document Metadata

- **Total Package Count**: 60+ packages
- **Categories**: 15 major categories
- **Architecture Pattern**: Clean Architecture (Domain-Driven Design)
- **State Management**: Riverpod
- **Backend Options**: Supabase (primary), Firebase (optional, disabled by default)
- **Monetization**: RevenueCat + AdMob
- **Minimum SDK**: Dart ^3.9.0
- **Last Updated**: 2025-10-15

---

## 🎯 Package Selection Philosophy

### Selection Criteria
1. **Production-Ready**: Battle-tested packages with strong community support
2. **Null Safety**: 100% null-safe ecosystem
3. **Active Maintenance**: Regular updates and security patches
4. **Documentation**: Comprehensive docs and examples
5. **Performance**: Minimal performance overhead
6. **Cross-Platform**: iOS, Android, Web, Desktop support where applicable

### Integration Approach
- **Minimal Boilerplate**: Code generation for repetitive tasks
- **Type Safety**: Compile-time validation over runtime checks
- **Testability**: Easy mocking and isolation
- **Modularity**: Packages serve specific, well-defined purposes

---

## 📦 Package Catalog by Category

---

## 1. State Management

### flutter_riverpod
- **Package**: `flutter_riverpod` (latest compatible)
- **Category**: State Management (Core)
- **Priority**: Critical
- **Purpose**: Primary state management solution providing reactive, compile-safe data flow
- **Why Chosen**:
  - Better than Provider (compile-time safety)
  - Easier than BLoC (less boilerplate)
  - More flexible than GetX (better testing)
- **Architecture Layer**: Presentation + Data
- **Use Cases**:
  - UI state management
  - Dependency injection
  - Async state handling
  - Stream subscriptions
- **Key Features**:
  - Compile-time safety with strong typing
  - Provider composition and family providers
  - AsyncValue for loading/error/data states
  - Built-in testing support
  - Auto-disposal and lifecycle management
- **Integration Points**:
  - Used by: All controllers, repositories, services
  - Depends on: None (peer to app)
  - Provides: State to all widgets
- **Code Pattern**:
```dart
// Provider definition
final userProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

// Controller pattern
class TodosController extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => _fetchTodos();

  Future<void> addTodo(String title) async {
    state = await AsyncValue.guard(() async {
      await repository.createTodo(title);
      return _fetchTodos();
    });
  }
}
```
- **Testing Approach**:
```dart
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(mockRepository),
  ],
);
```

### riverpod_annotation
- **Package**: `riverpod_annotation` (latest compatible)
- **Category**: State Management (Code Generation)
- **Priority**: Medium
- **Purpose**: Annotation-based provider generation to reduce boilerplate
- **Why Chosen**: Simplifies provider creation while maintaining type safety
- **Architecture Layer**: Presentation + Data
- **Use Cases**:
  - Auto-generated providers
  - Type-safe provider definitions
  - Simplified syntax for complex providers
- **Key Features**:
  - `@riverpod` annotation for providers
  - Auto-generated keepAlive providers
  - Family provider generation
  - Simplified async providers
- **Integration Points**:
  - Used by: Controller classes, repository providers
  - Requires: `riverpod_generator` (dev dependency)
  - Generated Code: `.g.dart` files
- **Implementation Status**: Configured but limited use (most providers are manual)
- **Code Pattern**:
```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    return AuthState.initial();
  }
}
```

---

## 2. Code Generation

### freezed_annotation
- **Package**: `freezed_annotation` ^3.1.0
- **Category**: Code Generation (Immutability)
- **Priority**: Critical
- **Purpose**: Create immutable data classes with copyWith, equality, and union types
- **Why Chosen**: De facto standard for immutable Dart classes
- **Architecture Layer**: Domain + Data + Presentation
- **Use Cases**:
  - Domain entities (business objects)
  - State classes (UI state)
  - DTOs (data transfer objects)
  - API response models
  - Union types for state machines
- **Key Features**:
  - Immutable classes with `@freezed` annotation
  - Union types (sealed classes)
  - `copyWith` method generation
  - `==` operator and `hashCode` overrides
  - Pattern matching support
  - JSON serialization integration
- **Integration Points**:
  - Used by: All entities, state classes, models
  - Requires: `freezed` (dev dependency), `build_runner`
  - Generated Code: `*.freezed.dart` files
- **Code Pattern**:
```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Union type example
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated({required UserModel user}) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(String message) = Error;
}
```
- **Usage Pattern**: Used in 100% of domain entities, 90% of state classes
- **Generation Command**: `dart run build_runner build --delete-conflicting-outputs`

### json_annotation
- **Package**: `json_annotation` ^4.9.0
- **Category**: Code Generation (Serialization)
- **Priority**: Critical
- **Purpose**: JSON serialization/deserialization for API communication
- **Why Chosen**: Type-safe, compile-time JSON handling
- **Architecture Layer**: Data (DTOs and API models)
- **Use Cases**:
  - API request/response models
  - Firebase Firestore documents
  - Local JSON storage
  - Configuration files
- **Key Features**:
  - Type-safe JSON conversion
  - Custom type converters
  - Field renaming (@JsonKey)
  - Null safety support
  - Nested object serialization
  - Date/time handling
- **Integration Points**:
  - Used by: All API models, DTOs
  - Requires: `json_serializable` (dev dependency), `build_runner`
  - Generated Code: `*.g.dart` files
  - Works with: `freezed_annotation` for combined usage
- **Code Pattern**:
```dart
@JsonSerializable()
class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.createdAt,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
```

---

## 3. Navigation & Routing

### go_router
- **Package**: `go_router` ^16.2.1
- **Category**: Navigation
- **Priority**: Critical
- **Purpose**: Declarative routing built on Navigator 2.0 API
- **Why Chosen**:
  - Official Flutter team recommendation
  - Better than Navigator 1.0 (deep linking support)
  - Simpler than custom Navigator 2.0 implementation
  - Excellent for web (URL-based routing)
- **Architecture Layer**: Presentation (navigation)
- **Use Cases**:
  - App-wide navigation
  - Authentication routing guards
  - Deep linking (web and mobile)
  - Nested navigation (tabs, drawers)
  - Shell routes for persistent UI
  - Query parameters and path params
- **Key Features**:
  - Declarative route configuration
  - Type-safe navigation
  - Route guards (redirect logic)
  - Deep linking support (universal links)
  - Shell routes for persistent bottom nav
  - Named routes with parameters
  - Error handling (404 pages)
  - Nested navigation
- **Integration Points**:
  - Used by: All screen navigation
  - Configured in: `lib/core/navigation/app_router.dart`
  - Route Guards: `lib/core/navigation/route_guards.dart`
  - Named Routes: `lib/core/navigation/routes.dart`
- **Code Pattern**:
```dart
final goRouter = GoRouter(
  initialLocation: Routes.splash,
  redirect: (context, state) async {
    // Auth guard logic
    final isAuthenticated = await ref.read(authStateProvider.future);
    if (!isAuthenticated && !state.matchedLocation.startsWith('/auth')) {
      return Routes.login;
    }
    return null;
  },
  routes: [
    // Shell route with persistent bottom nav
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    // Auth routes (outside shell)
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);

// Usage
context.go(Routes.home);
context.pushNamed(RouteNames.profile, pathParameters: {'id': userId});
```
- **Route Guard Implementation**: Authentication, onboarding, subscription checks
- **Deep Linking**: Supports universal links and custom URL schemes

---

## 4. UI & Theming

### google_fonts
- **Package**: `google_fonts` ^6.2.1
- **Category**: UI (Typography)
- **Priority**: High
- **Purpose**: Easy access to 1000+ Google Fonts
- **Why Chosen**: Rich typography without bundling font files
- **Architecture Layer**: Presentation (theme)
- **Use Cases**:
  - Custom typography in theme
  - Brand-specific fonts
  - Multi-language font support
  - Fallback fonts for special characters
- **Key Features**:
  - 1000+ font families
  - Auto-download and caching
  - Font weight variations (100-900)
  - Italic styles
  - Offline support (cached fonts)
- **Integration Points**:
  - Used in: `lib/core/themes/app_theme.dart`
  - Affects: All text rendering
- **Code Pattern**:
```dart
// In theme configuration
final theme = ThemeData(
  textTheme: GoogleFonts.interTextTheme(
    Theme.of(context).textTheme,
  ),
  // Specific font for headings
  headline1: GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
);
```

### flutter_animate
- **Package**: `flutter_animate` ^4.5.0
- **Category**: UI (Animation)
- **Priority**: Medium
- **Purpose**: Simple, declarative animations with minimal code
- **Why Chosen**: Much simpler than AnimationController, more powerful than implicit animations
- **Architecture Layer**: Presentation (widgets)
- **Use Cases**:
  - Page transitions
  - Button hover effects
  - Loading states
  - List item animations
  - Attention-grabbing effects
- **Key Features**:
  - Declarative animation syntax
  - Pre-built effects (fade, slide, scale, shimmer, etc.)
  - Chainable animations
  - Custom effects
  - Trigger-based animations
  - Timeline control
- **Integration Points**:
  - Used in: Button widgets, page transitions, loading indicators
- **Code Pattern**:
```dart
Text('Welcome')
  .animate()
  .fadeIn(duration: 600.ms)
  .slideY(begin: -20, end: 0);

// Conditional animation
Container()
  .animate(target: isVisible ? 1 : 0)
  .fade()
  .scale();
```

### shimmer
- **Package**: `shimmer` ^3.0.0
- **Category**: UI (Loading States)
- **Priority**: Medium
- **Purpose**: Shimmer loading effect for skeleton screens
- **Why Chosen**: Industry-standard loading UX pattern
- **Architecture Layer**: Presentation (loading widgets)
- **Use Cases**:
  - Skeleton screens
  - Loading placeholders
  - Image loading states
  - List item placeholders
- **Key Features**:
  - Customizable shimmer direction
  - Color customization
  - Speed control
  - Gradient effects
- **Code Pattern**:
```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: ListTile(
    leading: CircleAvatar(),
    title: Container(height: 16, color: Colors.white),
  ),
);
```

---

## 5. Localization & Internationalization

### easy_localization
- **Package**: `easy_localization` ^3.0.7
- **Category**: Localization
- **Priority**: High
- **Purpose**: Comprehensive i18n solution with JSON translation files
- **Why Chosen**:
  - Simpler than flutter_localizations
  - JSON-based (designer-friendly)
  - Runtime language switching
  - Rich plural/gender support
- **Architecture Layer**: Presentation + Core
- **Use Cases**:
  - Multi-language support
  - Runtime locale switching
  - Pluralization (1 item vs 2 items)
  - Gender-based translations
  - Fallback locale handling
- **Key Features**:
  - JSON-based translations (`assets/translations/`)
  - Pluralization support
  - Gender support
  - Context support
  - Automatic locale detection
  - Fallback locale
  - Asset loader customization
- **Integration Points**:
  - Initialized in: `main.dart`
  - Translation files: `assets/translations/{en,es,fr}.json`
  - Used by: All UI text
- **Supported Languages**: English (en), Spanish (es), French (fr)
- **Code Pattern**:
```dart
// In main.dart
await EasyLocalization.ensureInitialized();
runApp(
  EasyLocalization(
    supportedLocales: [Locale('en'), Locale('es'), Locale('fr')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    child: MyApp(),
  ),
);

// Usage
Text('welcome_message'.tr());
Text('items_count'.plural(count));

// In JSON (en.json)
{
  "welcome_message": "Welcome to the app!",
  "items_count": {
    "zero": "No items",
    "one": "1 item",
    "other": "{} items"
  }
}
```

### intl
- **Package**: `intl` ^0.20.2
- **Category**: Localization (Formatting)
- **Priority**: High
- **Purpose**: Internationalization utilities for dates, numbers, currencies
- **Why Chosen**: Official Dart i18n package, industry standard
- **Architecture Layer**: Core (utilities)
- **Use Cases**:
  - Date/time formatting
  - Number formatting
  - Currency formatting
  - Relative time (e.g., "2 hours ago")
- **Key Features**:
  - Locale-aware formatting
  - Custom date formats
  - Number parsing
  - Currency symbols
  - Plural and gender rules
- **Code Pattern**:
```dart
// Date formatting
final formatter = DateFormat.yMMMd('en_US');
final date = formatter.format(DateTime.now()); // "Oct 15, 2025"

// Currency
final currency = NumberFormat.currency(locale: 'en_US', symbol: '\$');
final price = currency.format(99.99); // "$99.99"

// Relative time
final relative = DateFormat.relative(DateTime.now().subtract(Duration(hours: 2)));
// "2 hours ago"
```

---

## 6. Backend & Database

### supabase_flutter
- **Package**: `supabase_flutter` ^2.5.6
- **Category**: Backend (BaaS)
- **Priority**: Critical
- **Purpose**: Open-source Firebase alternative with PostgreSQL, Auth, Storage, Realtime
- **Why Chosen**:
  - Open source (self-hostable)
  - PostgreSQL (powerful queries, triggers)
  - Row-level security
  - Realtime subscriptions
  - Better pricing than Firebase
  - RESTful APIs
- **Architecture Layer**: Data (backend integration)
- **Use Cases**:
  - User authentication
  - PostgreSQL database operations
  - File storage (user uploads)
  - Realtime subscriptions
  - Edge functions (serverless)
  - Row-level security (RLS)
- **Key Features**:
  - PostgreSQL database with full SQL support
  - Row-level security (RLS)
  - Authentication (email, OAuth, magic links)
  - Storage with CDN
  - Realtime subscriptions (WebSocket)
  - Edge functions (Deno-based)
  - Database functions and triggers
  - RESTful and GraphQL APIs
- **Integration Points**:
  - Initialized in: `main.dart`
  - Configuration: `.env` files (`SUPABASE_URL`, `SUPABASE_ANON_KEY`)
  - Used by: Auth repository, data repositories
  - Provider: `supabaseProvider`
- **Status**: ✅ Fully initialized and working
- **Code Pattern**:
```dart
// Initialization
await Supabase.initialize(
  url: EnvironmentConfig.supabaseUrl,
  anonKey: EnvironmentConfig.supabaseAnonKey,
);

// Usage
final supabase = Supabase.instance.client;

// Auth
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);

// Database query
final response = await supabase
  .from('users')
  .select()
  .eq('id', userId)
  .single();

// Realtime subscription
supabase
  .from('messages')
  .stream(primaryKey: ['id'])
  .listen((data) {
    // Handle realtime updates
  });

// Storage
await supabase.storage
  .from('avatars')
  .upload('user_id/avatar.png', file);
```

---

## 7. Firebase Services

> **Status**: ⚠️ All Firebase packages are installed but **DISABLED BY DEFAULT**. Infrastructure exists but initialization is commented out in `lib/core/services/firebase_service.dart`.

### firebase_core
- **Package**: `firebase_core` ^4.1.0
- **Category**: Backend (Firebase Core)
- **Priority**: Critical (when Firebase is enabled)
- **Purpose**: Core Firebase SDK initialization
- **Status**: Infrastructure ready, disabled by default
- **Required**: For all Firebase services
- **Configuration Files**:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
  - Web: Firebase config in `web/index.html`
- **Code Pattern**:
```dart
// In firebase_service.dart (currently commented out)
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### firebase_auth
- **Package**: `firebase_auth` ^6.0.2
- **Category**: Backend (Authentication)
- **Priority**: High (when Firebase is enabled)
- **Purpose**: User authentication with multiple providers
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Email/password auth
  - Google Sign-In
  - Apple Sign-In
  - Phone authentication
  - Anonymous auth
  - Custom token auth
- **Key Features**:
  - Multiple auth providers
  - Email verification
  - Password reset
  - Phone number verification
  - Anonymous user conversion
  - Multi-factor authentication
- **Code Pattern**:
```dart
final auth = FirebaseAuth.instance;

// Email/password
await auth.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Google Sign-In
final googleUser = await GoogleSignIn().signIn();
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
await auth.signInWithCredential(credential);
```

### cloud_firestore
- **Package**: `cloud_firestore` ^6.0.1
- **Category**: Backend (NoSQL Database)
- **Priority**: High (when Firebase is enabled)
- **Purpose**: Cloud-hosted NoSQL database with realtime sync
- **Status**: Installed but disabled by default
- **Use Cases**:
  - User data storage
  - Realtime data sync
  - Offline persistence
  - Complex queries
- **Key Features**:
  - Real-time synchronization
  - Offline support
  - Automatic scaling
  - Security rules
  - Composite queries
  - Subcollections
- **Code Pattern**:
```dart
final firestore = FirebaseFirestore.instance;

// Write
await firestore.collection('users').doc(userId).set({
  'name': 'John',
  'age': 30,
});

// Read
final doc = await firestore.collection('users').doc(userId).get();

// Realtime
firestore.collection('messages').snapshots().listen((snapshot) {
  for (var change in snapshot.docChanges) {
    // Handle realtime updates
  }
});
```

### firebase_storage
- **Package**: `firebase_storage` ^13.0.1
- **Category**: Backend (File Storage)
- **Priority**: Medium (when Firebase is enabled)
- **Purpose**: Cloud storage for user-generated content
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Image uploads
  - Video storage
  - File downloads
  - Profile pictures
- **Key Features**:
  - Secure file uploads/downloads
  - Resumable transfers
  - Progress tracking
  - Security rules
  - CDN integration

### firebase_messaging
- **Package**: `firebase_messaging` ^16.0.1
- **Category**: Backend (Push Notifications)
- **Priority**: Medium (when Firebase is enabled)
- **Purpose**: Push notifications and in-app messaging
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Push notifications
  - Topic messaging
  - Background message handling
  - Data messages
- **Key Features**:
  - Cross-platform push
  - Topic subscriptions
  - Background handlers
  - Notification customization

### firebase_analytics
- **Package**: `firebase_analytics` ^12.0.1
- **Category**: Analytics
- **Priority**: High (when Firebase is enabled)
- **Purpose**: App usage analytics and user behavior tracking
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Event tracking
  - User property tracking
  - Conversion tracking
  - Screen view tracking
- **Key Features**:
  - Event tracking
  - User properties
  - Audience segmentation
  - Conversion funnels
  - Integration with Google Analytics

### firebase_crashlytics
- **Package**: `firebase_crashlytics` ^5.0.1
- **Category**: Error Tracking
- **Priority**: High (when Firebase is enabled)
- **Purpose**: Real-time crash reporting
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Crash reporting
  - Non-fatal error logging
  - User tracking
  - Custom logs
- **Key Features**:
  - Automatic crash reporting
  - Non-fatal errors
  - Custom keys and logs
  - User identification
  - Crash analytics

### firebase_remote_config
- **Package**: `firebase_remote_config` ^6.0.1
- **Category**: Configuration
- **Priority**: Medium (when Firebase is enabled)
- **Purpose**: Dynamic app configuration without updates
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Feature flags
  - A/B testing
  - Gradual rollouts
  - Emergency kill switches
- **Key Features**:
  - Remote configuration
  - A/B testing
  - Conditional targeting
  - Default values
  - Fetch intervals

### firebase_performance
- **Package**: `firebase_performance` ^0.11.0+1
- **Category**: Monitoring
- **Priority**: Low (when Firebase is enabled)
- **Purpose**: App performance monitoring
- **Status**: Installed but disabled by default
- **Use Cases**:
  - Screen rendering times
  - Network request monitoring
  - Custom traces
  - Performance metrics
- **Key Features**:
  - Automatic traces
  - Custom traces
  - Network monitoring
  - Performance insights

---

## 8. Local Storage

### hive_ce
- **Package**: `hive_ce` ^2.6.0
- **Category**: Local Storage (NoSQL)
- **Priority**: Critical
- **Purpose**: Fast, lightweight NoSQL database with encryption support
- **Why Chosen**:
  - Faster than sqflite
  - No native dependencies (pure Dart)
  - Encryption support
  - Type adapters for custom objects
  - Lazy loading
- **Architecture Layer**: Data (local persistence)
- **Use Cases**:
  - App settings storage
  - User data caching
  - Offline data storage
  - Secure token storage (with encryption)
  - Cache management
- **Key Features**:
  - High performance (pure Dart)
  - Encryption with AES-256
  - Type adapters for custom objects
  - No native dependencies
  - Lazy box loading
  - Multiple boxes (like SQLite tables)
  - CRUD operations
- **Integration Points**:
  - Service: `lib/core/storage/hive_service.dart`
  - Initialized in: `main.dart`
  - Models: `lib/core/storage/models/`
  - Provider: `hiveServiceProvider`
- **Status**: ✅ Fully initialized with encryption
- **Code Pattern**:
```dart
// Initialization
await Hive.initFlutter();
final encryptionKey = await _getEncryptionKey();
_settingsBox = await Hive.openBox<AppSettings>(
  'settings',
  encryptionCipher: HiveAesCipher(encryptionKey),
);

// Type adapter (auto-generated)
@HiveType(typeId: 0)
class AppSettings {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final String language;
}

// Usage
await settingsBox.put('settings', AppSettings(isDarkMode: true));
final settings = settingsBox.get('settings');
```

### hive_ce_flutter
- **Package**: `hive_ce_flutter` ^2.1.0
- **Category**: Local Storage (Flutter Extensions)
- **Priority**: Critical
- **Purpose**: Flutter-specific extensions for Hive CE
- **Required**: For Hive initialization in Flutter
- **Integration**: Works with `hive_ce`

### flutter_secure_storage
- **Package**: `flutter_secure_storage` ^9.2.2
- **Category**: Local Storage (Secure)
- **Priority**: Critical
- **Purpose**: Platform-specific secure storage for sensitive data
- **Why Chosen**: Platform secure enclaves (Keychain, KeyStore)
- **Architecture Layer**: Data (secure storage)
- **Use Cases**:
  - Encryption keys (for Hive)
  - Auth tokens
  - API keys
  - Biometric protected data
  - Sensitive user data
- **Key Features**:
  - iOS Keychain integration
  - Android KeyStore integration
  - Biometric protection support
  - Encrypted on all platforms
  - Simple key-value API
- **Integration Points**:
  - Used by: `HiveService` for encryption keys
  - Used by: Auth repositories for tokens
- **Code Pattern**:
```dart
final secureStorage = FlutterSecureStorage();

// Write
await secureStorage.write(
  key: 'encryption_key',
  value: encryptionKey,
);

// Read
final key = await secureStorage.read(key: 'encryption_key');

// Delete
await secureStorage.delete(key: 'encryption_key');

// With biometric protection (iOS)
await secureStorage.write(
  key: 'sensitive_data',
  value: data,
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
);
```

---

## 9. Networking & Connectivity

### dio
- **Package**: `dio` ^5.4.3
- **Category**: Networking (HTTP Client)
- **Priority**: Critical
- **Purpose**: Powerful HTTP client with interceptors, file upload/download, cancellation
- **Why Chosen**:
  - More features than http package
  - Interceptors (auth, logging, retry)
  - Request cancellation
  - File uploads/downloads with progress
  - Better error handling
- **Architecture Layer**: Data (network layer)
- **Use Cases**:
  - RESTful API calls
  - File uploads/downloads
  - Request cancellation
  - Network interceptors
  - Timeout handling
- **Key Features**:
  - Request/response interceptors
  - FormData for file uploads
  - Request cancellation (CancelToken)
  - Timeout configuration
  - Cookie management
  - Certificate pinning
  - Progress callbacks
  - Base URL configuration
- **Integration Points**:
  - Service: `lib/core/network/network_service.dart`
  - Interceptors: `lib/core/network/interceptors/`
  - Provider: `networkServiceProvider`
  - Used by: All API repositories
- **Interceptors Implemented**:
  - `AuthInterceptor` - Add auth tokens
  - `RetryInterceptor` - Retry failed requests
  - `LoggingInterceptor` - Log requests/responses
  - `ConnectivityInterceptor` - Check network before requests
- **Code Pattern**:
```dart
// Initialization
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
));

// Interceptors
dio.interceptors.addAll([
  AuthInterceptor(),
  RetryInterceptor(),
  LoggingInterceptor(),
]);

// GET request
final response = await dio.get('/users/$id');

// POST with data
await dio.post('/users', data: {
  'name': 'John',
  'email': 'john@example.com',
});

// File upload with progress
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(filePath),
});
await dio.post('/upload',
  data: formData,
  onSendProgress: (sent, total) {
    print('${(sent / total * 100).toStringAsFixed(0)}%');
  },
);

// Request cancellation
final cancelToken = CancelToken();
dio.get('/data', cancelToken: cancelToken);
// Later...
cancelToken.cancel('Cancelled by user');
```

### cached_network_image
- **Package**: `cached_network_image` ^3.3.1
- **Category**: Networking (Image Caching)
- **Priority**: High
- **Purpose**: Load and cache network images efficiently
- **Why Chosen**: Industry standard for image caching
- **Architecture Layer**: Presentation (widgets)
- **Use Cases**:
  - User avatars
  - Product images
  - Gallery images
  - Remote content images
- **Key Features**:
  - Automatic caching
  - Placeholder widgets
  - Error widgets
  - Fade-in animations
  - Custom cache manager
  - Progress indicators
- **Code Pattern**:
```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 300),
);
```

### connectivity_plus
- **Package**: `connectivity_plus` ^6.0.3
- **Category**: Networking (Connectivity)
- **Priority**: High
- **Purpose**: Monitor network connectivity status
- **Why Chosen**: Essential for offline-first apps
- **Architecture Layer**: Core (services)
- **Use Cases**:
  - Check internet connectivity
  - Monitor connection changes
  - Show offline UI
  - Queue requests for later
- **Key Features**:
  - Connection type detection (WiFi, mobile, none)
  - Connectivity change stream
  - Cross-platform support
  - Works on all platforms
- **Integration Points**:
  - Used in: `ConnectivityInterceptor` (Dio)
  - Used by: Network service
- **Code Pattern**:
```dart
final connectivity = Connectivity();

// Check current status
final result = await connectivity.checkConnectivity();
if (result == ConnectivityResult.none) {
  // No internet
}

// Monitor changes
connectivity.onConnectivityChanged.listen((result) {
  if (result == ConnectivityResult.mobile) {
    // Mobile data
  } else if (result == ConnectivityResult.wifi) {
    // WiFi
  }
});
```

---

## 10. Permissions & Security

### permission_handler
- **Package**: `permission_handler` ^12.0.1
- **Category**: Permissions
- **Priority**: High
- **Purpose**: Cross-platform permission management
- **Why Chosen**: Unified API for all platform permissions
- **Architecture Layer**: Core (services)
- **Use Cases**:
  - Camera permission
  - Photo library access
  - Location permission
  - Microphone access
  - Notification permission
  - Storage access
- **Key Features**:
  - Check permission status
  - Request permissions
  - Open app settings
  - Service status checking
  - Support for all major permissions
- **Platform Configuration Required**:
  - iOS: `Info.plist` permission descriptions
  - Android: `AndroidManifest.xml` permission declarations
- **Code Pattern**:
```dart
// Check status
final status = await Permission.camera.status;
if (status.isDenied) {
  // Request permission
  final result = await Permission.camera.request();
  if (result.isGranted) {
    // Permission granted
  }
}

// Multiple permissions
Map<Permission, PermissionStatus> statuses = await [
  Permission.camera,
  Permission.photos,
].request();

// Open settings if permanently denied
if (await Permission.camera.isPermanentlyDenied) {
  await openAppSettings();
}
```

### local_auth
- **Package**: `local_auth` ^2.3.0
- **Category**: Security (Biometrics)
- **Priority**: Medium
- **Purpose**: Face ID, Touch ID, fingerprint authentication
- **Why Chosen**: Native biometric support
- **Architecture Layer**: Core (services)
- **Use Cases**:
  - App lock
  - Secure feature access
  - Payment authentication
  - Sensitive data access
- **Key Features**:
  - Face ID (iOS)
  - Touch ID (iOS)
  - Fingerprint (Android)
  - Device credentials fallback
  - Availability checking
- **Integration Points**:
  - Service: `lib/core/services/biometric_service.dart`
- **Code Pattern**:
```dart
final localAuth = LocalAuthentication();

// Check availability
final canAuthenticate = await localAuth.canCheckBiometrics;
final isDeviceSupported = await localAuth.isDeviceSupported();

// Available biometrics
final availableBiometrics = await localAuth.getAvailableBiometrics();
if (availableBiometrics.contains(BiometricType.face)) {
  // Face ID available
}

// Authenticate
final didAuthenticate = await localAuth.authenticate(
  localizedReason: 'Please authenticate to access this feature',
  options: const AuthenticationOptions(
    biometricOnly: true,
    stickyAuth: true,
  ),
);
```

---

## 11. Authentication Providers

### google_sign_in
- **Package**: `google_sign_in` ^7.1.1
- **Category**: Authentication (OAuth)
- **Priority**: High
- **Purpose**: OAuth 2.0 authentication with Google
- **Why Chosen**: Required for Google Sign-In
- **Architecture Layer**: Data (auth)
- **Use Cases**:
  - Google OAuth login
  - Access Google APIs
  - Social authentication
- **Key Features**:
  - OAuth 2.0 authentication
  - Account selection
  - Silent sign-in
  - Access tokens for Google APIs
  - Scopes configuration
- **Platform Configuration**:
  - iOS: URL schemes in `Info.plist`
  - Android: SHA-1 certificate in Firebase Console
  - Web: OAuth client ID
- **Code Pattern**:
```dart
final googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

// Sign in
final googleUser = await googleSignIn.signIn();
final googleAuth = await googleUser?.authentication;

// Get tokens
final accessToken = googleAuth?.accessToken;
final idToken = googleAuth?.idToken;

// Use with Firebase
final credential = GoogleAuthProvider.credential(
  accessToken: accessToken,
  idToken: idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

### sign_in_with_apple
- **Package**: `sign_in_with_apple` ^7.0.1
- **Category**: Authentication (OAuth)
- **Priority**: High (iOS apps with social login)
- **Purpose**: OAuth authentication with Apple ID
- **Why Chosen**: Required by Apple for apps with 3rd-party login
- **Architecture Layer**: Data (auth)
- **Use Cases**:
  - Apple Sign-In (iOS requirement)
  - Privacy-focused authentication
  - Email relay
- **Key Features**:
  - OAuth authentication
  - Privacy-focused (email relay)
  - Required for iOS apps with social login
  - Name and email on first sign-in
- **Platform Configuration**:
  - iOS: Sign in with Apple capability
  - Apple Developer: App ID configuration
- **Apple Requirements**: Mandatory if app offers any 3rd-party social login
- **Code Pattern**:
```dart
// Check availability
final isAvailable = await SignInWithApple.isAvailable();

// Sign in
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);

// credential.identityToken
// credential.authorizationCode
// credential.email (only on first sign-in)
// credential.givenName (only on first sign-in)
```

---

## 12. Media & File Handling

### flutter_svg
- **Package**: `flutter_svg` ^2.0.10
- **Category**: Media (SVG)
- **Priority**: High
- **Purpose**: Render SVG images and icons
- **Why Chosen**: Vector graphics for crisp icons at any size
- **Architecture Layer**: Presentation (assets)
- **Use Cases**:
  - App icons
  - Illustrations
  - Logos
  - Vector graphics
- **Key Features**:
  - SVG parsing and rendering
  - Asset and network SVGs
  - Color customization
  - Size scaling without pixelation
- **Integration**: Works with `flutter_gen` for type-safe SVG assets
- **Code Pattern**:
```dart
// Asset
SvgPicture.asset(
  'assets/icons/heart.svg',
  width: 24,
  height: 24,
  color: Colors.red,
);

// Network
SvgPicture.network(
  'https://example.com/icon.svg',
  placeholderBuilder: (context) => CircularProgressIndicator(),
);
```

### image_picker
- **Package**: `image_picker` ^1.1.2
- **Category**: Media (Image/Video Picker)
- **Priority**: High
- **Purpose**: Pick images and videos from gallery or camera
- **Why Chosen**: Official Flutter team plugin
- **Architecture Layer**: Presentation (media input)
- **Use Cases**:
  - Profile picture upload
  - Photo gallery selection
  - Camera capture
  - Video selection
- **Key Features**:
  - Gallery selection
  - Camera capture
  - Image quality control
  - Max width/height settings
  - Video support
- **Permissions Required**:
  - iOS: Camera, Photo Library usage descriptions
  - Android: Camera, Read External Storage
- **Code Pattern**:
```dart
final picker = ImagePicker();

// Pick from gallery
final image = await picker.pickImage(
  source: ImageSource.gallery,
  maxWidth: 1800,
  maxHeight: 1800,
  imageQuality: 85,
);

// Capture from camera
final photo = await picker.pickImage(
  source: ImageSource.camera,
);

// Multiple images
final images = await picker.pickMultiImage(
  maxWidth: 1800,
  maxHeight: 1800,
);

// Video
final video = await picker.pickVideo(
  source: ImageSource.gallery,
);
```

### share_plus
- **Package**: `share_plus` ^11.1.0
- **Category**: Media (Sharing)
- **Priority**: Medium
- **Purpose**: Share text, links, and files to other apps
- **Why Chosen**: Cross-platform sharing API
- **Architecture Layer**: Presentation (sharing)
- **Use Cases**:
  - Share app content
  - Share to social media
  - Share files
  - Share links
- **Key Features**:
  - Text sharing
  - File sharing
  - URL sharing
  - Subject and message
  - Share position (iPad)
- **Code Pattern**:
```dart
// Share text
await Share.share('Check out this app!');

// Share with subject
await Share.share(
  'Check out this article',
  subject: 'Interesting Read',
);

// Share files
await Share.shareXFiles([
  XFile('path/to/file.pdf'),
]);

// Share with position (iPad)
await Share.share(
  'Content',
  sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
);
```

---

## 13. Utilities

### url_launcher
- **Package**: `url_launcher` ^6.2.6
- **Category**: Utility
- **Priority**: High
- **Purpose**: Launch URLs, emails, phone numbers, external apps
- **Why Chosen**: Essential for external navigation
- **Architecture Layer**: Presentation (external actions)
- **Use Cases**:
  - Open web pages
  - Send emails
  - Make phone calls
  - Open maps
  - Launch other apps
- **Key Features**:
  - URL launching (http, https)
  - Email composition (mailto)
  - Phone dialing (tel)
  - SMS messaging (sms)
  - Custom URL schemes
- **Code Pattern**:
```dart
// Open URL
final uri = Uri.parse('https://example.com');
if (await canLaunchUrl(uri)) {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

// Email
final emailUri = Uri(
  scheme: 'mailto',
  path: 'support@example.com',
  query: 'subject=Help&body=I need help with...',
);
await launchUrl(emailUri);

// Phone
final phoneUri = Uri.parse('tel:+1234567890');
await launchUrl(phoneUri);
```

### path_provider
- **Package**: `path_provider` ^2.1.3
- **Category**: Utility (File System)
- **Priority**: High
- **Purpose**: Access common filesystem directories
- **Why Chosen**: Required for local file operations
- **Architecture Layer**: Core (file system)
- **Use Cases**:
  - Temporary file storage
  - App document storage
  - Cache directory
  - Download directory
- **Key Features**:
  - Temporary directory
  - Application documents directory
  - Application support directory
  - External storage directory (Android)
  - Downloads directory
- **Integration**: Used by Hive, image caching, file downloads
- **Code Pattern**:
```dart
// Temporary directory (cleared by system)
final tempDir = await getTemporaryDirectory();

// App documents (persisted, backed up)
final appDocDir = await getApplicationDocumentsDirectory();

// App support (persisted, not backed up)
final appSupportDir = await getApplicationSupportDirectory();

// External storage (Android only)
final externalDir = await getExternalStorageDirectory();
```

### package_info_plus
- **Package**: `package_info_plus` ^8.0.0
- **Category**: Utility (App Info)
- **Priority**: Medium
- **Purpose**: Get app version, build number, package name
- **Why Chosen**: Essential for version display and updates
- **Architecture Layer**: Core (app info)
- **Use Cases**:
  - Display app version in settings
  - Check for updates
  - Analytics tracking
  - Debug information
- **Key Features**:
  - App name
  - Package name
  - Version number
  - Build number
- **Code Pattern**:
```dart
final packageInfo = await PackageInfo.fromPlatform();

final appName = packageInfo.appName;
final packageName = packageInfo.packageName;
final version = packageInfo.version;
final buildNumber = packageInfo.buildNumber;

// Display: "MyApp v1.2.3 (42)"
```

### device_info_plus
- **Package**: `device_info_plus` ^11.5.0
- **Category**: Utility (Device Info)
- **Priority**: Medium
- **Purpose**: Get device model, OS version, platform details
- **Why Chosen**: Useful for analytics and debugging
- **Architecture Layer**: Core (device info)
- **Use Cases**:
  - Analytics tracking
  - Device-specific logic
  - Support debugging
  - Feature detection
- **Key Features**:
  - Device model
  - OS version
  - Platform identifiers
  - Screen info
  - System version
- **Code Pattern**:
```dart
final deviceInfo = DeviceInfoPlugin();

if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  final model = androidInfo.model;
  final osVersion = androidInfo.version.sdkInt;
} else if (Platform.isIOS) {
  final iosInfo = await deviceInfo.iosInfo;
  final model = iosInfo.utsname.machine;
  final osVersion = iosInfo.systemVersion;
}
```

---

## 14. Forms & Validation

### flutter_form_builder
- **Package**: `flutter_form_builder` ^10.2.0
- **Category**: Forms
- **Priority**: Medium
- **Purpose**: Advanced form building with minimal boilerplate
- **Why Chosen**: Much simpler than manual form management
- **Architecture Layer**: Presentation (forms)
- **Use Cases**:
  - User registration forms
  - Profile editing
  - Complex multi-field forms
  - Dynamic form generation
- **Key Features**:
  - Pre-built form fields
  - Form state management
  - Validation support
  - Custom field types
  - Form reset/save
  - Field dependencies
- **Code Pattern**:
```dart
final _formKey = GlobalKey<FormBuilderState>();

FormBuilder(
  key: _formKey,
  child: Column(
    children: [
      FormBuilderTextField(
        name: 'email',
        decoration: InputDecoration(labelText: 'Email'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
        ]),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            final values = _formKey.currentState!.value;
            // Process form data
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
);
```

### form_builder_validators
- **Package**: `form_builder_validators` ^11.2.0
- **Category**: Forms (Validation)
- **Priority**: Medium
- **Purpose**: Comprehensive validation rules for forms
- **Why Chosen**: Pre-built validators save time
- **Architecture Layer**: Presentation (validation)
- **Use Cases**:
  - Email validation
  - Password strength
  - Phone number validation
  - URL validation
  - Custom rules
- **Key Features**:
  - Email validator
  - Phone validator
  - Min/max length
  - Pattern matching (regex)
  - Numeric validation
  - Date validation
  - Credit card validation
  - Custom validators
  - Composite validators
- **Code Pattern**:
```dart
FormBuilderValidators.compose([
  FormBuilderValidators.required(errorText: 'Required'),
  FormBuilderValidators.email(errorText: 'Invalid email'),
  FormBuilderValidators.minLength(8, errorText: 'Min 8 characters'),
  FormBuilderValidators.match(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
    errorText: 'Must contain letters and numbers',
  ),
]);
```

---

## 15. Error Handling, Logging & Analytics

### flutter_dotenv
- **Package**: `flutter_dotenv` ^6.0.0
- **Category**: Configuration
- **Priority**: Critical
- **Purpose**: Load environment variables from .env files
- **Why Chosen**: Industry standard for env management
- **Architecture Layer**: Core (config)
- **Use Cases**:
  - API keys (separate by environment)
  - Backend URLs (dev, staging, prod)
  - Feature flags
  - Sensitive configuration
- **Key Features**:
  - Environment file loading
  - Multi-environment support
  - Type-safe access
  - Default values
- **Environment Files**:
  - `.env.dev` - Development
  - `.env.staging` - Staging
  - `.env.production` - Production
  - `.env` - Fallback
- **Integration Points**:
  - Loaded in: `main.dart` (before app initialization)
  - Accessed via: `lib/core/config/environment_config.dart`
- **Code Pattern**:
```dart
// Load in main.dart
await dotenv.load(fileName: '.env.${flavor}');

// Access via EnvironmentConfig
class EnvironmentConfig {
  static final _dotenv = dotenv;

  static String get supabaseUrl =>
    _dotenv.get('SUPABASE_URL', fallback: '');

  static bool get enableAds =>
    _dotenv.getBool('ENABLE_ADS', fallback: true);
}

// In .env.dev
SUPABASE_URL=https://dev.supabase.co
ENABLE_ADS=false
LOG_LEVEL=debug
```

### logger
- **Package**: `logger` ^2.3.0
- **Category**: Logging
- **Priority**: High
- **Purpose**: Structured logging with different log levels
- **Why Chosen**: Better than print(), structured output
- **Architecture Layer**: Core (logging)
- **Use Cases**:
  - Debug logging
  - Error tracking
  - Performance monitoring
  - Network request logging
- **Key Features**:
  - Multiple log levels (verbose, debug, info, warning, error, wtf)
  - Pretty printing
  - Custom output
  - Stack trace support
  - Method count
  - Time stamps
- **Integration Points**:
  - Service: `lib/core/utils/logger.dart`
  - Used everywhere for logging
- **Code Pattern**:
```dart
// Setup
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);

// Usage
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error, stackTrace);
```

### sentry_flutter
- **Package**: `sentry_flutter` ^9.6.0
- **Category**: Error Tracking (APM)
- **Priority**: High
- **Purpose**: Application monitoring, error tracking, performance monitoring
- **Why Chosen**:
  - Open source alternative to Crashlytics
  - Better error context
  - Performance monitoring
  - Release tracking
- **Architecture Layer**: Core (monitoring)
- **Use Cases**:
  - Production crash reporting
  - Error tracking
  - Performance monitoring
  - Release health tracking
  - User feedback
  - Breadcrumbs (user actions leading to error)
- **Key Features**:
  - Automatic crash reporting
  - Manual error logging
  - Performance monitoring (transactions)
  - User feedback
  - Release tracking
  - Breadcrumbs
  - User context
  - Environment tracking
  - Source maps (for web)
- **Integration Points**:
  - Initialized in: `main.dart` (wraps runApp)
  - Configuration: `.env` files (`SENTRY_DSN`)
  - Used throughout: Automatic error capture
- **Status**: ✅ Enabled when `SENTRY_DSN` is set
- **Code Pattern**:
```dart
// Initialization in main.dart
await SentryFlutter.init(
  (options) {
    options.dsn = EnvironmentConfig.sentryDsn;
    options.environment = EnvironmentConfig.currentEnvironment;
    options.tracesSampleRate = 1.0;
    options.enableAutoPerformanceTracing = true;
  },
  appRunner: () => runApp(MyApp()),
);

// Manual error capture
try {
  // risky operation
} catch (error, stackTrace) {
  await Sentry.captureException(error, stackTrace: stackTrace);
}

// Add breadcrumb
Sentry.addBreadcrumb(Breadcrumb(
  message: 'User clicked buy button',
  category: 'ui.click',
));

// Performance monitoring
final transaction = Sentry.startTransaction('api-call', 'http');
try {
  await apiCall();
  transaction.status = SpanStatus.ok();
} catch (e) {
  transaction.status = SpanStatus.internalError();
  rethrow;
} finally {
  await transaction.finish();
}
```

### clarity_flutter
- **Package**: `clarity_flutter` ^1.4.2
- **Category**: Analytics (User Behavior)
- **Priority**: Medium
- **Purpose**: Microsoft Clarity session recording and heatmaps
- **Why Chosen**: Free session recordings, privacy-compliant
- **Architecture Layer**: Core (analytics)
- **Use Cases**:
  - Session recordings
  - User behavior analysis
  - Heatmaps
  - UX optimization
  - Bug reproduction
- **Key Features**:
  - Session recordings
  - Heatmaps
  - User insights
  - Privacy-compliant (GDPR)
  - Free forever (Microsoft product)
  - Rage click detection
  - Dead click detection
- **Integration Points**:
  - Service: `lib/core/services/clarity_service.dart`
  - Initialized in: `main.dart`
  - Configuration: `.env` files (`CLARITY_PROJECT_ID`)
- **Status**: ✅ Fully initialized
- **Code Pattern**:
```dart
// Initialization
await Clarity.initialize(
  projectId: EnvironmentConfig.clarityProjectId,
);

// Set custom user ID
await Clarity.setCustomUserId(userId);

// Set custom tag
await Clarity.setCustomTag('subscription_type', 'premium');

// Set session URL (for web)
await Clarity.setCustomSessionUrl('https://myapp.com/session/$sessionId');
```

---

## 16. Cryptography

### crypto
- **Package**: `crypto` ^3.0.3
- **Category**: Cryptography
- **Priority**: Medium
- **Purpose**: Cryptographic algorithms (hashing, HMAC)
- **Why Chosen**: Pure Dart, no native dependencies
- **Architecture Layer**: Core (security)
- **Use Cases**:
  - Password hashing
  - Data integrity checks
  - HMAC signatures
  - Token generation
- **Key Features**:
  - SHA-1, SHA-256, SHA-512 hashing
  - MD5 hashing
  - HMAC
  - Pure Dart implementation (no native deps)
- **Code Pattern**:
```dart
import 'package:crypto/crypto.dart';

// SHA-256 hash
final bytes = utf8.encode('password123');
final hash = sha256.convert(bytes);
print(hash.toString()); // hex string

// HMAC
final key = utf8.encode('secret-key');
final hmac = Hmac(sha256, key);
final digest = hmac.convert(bytes);
```

---

## 17. Monetization

### purchases_flutter (RevenueCat)
- **Package**: `purchases_flutter` ^9.4.0
- **Category**: Monetization (Subscriptions)
- **Priority**: Critical
- **Purpose**: Cross-platform in-app purchase and subscription management
- **Why Chosen**:
  - Handles App Store and Play Store complexities
  - Subscription status across devices
  - Server-side receipt validation
  - Webhook support
  - Analytics dashboard
  - Better than implementing StoreKit/Billing manually
- **Architecture Layer**: Data (monetization)
- **Use Cases**:
  - In-app subscriptions
  - One-time purchases
  - Restore purchases
  - Check subscription status
  - Display paywall
  - Manage entitlements
- **Key Features**:
  - Cross-platform subscriptions (iOS, Android, Web)
  - Product management
  - Purchase restoration
  - Subscription status tracking
  - Customer info
  - Entitlements (feature access)
  - Receipt validation (server-side)
  - Webhook integration
  - Subscription offers and promo codes
  - Family sharing support
- **Integration Points**:
  - Service: `lib/core/services/revenue_cat_service.dart`
  - Initialized in: `main.dart`
  - Configuration: `.env` files (`REVENUE_CAT_API_KEY_IOS`, `REVENUE_CAT_API_KEY_ANDROID`)
  - Feature: `lib/features/subscription/`
  - Provider: `revenueCatServiceProvider`
- **Status**: ✅ Fully initialized and working (25KB service)
- **Code Pattern**:
```dart
// Initialization
await Purchases.configure(
  PurchasesConfiguration(EnvironmentConfig.revenueCatApiKey)
    ..appUserID = userId,
);

// Get offerings
final offerings = await Purchases.getOfferings();
final currentOffering = offerings.current;
final packages = currentOffering?.availablePackages;

// Purchase
try {
  final purchaseResult = await Purchases.purchasePackage(package);
  final entitlements = purchaseResult.customerInfo.entitlements.active;
  if (entitlements.containsKey('premium')) {
    // User is premium
  }
} on PlatformException catch (e) {
  final errorCode = PurchasesErrorHelper.getErrorCode(e);
  if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
    // User cancelled
  }
}

// Check subscription status
final customerInfo = await Purchases.getCustomerInfo();
final isPremium = customerInfo.entitlements.active.containsKey('premium');

// Restore purchases
final customerInfo = await Purchases.restorePurchases();

// Listen to updates
Purchases.addCustomerInfoUpdateListener((customerInfo) {
  // Handle subscription changes
});
```
- **Setup Required**:
  - RevenueCat dashboard: Create app, products, offerings
  - App Store Connect: In-app purchases
  - Google Play Console: Subscriptions
- **Entitlements Pattern**: Define feature access via entitlements, not products

### google_mobile_ads (AdMob)
- **Package**: `google_mobile_ads` ^5.1.0
- **Category**: Monetization (Advertising)
- **Priority**: High
- **Purpose**: Display Google AdMob ads (banner, interstitial, rewarded, native)
- **Why Chosen**: Largest ad network, best fill rates
- **Architecture Layer**: Data (monetization)
- **Use Cases**:
  - Banner ads (bottom/top of screen)
  - Interstitial ads (full screen)
  - Rewarded ads (video with reward)
  - Native ads (blended with content)
  - App open ads
- **Key Features**:
  - Multiple ad formats
  - Ad mediation
  - Consent management (GDPR, CCPA)
  - Test ads (for development)
  - Ad lifecycle management
  - Frequency capping
  - Ad targeting
- **Integration Points**:
  - Service: `lib/core/services/admob_service.dart` (25KB!)
  - Initialized in: `main.dart`
  - Configuration: `.env` files (Ad Unit IDs)
  - Widgets: `lib/core/widgets/ads/`
  - Provider: `adMobServiceProvider`
- **Status**: ✅ Fully initialized with GDPR consent
- **Ad Types Implemented**:
  - Banner ads with lifecycle management
  - Interstitial ads with frequency capping
  - Rewarded ads
  - Native ads
  - Ad consent dialog (GDPR/CCPA)
- **Code Pattern**:
```dart
// Initialization
await MobileAds.instance.initialize();

// Banner ad
class BannerAdWidget extends StatefulWidget {
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdMobService.instance.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return SizedBox();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

// Interstitial ad
InterstitialAd? _interstitialAd;

InterstitialAd.load(
  adUnitId: AdMobService.instance.interstitialAdUnitId,
  request: const AdRequest(),
  adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (ad) {
      _interstitialAd = ad;
      _interstitialAd?.show();
    },
    onAdFailedToLoad: (error) {
      print('Failed to load interstitial: $error');
    },
  ),
);

// GDPR consent (implemented in AdMobService)
final consentInfo = await ConsentInformation.instance.requestConsentInfoUpdate();
if (consentInfo.consentStatus == ConsentStatus.required) {
  ConsentForm.loadConsentForm((form) {
    form.show();
  });
}
```
- **Premium Users**: Ads hidden for users with active premium subscription
- **Test Ads**: Enabled in development environment
- **GDPR Compliance**: Consent dialog for EU users

---

## 18. Development Dependencies (Build Tools)

### build_runner
- **Package**: `build_runner` ^2.4.11
- **Category**: Development (Code Generation)
- **Priority**: Critical
- **Purpose**: Run code generators for multiple packages
- **Required For**: freezed, json_serializable, riverpod_generator, hive_ce_generator
- **Commands**:
  - `dart run build_runner build --delete-conflicting-outputs` - Generate once
  - `dart run build_runner watch --delete-conflicting-outputs` - Watch mode
  - `dart run build_runner clean` - Clean generated files

### flutter_gen_runner
- **Package**: `flutter_gen_runner` (latest compatible)
- **Category**: Development (Asset Generation)
- **Priority**: High
- **Purpose**: Generate type-safe asset classes
- **Benefits**:
  - Type-safe asset access
  - Auto-completion for assets
  - Compile-time checking
  - No string typos
- **Generated File**: `lib/gen/assets.gen.dart`
- **Usage**:
```dart
// Instead of: AssetImage('assets/images/logo.png')
// Use: Assets.images.logo.image()

// Instead of: SvgPicture.asset('assets/icons/heart.svg')
// Use: Assets.icons.heart.svg()
```

### freezed
- **Package**: `freezed` ^3.2.0
- **Category**: Development (Code Generator)
- **Priority**: Critical
- **Purpose**: Generate code for freezed_annotation
- **Generates**: `*.freezed.dart` files

### json_serializable
- **Package**: `json_serializable` ^6.8.0
- **Category**: Development (Code Generator)
- **Priority**: Critical
- **Purpose**: Generate JSON serialization code
- **Generates**: `*.g.dart` files (toJson, fromJson)

### riverpod_generator
- **Package**: `riverpod_generator` (latest compatible)
- **Category**: Development (Code Generator)
- **Priority**: Medium
- **Purpose**: Generate Riverpod providers from annotations
- **Generates**: `*.g.dart` files for providers

### hive_ce_generator
- **Package**: `hive_ce_generator` ^1.6.0
- **Category**: Development (Code Generator)
- **Priority**: Critical
- **Purpose**: Generate Hive type adapters
- **Generates**: Type adapters for @HiveType classes
- **Also Generates**: `hive_registrar.g.dart` (adapter registration)

---

## 19. App Configuration Tools

### flutter_launcher_icons
- **Package**: `flutter_launcher_icons` ^0.14.4
- **Category**: Development (Assets)
- **Priority**: High
- **Purpose**: Generate launcher icons for all platforms
- **Configuration**: `pubspec.yaml` > `flutter_launcher_icons`
- **Command**: `dart run flutter_launcher_icons`
- **Generates**: Platform-specific icons from single source image
- **Platforms**: Android, iOS, Web, macOS, Windows, Linux

### flutter_native_splash
- **Package**: `flutter_native_splash` ^2.4.0
- **Category**: Development (Splash)
- **Priority**: High
- **Purpose**: Generate native splash screens
- **Configuration**: `pubspec.yaml` > `flutter_native_splash`
- **Command**: `dart run flutter_native_splash:create`
- **Features**:
  - Native splash screens (not Flutter widgets)
  - Android 12+ support
  - Background color customization
  - Image positioning
  - Branding mode

### flutter_flavorizr
- **Package**: `flutter_flavorizr` ^2.4.1
- **Category**: Development (Build Configuration)
- **Priority**: Critical
- **Purpose**: Manage multiple app flavors (dev, staging, production)
- **Configuration**: `flavorizr.yaml`
- **Command**: `flutter pub run flutter_flavorizr -f`
- **Features**:
  - Multi-flavor support
  - Package name variants
  - App name variants
  - Icon variants
  - IDE run configurations
  - Android and iOS configuration
- **Flavors**:
  - **dev**: `com.example.fluttertemplate.dev`, "App (Dev)"
  - **staging**: `com.example.fluttertemplate.staging`, "App (Staging)"
  - **production**: `com.example.fluttertemplate`, "App"

---

## 20. Testing Dependencies

### mocktail
- **Package**: `mocktail` ^1.0.4
- **Category**: Testing (Mocking)
- **Priority**: High
- **Purpose**: Create mock objects for unit tests
- **Why Chosen**: No code generation required (vs mockito)
- **Use Cases**:
  - Unit test mocking
  - Repository mocks
  - Service mocks
- **Key Features**:
  - Type-safe mocking
  - No code generation
  - Verification
  - Stubbing
  - Argument matchers
- **Code Pattern**:
```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  test('sign in success', () async {
    when(() => mockRepository.signIn(any(), any()))
      .thenAnswer((_) async => UserModel(id: '1', email: 'test@test.com'));

    final user = await mockRepository.signIn('email', 'pass');

    expect(user.id, '1');
    verify(() => mockRepository.signIn('email', 'pass')).called(1);
  });
}
```

### mockito
- **Package**: `mockito` ^5.4.4
- **Category**: Testing (Mocking with Codegen)
- **Priority**: Medium
- **Purpose**: Generate mock classes for testing
- **Use Cases**: When mocktail isn't sufficient
- **Requires**: Code generation with build_runner

### fake_async
- **Package**: `fake_async` ^1.3.1
- **Category**: Testing (Async)
- **Priority**: Medium
- **Purpose**: Test async code synchronously
- **Use Cases**:
  - Test timers
  - Test delays
  - Test async operations deterministically
- **Code Pattern**:
```dart
fakeAsync((async) {
  var called = false;
  Timer(Duration(seconds: 5), () => called = true);

  async.elapse(Duration(seconds: 5));
  expect(called, isTrue);
});
```

### network_image_mock
- **Package**: `network_image_mock` ^2.1.1
- **Category**: Testing (Widget)
- **Priority**: Medium
- **Purpose**: Mock network images in widget tests
- **Why Needed**: Prevents network calls during tests
- **Code Pattern**:
```dart
testWidgets('image loads', (tester) async {
  mockNetworkImagesFor(() async {
    await tester.pumpWidget(
      MaterialApp(
        home: Image.network('https://example.com/image.png'),
      ),
    );
  });
});
```

### golden_toolkit
- **Package**: `golden_toolkit` ^0.15.0
- **Category**: Testing (Golden Files)
- **Priority**: Medium
- **Purpose**: Create and compare golden files for widget tests
- **Use Cases**:
  - Visual regression testing
  - UI consistency across devices
  - Screenshot comparison
- **Key Features**:
  - Device builder (test multiple screen sizes)
  - Multi-screen testing
  - Golden file comparison
  - Custom fonts support
- **Code Pattern**:
```dart
testGoldens('button renders correctly', (tester) async {
  await tester.pumpWidgetBuilder(
    AppButton(
      label: 'Submit',
      onPressed: () {},
    ),
  );

  await screenMatchesGolden(tester, 'button_default');
});
```

### test
- **Package**: `test` ^1.25.8
- **Category**: Testing (Core)
- **Priority**: Critical
- **Purpose**: Core Dart testing framework
- **Required**: For all test types
- **Included**: With flutter_test

### patrol
- **Package**: `patrol` ^3.12.1
- **Category**: Testing (Integration)
- **Priority**: High
- **Purpose**: UI testing with native automation
- **Why Chosen**: Better than integration_test (native features)
- **Use Cases**:
  - End-to-end testing
  - Native permission dialogs
  - Native features testing
  - Hot restart testing
- **Key Features**:
  - Native automation (permission dialogs)
  - Native dialogs handling
  - Hot restart testing
  - Better than flutter_driver
  - Custom finders
- **Command**: `patrol test`

---

## 🎯 Package Integration Patterns

### State Management Flow
```
UI Widget
  ↓ ref.watch()
AsyncNotifier Controller
  ↓ calls
Repository Implementation
  ↓ uses
Service/API
```

### Data Flow Pattern
```
External Source (API/Firebase/Supabase)
  ↓ raw data
Repository (converts to domain entities)
  ↓ domain models
Controller (manages state with AsyncValue)
  ↓ exposes state
UI (consumes via ref.watch)
```

### Error Handling Pattern
```
Service throws Exception
  ↓ caught by
Repository (converts to Failure)
  ↓ wrapped by
Controller (AsyncValue.error)
  ↓ displayed by
UI (.when() error state)
```

### Code Generation Workflow
```
1. Write annotated code (@freezed, @JsonSerializable, @HiveType)
2. Run: dart run build_runner build --delete-conflicting-outputs
3. Generated files: *.freezed.dart, *.g.dart
4. Import and use generated code
```

---

## 📊 Package Dependency Graph

### Critical Path Dependencies
```
App Initialization:
  flutter_dotenv (first)
    ↓
  EnvironmentConfig
    ↓
  ┌─────────────────┬──────────────┬───────────────┐
  supabase_flutter  hive_ce       sentry_flutter  MobileAds
  ↓                 ↓              ↓               ↓
  Repositories      Storage        ErrorTracking   Monetization
```

### State Management Stack
```
flutter_riverpod (base)
  ↓
riverpod_annotation (optional code gen)
  ↓
AsyncNotifier Controllers
  ↓
UI Widgets (ConsumerWidget)
```

### Data Persistence Stack
```
flutter_secure_storage (encryption keys)
  ↓
hive_ce + hive_ce_flutter (database)
  ↓
HiveService (abstraction)
  ↓
Repositories (usage)
```

---

## 🚀 Quick Reference Tables

### Package by Architecture Layer

| Layer | Packages |
|-------|----------|
| **Domain** | freezed_annotation |
| **Data** | supabase_flutter, firebase_*, dio, hive_ce, purchases_flutter |
| **Presentation** | flutter_riverpod, go_router, google_fonts, flutter_animate, easy_localization |
| **Core Services** | sentry_flutter, clarity_flutter, flutter_dotenv, logger, permission_handler |
| **Testing** | mocktail, patrol, golden_toolkit |
| **Build Tools** | build_runner, flutter_gen_runner, freezed, json_serializable |

### Package by Priority

| Priority | Count | Examples |
|----------|-------|----------|
| **Critical** | 15 | flutter_riverpod, supabase_flutter, hive_ce, dio, go_router, freezed |
| **High** | 20 | sentry_flutter, permission_handler, google_sign_in, image_picker |
| **Medium** | 15 | flutter_animate, shimmer, share_plus, device_info_plus |
| **Low** | 10 | firebase_performance, crypto |

### Package by Feature

| Feature | Core Packages |
|---------|---------------|
| **Authentication** | firebase_auth, supabase_flutter, google_sign_in, sign_in_with_apple, local_auth |
| **Monetization** | purchases_flutter, google_mobile_ads |
| **State Management** | flutter_riverpod, riverpod_annotation |
| **Navigation** | go_router |
| **Local Storage** | hive_ce, flutter_secure_storage |
| **Networking** | dio, cached_network_image, connectivity_plus |
| **Analytics** | firebase_analytics, clarity_flutter, sentry_flutter |
| **UI/UX** | google_fonts, flutter_animate, shimmer |

---

## 📝 Implementation Checklist

### New Project Setup
- [ ] Run `flutter pub get`
- [ ] Configure `.env.dev`, `.env.staging`, `.env.production`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Configure Supabase project (optional Firebase)
- [ ] Set up RevenueCat products
- [ ] Configure AdMob ad units
- [ ] Set up Sentry project
- [ ] Configure Clarity project
- [ ] Generate icons: `dart run flutter_launcher_icons`
- [ ] Generate splash: `dart run flutter_native_splash:create`
- [ ] Run flavors: `flutter pub run flutter_flavorizr -f`
- [ ] Configure platform-specific permissions (Info.plist, AndroidManifest.xml)
- [ ] Test on all target platforms

### Firebase Setup (if enabling)
- [ ] Create Firebase project
- [ ] Download `google-services.json` (Android)
- [ ] Download `GoogleService-Info.plist` (iOS)
- [ ] Uncomment Firebase initialization in `firebase_service.dart`
- [ ] Configure Firebase services in console

### Testing Setup
- [ ] Write unit tests for repositories
- [ ] Write widget tests for components
- [ ] Write integration tests for user flows
- [ ] Run `patrol test` for e2e tests
- [ ] Generate test coverage

---

## 🔄 Update Strategy

### Regular Updates (Monthly)
- Check for package updates: `flutter pub outdated`
- Update non-breaking: `flutter pub upgrade --major-versions`
- Test thoroughly after updates
- Update this documentation

### Breaking Changes
- Read CHANGELOG for each package
- Check migration guides
- Update deprecated APIs
- Run full test suite
- Test on all platforms

### Security Updates
- Monitor GitHub security alerts
- Update immediately for security patches
- Test auth flow after updates
- Verify encryption still works

---

## 🎓 Best Practices

### Package Management
1. **Pin critical versions** - Use exact versions for stability
2. **Regular updates** - Update packages monthly
3. **Test after updates** - Full regression testing
4. **Lock file** - Commit `pubspec.lock` for consistency
5. **Minimal dependencies** - Only add what you need

### Code Generation
1. **Run after changes** - Always run build_runner after model changes
2. **Clean when stuck** - `flutter clean && flutter pub get`
3. **Watch mode for development** - Use `watch` during active development
4. **Commit generated files** - Include `.g.dart` files in git

### Environment Configuration
1. **Never commit secrets** - Add `.env*` to `.gitignore`
2. **Use fallbacks** - Provide defaults for optional configs
3. **Validate on startup** - Check required configs in main
4. **Document requirements** - List all required env vars

### Testing
1. **Mock external dependencies** - Use mocktail for all external services
2. **Test state changes** - Verify all AsyncNotifier state transitions
3. **Golden tests for UI** - Visual regression for critical components
4. **Integration tests** - Cover critical user flows

---

## 📚 Additional Resources

- **Flutter Packages**: https://pub.dev
- **Riverpod Docs**: https://riverpod.dev
- **GoRouter Guide**: https://pub.dev/packages/go_router
- **Supabase Flutter**: https://supabase.com/docs/reference/dart
- **Firebase Flutter**: https://firebase.google.com/docs/flutter
- **RevenueCat Docs**: https://www.revenuecat.com/docs
- **AdMob Flutter**: https://developers.google.com/admob/flutter

---

## 🎯 Summary

This template includes **60+ carefully selected packages** organized into **15 categories**, providing a complete foundation for production Flutter apps. All packages are production-ready, actively maintained, and follow Flutter best practices.

### Key Strengths
- ✅ **Complete**: Everything needed for production app
- ✅ **Tested**: Proven package combinations
- ✅ **Scalable**: Clean architecture supports growth
- ✅ **Maintainable**: Clear organization and patterns
- ✅ **Type-Safe**: Compile-time safety with code generation
- ✅ **Cross-Platform**: iOS, Android, Web, Desktop ready

### Customization Notes
- Firebase is **disabled by default** - enable if needed
- AdMob can be disabled via environment config
- Packages can be removed if features aren't needed
- All packages are optional except core ones (Riverpod, Freezed, GoRouter)

---

*This documentation is designed to be LLM-friendly for requirement generation, project analysis, and architectural understanding. Use it to replicate, customize, or understand the template structure.*

**Last Updated**: 2025-10-15
**Template Version**: 1.0.0
**Minimum Flutter**: 3.9.0
