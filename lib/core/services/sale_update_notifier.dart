import 'dart:async';

/// Notifica cuando una venta fue actualizada en el servidor (p. ej. edición de
/// peso/precio de ganado vendido). El dashboard de ventas puede escuchar y recargar.
class SaleUpdateNotifier {
  SaleUpdateNotifier._();

  static final SaleUpdateNotifier _instance = SaleUpdateNotifier._();

  static SaleUpdateNotifier get instance => _instance;

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// IDs de ventas actualizadas. Escuchar para refrescar listados.
  Stream<String> get updatedSaleIds => _controller.stream;

  void notifySaleUpdated(String saleId) {
    if (!_controller.isClosed) {
      _controller.add(saleId);
    }
  }
}
