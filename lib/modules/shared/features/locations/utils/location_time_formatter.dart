import 'package:intl/intl.dart';

/// Formato requerido: YYYY-MM-DD-HH:mm (24h)
String formatLocationTime(DateTime time) {
  final local = time.toLocal();
  return DateFormat('yyyy-MM-dd-HH:mm').format(local);
}

