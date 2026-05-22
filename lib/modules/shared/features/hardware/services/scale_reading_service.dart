import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/models/scale_reading_model.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/services/scale_reading_api_service.dart';

/// Polls backend for scale status and readings (no WebSocket in backend v1).
class ScaleReadingService {
  ScaleReadingService._();
  static final ScaleReadingService instance = ScaleReadingService._();

  /// Solo tests: evita polling HTTP y usa [debugState] fijo.
  @visibleForTesting
  static ScaleReadingState? debugState;

  @visibleForTesting
  static void resetDebugState() {
    debugState = null;
    instance._listeners = 0;
    instance._pollTimer?.cancel();
    instance._pollTimer = null;
    instance._state = ScaleReadingState.empty;
  }

  final ScaleReadingApiService _api = ScaleReadingApiService();
  final _controller = StreamController<ScaleReadingState>.broadcast();

  Stream<ScaleReadingState> get stream => _controller.stream;

  ScaleReadingState _state = ScaleReadingState.empty;
  ScaleReadingState get currentState => _state;

  Timer? _pollTimer;
  int _listeners = 0;
  String _scaleId = ScaleReadingApiService.defaultScaleId;

  void configure({String? scaleId}) {
    if (scaleId != null && scaleId.isNotEmpty) {
      _scaleId = scaleId;
    }
  }

  void startListening() {
    _listeners += 1;
    final debug = debugState;
    if (debug != null) {
      _emit(debug);
      return;
    }
    if (_pollTimer != null) return;
    unawaited(_bindAndPoll());
    _pollTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      _poll();
    });
  }

  Future<void> _bindAndPoll() async {
    try {
      await _api.bindSession(_scaleId);
    } catch (_) {
      // Sin sesión activa el bridge no enruta lecturas al tenant; el panel seguirá en disconnected.
    }
    await _poll();
  }

  void stopListening() {
    _listeners = (_listeners - 1).clamp(0, 999);
    if (_listeners == 0) {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  Future<void> _poll() async {
    try {
      final status = await _api.fetchStatus(_scaleId);
      ScaleReadingModel? latest;
      ScaleReadingModel? stable;
      try {
        latest = await _api.fetchLatestReading(_scaleId);
      } on ApiException catch (e) {
        if (e.code != ApiExceptionCode.notFound.name) rethrow;
      }
      try {
        stable = await _api.fetchLatestStableReading(_scaleId);
      } on ApiException catch (e) {
        if (e.code != ApiExceptionCode.notFound.name) rethrow;
      }
      _emit(
        ScaleReadingState(
          status: status.status,
          latestReading: latest,
          latestStableReading: stable,
        ),
      );
    } catch (_) {
      _emit(
        const ScaleReadingState(status: ScaleConnectionStatus.disconnected),
      );
    }
  }

  void _emit(ScaleReadingState next) {
    _state = next;
    if (!_controller.isClosed) {
      _controller.add(next);
    }
  }

  void dispose() {
    _pollTimer?.cancel();
    _listeners = 0;
    _controller.close();
  }
}
