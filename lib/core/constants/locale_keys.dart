abstract class LocaleKeys {
  static const app = _AppKeys();
  static const navigation = _NavigationKeys();
  static const auth = _AuthKeys();
  static const validation = _ValidationKeys();
  static const buttons = _ButtonsKeys();
  static const settings = _SettingsKeys();
  static const errors = _ErrorsKeys();
  static const success = _SuccessKeys();
  static const dialogs = _DialogsKeys();
  static const loading = _LoadingKeys();
  static const deals = _DealsKeys();
  static const dealDetails = _DealDetailsKeys();
  static const notifications = _NotificationsKeys();
  static const creditCards = _CreditCardsKeys();
  static const stores = _StoresKeys();
  static const onboarding = _OnboardingKeys();
  static const subscription = _SubscriptionKeys();
  static const cities = _CitiesKeys();
  static const accountDetails = _AccountDetailsKeys();
  static const profile = _ProfileKeys();
  static const common = _CommonKeys();

  static const chooseLanguage = 'choose_language';
  static const productPage = _ProductPageKeys();
}

class _CommonKeys {
  const _CommonKeys();
  final ok = 'common.ok';
  final cancel = 'common.cancel';
  final retry = 'common.retry';
  final yes = 'common.yes';
  final no = 'common.no';
}

class _AppKeys {
  const _AppKeys();
  final name = 'app.name';
  final welcome = 'app.welcome';
  final description = 'app.description';
}

class _NavigationKeys {
  const _NavigationKeys();
  final home = 'navigation.home';
  final profile = 'navigation.profile';
  final settings = 'navigation.settings';
  final about = 'navigation.about';
}

class _AuthKeys {
  const _AuthKeys();
  final login = 'auth.login';
  final register = 'auth.register';
  final logout = 'auth.logout';
  final forgotPassword = 'auth.forgotPassword';
  final email = 'auth.email';
  final password = 'auth.password';
  final confirmPassword = 'auth.confirmPassword';
  final firstName = 'auth.firstName';
  final lastName = 'auth.lastName';
  final signInWithGoogle = 'auth.signInWithGoogle';
  final signInWithApple = 'auth.signInWithApple';
  final googleSignInFailed = 'auth.googleSignInFailed';
  final appleSignInFailed = 'auth.appleSignInFailed';
  final dontHaveAccount = 'auth.dontHaveAccount';
  final alreadyHaveAccount = 'auth.alreadyHaveAccount';
  final resetPassword = 'auth.resetPassword';
  final backToLogin = 'auth.backToLogin';
  final loginSuccessful = 'auth.loginSuccessful';
  final registrationSuccessful = 'auth.registrationSuccessful';
  final resetPasswordEmailSent = 'auth.resetPasswordEmailSent';
  final welcomeToWaffir = 'auth.welcomeToWaffir';
  final loginSubtitle = 'auth.loginSubtitle';
  final phoneHint = 'auth.phoneHint';
  final or = 'auth.or';
  final continueWithGoogle = 'auth.continueWithGoogle';
  final continueWithApple = 'auth.continueWithApple';
  final phoneNumber = 'auth.phoneNumber';
  final enterPhoneNumber = 'auth.enterPhoneNumber';
  final otpTitle = 'auth.otpTitle';
  final otpSubtitle = 'auth.otpSubtitle';
  final changeNumber = 'auth.changeNumber';
  final resendCode = 'auth.resendCode';
  final verify = 'auth.verify';
  final resendCodeIn = 'auth.resendCodeIn';
  final codeSentSuccess = 'auth.codeSentSuccess';
  final otpVerificationFailed = 'auth.otpVerificationFailed';
  final verificationIdMissing = 'auth.verificationIdMissing';
  final codeTimeout = 'auth.codeTimeout';
}

class _ValidationKeys {
  const _ValidationKeys();
  final required = 'validation.required';
  final invalidEmail = 'validation.invalidEmail';
  final passwordTooShort = 'validation.passwordTooShort';
  final passwordsDoNotMatch = 'validation.passwordsDoNotMatch';
  final invalidPhone = 'validation.invalidPhone';
  final phoneTooShort = 'validation.phoneTooShort';
  final phoneTooLong = 'validation.phoneTooLong';
  final selectCity = 'validation.selectCity';
}

