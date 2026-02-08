enum PurchaseStatus {
  open,
  received;

  String get name {
    switch (this) {
      case PurchaseStatus.open:
        return 'OPEN';
      case PurchaseStatus.received:
        return 'RECEIVED';
    }
  }

  static PurchaseStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'RECEIVED':
        return PurchaseStatus.received;
      default:
        return PurchaseStatus.open;
    }
  }
}
