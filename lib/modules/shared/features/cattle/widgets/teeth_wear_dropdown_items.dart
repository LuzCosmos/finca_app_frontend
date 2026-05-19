import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Ítems para desgaste incisivos (API: entero 0–5). Textos según escala práctica
/// de desgaste (tabla edad bovinos / dentición).
///
/// Si [allowedGrades] es null o vacío, se muestran todos los grados 0–5.
List<DropdownMenuItem<int?>> teethWearDropdownItems(
  AppLocalizations l10n, {
  Set<int>? allowedGrades,
  TextStyle? itemStyle,
}) {
  final textStyle = itemStyle ?? const TextStyle();
  final labels = <String>[
    l10n.teethWearGrade0,
    l10n.teethWearGrade1,
    l10n.teethWearGrade2,
    l10n.teethWearGrade3,
    l10n.teethWearGrade4,
    l10n.teethWearGrade5,
  ];
  final grades =
      (allowedGrades == null || allowedGrades.isEmpty)
          ? <int>{0, 1, 2, 3, 4, 5}
          : allowedGrades;
  final sorted = grades.toList()..sort();
  return [
    DropdownMenuItem<int?>(
      value: null,
      child: Text('—', style: textStyle),
    ),
    ...sorted.map(
      (i) => DropdownMenuItem<int?>(
        value: i,
        child: Text(
          '${i.toString()} — ${labels[i]}',
          style: textStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ];
}
