import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Ítems para desgaste incisivos (API: entero 0–5). Textos según escala práctica
/// de desgaste (tabla edad bovinos / dentición).
List<DropdownMenuItem<int?>> teethWearDropdownItems(AppLocalizations l10n) {
  final labels = <String>[
    l10n.teethWearGrade0,
    l10n.teethWearGrade1,
    l10n.teethWearGrade2,
    l10n.teethWearGrade3,
    l10n.teethWearGrade4,
    l10n.teethWearGrade5,
  ];
  return [
    const DropdownMenuItem<int?>(
      value: null,
      child: Text('—'),
    ),
    ...List.generate(
      labels.length,
      (i) => DropdownMenuItem<int?>(
        value: i,
        child: Text(
          '${i.toString()} — ${labels[i]}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ];
}
