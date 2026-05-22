import 'dart:async';

import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/models/scale_reading_model.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/services/scale_reading_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/utils/scale_weight_format.dart';

typedef ApplyStableWeightCallback = void Function(double weightKg, String formatted);

class LiveScaleReadingPanel extends StatefulWidget {
  final ApplyStableWeightCallback? onApplyStableWeight;
  final bool enabled;

  const LiveScaleReadingPanel({
    super.key,
    this.onApplyStableWeight,
    this.enabled = true,
  });

  @override
  State<LiveScaleReadingPanel> createState() => _LiveScaleReadingPanelState();
}

class _LiveScaleReadingPanelState extends State<LiveScaleReadingPanel> {
  final _service = ScaleReadingService.instance;
  StreamSubscription<ScaleReadingState>? _sub;
  ScaleReadingState _state = ScaleReadingState.empty;

  @override
  void initState() {
    super.initState();
    _service.startListening();
    _state = _service.currentState;
    _sub = _service.stream.listen((s) {
      if (mounted) setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _service.stopListening();
    super.dispose();
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (_state.status) {
      case ScaleConnectionStatus.connected:
        return l10n.scale_connected;
      case ScaleConnectionStatus.reconnecting:
        return l10n.scale_reconnecting;
      case ScaleConnectionStatus.error:
        return l10n.scale_error;
      case ScaleConnectionStatus.disconnected:
        return l10n.scale_disconnected;
    }
  }

  IconData _statusIcon() {
    switch (_state.status) {
      case ScaleConnectionStatus.connected:
        return Icons.scale;
      case ScaleConnectionStatus.reconnecting:
        return Icons.sync;
      case ScaleConnectionStatus.error:
        return Icons.error_outline;
      case ScaleConnectionStatus.disconnected:
        return Icons.link_off;
    }
  }

  Color _statusColor(BuildContext context) {
    switch (_state.status) {
      case ScaleConnectionStatus.connected:
        return Colors.green.shade700;
      case ScaleConnectionStatus.reconnecting:
        return Colors.orange.shade800;
      case ScaleConnectionStatus.error:
        return Colors.red.shade700;
      case ScaleConnectionStatus.disconnected:
        return Theme.of(context).colorScheme.outline;
    }
  }

  void _applyStable(AppLocalizations l10n) {
    final stable = _state.latestStableReading;
    if (stable?.weight == null || stable!.weight! <= 0) return;
    final formatted = formatScaleWeightKg(stable.weight!);
    widget.onApplyStableWeight?.call(stable.weight!, formatted);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.scale_weightApplied(formatted))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final live = _state.latestReading;
    final stable = _state.latestStableReading;
    final canApply = widget.enabled &&
        stable?.weight != null &&
        stable!.weight! > 0 &&
        stable.isStable;

    final liveText = live?.weight != null
        ? l10n.scale_liveWeight(
            formatScaleWeightKg(live!.weight!),
            live.unit ?? 'kg',
          )
        : l10n.scale_noReading;

    final applyButton = Tooltip(
      message: canApply ? '' : l10n.scale_notStable,
      child: FilledButton.tonal(
        onPressed: canApply ? () => _applyStable(l10n) : null,
        child: Text(l10n.scale_useStableWeight),
      ),
    );

    final statusTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _statusLabel(l10n),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(liveText, style: const TextStyle(fontSize: 11)),
        Text(
          stable?.isStable == true ? l10n.scale_stable : l10n.scale_unstable,
          style: TextStyle(
            fontSize: 11,
            color: stable?.isStable == true
                ? Colors.green.shade700
                : Colors.orange.shade800,
          ),
        ),
      ],
    );

    final statusRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_statusIcon(), color: _statusColor(context), size: 20),
        const SizedBox(width: 8),
        Expanded(child: statusTexts),
      ],
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 300) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  statusRow,
                  const SizedBox(height: 8),
                  applyButton,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_statusIcon(), color: _statusColor(context), size: 20),
                const SizedBox(width: 8),
                Expanded(child: statusTexts),
                applyButton,
              ],
            );
          },
        ),
      ),
    );
  }
}
