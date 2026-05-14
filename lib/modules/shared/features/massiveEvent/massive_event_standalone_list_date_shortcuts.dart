import 'package:flutter/material.dart';

/// Atajos de rango de fechas (solo día local) para filtros del listado autónomo.
abstract final class MassiveEventStandaloneListDateShortcuts {
  /// Hoy: [from] y [to] son el mismo día civil local.
  static (DateTime from, DateTime to) todayLocal() {
    final n = DateTime.now();
    final d = DateTime(n.year, n.month, n.day);
    return (d, d);
  }

  /// Semana calendario según el primer día de la semana de Material (locale).
  static (DateTime from, DateTime to) thisWeekLocal(BuildContext context) {
    final firstIdx = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final anchorWeekday = firstIdx == 0 ? DateTime.sunday : firstIdx;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var deltaDays = (today.weekday - anchorWeekday) % 7;
    if (deltaDays < 0) {
      deltaDays += 7;
    }
    final start = today.subtract(Duration(days: deltaDays));
    final end = start.add(const Duration(days: 6));
    return (start, end);
  }
}
