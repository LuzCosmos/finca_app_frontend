import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_form_field_style.dart';

InputDecoration receptionFieldDecoration(
  WidgetTester tester,
  Finder fieldFinder,
) {
  return tester
      .widget<InputDecorator>(
        find.descendant(
          of: fieldFinder,
          matching: find.byType(InputDecorator),
        ),
      )
      .decoration;
}

void expectCompactReceptionFieldDecoration(
  WidgetTester tester,
  Finder fieldFinder,
) {
  final decoration = receptionFieldDecoration(tester, fieldFinder);
  expect(decoration.isDense, isTrue);
  expect(decoration.contentPadding, kReceptionFormFieldContentPadding);
}
