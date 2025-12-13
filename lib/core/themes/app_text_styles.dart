import 'package:flutter/material.dart';

/// Centralized text styles extracted from Figma.
///
/// Note: These styles intentionally do **not** include colors so widget code can remain
/// theme-driven via `Theme.of(context)` / Theme extensions.
class AppTextStyles {
  AppTextStyles._();

  // --- Store Page (Figma node: 54:5545) ---

  // Header
  static const TextStyle storePageHeaderLabel = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.3999999364217122,
  );

  // Outlet banner
  static const TextStyle storePageOutletLeft = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4000000272478377,
  );

  static const TextStyle storePageOutletRight = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.3999999364217122,
  );

  // Actions
  static const TextStyle storePageActionCount = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.1500000272478377,
  );

  static const TextStyle storePageTimestamp = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3999999364217122,
  );

  // Headline / prices
  static const TextStyle storePageDealHeadline = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.3999999364217122,
  );

  static const TextStyle storePageDiscountLabel = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.149999976158142,
  );

  static const TextStyle storePageAtStore = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 14.266104698181152,
    height: 1.089547863690952,
  );

  // Additional actions
  static const TextStyle storePageReportExpired = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.2102272510528564,
  );

  // Info blocks
  static const TextStyle storePageDetailsTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.3374472856521606,
  );

  static const TextStyle storePageFeaturesTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.114539384841919,
  );

  static const TextStyle storePageInfoBody = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4000000272478377,
  );

  // Comments
  static const TextStyle storePageCommentPlaceholder = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.149999976158142,
  );

  static const TextStyle storePageTestimonialAuthor = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4000000272478377,
  );

  static const TextStyle storePageTestimonialDate = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3374473253885906,
  );

  static const TextStyle storePageTestimonialBody = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.3999999364217122,
  );

  // Bottom CTA
  static const TextStyle storePageCta = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.0,
  );

  // --- Notifications & Alerts Screen (Figma node: 7774:3441) ---

  // Section title ("My deal alerts", "Popular Alerts")
  static const TextStyle notificationsSectionTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.0,
  );

  // Filter selected state
  static const TextStyle notificationsFilterSelected = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.4,
  );

  // Filter unselected state
  static const TextStyle notificationsFilterUnselected = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4,
  );

  // Main title ("Don't miss out!")
  static const TextStyle notificationsTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.0,
  );

  // Subtitle ("Get notified when great deals drop!")
  static const TextStyle notificationsSubtitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.149999976158142,
  );

  // Deal card title
  static const TextStyle notificationsDealTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.149999976158142,
  );

  // Deal card subtitle
  static const TextStyle notificationsDealSubtitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 11.899999618530273,
    height: 1.1499999919859298,
  );

  // Deal card letter/initial
  static const TextStyle notificationsDealLetter = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.15,
  );

  // Alert card title
  static const TextStyle notificationsAlertTitle = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.149999976158142,
  );

  // Add button text
  static const TextStyle notificationsAddButton = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.1499999364217122,
  );

  // Search label
  static const TextStyle notificationsSearchLabel = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.2857142857142858,
  );

  // Search placeholder
  static const TextStyle notificationsSearchPlaceholder = TextStyle(
    fontFamily: 'Parkinsans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3333333333333333,
  );
}
