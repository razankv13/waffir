class EntitlementInfo {

  const EntitlementInfo({
    required this.identifier,
    required this.isActive,
    required this.willRenew,
    required this.periodType,
    this.latestPurchaseDate,
    required this.productIdentifier,
    required this.isSandbox,
    this.originalPurchaseDate,
    this.expirationDate,
    this.unsubscribeDetectedAt,
    this.billingIssueDetectedAt,
  });
  final String identifier;
  final bool isActive;
  final bool willRenew;
  final String periodType;
  final String? latestPurchaseDate;
  final String productIdentifier;
  final bool isSandbox;
  final String? originalPurchaseDate;
  final DateTime? expirationDate;
  final String? unsubscribeDetectedAt;
  final String? billingIssueDetectedAt;
}