class _ButtonsKeys {
  const _ButtonsKeys();
  final save = 'buttons.save';
  final cancel = 'buttons.cancel';
  final delete = 'buttons.delete';
  final edit = 'buttons.edit';
  final update = 'buttons.update';
  final submit = 'buttons.submit';
  final confirm = 'buttons.confirm';
  final getStarted = 'buttons.getStarted';
  final retry = 'buttons.retry';
  final close = 'buttons.close';
  final next = 'buttons.next';
  final previous = 'buttons.previous';
  final finish = 'buttons.finish';
  final accept = 'buttons.accept';
  final reject = 'buttons.reject';
  final continueBtn = 'buttons.continueBtn';
  final copy = 'buttons.copy';
  final readMore = 'buttons.readMore';
  final readLess = 'buttons.readLess';
}

class _DealDetailsKeys {
  const _DealDetailsKeys();
  final title = 'dealDetails.title';
  final actions = const _DealDetailsActionsKeys();
  final labels = const _DealDetailsLabelsKeys();
  final errors = const _DealDetailsErrorsKeys();
  final success = const _DealDetailsSuccessKeys();
}

class _DealDetailsActionsKeys {
  const _DealDetailsActionsKeys();
  final share = 'dealDetails.actions.share';
  final shopNow = 'dealDetails.actions.shopNow';
}

class _DealDetailsLabelsKeys {
  const _DealDetailsLabelsKeys();
  final promoCode = 'dealDetails.labels.promoCode';
  final terms = 'dealDetails.labels.terms';
}

class _DealDetailsErrorsKeys {
  const _DealDetailsErrorsKeys();
  final loadFailed = 'dealDetails.errors.loadFailed';
  final couldNotOpenLink = 'dealDetails.errors.couldNotOpenLink';
  final noLongerAvailable = 'dealDetails.errors.noLongerAvailable';
}

class _DealDetailsSuccessKeys {
  const _DealDetailsSuccessKeys();
  final promoCodeCopied = 'dealDetails.success.promoCodeCopied';
}

class _SettingsKeys {
  const _SettingsKeys();
  final title = 'settings.title';
  final appearance = 'settings.appearance';
  final theme = 'settings.theme';
  final light = 'settings.light';
  final dark = 'settings.dark';
  final system = 'settings.system';
  final language = 'settings.language';
  final notifications = 'settings.notifications';
  final privacy = 'settings.privacy';
  final about = 'settings.about';
  final version = 'settings.version';
  final themeSettings = 'settings.themeSettings';
}

class _ErrorsKeys {
  const _ErrorsKeys();
  final networkError = 'errors.networkError';
  final serverError = 'errors.serverError';
  final unknownError = 'errors.unknownError';
  final unknown = 'errors.unknown';
  final timeoutError = 'errors.timeoutError';
  final unauthorizedError = 'errors.unauthorizedError';
  final saveSelection = 'errors.saveSelection';
  final authError = 'errors.authError';
  final validationError = 'errors.validationError';
  final storageError = 'errors.storageError';
  final permissionError = 'errors.permissionError';
  final cacheError = 'errors.cacheError';
  final forbiddenError = 'errors.forbiddenError';
  final notFoundError = 'errors.notFoundError';
  final conflictError = 'errors.conflictError';
  final tooManyRequestsError = 'errors.tooManyRequestsError';
  final internalServerError = 'errors.internalServerError';
  final serviceUnavailableError = 'errors.serviceUnavailableError';
  final deviceError = 'errors.deviceError';
  final platformError = 'errors.platformError';
  final fileSystemError = 'errors.fileSystemError';
  final encryptionError = 'errors.encryptionError';
  final biometricError = 'errors.biometricError';
  final locationError = 'errors.locationError';
  final cameraError = 'errors.cameraError';
  final galleryError = 'errors.galleryError';
  final notificationError = 'errors.notificationError';
  final shareError = 'errors.shareError';
  final urlLauncherError = 'errors.urlLauncherError';
  final connectivityError = 'errors.connectivityError';
  final parseError = 'errors.parseError';
  final databaseError = 'errors.databaseError';
  final migrationError = 'errors.migrationError';
  final syncError = 'errors.syncError';
  final featureNotAvailableError = 'errors.featureNotAvailableError';
  final versionMismatchError = 'errors.versionMismatchError';
  final maintenanceModeError = 'errors.maintenanceModeError';
  final rateLimitError = 'errors.rateLimitError';
  final subscriptionError = 'errors.subscriptionError';
  final paymentError = 'errors.paymentError';
  final contentNotAvailableError = 'errors.contentNotAvailableError';
  final quotaExceededError = 'errors.quotaExceededError';
  final configurationError = 'errors.configurationError';
  final dependencyError = 'errors.dependencyError';
}

