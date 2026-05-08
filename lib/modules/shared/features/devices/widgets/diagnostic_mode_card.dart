import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_event.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

/// Card del modo diagnóstico LW001-BG PRO.
///
/// - **Inactivo**: explicación + botón "Activar".
/// - **Activo**: borde naranja, cuenta regresiva mm:ss y botón "Desactivar y restaurar".
///
/// El widget reagenda un `Timer.periodic(1s)` para repintar el contador mientras hay
/// modo activo. El timer se cancela en `dispose()` para no fugar.
class DiagnosticModeCard extends StatefulWidget {
  final String deveui;

  /// Override del proveedor de "ahora" para tests determinísticos.
  /// En producción siempre se usa `DateTime.now()`.
  @visibleForTesting
  final DateTime Function()? clock;

  const DiagnosticModeCard({super.key, required this.deveui, this.clock});

  @override
  State<DiagnosticModeCard> createState() => _DiagnosticModeCardState();
}

class _DiagnosticModeCardState extends State<DiagnosticModeCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = context.read<DeviceRemoteConfigBloc>().state;
      if (state.status?.isDiagnosticActive == true) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Calcula `expiresAt - now` usando el reloj inyectado o `DateTime.now()`.
  Duration _remaining(DiagnosticStateModel diag) {
    final now = (widget.clock ?? DateTime.now)();
    final delta = diag.expiresAt.difference(now);
    return delta.isNegative ? Duration.zero : delta;
  }

  String _formatRemaining(BuildContext context, Duration d) {
    final l10n = AppLocalizations.of(context)!;
    final mm = d.inMinutes;
    final ss = d.inSeconds - mm * 60;
    return l10n.deviceRemoteConfig_diagnostic_remainingMinutesSeconds('$mm', '$ss');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.watch<DeviceRemoteConfigBloc>();
    final state = bloc.state;
    final RemoteConfigStatusModel? status = state.status;
    final DiagnosticStateModel? diag = status?.diagnosticState;
    final bool active = diag != null && _remaining(diag) > Duration.zero;
    final bool busy = state.isTogglingDiagnosticMode;
    final DiagnosticStateModel? activeDiag = active ? diag : null;

    return Card(
      key: const Key('diagnosticModeCard'),
      color: active ? Colors.orange.shade50 : null,
      shape: active
          ? RoundedRectangleBorder(
              side: BorderSide(color: Colors.orange.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  active ? Icons.bug_report : Icons.bug_report_outlined,
                  color: active ? Colors.orange.shade800 : null,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.deviceRemoteConfig_diagnostic_title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.deviceRemoteConfig_diagnostic_description),
            const SizedBox(height: 12),
            if (activeDiag != null)
              Text(
                l10n.deviceRemoteConfig_diagnostic_activeStatus(
                  _formatRemaining(context, _remaining(activeDiag)),
                ),
                key: const Key('diagnosticModeCard.activeStatus'),
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              Text(
                l10n.deviceRemoteConfig_diagnostic_inactiveStatus,
                key: const Key('diagnosticModeCard.inactiveStatus'),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: active
                  ? FilledButton.icon(
                      key: const Key('diagnosticModeCard.disableButton'),
                      icon: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.restart_alt),
                      label: Text(
                        l10n.deviceRemoteConfig_diagnostic_action_disable,
                      ),
                      onPressed: busy
                          ? null
                          : () => bloc.add(
                                DisableDiagnosticModeRequested(widget.deveui),
                              ),
                    )
                  : OutlinedButton.icon(
                      key: const Key('diagnosticModeCard.enableButton'),
                      icon: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.bug_report),
                      label: Text(
                        l10n.deviceRemoteConfig_diagnostic_action_enable,
                      ),
                      onPressed: busy
                          ? null
                          : () => bloc.add(
                                EnableDiagnosticModeRequested(deveui: widget.deveui),
                              ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
