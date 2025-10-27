import 'package:waffir/features/subscription/domain/entities/purchase_state.dart';

class Purchase {

  const Purchase({
    required this.id,
    required this.productId,
    required this.transactionId,
    required this.purchaseDate,
    required this.state,
    required this.isAcknowledged,
    required this.isAutoRenewing,
    required this.price,
    required this.currencyCode,
  });
  final String id;
  final String productId;
  final String transactionId;
  final DateTime purchaseDate;
  final PurchaseState state;
  final bool isAcknowledged;
  final bool isAutoRenewing;
  final double price;
  final String currencyCode;
}