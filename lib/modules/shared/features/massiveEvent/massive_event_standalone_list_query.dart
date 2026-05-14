import 'package:intl/intl.dart';

/// Filtros del listado autónomo de eventos masivos (`GET /massive-events`).
///
/// Centraliza el conocimiento de **fechas sobre `event_date`**, **nombre/id**
/// y **estado** (`all` | `open` | `closed`) y su serialización a los strings
/// que espera [MassiveEventApiService.listStandaloneMassiveEventsPaged].
class MassiveEventStandaloneListQuery {
  const MassiveEventStandaloneListQuery({
    required this.eventFrom,
    required this.eventTo,
    required this.nameTrim,
    required this.statusRaw,
  });

  final DateTime? eventFrom;
  final DateTime? eventTo;

  /// Ya recortado (como en los `TextEditingController` de las pantallas).
  final String nameTrim;

  /// Valor del desplegable; puede ser inválido si el estado se corrompe.
  final String statusRaw;

  /// Misma lista que usa el backend y los desplegables de filtro.
  static const List<String> allowedStatusCodes = ['all', 'open', 'closed'];

  static final DateFormat _apiYmd = DateFormat('yyyy-MM-dd');

  static String coerceStatus(String? raw) {
    final s = raw ?? 'all';
    return allowedStatusCodes.contains(s) ? s : 'all';
  }

  String get statusForApi => coerceStatus(statusRaw);

  String? get fromForApi =>
      eventFrom != null ? _apiYmd.format(eventFrom!) : null;

  String? get toForApi => eventTo != null ? _apiYmd.format(eventTo!) : null;

  String? get nameForApi => nameTrim.isEmpty ? null : nameTrim;

  bool get hasActiveFilters =>
      eventFrom != null ||
      eventTo != null ||
      nameTrim.isNotEmpty ||
      statusForApi != 'all';
}
