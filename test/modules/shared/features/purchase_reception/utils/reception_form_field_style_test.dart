import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_form_field_style.dart';

void main() {
  group('receptionFormInputDecoration', () {
    test('aplica isDense y contentPadding compacto', () {
      final decoration = receptionFormInputDecoration(labelText: 'Peso');

      expect(decoration.isDense, isTrue);
      expect(decoration.contentPadding, kReceptionFormFieldContentPadding);
      expect(decoration.labelStyle, kReceptionFormFieldLabelStyle);
      expect(decoration.labelText, 'Peso');
    });
  });
}
