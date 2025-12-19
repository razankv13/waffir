import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/app_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/logger.dart';

class NotificationRouter {
  // Use the global navigator key from AppRouter
  static GlobalKey<NavigatorState> get navigatorKey => rootNavigatorKey;

  static void handleNotification(Map<String, dynamic> data) {
    final context = navigatorKey.currentContext;
    if (context == null) {
        AppLogger.warning('⚠️ Navigation context is null, cannot route notification');
        return;
    }

    final type = data['type'] as String?;
    final dealId = data['deal_id'] as String?;
    final dealType = data['deal_type'] as String?;

    if (type == null || dealId == null) return;

    switch (type) {
      case 'deal_alert':
      case 'price_drop':
      case 'new_deal':
        _navigateToDealDetails(context, dealId, dealType ?? 'product');
        break;
      default:
        AppLogger.warning('⚠️ Unknown notification type: $type');
    }
  }

  static void _navigateToDealDetails(BuildContext context, String dealId, String dealType) {
    // Navigate based on deal type using GoRouter
    // Need to ensure routes are clean.
    // Assuming AppRouteNames or similar constants.
    
    // We can use context.push() because we have GoRouterContext extension.
    switch (dealType) {
      case 'product':
        context.pushNamed(AppRouteNames.productDetail, pathParameters: {'id': dealId});
        break;
      case 'store_offer':
         // Assuming storeDetail takes id
        context.pushNamed(AppRouteNames.storeDetail, pathParameters: {'id': dealId});
        break;
      case 'bank_offer':
        // Assuming bankOfferDetail exists
        // context.pushNamed(AppRouteNames.bankOfferDetail, pathParameters: {'id': dealId});
        AppLogger.warning('Bank offer routing not yet implemented');
        break;
    }
  }
}
