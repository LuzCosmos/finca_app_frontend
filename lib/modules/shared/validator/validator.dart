import 'package:flutter/material.dart';

class Validator {
  static FormFieldValidator<String> validateNotEmpty(
    String errorMessage,
    RegExp? customRegex,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) return errorMessage;
      if (customRegex != null) {
        if (!customRegex.hasMatch(value)) return errorMessage;
      }
      return null;
    };
  }

  static FormFieldValidator<String> validateNumericMandatory(
    String requiredMessage,
    String invalidMessage,
    RegExp? customRegex,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) return requiredMessage;
      final parsed = double.tryParse(value);
      if (parsed == null || parsed <= 0) return invalidMessage;
      if (customRegex != null) {
        if (!customRegex.hasMatch(value)) return invalidMessage;
      }
      return null;
    };
  }
}
