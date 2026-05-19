import 'package:flutter/widgets.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

/// Título legible para un evento aplicado en recepción (panel lateral).
String appliedReceptionEventTitle(
  BuildContext context,
  Map<String, dynamic> event,
  AppLocalizations l10n,
) {
  final data = event['data'] as Map<String, dynamic>?;

  if (data != null && data.containsKey('medicationName')) {
    return data['medicationName']?.toString() ?? l10n.eventTypeMedication;
  }
  if (data != null && data.containsKey('brandName')) {
    return '${l10n.eventTypeBrand}: ${data['brandName'] ?? ''}';
  }

  final typeRaw = event['type'] as String?;
  if (typeRaw != null) {
    for (final type in SimpleEventType.values) {
      if (type.name == typeRaw) {
        if (type == SimpleEventType.weight && data != null) {
          final weight = data['weight'] ?? data['kg'];
          if (weight != null) {
            return '${type.asText(context)}: $weight';
          }
        }
        return type.asText(context);
      }
    }
  }

  if (data != null) {
    final weight = data['weight'] ?? data['kg'];
    if (weight != null) {
      return '${l10n.eventTypeWeight}: $weight';
    }
    if (data.containsKey('eartagLeft') || data.containsKey('eartagRight')) {
      return l10n.eventTypeEartag;
    }
    if (data.containsKey('tracker_deveui') || data.containsKey('tracker_id')) {
      return l10n.eventTypeTracker;
    }
  }

  return event['id']?.toString() ?? 'Event';
}
