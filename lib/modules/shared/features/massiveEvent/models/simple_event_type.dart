import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum EventType { weight, castration, tracker, eartag, medication, brand }

extension EventTypeL10n on EventType {
  String asText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EventType.weight:
        return l10n.eventTypeWeight;
      case EventType.castration:
        return l10n.eventTypeCastration;
      case EventType.tracker:
        return l10n.eventTypeTracker;
      case EventType.eartag:
        return l10n.eventTypeEartag;
      case EventType.medication:
        return l10n.eventTypeMedication;
      case EventType.brand:
        return l10n.eventTypeBrand;
    }
  }
}
