import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_form_field_style.dart';

void main() {
  testWidgets('receptionFormFieldTextStyle usa color onSurface del tema', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Builder(
          builder: (context) {
            final style = receptionFormFieldTextStyle(context);
            return Text('x', style: style);
          },
        ),
      ),
    );
    final context = tester.element(find.text('x'));
    final style = receptionFormFieldTextStyle(context);
    expect(style.color, Theme.of(context).colorScheme.onSurface);
    expect(style.fontSize, kReceptionFormFieldFontSize);
  });

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
