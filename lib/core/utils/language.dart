//lib/core/utils/language.dart

import 'dart:ui';

enum Language { english, spanish }

extension LanguageExtension on Language {
  String get locale {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.spanish:
        return 'es';
      default:
        return 'es';
    }
  }

  String get name {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Español';
      default:
        return 'Español';
    }
  }

  String get flag {
    switch (this) {
      case Language.english:
        return '🇺🇸';
      case Language.spanish:
        return '🇪🇸';
      default:
        return '🇪🇸';
    }
  }

  Locale get localeValue {
    switch (this) {
      case Language.english:
        return const Locale('en', "US");
      case Language.spanish:
        return const Locale('es', "ES");
      default:
        return const Locale('es', "ES");
    }
  }
}

Language languageFromCode(String code) {
  switch (code) {
    case 'en':
      return Language.english;
    case 'es':
      return Language.spanish;
    default:
      return Language.spanish;
  }
}
