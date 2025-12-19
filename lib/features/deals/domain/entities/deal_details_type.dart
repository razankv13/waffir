enum DealDetailsType {
  product,
  store,
  bank;

  static DealDetailsType? tryParse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'product':
        return DealDetailsType.product;
      case 'store':
        return DealDetailsType.store;
      case 'bank':
        return DealDetailsType.bank;
    }
    return null;
  }

  String get routeValue {
    switch (this) {
      case DealDetailsType.product:
        return 'product';
      case DealDetailsType.store:
        return 'store';
      case DealDetailsType.bank:
        return 'bank';
    }
  }
}
