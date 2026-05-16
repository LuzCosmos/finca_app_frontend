import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

String massiveEventListDisplayCreatedByUsername(MassiveEventModel e) {
  final u = e.createdByUsername?.trim();
  if (u != null && u.isNotEmpty) return u;
  return '—';
}

/// Chip de estado (abierto/cerrado) alineado con la tabla web.
class MassiveEventListStatusChip extends StatelessWidget {
  const MassiveEventListStatusChip({
    super.key,
    required this.l10n,
    required this.event,
    this.maxWidth,
  });

  final AppLocalizations l10n;
  final MassiveEventModel event;
  /// Si no es null, limita el ancho del chip (lista móvil / celdas estrechas).
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final open = event.status.toLowerCase() == 'open';
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            open
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: open ? Colors.green : Colors.grey),
      ),
      child: Text(
        open ? l10n.open : l10n.massiveEventsStatusClosedLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: open ? Colors.green[800] : Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: chip,
      );
    }
    return chip;
  }
}