class _SuccessKeys {
  const _SuccessKeys();
  final dataSaved = 'success.dataSaved';
  final saved = 'success.saved';
  final profileUpdated = 'success.profileUpdated';
  final settingsUpdated = 'success.settingsUpdated';
}

class _DialogsKeys {
  const _DialogsKeys();
  final confirmation = 'dialogs.confirmation';
  final areYouSure = 'dialogs.areYouSure';
  final deleteConfirmation = 'dialogs.deleteConfirmation';
  final logoutConfirmation = 'dialogs.logoutConfirmation';
  final yes = 'dialogs.yes';
  final no = 'dialogs.no';
}

class _LoadingKeys {
  const _LoadingKeys();
  final pleaseWait = 'loading.pleaseWait';
  final loading = 'loading.loading';
  final saving = 'loading.saving';
  final updating = 'loading.updating';
  final processing = 'loading.processing';
}

class _DealsKeys {
  const _DealsKeys();
  final title = 'deals.title';
  final searchHint = 'deals.searchHint';
  final filterComingSoon = 'deals.filterComingSoon';
  final loadError = 'deals.loadError';
  final loadErrorShort = 'deals.loadErrorShort';
  final storeFallback = 'deals.storeFallback';
  final categories = const _DealsCategoriesKeys();
  final badges = const _DealsBadgesKeys();
  final actions = const _DealsActionsKeys();
  final empty = const _DealsEmptyKeys();
}

class _DealsCategoriesKeys {
  const _DealsCategoriesKeys();
  final forYou = 'deals.categories.forYou';
  final frontPage = 'deals.categories.frontPage';
  final popular = 'deals.categories.popular';
}

class _DealsBadgesKeys {
  const _DealsBadgesKeys();
  final hot = 'deals.badges.hot';
  final newBadge = 'deals.badges.new';
  final featured = 'deals.badges.featured';
}

class _DealsActionsKeys {
  const _DealsActionsKeys();
  final likeComingSoon = 'deals.actions.likeComingSoon';
  final commentComingSoon = 'deals.actions.commentComingSoon';
}

class _DealsEmptyKeys {
  const _DealsEmptyKeys();
  final title = 'deals.empty.title';
  final categorySuggestion = 'deals.empty.categorySuggestion';
  final searchSuggestion = 'deals.empty.searchSuggestion';
}

class _NotificationsKeys {
  const _NotificationsKeys();
  final header = const _NotificationsHeaderKeys();
  final filter = const _NotificationsFilterKeys();
  final search = const _NotificationsSearchKeys();
  final sections = const _NotificationsSectionsKeys();
  final empty = const _NotificationsEmptyKeys();
  final snackbar = const _NotificationsSnackbarKeys();
}

class _NotificationsHeaderKeys {
  const _NotificationsHeaderKeys();
  final title = 'notifications.header.title';
  final subtitle = 'notifications.header.subtitle';
}

class _NotificationsFilterKeys {
  const _NotificationsFilterKeys();
  final dealAlerts = 'notifications.filter.dealAlerts';
  final notifications = 'notifications.filter.notifications';
}

class _NotificationsSearchKeys {
  const _NotificationsSearchKeys();
  final label = 'notifications.search.label';
  final placeholder = 'notifications.search.placeholder';
}

class _NotificationsSectionsKeys {
  const _NotificationsSectionsKeys();
  final myDealAlerts = 'notifications.sections.myDealAlerts';
  final popularAlerts = 'notifications.sections.popularAlerts';
}

class _NotificationsEmptyKeys {
  const _NotificationsEmptyKeys();
  final dealAlerts = 'notifications.empty.dealAlerts';
  final popularAlerts = 'notifications.empty.popularAlerts';
  final systemNotifications = 'notifications.empty.systemNotifications';
}

class _NotificationsSnackbarKeys {
  const _NotificationsSnackbarKeys();
  final view = 'notifications.snackbar.view';
  final subscribed = 'notifications.snackbar.subscribed';
  final unsubscribed = 'notifications.snackbar.unsubscribed';
}

class _CreditCardsKeys {
  const _CreditCardsKeys();
  final title = 'creditCards.title';
  final subtitle = 'creditCards.subtitle';
  final searchHint = 'creditCards.searchHint';
  final filterComingSoon = 'creditCards.filterComingSoon';
  final loading = 'creditCards.loading';
  final empty = const _CreditCardsEmptyKeys();
  final error = const _CreditCardsErrorKeys();
}

