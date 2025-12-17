class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Flutter Template';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'A production-ready Flutter template with clean architecture';

  // Developer Information
  static const String developerName = 'Flutter Template Team';
  static const String developerEmail = 'contact@fluttertemplate.dev';
  static const String supportEmail = 'support@fluttertemplate.dev';

  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';
  static const int apiTimeout = 30000; // 30 seconds
  static const int connectionTimeout = 15000; // 15 seconds

  // Authentication
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String biometricKey = 'biometric_enabled';
  static const int tokenExpiryBuffer = 300; // 5 minutes in seconds

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingKey = 'onboarding_completed';
  static const String notificationsKey = 'notifications_enabled';
  static const String firstLaunchKey = 'first_launch';
  static const String lastSyncKey = 'last_sync_time';

  // Hive Box Names
  static const String settingsBoxName = 'settings';
  static const String userBoxName = 'user';
  static const String cacheBoxName = 'cache';
  static const String secureBoxName = 'secure';

  // Animation Durations (in milliseconds)
  static const int shortAnimationDuration = 150;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  static const int extraLongAnimationDuration = 1000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int initialPage = 1;

  // Image Configuration
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const double imageQuality = 0.8;
  static const int thumbnailSize = 200;
  // TODO: Replace with Assets.images.defaultAvatar.path when asset is added
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';
  // TODO: Replace with Assets.images.placeholder.path when asset is added
  static const String placeholderImagePath = 'assets/images/placeholder.png';

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;
  static const int maxMessageLength = 1000;

  // Social Login
  static const String googleClientIdAndroid = 'your-android-client-id';
  static const String googleClientIdIOS = 'your-ios-client-id';
  static const String googleClientIdWeb = 'your-web-client-id';
  static const String appleClientId = 'your-apple-client-id';

  // Deep Links
  static const String deepLinkScheme = 'fluttertemplate';
  static const String deepLinkHost = 'app';

  // External URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportUrl = 'https://example.com/support';
  static const String websiteUrl = 'https://example.com';

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again';
  static const String serverErrorMessage = 'Something went wrong on our end. Please try again later';
  static const String unknownErrorMessage = 'An unexpected error occurred. Please try again';
  static const String timeoutErrorMessage = 'Request timed out. Please try again';
  static const String unauthorizedErrorMessage = 'You are not authorized to perform this action';

  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String passwordResetSuccessMessage = 'Password reset link sent to your email';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully';

  // Feature Flags (for development)
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableDebugMode = true;
  static const bool enableBiometrics = true;
  static const bool enableNotifications = true;
  static const bool enableRemoteConfig = true;
  static const bool enableMessaging = true;

  // Firebase specific info (using existing app info)
  static const String buildNumber = '1';
  static const String environment = 'development'; // development, staging, production

  // Platform Specific
  static const Map<String, String> androidPackageName = {
    'dev': 'com.example.flutter_template.dev',
    'staging': 'com.example.flutter_template.staging',
    'production': 'com.example.flutter_template',
  };

  static const Map<String, String> iosBundleId = {
    'dev': 'com.example.flutter-template.dev',
    'staging': 'com.example.flutter-template.staging',
    'production': 'com.example.flutter-template',
  };

  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$';
  static const String phoneRegex = r'^\+?[1-9]\d{4,14}$';
  static const String alphanumericRegex = r'^[a-zA-Z0-9]+$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,30}$';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Locale Support
  static const List<String> supportedLanguages = ['en', 'es', 'fr'];
  static const String defaultLanguage = 'en';
  static const String fallbackLanguage = 'en';

  // Cache Configuration
  static const int cacheExpiryHours = 24;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const String cacheDirectory = 'cache';

  // Notification Configuration
  static const String defaultNotificationChannel = 'default';
  static const String highPriorityNotificationChannel = 'high_priority';
  // TODO: Replace with Assets.icons.notificationIcon.path when asset is added
  static const String notificationIconPath = 'assets/icons/notification_icon.png';

  // Development
  static const bool isDebugMode = true; // Will be overridden by build config
  static const bool showPerformanceOverlay = false;
  static const bool enableLogging = true;


  // Biometric Authentication
  static const String biometricReason = 'Please authenticate to access your account';
  static const String biometricTitle = 'Biometric Authentication';
  static const String biometricSubtitle = 'Use your fingerprint or face to authenticate';

  // App Store Information
  static const String androidAppId = 'com.example.flutter_template';
  static const String iosAppId = '123456789';
  static const String appStoreUrl = 'https://apps.apple.com/app/id123456789';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.flutter_template';

  // Analytics Events
  static const String loginEvent = 'login';
  static const String registerEvent = 'register';
  static const String logoutEvent = 'logout';
  static const String purchaseEvent = 'purchase';
  static const String shareEvent = 'share';
  static const String searchEvent = 'search';

  // Environment Variables Keys
  static const String supabaseUrlKey = 'SUPABASE_URL';
  static const String supabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const String sentryDsnKey = 'SENTRY_DSN';
  static const String environmentKey = 'ENVIRONMENT';
  static const String revenueCatApiKey = 'REVENUECAT_API_KEY';
}
