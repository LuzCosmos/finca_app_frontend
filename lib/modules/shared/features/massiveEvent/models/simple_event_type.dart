import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum SimpleEventType { weight, castration, tracker, eartag, medication, brand }

extension EventTypeL10n on SimpleEventType {
  String asText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SimpleEventType.weight:
        return l10n.eventTypeWeight;
      case SimpleEventType.castration:
        return l10n.eventTypeCastration;
      case SimpleEventType.tracker:
        return l10n.eventTypeTracker;
      case SimpleEventType.eartag:
        return l10n.eventTypeEartag;
      case SimpleEventType.medication:
        return l10n.eventTypeMedication;
      case SimpleEventType.brand:
        return l10n.eventTypeBrand;
    }
  }
}