class _CreditCardsEmptyKeys {
  const _CreditCardsEmptyKeys();
  final title = 'creditCards.empty.title';
  final description = 'creditCards.empty.description';
}

class _CreditCardsErrorKeys {
  const _CreditCardsErrorKeys();
  final title = 'creditCards.error.title';
  final description = 'creditCards.error.description';
  final retry = 'creditCards.error.retry';
}

class _StoresKeys {
  const _StoresKeys();
  final searchHint = 'stores.searchHint';
  final filterComingSoon = 'stores.filterComingSoon';
  final loadError = 'stores.loadError';
  final loadErrorShort = 'stores.loadErrorShort';
  final otherLocations = 'stores.otherLocations';
  final section = const _StoreSectionKeys();
  final empty = const _StoreEmptyKeys();
  final categories = const _StoreCategoriesKeys();
  final count = 'stores.count';
  final detail = const _StoreDetailKeys();
}

class _StoreDetailKeys {
  const _StoreDetailKeys();
  final notFound = 'stores.detail.notFound';
  final banner = const _StoreDetailBannerKeys();
  final discountTitle = 'stores.detail.discountTitle';
  final discountTag = 'stores.detail.discountTag';
  final atStore = 'stores.detail.atStore';
  final actions = const _StoreDetailActionsKeys();
  final header = const _StoreDetailHeaderKeys();
  final comments = const _StoreDetailCommentsKeys();
}

class _StoreDetailBannerKeys {
  const _StoreDetailBannerKeys();
  final seeAllOutlets = 'stores.detail.banner.seeAllOutlets';
  final nearestOutlet = 'stores.detail.banner.nearestOutlet';
}

class _StoreDetailActionsKeys {
  const _StoreDetailActionsKeys();
  final reportSuccess = 'stores.detail.actions.reportSuccess';
  final shareTapped = 'stores.detail.actions.shareTapped';
}

class _StoreDetailHeaderKeys {
  const _StoreDetailHeaderKeys();
  final storePill = 'stores.detail.header.storePill';
}

class _StoreDetailCommentsKeys {
  const _StoreDetailCommentsKeys();
  final timeAgo = 'stores.detail.comments.timeAgo';
}

class _StoreSectionKeys {
  const _StoreSectionKeys();
  final nearYou = 'stores.section.nearYou';
  final mallPrefix = 'stores.section.mallPrefix';
}

class _StoreEmptyKeys {
  const _StoreEmptyKeys();
  final title = 'stores.empty.title';
  final categorySuggestion = 'stores.empty.categorySuggestion';
  final searchSuggestion = 'stores.empty.searchSuggestion';
}

class _StoreCategoriesKeys {
  const _StoreCategoriesKeys();
  final all = 'stores.categories.all';
  final dining = 'stores.categories.dining';
  final fashion = 'stores.categories.fashion';
  final electronics = 'stores.categories.electronics';
  final beauty = 'stores.categories.beauty';
  final entertainment = 'stores.categories.entertainment';
  final lifestyle = 'stores.categories.lifestyle';
  final jewelry = 'stores.categories.jewelry';
  final travel = 'stores.categories.travel';
  final other = 'stores.categories.other';
}

class _OnboardingKeys {
  const _OnboardingKeys();
  final chooseLanguage = 'onboarding.chooseLanguage';
  final languageButton = const _LanguageButtonKeys();
  final familyInvite = const _FamilyInviteKeys();
  final citySelection = const _CitySelectionKeys();
  final splash = const _SplashKeys();
}

class _SplashKeys {
  const _SplashKeys();
  final takingLonger = 'onboarding.splash.takingLonger';
}

class _LanguageButtonKeys {
  const _LanguageButtonKeys();
  final arabicSelected = 'onboarding.languageButton.arabicSelected';
  final selectArabic = 'onboarding.languageButton.selectArabic';
  final englishSelected = 'onboarding.languageButton.englishSelected';
  final selectEnglish = 'onboarding.languageButton.selectEnglish';
  final continueToLogin = 'onboarding.languageButton.continueToLogin';
}

class _FamilyInviteKeys {
  const _FamilyInviteKeys();
  final title = 'onboarding.familyInvite.title';
  final message = 'onboarding.familyInvite.message';
  final inviteAccepted = 'onboarding.familyInvite.inviteAccepted';
  final inviteRejected = 'onboarding.familyInvite.inviteRejected';
}

