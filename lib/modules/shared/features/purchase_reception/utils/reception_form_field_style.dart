import 'package:flutter/material.dart';

/// Padding del contenedor ([Card] / diálogo) del formulario de recepción.
const kReceptionFormOuterPadding = EdgeInsets.all(8);

/// Espaciado entre campos en [Wrap].
const double kReceptionFormWrapSpacing = 8;

/// Padding interno de [TextFormField] / [DropdownButtonFormField].
const EdgeInsets kReceptionFormFieldContentPadding = EdgeInsets.symmetric(
  horizontal: 10,
  vertical: 8,
);

const TextStyle kReceptionFormFieldLabelStyle = TextStyle(fontSize: 13);

const TextStyle kReceptionFormFieldTextStyle = TextStyle(fontSize: 14);

const EdgeInsets kReceptionFormLoadingIconPadding = EdgeInsets.all(8);

/// Decoración compacta para campos de alta/edición en recepción.
InputDecoration receptionFormInputDecoration({
  String? labelText,
  String? hintText,
  String? errorText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  InputBorder? border,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    errorText: errorText,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    border: border ?? const OutlineInputBorder(),
    isDense: true,
    contentPadding: kReceptionFormFieldContentPadding,
    labelStyle: kReceptionFormFieldLabelStyle,
  );
}
