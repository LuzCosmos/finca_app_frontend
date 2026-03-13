import 'dart:async';

/// Notifies when a sale was updated (e.g. after editing sold cattle salePrice/saleWeight).
/// Sales dashboard or detail views can listen and refresh their data.
class SaleSyncNotifier {
  SaleSyncNotifier._();

  static final SaleSyncNotifier _instance = SaleSyncNotifier._();

  static SaleSyncNotifier get instance => _instance;

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// Stream of sale IDs that were updated. Listen to refresh sale data.
  Stream<String> get updatedSaleIds => _controller.stream;

  /// Call when a sale was updated (e.g. backend returned affectedSaleId).
  void notifySaleUpdated(String saleId) {
    if (!_controller.isClosed) {
      _controller.add(saleId);
    }
  }
}