class _CitySelectionKeys {
  const _CitySelectionKeys();
  final title = 'onboarding.citySelection.title';
  final subtitle = 'onboarding.citySelection.subtitle';
}

class _AccountDetailsKeys {
  const _AccountDetailsKeys();
  final nameLabel = 'auth.accountDetails.nameLabel';
  final nameHint = 'auth.accountDetails.nameHint';
  final detailsTitle = 'auth.accountDetails.detailsTitle';
  final termsAcceptance = 'auth.accountDetails.termsAcceptance';
}

class _SubscriptionKeys {
  const _SubscriptionKeys();
  final management = const _SubscriptionManagementKeys();
  final purchase = const _SubscriptionPurchaseKeys();
  final restore = const _SubscriptionRestoreKeys();
}

class _SubscriptionPurchaseKeys {
  const _SubscriptionPurchaseKeys();
  final success = 'subscription.purchase.success';
  final failed = 'subscription.purchase.failed';
  final processing = 'subscription.purchase.processing';
  final unavailable = 'subscription.purchase.unavailable';
  final serviceUnavailable = 'subscription.purchase.serviceUnavailable';
  final planNotAvailable = 'subscription.purchase.planNotAvailable';
  final alreadySubscribed = 'subscription.purchase.alreadySubscribed';
}

class _SubscriptionRestoreKeys {
  const _SubscriptionRestoreKeys();
  final button = 'subscription.restore.button';
  final success = 'subscription.restore.success';
  final failed = 'subscription.restore.failed';
  final noPurchases = 'subscription.restore.noPurchases';
}

class _SubscriptionManagementKeys {
  const _SubscriptionManagementKeys();
  final title = 'subscription.management.title';
  final subtitle = 'subscription.management.subtitle';
  final proceed = 'subscription.management.proceed';
  final selection = 'subscription.management.selection';
  final tabs = const _SubscriptionTabsKeys();
  final options = const _SubscriptionOptionsKeys();
  final badges = const _SubscriptionBadgesKeys();
  final benefits = const _SubscriptionBenefitsKeys();
  final promo = const _SubscriptionPromoKeys();
}

class _SubscriptionTabsKeys {
  const _SubscriptionTabsKeys();
  final monthly = 'subscription.management.tabs.monthly';
  final yearlySaveMore = 'subscription.management.tabs.yearlySaveMore';
}

class _SubscriptionOptionsKeys {
  const _SubscriptionOptionsKeys();
  final individual = const _SubscriptionIndividualKeys();
  final family = const _SubscriptionFamilyKeys();
}

class _SubscriptionIndividualKeys {
  const _SubscriptionIndividualKeys();
  final name = 'subscription.management.options.individual.name';
  final priceMonthly = 'subscription.management.options.individual.priceMonthly';
  final priceYearly = 'subscription.management.options.individual.priceYearly';
  final users = 'subscription.management.options.individual.users';
}

class _SubscriptionFamilyKeys {
  const _SubscriptionFamilyKeys();
  final name = 'subscription.management.options.family.name';
  final priceMonthly = 'subscription.management.options.family.priceMonthly';
  final priceYearly = 'subscription.management.options.family.priceYearly';
  final users = 'subscription.management.options.family.users';
}

class _SubscriptionBadgesKeys {
  const _SubscriptionBadgesKeys();
  final firstMonthFree = 'subscription.management.badges.firstMonthFree';
  final discount20 = 'subscription.management.badges.discount20';
  final bestValue25 = 'subscription.management.badges.bestValue25';
  final bestValue30 = 'subscription.management.badges.bestValue30';
}

class _SubscriptionBenefitsKeys {
  const _SubscriptionBenefitsKeys();
  final cancelAnytime = 'subscription.management.benefits.cancelAnytime';
  final dailyVerified = 'subscription.management.benefits.dailyVerified';
  final oneApp = 'subscription.management.benefits.oneApp';
}

class _SubscriptionPromoKeys {
  const _SubscriptionPromoKeys();
  final question = 'subscription.management.promo.question';
  final placeholder = 'subscription.management.promo.placeholder';
  final applied = 'subscription.management.promo.applied';
}

class _ProfileKeys {
  const _ProfileKeys();
  final subscription = const _ProfileSubscriptionKeys();
  final menu = const _ProfileMenuKeys();
  final myAccount = const _ProfileMyAccountKeys();
  final favorites = const _FavoritesKeys();
  final notificationSettings = const _ProfileNotificationSettingsKeys();
  final changeCity = const _ChangeCityKeys();
}

