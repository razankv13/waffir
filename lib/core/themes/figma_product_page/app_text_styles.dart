import 'package:flutter/material.dart';

/// Exact typography tokens extracted from Figma node `34:4022` (Product Page).
///
/// IMPORTANT: Do not import this file from widgets.
/// Widgets must access these values via `Theme.of(context)` using `ProductPageTheme`.
class ProductPageFigmaTextStyles {
  ProductPageFigmaTextStyles._();

  static const String parkinsans = 'Parkinsans';
  static const String inter = 'Inter';

  // Title: "Nike Men’s Air Max 2025 Shoes (3 Colors)"
  static const TextStyle title = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.3999999364217122,
  );

  // Price: "400"
  static const TextStyle price = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.15,
  );

  // Original price: "809" (strikethrough applied at usage time if needed)
  static const TextStyle originalPrice = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.149999976158142,
  );

  // Store line: "At Nike store"
  static const TextStyle storeLine = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w400,
    fontSize: 14.266104698181152,
    height: 1.089547863690952,
  );

  // Counts: like/comment numbers
  static const TextStyle count = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.1500000272478377,
  );

  // Timestamp: "3 hours ago"
  static const TextStyle timestamp = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3999999364217122,
  );

  // Comment placeholder: "Write your comment"
  static const TextStyle commentPlaceholder = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.149999976158142,
  );

  // Section label: "Details:" (Figma style 5PZ29Q)
  static const TextStyle sectionLabelRegular = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.3374472856521606,
  );

  // Section label: "Features:" and "Price Research:" (Figma style BVL8LX)
  static const TextStyle sectionLabelBold = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.114539384841919,
  );

  // Body copy blocks (Figma style DFWFH1)
  static const TextStyle body = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4000000272478377,
  );

  // Body copy variant (Figma style 9X02FY)
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4000000272478377,
  );

  // Additional action label: "Report Expired" (Inter)
  static const TextStyle reportExpired = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.2102272510528564,
  );

  // CTA button: "See the deal at (store name)"
  static const TextStyle cta = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.0,
  );

  // Online pill text: "Online"
  static const TextStyle onlinePill = TextStyle(
    fontFamily: parkinsans,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.3999999364217122,
  );
}
