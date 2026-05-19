import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
/// Valores alineados con `_kEditIconSize` / `_kActionsColumnWidth` en
/// `CattleListWithEvents` y `UnassignedCattleList`.
const kReceptionEditIconSize = 18.0;
const kReceptionActionsColumnWidth = 22.0;

/// Tipografía de tablas de recepción (`LotsTable`, listas de reses).
const kReceptionTableHeaderFontSize = 15.0;
const kReceptionTableRowFontSize = 14.0;

void expectNoActionsColumnHeaderLabel(WidgetTester tester) {
  // Los tests de recepción usan `locale: const Locale('es')`.
  expect(find.text('Acciones'), findsNothing);
}

void expectCompactEditIconButton(WidgetTester tester) {
  final editIcon = find.byIcon(Icons.edit);
  expect(editIcon, findsOneWidget);
  expect(tester.widget<Icon>(editIcon).size, kReceptionEditIconSize);
  expect(tester.widget<Icon>(editIcon).color, Colors.blue);

  final button = tester.widget<IconButton>(find.byType(IconButton));
  expect(button.constraints?.maxWidth, kReceptionActionsColumnWidth);
  expect(button.constraints?.maxHeight, kReceptionEditIconSize);
  expect(button.padding, EdgeInsets.zero);
}

bool _textHasFontSize(WidgetTester tester, Finder finder, double size) {
  return tester
      .widgetList<Text>(finder)
      .any((text) => text.style?.fontSize == size);
}

void expectTableRowTypography(WidgetTester tester, Finder tableRoot) {
  expect(
    _textHasFontSize(
      tester,
      find.descendant(of: tableRoot, matching: find.byType(Text)),
      kReceptionTableRowFontSize,
    ),
    isTrue,
    reason: 'debe haber celdas de fila con fontSize $kReceptionTableRowFontSize',
  );
}

void expectTableHeaderTypography(WidgetTester tester, Finder tableRoot) {
  expect(
    _textHasFontSize(
      tester,
      find.descendant(of: tableRoot, matching: find.byType(Text)),
      kReceptionTableHeaderFontSize,
    ),
    isTrue,
    reason:
        'debe haber cabecera con fontSize $kReceptionTableHeaderFontSize',
  );
}
