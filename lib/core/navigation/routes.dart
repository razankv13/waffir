/// Application routes constants
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Authentication routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/auth/otp-verification';

  // Main app routes
  static const String home = '/deals';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Feature routes
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String sampleList = '/sample-list';
  static const String help = '/help';
  static const String about = '/about';

  // Landing page routes
  static const String deals = '/deals';
  static const String hotDeals = '/deals'; // Alias for deals
  static const String stores = '/stores';
  static const String creditCards = '/credit-cards';
  static const String addCreditCard = '/credit-cards/add';

  // Product routes
  static const String productDetail = '/product/:id';
  static const String storeDetail = '/store/:id';

  // Nested routes
  static const String profileEdit = '/profile/edit';
  static const String profilePersonalDetails = '/profile/personal-details';
  static const String profileSavedDeals = '/profile/saved-deals';
  static const String profileChangeCity = '/profile/change-city';
  static const String profileLanguage = '/profile/language';
  static const String profileHelpCenter = '/profile/help-center';
  static const String profileDeleteAccount = '/profile/delete-account';
  static const String themeSettings = '/settings/theme';
  static const String privacySettings = '/settings/privacy';
  static const String accountSettings = '/settings/account';
  static const String notificationSettings = '/settings/notifications';

  // Error routes
  static const String error = '/error';
  static const String notFound = '/404';

  // Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String citySelection = '/city-selection';
  static const String accountDetails = '/auth/account-details';

  // Subscription routes
  static const String paywall = '/subscription/paywall';
  static const String subscriptionManagement = '/subscription/management';

  /// Get all authentication routes
  static List<String> get authRoutes => [login, signup, forgotPassword, resetPassword];

  /// Get all main app routes (requiring authentication)
  static List<String> get protectedRoutes => [
    home,
    profile,
    settings,
    search,
    notifications,
    sampleList,
    profileEdit,
    profilePersonalDetails,
    profileSavedDeals,
    profileChangeCity,
    profileLanguage,
    profileHelpCenter,
    profileDeleteAccount,
    themeSettings,
    privacySettings,
    accountSettings,
    notificationSettings,
    deals,
    stores,
    creditCards,
    addCreditCard,
    productDetail,
    storeDetail,
  ];

  /// Get all public routes (no authentication required)
  static List<String> get publicRoutes => [
    error,
    notFound,
    help,
    about,
    splash,
    onboarding,
    welcome,
  ];
}

/// Route names for named navigation
class AppRouteNames {
  // Private constructor to prevent instantiation
  AppRouteNames._();

  // Authentication route names
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String otpVerification = 'otp-verification';

  // Main app route names
  static const String home = 'home';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // Feature route names
  static const String search = 'search';
  static const String notifications = 'notifications';
  static const String sampleList = 'sample-list';
  static const String help = 'help';
  static const String about = 'about';

  // Landing page route names
  static const String deals = 'deals';
  static const String hotDeals = 'hot-deals';
  static const String stores = 'stores';
  static const String creditCards = 'credit-cards';
  static const String addCreditCard = 'add-credit-card';

  // Product route names
  static const String productDetail = 'product-detail';
  static const String storeDetail = 'store-detail';

  // Nested route names
  static const String profileEdit = 'profile-edit';
  static const String profilePersonalDetails = 'profile-personal-details';
  static const String profileSavedDeals = 'profile-saved-deals';
  static const String profileChangeCity = 'profile-change-city';
  static const String profileLanguage = 'profile-language';
  static const String profileHelpCenter = 'profile-help-center';
  static const String profileDeleteAccount = 'profile-delete-account';
  static const String themeSettings = 'theme-settings';
  static const String privacySettings = 'privacy-settings';
  static const String accountSettings = 'account-settings';
  static const String notificationSettings = 'notification-settings';

  // Error route names
  static const String error = 'error';
  static const String notFound = 'not-found';

  // Onboarding route names
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String welcome = 'welcome';
  static const String citySelection = 'city-selection';
  static const String accountDetails = 'account-details';

  // Subscription route names
  static const String paywall = 'paywall';
  static const String subscriptionManagement = 'subscription-management';
}

/// Route parameters
class AppRouteParams {
  // Private constructor to prevent instantiation
  AppRouteParams._();

  // Common parameters
  static const String id = 'id';
  static const String userId = 'userId';
  static const String token = 'token';
  static const String email = 'email';

  // Error parameters
  static const String error = 'error';
  static const String message = 'message';

  // Search parameters
  static const String query = 'query';
  static const String category = 'category';

  // Pagination parameters
  static const String page = 'page';
  static const String limit = 'limit';
}

/// Query parameters
class AppQueryParams {
  // Private constructor to prevent instantiation
  AppQueryParams._();

  // Navigation
  static const String returnTo = 'returnTo';
  static const String redirect = 'redirect';

  // Auth flow
  static const String emailVerified = 'emailVerified';
  static const String passwordReset = 'passwordReset';

  // Deep linking
  static const String deepLink = 'deepLink';
  static const String source = 'source';

  // Filters and sorting
  static const String sortBy = 'sortBy';
  static const String sortOrder = 'sortOrder';
  static const String filter = 'filter';

  // UI state
  static const String tab = 'tab';
  static const String section = 'section';
}
