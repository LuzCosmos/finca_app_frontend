import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

/// Misma lógica de filtro que el API (tests con [fetchStandaloneOverride]).
List<MassiveEventModel> filterStandaloneMassiveEventsClient(
  List<MassiveEventModel> events, {
  DateTime? from,
  DateTime? to,
  required String nameTrim,
  required String status,
}) {
  final n = nameTrim.toLowerCase();
  return events.where((e) {
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      if (e.eventDate.isBefore(start)) return false;
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);
      if (e.eventDate.isAfter(end)) return false;
    }
    if (n.isNotEmpty) {
      final id = e.id.toLowerCase();
      final nm = (e.name ?? '').toLowerCase();
      if (!id.contains(n) && !nm.contains(n)) return false;
    }
    if (status != 'all') {
      if (e.status.toLowerCase() != status.toLowerCase()) return false;
    }
    return true;
  }).toList();
}
