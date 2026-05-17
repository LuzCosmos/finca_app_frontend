import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// [AppLocalizations] del árbol ya montado (evita hardcodear textos de `.arb`).
AppLocalizations l10nFromTester(WidgetTester tester) {
  final matches =
      find
          .byElementPredicate((e) => AppLocalizations.of(e) != null)
          .evaluate();
  assert(matches.isNotEmpty, 'No AppLocalizations found in widget tree');
  return AppLocalizations.of(matches.first)!;
}