class _ProfileNotificationSettingsKeys {
  const _ProfileNotificationSettingsKeys();
  final title = 'profile.notificationSettings.title';
  final pushNotifications = 'profile.notificationSettings.pushNotifications';
  final hotDeals = 'profile.notificationSettings.hotDeals';
  final storeOffers = 'profile.notificationSettings.storeOffers';
  final bankCardsOffers = 'profile.notificationSettings.bankCardsOffers';
  final emailNotifications = 'profile.notificationSettings.emailNotifications';
  final typeTitle = 'profile.notificationSettings.typeTitle';
  final allOffers = 'profile.notificationSettings.allOffers';
  final allOffersSubtitle = 'profile.notificationSettings.allOffersSubtitle';
  final topOffers = 'profile.notificationSettings.topOffers';
  final topOffersSubtitle = 'profile.notificationSettings.topOffersSubtitle';
}

class _FavoritesKeys {
  const _FavoritesKeys();
  final title = 'profile.favorites.title';
  final emptyTitle = 'profile.favorites.emptyTitle';
  final emptySubtitle = 'profile.favorites.emptySubtitle';
  final loadError = 'profile.favorites.loadError';
}

class _ProfileSubscriptionKeys {
  const _ProfileSubscriptionKeys();
  final premiumPlan = 'profile.premiumPlan';
  final freePlan = 'profile.freePlan';
  final validUntil = 'profile.validUntil';
  final manageSubscription = 'profile.manageSubscription';
  final upgradeToPremium = 'profile.upgradeToPremium';
}

class _ProfileMenuKeys {
  const _ProfileMenuKeys();
  final myAccount = 'profile.menu.myAccount';
  final favourites = 'profile.menu.favourites';
  final changeCity = 'profile.menu.changeCity';
  final helpCenter = 'profile.menu.helpCenter';
}

class _ProfileMyAccountKeys {
  const _ProfileMyAccountKeys();
  final welcome = 'profile.myAccount.welcome';
  final likes = 'profile.myAccount.likes';
  final comments = 'profile.myAccount.comments';
  final votes = 'profile.myAccount.votes';
  final managePersonalDetails = 'profile.myAccount.managePersonalDetails';
  final selectedCreditCards = 'profile.myAccount.selectedCreditCards';
  final deleteAccount = 'profile.myAccount.deleteAccount';
  final deleteDescription = 'profile.myAccount.deleteDescription';
  final confirmDelete = 'profile.myAccount.confirmDelete';
}

class _ChangeCityKeys {
  const _ChangeCityKeys();
  final title = 'profile.changeCity.title';
  final subtitle = 'profile.changeCity.subtitle';
  final success = 'profile.changeCity.success';
}

class _CitiesKeys {
  const _CitiesKeys();
  final riyadh = 'cities.riyadh';
  final jeddah = 'cities.jeddah';
  final mecca = 'cities.mecca';
  final medina = 'cities.medina';
  final khobar = 'cities.khobar';
  final dammam = 'cities.dammam';
  final tabuk = 'cities.tabuk';
  final abha = 'cities.abha';
  final taif = 'cities.taif';
  final qassim = 'cities.qassim';
  final yanbu = 'cities.yanbu';
  final jubail = 'cities.jubail';
  final najran = 'cities.najran';
  final jizan = 'cities.jizan';
}

class _ProductPageKeys {
  const _ProductPageKeys();
  final cta = const _ProductPageCtaKeys();
  final availability = const _ProductPageAvailabilityKeys();
  final actions = const _ProductPageActionsKeys();
  final info = const _ProductPageInfoKeys();
  final comments = const _ProductPageCommentsKeys();
}

class _ProductPageCtaKeys {
  const _ProductPageCtaKeys();
  final seeDeal = 'productPage.cta.seeDeal';
}

class _ProductPageAvailabilityKeys {
  const _ProductPageAvailabilityKeys();
  final online = 'productPage.availability.online';
}

class _ProductPageActionsKeys {
  const _ProductPageActionsKeys();
  final reportExpired = 'productPage.actions.reportExpired';
}

class _ProductPageInfoKeys {
  const _ProductPageInfoKeys();
  final details = 'productPage.info.details';
  final features = 'productPage.info.features';
  final priceResearch = 'productPage.info.priceResearch';
}

class _ProductPageCommentsKeys {
  const _ProductPageCommentsKeys();
  final writeComment = 'productPage.comments.writeComment';
  final noComments = 'productPage.comments.noComments';
}
