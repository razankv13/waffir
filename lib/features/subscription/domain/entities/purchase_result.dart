import 'package:waffir/features/subscription/domain/entities/purchase.dart';
import 'package:waffir/features/subscription/domain/entities/customer_info.dart';

class PurchaseResult {

  const PurchaseResult({
    required this.purchase,
    required this.isNewPurchase,
    required this.customerInfo,
  });
  final Purchase purchase;
  final bool isNewPurchase;
  final CustomerInfo customerInfo;
}